local rottinWoodBroken = Action()
function rottinWoodBroken.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
	local position = { x = 32655, y = 32205, z = 7 } --32655, 32205, 7
	if player:getStorageValue(Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.RottinStart) < 6 then
		player:setStorageValue(Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.RottinStart, 6)
		player:teleportTo(position)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:say("There we go.", TALKTYPE_MONSTER_SAY)
	else
		player:say("You already done this mission, go and talk with Rottin Wood to others missions.", TALKTYPE_MONSTER_SAY)
		return true
	end
	return true
end

rottinWoodBroken:aid(42501, 42502, 42503, 42504, 42505)
rottinWoodBroken:register()
