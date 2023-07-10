local bellow = MoveEvent()

function bellow.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local steameffect = CONST_ME_SMOKE
	if not player then
		return true
	end
	if item.itemid == 9121 then
		item:transform(9120)
	end
	local crucibleItem = Tile(Position(32699, 31494, 11)):getItemById(7813)
	if not crucibleItem then
		return true
	end
	if crucibleItem.actionid == 50119 then
		crucibleItem:setActionId(50120)
		Position(32697, 31494, 11):sendMagicEffect(steameffect)
	elseif crucibleItem.actionid == 50120 then
		crucibleItem:setActionId(50121)
		Position(32695, 31494, 10):sendMagicEffect(steameffect)
		Position(32696, 31494, 10):sendMagicEffect(steameffect)
	elseif crucibleItem.actionid == 50121 then
		player:say('TSSSSHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32695, 31494, 11))
		player:say('CHOOOOOOOHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32698, 31492, 11))
	end
	return true
end

bellow:type("stepin")
bellow:aid(40025)
bellow:register()

bellow = MoveEvent()

function bellow.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.itemid == 9120 then
		item:transform(9121)
	end
	return true
end

bellow:type("stepout")
bellow:aid(40025)
bellow:register()
