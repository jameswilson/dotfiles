"""Install the pinned CSpell runtime into XDG data, outside the config repo."""
from pathlib import Path
import os
import shutil
import subprocess

config = Path(__file__).resolve().parent
data = Path(os.environ.get('XDG_DATA_HOME') or Path.home() / '.local/share') / 'vim/cspell'
data.mkdir(parents=True, exist_ok=True)
for name in ['package.json', 'package-lock.json']:
    shutil.copy2(config / name, data / name)
subprocess.run(['npm', 'ci', '--prefix', str(data), '--ignore-scripts', '--no-audit', '--no-fund'], check=True)
print(f'CSpell installed in {data}')
