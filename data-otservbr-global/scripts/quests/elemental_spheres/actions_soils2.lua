local spheres = {
	[942] = VOCATION.BASE_ID.PALADIN,
	[946] = VOCATION.BASE_ID.SORCERER,
	[947] = VOCATION.BASE_ID.DRUID,
	[948] = VOCATION.BASE_ID.KNIGHT,
}

local globalTable = {
	[VOCATION.BASE_ID.SORCERER] = 10005,
	[VOCATION.BASE_ID.DRUID] = 10006,
	[VOCATION.BASE_ID.PALADIN] = 10007,
	[VOCATION.BASE_ID.KNIGHT] = 10008,
}

local elementalSpheresSoils2 = Action()
function elementalSpheresSoils2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 842, 843, 844, 845, 846, 847, 848, 849 }, target.itemid) then
		return false
	end

	if not toPosition:isInRange({ x = 33238, y = 31806, z = 12 }, { x = 33297, y = 31865, z = 12 }) then
		return false
	end

	if spheres[item.itemid] ~= player:getVocation():getBaseId() then
		return false
	end

	if table.contains({ 846, 847, 848, 849 }, target.itemid) then
		player:say("Turn off the machine first.", TALKTYPE_MONSTER_SAY)
		return true
	end

	toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
	Game.setStorageValue(globalTable[player:getVocation():getBaseId()], 1)
	item:remove(1)
	return true
end

elementalSpheresSoils2:id(942, 946, 947, 948)
elementalSpheresSoils2:register()
