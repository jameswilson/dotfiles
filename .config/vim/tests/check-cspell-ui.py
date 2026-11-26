"""Exercise automatic open/save checks and CSpell commands in real Vim."""
from pathlib import Path
import json
import tempfile
from check import run_vim

with tempfile.TemporaryDirectory(prefix='vim-cspell-ui-') as directory:
    root = Path(directory)
    (root / 'cspell.json').write_text(json.dumps({'version': '0.2', 'words': ['projectwordzz'], 'ignorePaths': ['excluded.txt']}))
    (root / 'example.txt').write_text('druplicon projectwordzz wrdzzcheck\n')
    (root / 'excluded.txt').write_text('wrdzzcheck\n')
    report = root / 'report.json'
    status, output = run_vim(Path(__file__).with_name('cspell-ui.vim'), {
        'VIM_CSPELL_TEST_ROOT': str(root), 'VIM_CSPELL_TEST_REPORT': str(report),
    }, automatic=True)
    if not report.exists():
        raise RuntimeError(output.decode(errors='replace'))
    result = json.loads(report.read_text())
    print(json.dumps(result, indent=2))
    assert status == 0, status
    assert not result['errors'], result['errors']
    assert 'Error detected' not in result['messages'], result['messages']
    print('PASS: automatic open, save, manual command, enable/disable, ignored file, stale results, and underline colors.')
