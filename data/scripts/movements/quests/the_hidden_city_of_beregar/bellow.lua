local bellow = MoveEvent()

function bellow.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local crucibleItem = Tile(Position(32699, 31494, 11)):getItemById(8641)
	if not crucibleItem then
		return true
	end

	if crucibleItem.actionid == 0 then
		crucibleItem:setActionId(50120)
		Position(32696, 31494, 11):sendMagicEffect(CONST_ME_POFF)
	elseif crucibleItem.actionid == 50120 then
		crucibleItem:setActionId(50121)
		Position(32695, 31494, 10):sendMagicEffect(CONST_ME_POFF)
	elseif crucibleItem.actionid == 50121 then
		player:say('TSSSSHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32695, 31494, 11))
		player:say('CHOOOOOOOHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32698, 31492, 11))
	end
	return true
end

bellow:type("stepin")
bellow:uid(50107)
bellow:register()
