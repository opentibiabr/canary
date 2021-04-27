local effectPositions = {
	Position(32312, 31745, 9),
	Position(32313, 31745, 9),
	Position(32314, 31746, 9),
	Position(32315, 31746, 9),
	Position(32316, 31746, 9),
	Position(32317, 31745, 9)
}

local function removeKitty(monsterId)
	local monster = Monster(monsterId)
	if monster then
		monster:remove()
	end
end

local whatFoolishCat = Action()
function whatFoolishCat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WhatAFoolish.Questline) ~= 19
			or player:getStorageValue(Storage.WhatAFoolish.CatBasket) == 1 then
		return false
	end

	player:setStorageValue(Storage.WhatAFoolish.CatBasket, 1)
	player:say('The queen\'s cat is not amused!', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
	player:say('Fchhhhh', TALKTYPE_MONSTER_SAY, false, player, effectPositions[1])

	for i = 1, #effectPositions do
		effectPositions[i]:sendMagicEffect(CONST_ME_POFF)
	end

	Game.createItem(7487, 1, toPosition)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	local monster = Game.createMonster('Kitty', Position(toPosition.x, toPosition.y + 1, toPosition.z))
	addEvent(removeKitty, 10000, monster.uid)
	return true
end

whatFoolishCat:id(7486)
whatFoolishCat:register()