#!/usr/bin/env python3
from __future__ import annotations
import argparse,json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json, atomic_write_json, dumps_json
from id_allocator import find_range, add_reservation, ensure_no_overlap, VALID

def main():
 p=argparse.ArgumentParser(); p.add_argument('--registry',required=True); p.add_argument('--reservations',required=True); p.add_argument('--task-id',required=True); p.add_argument('--namespace',required=True,choices=sorted(VALID)); p.add_argument('--count',type=int,default=1); p.add_argument('--min',type=int,default=1); p.add_argument('--max',type=int,default=2147483647); p.add_argument('--target-datapack',required=True); p.add_argument('--mode',choices=['suggest','reserve','release','commit'],default='suggest'); p.add_argument('--description',default='')
 a=p.parse_args(); reg=read_json(a.registry); res=read_json(a.reservations); ensure_no_overlap(res); out={'ok':True,'mode':a.mode,'taskId':a.task_id,'namespace':a.namespace}
 if a.mode in {'suggest','reserve'}:
  s,e=find_range(reg,res,a.namespace,a.count,a.min,a.max); out.update({'from':s,'to':e})
  if a.mode=='reserve': out['reservation']=add_reservation(res,a.task_id,a.namespace,s,e,a.target_datapack,a.description); atomic_write_json(a.reservations,res)
 else:
  changed=0
  for r in res.get('reservations',[]):
   if r.get('taskId')==a.task_id and r.get('namespace')==a.namespace and r.get('targetDatapack')==a.target_datapack:
    r['status']='released' if a.mode=='release' else 'committed'; changed+=1
  out['changed']=changed; atomic_write_json(a.reservations,res)
 print(dumps_json(out),end=''); return 0
if __name__=='__main__':
 try: raise SystemExit(main())
 except Exception as e: print(json.dumps({'ok':False,'error':str(e)},sort_keys=True), file=sys.stderr); raise SystemExit(2)
