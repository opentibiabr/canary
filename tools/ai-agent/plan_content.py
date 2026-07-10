#!/usr/bin/env python3
from __future__ import annotations
import argparse,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent/'lib'))
from io_utils import read_json,atomic_write_json,dumps_json
from id_allocator import find_range

def plan(task, content, registry, reservations):
 tid=task['taskId']; t=task['type']; name=task['name']; dp=task['targetDatapack']
 p={'taskId':tid,'type':t,'name':name,'targetDatapack':dp,'dryRun':task.get('dryRun'),'newFiles':[],'modifyFiles':[],'proposedStorage':[],'proposedActionIds':[],'proposedUniqueIds':[],'monsterReferences':[],'npcReferences':[],'itemReferences':[],'requiredEvents':[],'implementationOrder':['validate task spec','reserve identifiers','render preview','human review','manual apply'],'testPlan':['run unit tests','validate content plan','review generated preview'],'rollbackPlan':['discard preview artifacts','release reserved identifiers if not used'],'manualSteps':[],'mapRequirements':[],'warnings':[],'blockers':[],'riskLevel':'low'}
 if t=='quest':
  q=task.get('quest',{}); p['newFiles'] += [f'artifacts/generated-content/{tid}/npc/{name.lower().replace(" ","_")}.lua', f'artifacts/generated-content/{tid}/actions/{tid}.lua']
  p['proposedStorage']=[{'id':q.get('storage',{}).get('progress',find_range(registry,reservations,'storage',1,300000,399999)[0]),'purpose':'quest progress'}]
  for aid in q.get('requiredActionIds',[]): p['proposedActionIds'].append({'id':aid,'purpose':'requested quest action'})
  p['monsterReferences']=[m for s in q.get('stages',[]) for m in s.get('monsters',[])]
  p['npcReferences']=[q.get('starterNpc')] if q.get('starterNpc') else []
  p['itemReferences']=[r.get('itemId') for r in q.get('rewards',[]) if r.get('itemId')]
  if q.get('mapRequirements'): p['mapRequirements']=q['mapRequirements']; p['manualSteps'].append('Apply map changes manually; OTBM files are never edited by this pipeline.')
 elif t=='instance':
  p['newFiles']=[f'artifacts/generated-content/{tid}/instance/{name.lower().replace(" ","_")}.lua']; p['manualSteps']=['Create or edit map areas manually outside this dry-run pipeline.']; p['mapRequirements']=task.get('instance',{}).get('mapRequirements',[]); p['riskLevel']='medium'
 else:
  p['newFiles']=[f'artifacts/generated-content/{tid}/{t}/{name.lower().replace(" ","_")}.lua']
 return p

def main():
 a=argparse.ArgumentParser(); a.add_argument('--task',required=True); a.add_argument('--content-index',required=True); a.add_argument('--registry',required=True); a.add_argument('--reservations',required=True); a.add_argument('--output',required=True); ns=a.parse_args(); pl=plan(read_json(ns.task),read_json(ns.content_index),read_json(ns.registry),read_json(ns.reservations)); atomic_write_json(ns.output,pl); print(dumps_json(pl),end='')
if __name__=='__main__': raise SystemExit(main())
