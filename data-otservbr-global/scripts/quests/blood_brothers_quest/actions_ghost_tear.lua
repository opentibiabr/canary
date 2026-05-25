local ghostTear = Action()

function ghostTear.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission10) >= 2 then
		return true
	end

	if not target or target:getId() ~= 8325 then
		return false
	end

	if target:getPosition() ~= Position(32953, 31440, 2) then
		return false
	end

	target:transform(8326)
	target:getPosition():sendMagicEffect(CONST_ME_HITBYFIRE)
	player:say("YES... THAT FEELING... IS... HUNGER!!", TALKTYPE_MONSTER_SAY)

	local fromPos = Position(32949, 31439, 2)
	local toPos = Position(32957, 31447, 2)
	local teleportDestination = Position(32953, 31444, 1)

	local spectators = Game.getSpectators(fromPos, false, false, toPos.x - fromPos.x, toPos.x - fromPos.x, toPos.y - fromPos.y, toPos.y - fromPos.y)

	for _, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			spectator:teleportTo(teleportDestination)
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	Game.createMonster("Arthei", Position(32953, 31441, 1))
	Game.createMonster("Vampire", Position(32952, 31441, 1))
	Game.createMonster("Vampire", Position(32954, 31441, 1))

	item:remove(1)

	return true
end

ghostTear:id(8746)
ghostTear:register()
