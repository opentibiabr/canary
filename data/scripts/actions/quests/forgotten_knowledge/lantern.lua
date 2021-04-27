local config = {
	[26402] = {transformId = 26406},
	[26406] = {transformId = 26402}
}

local forgottenKnowledgeLantern = Action()
function forgottenKnowledgeLantern.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lantern = config[item.itemid]
	if not lantern then
		return true
	end

	if not player:getStorageValue(26402) == 1 then
		return false
	end
	if item:getId() == 26402 then
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
		local msg = 'As you start polishing the lantern it begins to glow in an otherworldly light.'
		if player:getPosition():getDistance(Position(32891, 31619, 10)) < 2 then
			if not player:getItemById(26401, true) then
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

forgottenKnowledgeLantern:id(26402,26406)
forgottenKnowledgeLantern:register()