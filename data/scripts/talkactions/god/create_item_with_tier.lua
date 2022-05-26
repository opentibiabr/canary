local tier = TalkAction("/testtier")

-- usage: /testtier item id or name, tier
-- example: /testtier falcon coif, 8
-- make sure to move the item at least 1 time to refresh item tier icon

function tier.onSay(player, words, param)
	local split = param:split(",")
	local itemType = ItemType(split[1])
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(split[1]))
		if not tonumber(split[1]) or itemType:getId() == 0 then
			player:sendCancelMessage("There is no item with that id or name.")
			return false
		end
	end
	local tier = tonumber(split[2])
	if tier <= 0 or tier == nil or tier > 10 then
		player:sendCancelMessage("Invalid tier count.")
		return false
	end

	player:addItem(itemType:getId(), 1):setTier(tier)
	return false
end

tier:separator(" ")
tier:register()
