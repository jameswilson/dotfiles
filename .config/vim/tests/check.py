"""Run the syntax fixtures through a normal Vim terminal startup."""
from pathlib import Path
import argparse
import json
import os
import pty
import select
import shutil
import struct
import subprocess
import termios
import fcntl
import time


def run_vim(script, env, binary='vim', automatic=False):
    master, slave = pty.openpty()
    fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', 40, 140, 0, 0))
    command = [shutil.which(binary) or binary, '-i', 'NONE', '-n']
    if not automatic:
        command += ['--cmd', 'let g:cspell_auto_enabled=0']
    command += ['-S', str(script)]
    process = subprocess.Popen(command, stdin=slave, stdout=slave, stderr=slave,
                               env={**os.environ, 'TERM': 'xterm-256color', **env})
    os.close(slave)
    output = bytearray()
    deadline = time.monotonic() + 45
    try:
        while True:
            if time.monotonic() > deadline:
                raise TimeoutError('Vim did not finish; terminal output: ' + output.decode(errors='replace')[-3000:])
            ready, _, _ = select.select([master], [], [], 0.1)
            if ready:
                try:
                    chunk = os.read(master, 65536)
                except OSError:
                    break
                if not chunk:
                    break
                output.extend(chunk)
            elif process.poll() is not None:
                break
        return process.wait(timeout=3), output
    finally:
        if process.poll() is None:
            process.kill()
            process.wait()
        os.close(master)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--vim', default='vim')
    parser.add_argument('--file', action='append', default=[], help='Additional JSON file to inspect read-only')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    state = Path(os.environ.get('XDG_STATE_HOME') or Path.home() / '.local/state') / 'vim/syntax-checks'
    state.mkdir(parents=True, exist_ok=True)
    report_path = state / 'latest.json'
    status, output = run_vim(root / 'check-syntax.vim', {
        'VIM_SYNTAX_REPORT': str(report_path),
        'VIM_SYNTAX_EXTRA': json.dumps([str(Path(p).expanduser().resolve()) for p in args.file]),
    }, args.vim)
    (state / 'terminal.log').write_bytes(output)
    report = json.loads(report_path.read_text())
    failures = []
    for result in report['files']:
        errors = []
        if 'error' in result:
            errors.append(result['error'])
        else:
            if result['filetype'] not in result['expected']:
                errors.append('unexpected filetype: ' + result['filetype'])
            if not result['plain'] and (not result['loaded'] or not result['groups']):
                errors.append('no loaded syntax or highlight groups')
            if result['spell']:
                errors.append('native spelling is enabled')
            for group, colors in result['groups'].items():
                if colors['fg'].startswith('#') and colors['fg'] == colors['bg']:
                    errors.append('identical foreground/background: ' + group)
        if errors:
            failures.append((result['file'], errors))
        print(('FAIL' if errors else 'PASS') + ' ' + result['file'] + (': ' + '; '.join(errors) if errors else ''))
    for group, colors in report['spell_groups'].items():
        if any(colors[key] for key in ['gui_fg', 'gui_bg', 'cterm_fg', 'cterm_bg']) or colors['undercurl'] != '1':
            failures.append((group, ['spelling marks override syntax colors or lack an underline']))
    if status or not report['truecolor'] or 'Error detected' in report['messages']:
        failures.append(('startup', [report['messages']]))
    print(f"{len(report['files']) - len([f for f in failures if f[0] not in report['spell_groups']])}/{len(report['files'])} files passed. Report: {report_path}")
    if failures:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
