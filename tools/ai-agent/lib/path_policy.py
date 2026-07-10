from __future__ import annotations
from pathlib import Path
BLOCKED_SUFFIXES={'.otbm'}
BLOCKED_NAMES={'items.otb'}

def repo_root() -> Path:
    return Path(__file__).resolve().parents[3]

def is_safe_write(path: str|Path, *, root: str|Path|None=None, output_root: str|Path|None=None, allow_reservations=False) -> tuple[bool,str]:
    rootp=Path(root).resolve() if root else repo_root()
    p=Path(path)
    rp=(rootp/p).resolve() if not p.is_absolute() else p.resolve()
    rel=rp.relative_to(rootp).as_posix() if str(rp).startswith(str(rootp)) else rp.as_posix()
    if rp.name in BLOCKED_NAMES or rp.suffix.lower() in BLOCKED_SUFFIXES: return False, f'blocked protected file: {rel}'
    if rel == 'main' or rel.startswith('main/'): return False, 'writes to main are forbidden'
    if rel.startswith(('data/','data-otservbr-global/')): return False, f'active datapack writes are forbidden: {rel}'
    if allow_reservations and rel.endswith('ID_RESERVATIONS.json'): return True,'allowed reservations file'
    if output_root:
        op=Path(output_root); orp=(rootp/op).resolve() if not op.is_absolute() else op.resolve()
        try: rp.relative_to(orp); return True,'allowed output root'
        except ValueError: pass
    if rel.startswith('artifacts/'): return True,'allowed artifacts path'
    return False, f'path is outside dry-run writable roots: {rel}'

def require_safe_write(path, **kw):
    ok,msg=is_safe_write(path, **kw)
    if not ok: raise ValueError(msg)
