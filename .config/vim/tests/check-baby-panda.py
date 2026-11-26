"""Verify Baby Panda's token mappings, reload behavior, and fallback colors."""
from pathlib import Path
import json
import os
from check import run_vim

root = Path(__file__).resolve().parent
state = Path(os.environ.get('XDG_STATE_HOME') or Path.home() / '.local/state') / 'vim/syntax-checks'
state.mkdir(parents=True, exist_ok=True)
report = state / 'baby-panda.json'
status, output = run_vim(root / 'check-baby-panda.vim', {'VIM_BABY_PANDA_REPORT': str(report)})
(state / 'baby-panda-terminal.log').write_bytes(output)
result = json.loads(report.read_text())
for error in result['errors']:
    print('FAIL', error)
assert status == 0, output.decode(errors='replace')[-3000:]
assert not result['errors'], f"{len(result['errors'])} Baby Panda checks failed; see {report}"
assert 'Error detected' not in result['messages'], result['messages']
fixtures = {entry['file'] for entry in json.loads((root / 'manifest.json').read_text())}
covered = {token['file'] for token in result['tokens']}
assert not fixtures - covered, f'Missing token checks for: {sorted(fixtures - covered)}'
print(f"PASS: {len(result['tokens'])} token colors, theme switching/reload, spelling overlays, 256-color fallbacks, and Airline.")
print(f'Report: {report}')
