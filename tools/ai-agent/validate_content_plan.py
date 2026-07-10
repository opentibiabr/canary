#!/usr/bin/env python3
from __future__ import annotations
import argparse,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json,atomic_write_json,dumps_json
from id_allocator import registry_used,reserved_used
from path_policy import is_safe_write

def validate(plan, registry, reservations):
 f=[]
 def add(l,m): f.append({'level':l,'message':m})
 for ns,key in [('storage','proposedStorage'),('actionId','proposedActionIds'),('uniqueId','proposedUniqueIds')]:
  used=registry_used(registry,ns); res=reserved_used(reservations,ns)
  for entry in plan.get(key,[]):
   i=int(entry.get('id'))
   if i in used: add('error',f'{ns} {i} collides with registry')
   if i not in res: add('warning',f'{ns} {i} is not reserved')
 for p in plan.get('newFiles',[])+plan.get('modifyFiles',[]):
  ok,msg=is_safe_write(p, output_root='artifacts/generated-content')
  if not ok: add('error',msg)
 if not plan.get('rollbackPlan'): add('error','rollback plan is required')
 if not plan.get('testPlan'): add('error','test plan is required')
 for m in plan.get('mapRequirements',[]):
  if not plan.get('manualSteps'): add('error','map requirements require explicit manual steps')
 if not Path(plan.get('targetDatapack','')).exists(): add('warning','target datapack path does not exist in this checkout')
 return {'ok':not any(x['level']=='error' for x in f),'findings':f,'summary':{'findingCount':len(f),'errors':sum(x['level']=='error' for x in f)}}
def main():
 p=argparse.ArgumentParser(); p.add_argument('--plan',required=True); p.add_argument('--registry',required=True); p.add_argument('--reservations',required=True); p.add_argument('--output',required=True); a=p.parse_args(); r=validate(read_json(a.plan),read_json(a.registry),read_json(a.reservations)); atomic_write_json(a.output,r); print(dumps_json(r),end=''); return 0 if r['ok'] else 1
if __name__=='__main__': raise SystemExit(main())
