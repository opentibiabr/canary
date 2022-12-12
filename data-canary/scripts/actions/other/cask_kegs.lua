local targetIdList = {
	--health potions casks
	[25879] = {itemId = 285, transform = 266}, -- Health Potion --
	[25880] = {itemId = 283, transform = 236}, -- Strong Health --
	[25881] = {itemId = 284, transform = 239}, -- Great Health --
	[25882] = {itemId = 284, transform = 7643}, -- Ultimate Health --
	[25883] = {itemId = 284, transform = 23375}, -- Supreme Health --
	--mana potions casks
	[25889] = {itemId = 285, transform = 268}, -- Mana Potion --
	[25890] = {itemId = 283, transform = 237}, -- Strong Mana --
	[25891] = {itemId = 284, transform = 238}, -- Great Mana --
	[25892] = {itemId = 284, transform = 23373}, -- Ultimate Mana --
	--spirit potions caks
	[25899] = {itemId = 284, transform = 7642}, -- Great Spirit --
	[25900] = {itemId = 284, transform = 23374}, --Ultimate Spirit --

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
	if not target or not player:getTile():getHouse() then
		return false
	end

	local charges = target:getCharges()
	local itemCount = item:getCount()
	if itemCount > charges then
		itemCount = charges
	end

	local targetId = targetIdList[target:getId()]
	if targetId and item:getId() == targetId.itemId and charges > 0 then
		local potMath = item:getCount() - itemCount
		local parent = item:getParent()
		if not (parent:isContainer() and parent:addItem(item:getId(), potMath)) then
			player:addItem(item:getId(), potMath, true)
		end

		item:transform(targetId.transform, itemCount)
		charges = charges - itemCount
		target:transform(target:getId(), charges)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Remaining %s charges.", charges))
		if charges == 0 then
			target:remove()
		end
		return true
	end
	return false
end

flasks:id(283, 284, 285)
flasks:register()
