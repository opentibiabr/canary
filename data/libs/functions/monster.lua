if not monsterStorage then
	monsterStorage = {[0] = {[0] = 0}}
end

function Monster.getStorageValue(self, key)
	if not self:isMonster() then
		return -1
	end
	local ret = -1
	for id, pid in pairs(monsterStorage) do
		if id == self:getId() then
			for key1, value in pairs(pid) do
				if(key1 == key)then
					ret = value
					break
				end
			end
		end
	end
	return ret
end

function Monster.setStorageValue(self, key, value)
	if not self:isMonster() then
		return false
	end
	if not monsterStorage[self:getId()] then
		monsterStorage[self:getId()] = {}
	end
	if not monsterStorage[self:getId()][key] then
		monsterStorage[self:getId()][key] = value
	else
		monsterStorage[self:getId()][key] = value
	end
	return true
end

function Monster.getStorage(self, key)
	return self:getStorageValue(key)
end

function Monster.setStorage(self, key, value)
	return self:setStorageValue(key, value)
end

if not hpCompartilhada then
	hpCompartilhada = {[0] = {hp = 0, monsters = {}}}
end

function Monster.beginSharedLife(self, hpid)
	if not self:isMonster() then
		return false
	end
	if not hpCompartilhada[hpid] then
		hpCompartilhada[hpid] = {hp = self:getMaxHealth(), monsters = {}}
	end
	table.insert(hpCompartilhada[hpid].monsters, self:getId())
	self:setStorageValue("shared_storage", hpid)
end

function Monster.inSharedLife(self)
	if not self:isMonster() then
		return false
	end
	local storage = self:getStorageValue("shared_storage")
	if storage < 1 then
		return false
	end
	for id, pid in pairs(hpCompartilhada) do
		if(storage == id) then
			for _id, mid in pairs(pid.monsters) do
				local mtemp = Monster(mid)
				if(mtemp and mtemp:getId() == self:getId())then
					return true
				end
			end
		end
	end
	return false
end

function updateMonstersSharedLife(hpid, amount, orign, _type, kill)
	if not hpCompartilhada[hpid] then
		return false
	end
	if(_type == "healing") then
		hpCompartilhada[hpid].hp = hpCompartilhada[hpid].hp + amount
	else
		hpCompartilhada[hpid].hp = hpCompartilhada[hpid].hp - amount
	end
	if(hpCompartilhada[hpid].hp < 0)then
		hpCompartilhada[hpid].hp = 0
	end
	for _, monster in pairs(hpCompartilhada[hpid].monsters)do
		local mt = Monster(monster)
		if mt and mt:getId() ~= orign then
			if kill then
				mt:addHealth(-mt:getHealth())
			else
				mt:setHealth(hpCompartilhada[hpid].hp)
			end
		end
	end
	return true
end

function Monster.onReceivDamageSL(self, damage, tp, killer)
	if not self:inSharedLife() then
		return true
	end
	local storage = self:getStorageValue("shared_storage")
	if storage < 1 then
		return false
	end
	updateMonstersSharedLife(storage, damage, self:getId(), tp, killer)
	return true
end
