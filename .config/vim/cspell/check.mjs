import { readFile, access } from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath, pathToFileURL } from 'node:url';

const configDir = path.dirname(fileURLToPath(import.meta.url));
const dataDir = process.env.VIM_XDG_DATA_HOME || path.join(process.env.XDG_DATA_HOME || path.join(os.homedir(), '.local/share'), 'vim');

async function exists(filename) {
  try { await access(filename); return true; } catch { return false; }
}

async function drupalDictionaries(filename) {
  for (let dir = path.dirname(filename); ; dir = path.dirname(dir)) {
    for (const relative of ['web/core/misc/cspell', 'docroot/core/misc/cspell', 'core/misc/cspell', 'misc/cspell']) {
      const candidate = path.join(dir, relative);
      if (await exists(path.join(candidate, 'drupal-dictionary.txt'))) return candidate;
    }
    if (dir === path.dirname(dir)) break;
  }
  return path.join(configDir, 'dictionaries');
}

export async function check(filename, filetype = '') {
  filename = path.resolve(filename);
  let library;
  try {
    const packageDir = path.join(dataDir, 'cspell/node_modules/cspell-lib');
    const manifest = JSON.parse(await readFile(path.join(packageDir, 'package.json'), 'utf8'));
    library = await import(pathToFileURL(path.join(packageDir, manifest.exports['.'].import)).href);
  } catch {
    throw new Error('CSpell runtime is missing. Run: python3 ~/.config/vim/cspell/setup.py');
  }
  const root = await drupalDictionaries(filename);
  const dictionaryDefinitions = [];
  for (const name of ['drupal-dictionary', 'dictionary']) {
    const source = path.join(root, name + '.txt');
    if (await exists(source)) dictionaryDefinitions.push({ name: 'vim-' + name, path: source });
  }
  const text = await readFile(filename, 'utf8');
  const aliases = { 'javascript.jsx': 'javascriptreact', 'html.twig': 'twig', sh: 'shellscript', dosini: 'ini', text: 'plaintext', vue: 'vue' };
  const languageId = aliases[filetype] || filetype.split('.')[0] || undefined;
  const result = await library.spellCheckDocument(
    { uri: pathToFileURL(filename).href, text, languageId },
    { generateSuggestions: false, noConfigSearch: false },
    { version: '0.2', dictionaryDefinitions, dictionaries: dictionaryDefinitions.map(d => d.name) },
  );
  const errors = [...(result.errors || []), ...(result.configErrors || []).map(e => e.error || e)];
  for (const entries of result.dictionaryErrors?.values() || []) errors.push(...entries);
  if (errors.length) throw new Error(errors.map(e => e.message || String(e)).join('; '));
  const issues = result.issues.map(issue => {
    const lineStart = text.lastIndexOf('\n', issue.offset - 1) + 1;
    return {
      lnum: text.slice(0, issue.offset).split('\n').length,
      col: Buffer.byteLength(text.slice(lineStart, issue.offset), 'utf8') + 1,
      length: Buffer.byteLength(issue.text, 'utf8'),
      word: issue.text,
    };
  });
  return { ok: true, checked: result.checked, config: result.localConfigFilepath || null, dictionaries: dictionaryDefinitions.map(d => d.path), issues };
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    if (!process.argv[2]) throw new Error('Usage: node check.mjs FILE [VIM_FILETYPE]');
    console.log(JSON.stringify(await check(process.argv[2], process.argv[3])));
  } catch (error) {
    console.log(JSON.stringify({ ok: false, error: error.message }));
    process.exitCode = 1;
  }
}
