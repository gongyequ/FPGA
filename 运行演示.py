from pathlib import Path
import subprocess, sys
root = Path(__file__).resolve().parent
raise SystemExit(subprocess.call([sys.executable, str(root / "演示与截图/录制演示.py"), *sys.argv[1:], "--代码目录", str(root / "参赛工程")]))
