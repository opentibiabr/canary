#!/usr/bin/env python3
from __future__ import annotations
import argparse,hashlib,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json,atomic_write_json,dumps_json
from path_policy import require_safe_write
HEADER='-- Generated preview — not active game content\n'
def render(task, plan, outdir):
 base=Path(outdir)/task['taskId']; files=[]; base.mkdir(parents=True,exist_ok=True)
 kind=task['type']; stem=task['name'].lower().replace(' ','_')
 if kind in {'quest','npc','spell','raid','monster'}:
  ext='.xml' if kind in {'monster','raid'} else '.lua'; path=base/kind/(stem+ext); require_safe_write(path, output_root=outdir); path.parent.mkdir(parents=True,exist_ok=True)
  body=HEADER+f'-- Task: {task["taskId"]}\n-- Type: {kind}\n-- Name: {task["name"]}\nreturn {{ name = "{task["name"]}", dryRun = true }}\n'
  if ext=='.xml': body='<!-- Generated preview — not active game content -->\n'+f'<!-- Task: {task["taskId"]}; Type: {kind}; Name: {task["name"]} -->\n'
  path.write_text(body,encoding='utf-8'); files.append(path)
 else:
  path=base/'MANUAL_IMPLEMENTATION_REQUIRED.md'; path.write_text('# Manual implementation required\n\nGenerated preview — not active game content.\n',encoding='utf-8'); files.append(path)
 manifest={'taskId':task['taskId'],'files':[{'path':str(p).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(files)]}
 atomic_write_json(base/'MANIFEST.json',manifest); return manifest

def main():
 p=argparse.ArgumentParser(); p.add_argument('--task',required=True); p.add_argument('--plan',required=True); p.add_argument('--output-dir',required=True); a=p.parse_args(); m=render(read_json(a.task),read_json(a.plan),a.output_dir); print(dumps_json(m),end='')
if __name__=='__main__': raise SystemExit(main())
