local targetIdList = {
 	--health potions casks
	[28555] = {itemId = 7636, transform = 7618}, [28579] = {itemId = 7636, transform = 7618}, -- Health Potion --
 	[28556] = {itemId = 7634, transform = 7588}, [28580] = {itemId = 7634, transform = 7588}, -- Strong Health --
 	[28557] = {itemId = 7635, transform = 7591}, [28581] = {itemId = 7635, transform = 7591}, -- Great Health --
 	[28558] = {itemId = 7635, transform = 8473}, [28582] = {itemId = 7635, transform = 8473}, -- Ultimate Health --
 	[28559] = {itemId = 7635, transform = 26031}, [28583] = {itemId = 7635, transform = 26031}, -- Supreme Health --
 	--mana potions casks
 	[28565] = {itemId = 7636, transform = 7620}, [28584] = {itemId = 7636, transform = 7620}, -- Mana Potion --
 	[28566] = {itemId = 7634, transform = 7589}, [28585] = {itemId = 7634, transform = 7589}, -- Strong Mana --
 	[28567] = {itemId = 7635, transform = 7590}, [28586] = {itemId = 7635, transform = 7590}, -- Great Mana --
 	[28568] = {itemId = 7635, transform = 26029}, [28587] = {itemId = 7635, transform = 26029}, -- Ultimate Mana --
 	--spirit potions caks
 	[28575] = {itemId = 7635, transform = 8472}, [28589] = {itemId = 7635, transform = 8472}, -- Great Spirit --
 	[28576] = {itemId = 7635, transform = 26030}, [28590] = {itemId = 7635, transform = 26030}, --Ultimate Spirit --
 }

local flasks = Action()

function flasks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target:getId() >= 28535 and target:getId() <= 28590 then
	local house = player:getTile():getHouse()
	if house and house:canEditAccessList(SUBOWNER_LIST, player) and house:canEditAccessList(doorId, player) or target:getId() >= 28579 then
	elseif target:getId() >= 28535 and target:getId() < 28579 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Sorry, casks only can be useds inside house.')
		return false
	else
		return false
	end

	if target then
		local charges = target:getCharges()
		local itemCount = item:getCount()
 		if itemCount > charges then
			itemCount = charges
		end

 		local targetId = targetIdList[target:getId()]
 		if targetId then
 			if item:getId() == targetId.itemId then
				if not(itemCount == item:getCount()) then
					local potMath = item:getCount() - itemCount
					if not(item:getParent():isContainer() and item:getParent():addItem(item:getId(), potMath)) then
						player:addItem(item:getId(), potMath, true)
					end
				end
				item:transform(targetId.transform, itemCount)
				charges = charges - itemCount
				target:transform(target:getId(), charges)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('Remaining %s charges.', charges))

				if charges == 0 then
					target:remove()
				end
 			end
 		end
	end
	return true
end
end

flasks:id(7634, 7635, 7636)
flasks:register()
