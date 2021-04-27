local spheres = {
	[8300] = VOCATION.CLIENT_ID.PALADIN,
	[8304] = VOCATION.CLIENT_ID.SORCERER,
	[8305] = VOCATION.CLIENT_ID.DRUID,
	[8306] = VOCATION.CLIENT_ID.KNIGHT
}

local globalTable = {
	[VOCATION.CLIENT_ID.SORCERER] = 10005,
	[VOCATION.CLIENT_ID.DRUID] = 10006,
	[VOCATION.CLIENT_ID.PALADIN] = 10007,
	[VOCATION.CLIENT_ID.KNIGHT] = 10008
}

local elementalSpheresSoils2 = Action()
function elementalSpheresSoils2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({7917, 7918, 7913, 7914}, target.itemid) then
		return false
	end

	if not isInRange(toPosition, {x=33238, y=31806, z=12}, {x=33297, y=31865, z=12}) then
		return false
	end

	if not table.contains(spheres[item.itemid], player:getVocation():getClientId()) then
		return false
	end

	if table.contains({7917, 7918}, target.itemid) then
		player:say('Turn off the machine first.', TALKTYPE_MONSTER_SAY)
		return true
	end

	toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
	Game.setStorageValue(globalTable[player:getVocation():getBase():getId()], 1)
	item:remove(1)
	return true
end

elementalSpheresSoils2:id(8300,8304,8305,8306)
elementalSpheresSoils2:register()