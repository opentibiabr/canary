local config = {
	[2127] = { text = "This mission stinks ... and now you do as well!", condition = true, transformId = 107 },
	[6065] = { text = "You carefully gather the quara ink", transformId = 9149 },
	[18230] = { text = "You carefully gather the stalker blood.", transformId = 125 },
}

local poisonField = Condition(CONDITION_OUTFIT)
poisonField:setTicks(8000)

local exterminatorFlask = Action()

function exterminatorFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4207 then
		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.TheExterminator) ~= 1 then
			return false
		end
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.TheExterminator, 2)
		item:transform(2874, 0)
		toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
		return true
	end

	-- What a Foolish Quest
	local targetItem = config[target.itemid]
	if not targetItem then
		return false
	end

	if targetItem.condition then
		player:addCondition(poisonField)
	end

	player:say(targetItem.text, TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
	item:transform(targetItem.transformId)
	return true
end

exterminatorFlask:id(135)
exterminatorFlask:register()
