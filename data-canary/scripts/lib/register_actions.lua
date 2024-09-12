local holeId = { 294, 369, 370, 385, 394, 411, 412, 413, 432, 433, 435, 482, 483, 594, 595, 609, 610, 615, 868, 874, 1156, 4824, 7515, 7516, 7517, 7518, 7519, 7520, 7521, 7522, 7737, 7755, 7762, 7767, 7768, 8144, 8690, 8709, 12203, 12961, 17239, 19220, 23364 } -- usable rope holes, for rope spots see global.lua
local wildGrowth = { 2130, 3635, 30224 } -- wild growth destroyable by machete
local jungleGrass = { -- grass destroyable by machete
	[3696] = 3695,
	[3702] = 3701,
	[17153] = 17151,
}
local groundIds = { 354, 355 } -- pick usable grounds
local sandIds = { 231 } -- desert sand
local fruits = { 3584, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3595, 3596, 5096, 8011, 8012, 8013 } -- fruits to make decorated cake with knife
local holes = { 593, 606, 608, 867, 21341 } -- holes opened by shovel
local ropeSpots = { 386, 421, 12935, 12936, 14238, 17238, 21501, 21965, 21966, 21967, 21968, 23363 }

function destroyItem(player, item, fromPosition, target, toPosition, isHotkey)
	if type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) or target:hasAttribute(ITEM_ATTRIBUTE_ACTIONID) then
		return false
	end

	if toPosition.x == CONTAINER_POSITION then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local destroyId = ItemType(target.itemid):getDestroyId()
	if destroyId == 0 then
		return false
	end

	if math.random(7) == 1 then
		local item = Game.createItem(destroyId, 1, toPosition)
		if item then
			item:decay()
		end

		-- Move items outside the container
		if target:isContainer() then
			for i = target:getSize() - 1, 0, -1 do
				local containerItem = target:getItem(i)
				if containerItem then
					containerItem:moveTo(toPosition)
				end
			end
		end
		target:remove(1)
	end
	toPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

function onUseMachete(player, item, fromPosition, target, toPosition, isHotkey)
	local targetId = target.itemid
	if not targetId then
		return true
	end

	if table.contains(wildGrowth, targetId) then
		toPosition:sendMagicEffect(CONST_ME_POFF)
		target:remove()
		return true
	end

	local grass = jungleGrass[targetId]
	if grass then
		target:transform(grass)
		target:decay()
		player:addAchievementProgress("Nothing Can Stop Me", 100)
		return true
	end
	return destroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 10310 then -- shiny stone refining
		local chance = math.random(1, 100)
		if chance == 1 then
			player:addItem(ITEM_CRYSTAL_COIN) -- 1% chance of getting crystal coin
		elseif chance <= 6 then
			player:addItem(ITEM_GOLD_COIN) -- 5% chance of getting gold coin
		elseif chance <= 51 then
			player:addItem(ITEM_PLATINUM_COIN) -- 45% chance of getting platinum coin
		else
			player:addItem(3028) -- 49% chance of getting small diamond
		end
		player:addAchievementProgress("Petrologist", 100)
		target:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		target:remove(1)
		return true
	end

	local tile = Tile(toPosition)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground then
		return false
	end

	if table.contains(groundIds, ground.itemid) and (ground:hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) or ground:hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) then
		ground:transform(394)
		ground:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)

		toPosition.z = toPosition.z + 1
		tile:relocateTo(toPosition)
		return true
	end

	-- Ice fishing hole
	if ground.itemid == 7200 then
		ground:transform(7236)
		ground:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
		return true
	end
	return false
end

function onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(toPosition)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if ground and table.contains(ropeSpots, ground:getId()) or tile:getItemById(12935) then
		if Tile(toPosition:moveUpstairs()):hasFlag(TILESTATE_PROTECTIONZONE) and player:isPzLocked() then
			player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
			return true
		end
		player:teleportTo(toPosition, false)
		return true
	elseif table.contains(holeId, target.itemid) then
		toPosition.z = toPosition.z + 1
		tile = Tile(toPosition)
		if tile then
			local thing = tile:getTopVisibleThing()
			if thing:isPlayer() then
				if Tile(toPosition:moveUpstairs()):hasFlag(TILESTATE_PROTECTIONZONE) and thing:isPzLocked() then
					return false
				end
				return thing:teleportTo(toPosition, false)
			end
			if thing:isItem() and thing:getType():isMovable() then
				return thing:moveTo(toPosition:moveUpstairs())
			end
		end
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end
	return false
end

function onUseShovel(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(toPosition)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground then
		return false
	end

	local groundId = ground:getId()
	if table.contains(holes, groundId) then
		ground:transform(groundId + 1)
		ground:decay()
		toPosition:moveDownstairs()
		toPosition.y = toPosition.y - 1
		if Tile(toPosition):hasFlag(TILESTATE_PROTECTIONZONE) and player:isPzLocked() then
			player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
			return true
		end
		player:teleportTo(toPosition, false)
		toPosition.z = toPosition.z + 1
		tile:relocateTo(toPosition)
		player:addAchievementProgress("The Undertaker", 500)
	elseif target.itemid == 867 then -- large hole
		target:transform(868)
		target:decay()
		player:addAchievementProgress("The Undertaker", 500)
	elseif target.itemid == 17950 then -- swamp digging
		if not player:hasExhaustion("swamp-digging") then
			local chance = math.random(1, 100)
			if chance <= 42 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dug up a dead snake.")
				player:addItem(4259)
			elseif chance >= 43 and chance <= 79 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dug up a small diamond.")
				player:addItem(3028)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dug up a leech.")
				player:addItem(17858)
			end

			player:setExhaustion("swamp-digging", 7 * 24 * 60 * 60)
			player:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		end
	elseif table.contains(sandIds, groundId) then
		local randomValue = math.random(1, 100)
		if target.actionid == 100 and randomValue <= 20 then
			ground:transform(615)
			ground:decay()
		elseif randomValue == 1 then
			Game.createItem(3042, 1, toPosition) -- Scarab Coin
			player:addAchievementProgress("Gold Digger", 100)
		elseif randomValue > 95 then
			Game.createMonster("Scarab", toPosition)
		end
		toPosition:sendMagicEffect(CONST_ME_POFF)
	else
		return false
	end
	return true
end

function onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 3453, 9596 }, item.itemid) then
		return false
	end

	if target.itemid == 3653 then -- wheat
		target:transform(3651)
		target:decay()
		Game.createItem(3605, 1, toPosition) -- bunch of wheat
		player:addAchievementProgress("Happy Farmer", 200)
		return true
	end
	return destroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseSickle(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 3293, 3306 }, item.itemid) then
		return false
	end

	if target.itemid == 5464 then -- burning sugar cane
		target:transform(5463)
		target:decay()
		Game.createItem(5466, 1, toPosition) -- bunch of sugar cane
		player:addAchievementProgress("Natural Sweetener", 50)
		return true
	end
	return destroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 3304, 9598 }, item.itemid) then
		return false
	end
	return destroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 3469, 9594, 9598 }, item.itemid) then
		return false
	end

	if table.contains(fruits, target.itemid) and player:removeItem(6277, 1) then
		target:remove(1)
		player:addItem(6278, 1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end
	return false
end

function onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({ 3468, 3470 }, item.itemid) then
		return false
	end
	return false
end
