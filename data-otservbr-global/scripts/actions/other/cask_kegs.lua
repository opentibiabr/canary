local targetIdList = {
	--health potions casks
	[25879] = {itemId = 285, transform = 266, house = true}, -- Health Potion --
	[25880] = {itemId = 283, transform = 236, house = true}, -- Strong Health --
	[25881] = {itemId = 284, transform = 239, house = true}, -- Great Health --
	[25882] = {itemId = 284, transform = 7643, house = true}, -- Ultimate Health --
	[25883] = {itemId = 284, transform = 23375, house = true}, -- Supreme Health --
	--mana potions casks
	[25889] = {itemId = 285, transform = 268, house = true}, -- Mana Potion --
	[25890] = {itemId = 283, transform = 237, house = true}, -- Strong Mana --
	[25891] = {itemId = 284, transform = 238, house = true}, -- Great Mana --
	[25892] = {itemId = 284, transform = 23373, house = true}, -- Ultimate Mana --
	--spirit potions caks
	[25899] = {itemId = 284, transform = 7642, house = true}, -- Great Spirit --
	[25900] = {itemId = 284, transform = 23374, house = true}, --Ultimate Spirit --

	--health potions kegs
	[25903] = {itemId = 285, transform = 266}, -- Health Potion --
	[25904] = {itemId = 283, transform = 236}, -- Strong Health --
	[25905] = {itemId = 284, transform = 239}, -- Great Health --
	[25906] = {itemId = 284, transform = 7643}, -- Ultimate Health --
	[25907] = {itemId = 284, transform = 23375}, -- Supreme Health --

	--mana potion kegs
	[25908] = {itemId = 285, transform = 268}, -- Mana Potion --
	[25909] = {itemId = 283, transform = 237}, -- Strong Mana --
	[25910] = {itemId = 284, transform = 238}, -- Great Mana --
	[25911] = {itemId = 284, transform = 23373}, -- Ultimate Mana --

	--spirit potions kegs
	[25913] = {itemId = 284, transform = 7642}, -- Great Spirit --
	[25914] = {itemId = 284, transform = 23374} --Ultimate Spirit --
}

local flasks = Action()

function flasks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target then
		return false
	end

	local charges = target:getCharges()
	local itemCount = item:getCount()
	local recharged = itemCount

	if recharged > charges then
		recharged = charges
	end

	local targetId = targetIdList[target:getId()]
	if targetId and targetId.itemId == item:getId() and charges > 0 then
		-- Check is cask item is in house
		if targetId.house and not player:getTile():getHouse() then
			return false
		end

		charges = charges - recharged
		target:transform(target:getId(), charges)
		if charges == 0 then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("No more charges left. Your keg has run dry.", charges))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Remaining %s charges.", charges))
		end

		player:addItem(targetId.transform, recharged)
		if itemCount >= recharged then
			item:transform(targetId.itemId, itemCount - recharged)
		end
		return true
	end
	return false
end

flasks:id(283, 284, 285)
flasks:register()
