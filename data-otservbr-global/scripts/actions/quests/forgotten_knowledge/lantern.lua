local config = {
	[23734] = {transformId = 23738},
	[23738] = {transformId = 23734}
}

local forgottenKnowledgeLantern = Action()
function forgottenKnowledgeLantern.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lantern = config[item.itemid]
	if not lantern then
		return true
	end

	if not player:getStorageValue(23734) == 1 then
		return false
	end
	if item:getId() == 23734 then
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
		local msg = 'As you start polishing the lantern it begins to glow in an otherworldly light.'
		if player:getPosition():getDistance(Position(32891, 31619, 10)) < 2 then
			if not player:getItemById(23733, true) then
				msg = 'In the light of the ghostsilver lantern you discover an otherwise invisible door. But you lack the key to open it.'
			else
				msg = 'In the light of the ghostsilver lantern you discover an otherwise invisible door. As you have the fitting key you can pass.'
			end
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
	end
	item:transform(lantern.transformId)
	return true
end

for itemId, itemInfo in pairs(config) do
	forgottenKnowledgeLantern:id(itemId)
end

forgottenKnowledgeLantern:register()
