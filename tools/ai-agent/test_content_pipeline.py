from __future__ import annotations
import json, tempfile, unittest, importlib.util, sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools/ai-agent'))
sys.path.insert(0,str(ROOT/'tools/ai-agent/lib'))
from id_allocator import find_range, add_reservation
from task_validation import *  # noqa: F401,F403

def load(name):
 p=ROOT/'tools/ai-agent'/f'{name}.py'; spec=importlib.util.spec_from_file_location(name,p); m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m); return m
validate_task=load('validate_task_spec').validate
make_plan=load('plan_content').plan
validate_plan=load('validate_content_plan').validate
render=load('render_content').render

class PipelineTests(unittest.TestCase):
 def registry(self): return {'namespaces':{'storage':{'entries':{'300000':[]}},'actionId':{'entries':{}},'uniqueId':{'entries':{}},'itemId':{'entries':{'2160':[]}}}}
 def reservations(self): return {'schemaVersion':'1.0','reservations':[]}
 def task(self): return json.loads((ROOT/'docs/ai-agent/examples/forgotten_forge.quest.json').read_text())
 def test_allocator_finds_free_range_deterministically(self):
  self.assertEqual(find_range(self.registry(), self.reservations(), 'storage', 2, 300000, 300010), (300001,300002))
  self.assertEqual(find_range(self.registry(), self.reservations(), 'storage', 2, 300000, 300010), (300001,300002))
 def test_allocator_overlap_and_release(self):
  r=self.reservations(); add_reservation(r,'a','storage',10,12,'data','x')
  with self.assertRaises(ValueError): add_reservation(r,'b','storage',12,13,'data','x')
  r['reservations'][0]['status']='released'; self.assertEqual(find_range({},r,'storage',1,10,10),(10,10))
 def test_allocator_no_range_and_invalid_namespace(self):
  with self.assertRaises(RuntimeError): find_range(self.registry(), self.reservations(), 'storage', 1, 300000, 300000)
  with self.assertRaises(ValueError): find_range({}, {}, 'bad', 1)
 def test_task_validator_quest(self): self.assertTrue(validate_task(self.task())['ok'])
 def test_task_validator_missing_reference(self):
  t=self.task(); t['quest']['stages'][1]['dependsOn']=['missing']; self.assertFalse(validate_task(t)['ok'])
 def test_planner_and_plan_validator(self):
  reg=self.registry(); res=self.reservations(); add_reservation(res,'forgotten_forge','storage',300001,300001,'data-otservbr-global','x')
  pl=make_plan(self.task(),{},reg,res); self.assertIn('rollbackPlan',pl); self.assertTrue(validate_plan(pl,reg,res)['ok'])
 def test_renderer_writes_only_artifacts(self):
  (ROOT/'artifacts').mkdir(exist_ok=True)
  with tempfile.TemporaryDirectory(dir=ROOT/'artifacts') as td:
   t=self.task(); pl=make_plan(t,{},self.registry(),self.reservations()); m=render(t,pl,td); self.assertEqual(len(m['files']),1); self.assertIn('sha256',m['files'][0])
 def test_instance_basic_plan(self):
  t=self.task(); t['type']='instance'; t['taskId']='inst'; t['instance']={'mapRequirements':['manual room']}; pl=make_plan(t,{},self.registry(),self.reservations()); self.assertIn('manual', ' '.join(pl['manualSteps']).lower())
 def test_plan_blocks_otbm_and_items_otb(self):
  pl={'targetDatapack':'.','newFiles':['data/map/world.otbm','items.otb'],'modifyFiles':[],'rollbackPlan':['x'],'testPlan':['x']}
  self.assertFalse(validate_plan(pl,self.registry(),self.reservations())['ok'])
if __name__=='__main__': unittest.main()
