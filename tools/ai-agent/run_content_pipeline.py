#!/usr/bin/env python3
from __future__ import annotations
import argparse,shutil,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json,atomic_write_json,dumps_json
from validate_task_spec import validate as validate_task
from id_allocator import find_range,add_reservation
from plan_content import plan as make_plan
from validate_content_plan import validate as validate_plan
from render_content import render

def main():
 p=argparse.ArgumentParser(); p.add_argument('--task',required=True); p.add_argument('--registry',required=True); p.add_argument('--content-index',required=True); p.add_argument('--reservations',required=True); p.add_argument('--output',required=True); a=p.parse_args(); out=Path(a.output); out.mkdir(parents=True,exist_ok=True)
 task=read_json(a.task); reg=read_json(a.registry); content=read_json(a.content_index); res=read_json(a.reservations); atomic_write_json(out/'TASK_SPEC.json',task)
 spec=validate_task(task); atomic_write_json(out/'TASK_SPEC_VALIDATION.json',spec)
 if not spec['ok']: return 1
 q=task.get('quest',{}); needed=[]
 if task['type'] in {'quest','instance'}: needed.append(('storage',1,300000,399999))
 for ns,c,mi,ma in needed:
  s,e=find_range(reg,res,ns,c,mi,ma); add_reservation(res,task['taskId'],ns,s,e,task['targetDatapack'],'temporary CI reservation')
 atomic_write_json(out/'ID_RESERVATIONS.working.json',res)
 pl=make_plan(task,content,reg,res); atomic_write_json(out/'CONTENT_PLAN.json',pl)
 val=validate_plan(pl,reg,res); atomic_write_json(out/'CONTENT_PLAN_VALIDATION.json',val)
 man=render(task,pl,out/'generated-content'); preview_count=len(man['files'])
 lines=['# Content pipeline summary','',f'- task: {task["name"]}',f'- status: {"passed" if spec["ok"] and val["ok"] else "failed"}',f'- preview files: {preview_count}',f'- artifacts: {out.as_posix()}','', '## Manual steps']+[f'- {x}' for x in pl.get('manualSteps',[])]
 (out/'CONTENT_PIPELINE_SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
 print(dumps_json({'ok':spec['ok'] and val['ok'],'output':str(out),'previewFiles':preview_count}),end=''); return 0 if spec['ok'] and val['ok'] else 1
if __name__=='__main__': raise SystemExit(main())
