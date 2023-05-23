local prision = Position(33170, 31253, 11)
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local lizardsTrap = MoveEvent()

function lizardsTrap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(TheNewFrontier.Questline) == 21
	and player:getStorageValue(TheNewFrontier.Mission07[1]) == 1
	and player:getStorageValue(TheNewFrontier.Mission08) < 1 then
		player:setStorageValue(TheNewFrontier.Mission07[1], 2) -- Questlog, "Mission 07: Messengers Of Peace"
		player:setStorageValue(TheNewFrontier.Mission08, 1) -- Questlog, "Mission 08: An Offer You Can't Refuse"
		player:setStorageValue(TheNewFrontier.Questline, 22)
		player:say("So far for the negotiating peace. Now you have other problems to handle.", TALKTYPE_MONSTER_SAY)
	end
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:teleportTo(prision)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

lizardsTrap:position(Position(33169, 31253, 10),Position(33170, 31253, 10),Position(33171, 31253, 10))
lizardsTrap:register()
