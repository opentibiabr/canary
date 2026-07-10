from __future__ import annotations
import json, os, tempfile
from pathlib import Path
from typing import Any

def read_json(path: str|Path) -> Any:
    return json.loads(Path(path).read_text(encoding='utf-8'))

def dumps_json(data: Any) -> str:
    return json.dumps(data, indent=2, sort_keys=True, ensure_ascii=False) + '\n'

def atomic_write_json(path: str|Path, data: Any) -> None:
    p=Path(path); p.parent.mkdir(parents=True, exist_ok=True)
    text=dumps_json(data); json.loads(text)
    fd,tmp=tempfile.mkstemp(prefix=p.name+'.', suffix='.tmp', dir=str(p.parent))
    with os.fdopen(fd,'w',encoding='utf-8') as f: f.write(text)
    os.replace(tmp,p)
