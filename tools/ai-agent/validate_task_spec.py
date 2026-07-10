#!/usr/bin/env python3
from __future__ import annotations
import argparse,json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json,dumps_json,atomic_write_json
TYPES={'quest','monster','npc','spell','raid','instance','content_bundle'}
def validate(d):
 findings=[]
 def err(m): findings.append({'level':'error','message':m})
 for k in ['schemaVersion','taskId','type','name','description','targetDatapack','dryRun','requestedBy','tags']:
  if k not in d: err(f'missing required field: {k}')
 if d.get('type') not in TYPES: err('invalid task type')
 if d.get('dryRun') is not True: err('dryRun must be true')
 stages=d.get('quest',{}).get('stages',[]) if d.get('type')=='quest' else d.get('stages',[])
 ids=[s.get('id') for s in stages if isinstance(s,dict)]
 if len(ids)!=len(set(ids)): err('stage ids must be unique')
 known=set(ids)
 for s in stages:
  for dep in s.get('dependsOn',[]):
   if dep not in known: err(f'unknown stage reference: {dep}')
 rewards=(d.get('quest',{}) or d).get('rewards',[])
 for r in rewards:
  if any(isinstance(r.get(k),int) and r[k] < 0 for k in ['count','experience','money']): err('reward values must not be negative')
 if d.get('type')=='quest' and 'quest' not in d: err('quest payload is required')
 return {'ok': not any(f['level']=='error' for f in findings),'findings':findings,'summary':{'findingCount':len(findings)}}
def main():
 p=argparse.ArgumentParser(); p.add_argument('--task',required=True); p.add_argument('--output'); a=p.parse_args(); rep=validate(read_json(a.task));
 if a.output: atomic_write_json(a.output, rep)
 print(dumps_json(rep),end=''); return 0 if rep['ok'] else 1
if __name__=='__main__': raise SystemExit(main())
