from __future__ import annotations
from datetime import datetime, timezone
from typing import Any
VALID={'storage','actionId','uniqueId','itemId'}

def registry_used(registry:dict[str,Any], ns:str)->set[int]:
    data=registry.get('namespaces',{}).get(ns,{}).get('entries',{})
    if isinstance(data,dict): return {int(k) for k in data}
    return {int(e.get('id',e.get('value'))) for e in data if e.get('id',e.get('value')) is not None}

def reserved_used(res:dict[str,Any], ns:str)->set[int]:
    out=set()
    for r in res.get('reservations',[]):
        if r.get('namespace')==ns and r.get('status') in {'reserved','committed'}:
            out.update(range(int(r['from']), int(r['to'])+1))
    return out

def find_range(registry,res,ns,count,min_id=1,max_id=2147483647):
    if ns not in VALID: raise ValueError(f'invalid namespace: {ns}')
    if count < 1: raise ValueError('count must be positive')
    used=registry_used(registry,ns)|reserved_used(res,ns)
    start=min_id
    while start+count-1<=max_id:
        if all(i not in used for i in range(start,start+count)): return start,start+count-1
        start+=1
    raise RuntimeError('no available identifier range')

def ensure_no_overlap(res):
    seen={}
    for r in res.get('reservations',[]):
        if r.get('status')=='released': continue
        ns=r['namespace']
        for i in range(int(r['from']),int(r['to'])+1):
            if (ns,i) in seen: raise ValueError(f'overlapping reservation for {ns} {i}')
            seen[(ns,i)]=r['taskId']

def add_reservation(res, task, ns, a,b, target, desc=''):
    r={'taskId':task,'namespace':ns,'from':a,'to':b,'status':'reserved','createdAt':datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace('+00:00','Z'),'description':desc,'targetDatapack':target}
    res.setdefault('schemaVersion','1.0'); res.setdefault('reservations',[]).append(r); ensure_no_overlap(res); return r
