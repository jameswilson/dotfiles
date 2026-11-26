import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, mkdir, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { check } from '../cspell/check.mjs';

async function project(run) {
  const root = await mkdtemp(path.join(tmpdir(), 'vim-cspell-'));
  try { await run(root); } finally { await rm(root, { recursive: true, force: true }); }
}

test('project words, imported settings, and shared Drupal words are accepted', () => project(async root => {
  await writeFile(path.join(root, 'shared.json'), JSON.stringify({ words: ['importwordzz'] }));
  await writeFile(path.join(root, 'cspell.json'), JSON.stringify({ version: '0.2', words: ['projectwordzz'], import: ['./shared.json'] }));
  await mkdir(path.join(root, 'src'));
  const file = path.join(root, 'src/example.txt');
  await writeFile(file, 'projectwordzz importwordzz druplicon drush langcode wrdzzcheck\n');
  const result = await check(file, 'text');
  assert.equal(result.checked, true);
  assert.equal(result.config, path.join(root, 'cspell.json'));
  assert.deepEqual(result.issues.map(i => i.word), ['wrdzzcheck']);
}));

test('relative custom dictionaries and per-file overrides are respected', () => project(async root => {
  await mkdir(path.join(root, 'words'));
  await writeFile(path.join(root, 'words/custom.txt'), 'customerwordzz\n');
  await writeFile(path.join(root, '.cspell.json'), JSON.stringify({ version: '0.2',
    dictionaryDefinitions: [{ name: 'customer', path: './words/custom.txt' }], dictionaries: ['customer'],
    overrides: [{ filename: '**/*.txt', words: ['overridewordzz'] }] }));
  const file = path.join(root, 'example.txt');
  await writeFile(file, 'customerwordzz overridewordzz wrdzzcheck\n');
  assert.deepEqual((await check(file, 'text')).issues.map(i => i.word), ['wrdzzcheck']);
}));

test('ignored files are excluded', () => project(async root => {
  await writeFile(path.join(root, 'cspell.json'), JSON.stringify({ version: '0.2', ignorePaths: ['ignored.txt'] }));
  const file = path.join(root, 'ignored.txt');
  await writeFile(file, 'wrdzzcheck\n');
  const result = await check(file, 'text');
  assert.equal(result.checked, false);
  assert.deepEqual(result.issues, []);
}));

test('YAML configuration and ignored regular expressions are respected', () => project(async root => {
  await writeFile(path.join(root, 'cspell.yaml'), 'version: "0.2"\nwords:\n  - yamlwordzz\nignoreRegExpList:\n  - /tokenwordzz/g\n');
  const file = path.join(root, 'example.txt');
  await writeFile(file, 'yamlwordzz tokenwordzz wrdzzcheck\n');
  const result = await check(file, 'text');
  assert.equal(result.config, path.join(root, 'cspell.yaml'));
  assert.deepEqual(result.issues.map(i => i.word), ['wrdzzcheck']);
}));

test('project flagWords override otherwise accepted Drupal terms', () => project(async root => {
  await writeFile(path.join(root, 'cspell.json'), JSON.stringify({ version: '0.2', flagWords: ['druplicon'] }));
  const file = path.join(root, 'example.txt');
  await writeFile(file, 'druplicon\n');
  assert.deepEqual((await check(file, 'text')).issues.map(i => i.word), ['druplicon']);
}));

test('inline directives and UTF-8 byte columns are respected', () => project(async root => {
  const file = path.join(root, 'example.js');
  await writeFile(file, '// cspell:ignore inlinewordzz\n// café inlinewordzz wrdzzcheck\n');
  const result = await check(file, 'javascript');
  const issue = result.issues.find(i => i.word === 'wrdzzcheck');
  assert.ok(issue);
  assert.equal(issue.lnum, 2);
  assert.equal(issue.col, Buffer.byteLength('// café inlinewordzz ') + 1);
  assert.ok(!result.issues.some(i => i.word === 'inlinewordzz'));
}));

test('invalid project configurations produce a visible error', () => project(async root => {
  await writeFile(path.join(root, 'cspell.json'), '{ invalid JSON');
  const file = path.join(root, 'example.txt');
  await writeFile(file, 'hello\n');
  await assert.rejects(check(file, 'text'));
}));

test('a missing isolated runtime gives an actionable error', () => project(async root => {
  const command = fileURLToPath(new URL('../cspell/check.mjs', import.meta.url));
  const result = spawnSync(process.execPath, [command, path.join(root, 'example.txt')], {
    encoding: 'utf8', env: { ...process.env, VIM_XDG_DATA_HOME: root },
  });
  assert.equal(result.status, 1);
  assert.match(JSON.parse(result.stdout).error, /setup\.py/);
}));
