local lersatio = Action()

local function revertMirror(position)
	local mirror = Tile(position):getItemById(8721)
	if mirror then
		mirror:transform(8667)
	end
end

function lersatio.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission08) >= 2 then
		return false
	end

	local mirrorPositions = {
		Position(32965, 31457, 2),
		Position(32966, 31456, 2),
		Position(32968, 31456, 2),
	}

	local isValidPosition = false
	for _, pos in ipairs(mirrorPositions) do
		if toPosition == pos then
			isValidPosition = true
			break
		end
	end

	if not isValidPosition then
		return false
	end

	local mirror = Tile(toPosition):getItemById(8667)
	if not mirror then
		return false
	end

	mirror:transform(8721)
	toPosition:sendMagicEffect(CONST_ME_POFF)

	local brokenCount = player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.MirrorCounter)
	if brokenCount < 0 then
		brokenCount = 0
	end
	brokenCount = brokenCount + 1
	player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.MirrorCounter, brokenCount)
	addEvent(revertMirror, 30 * 1000, toPosition)

	local statuePos = Position(32967, 31457, 2)
	local statue = Tile(statuePos):getItemById(8325)
	if statue then
		statue:transform(8326)
	end

	if brokenCount == 1 then
		player:say("STOP THAT, YOU WORM, OR I'LL SHOW YOU THE BEAUTY OF DEATH.", TALKTYPE_MONSTER_SAY)
	end

	if brokenCount >= 2 then
		player:say("FINE. DIE PRETTY!", TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.MirrorCounter, 0)
		local fromPos = Position(32963, 31456, 2)
		local toPos = Position(32972, 31465, 2)
		local teleportDestination = Position(32967, 31459, 1)

		local spectators = Game.getSpectators(fromPos, false, false, toPos.x - fromPos.x, toPos.x - fromPos.x, toPos.y - fromPos.y, toPos.y - fromPos.y)

		local playersTeleported = 0
		for _, spectator in ipairs(spectators) do
			if spectator:isPlayer() then
				spectator:teleportTo(teleportDestination)
				spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				playersTeleported = playersTeleported + 1
			end
		end

		Game.createMonster("Lersatio", Position(32967, 31459, 1))
		Game.createMonster("Vampire", Position(32966, 31459, 1))
		Game.createMonster("Vampire", Position(32968, 31459, 1))
	end

	return true
end

lersatio:id(8667)
lersatio:register()
