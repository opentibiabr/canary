local config = {
	{ leverPos = Position(32820, 32321, 10), firewallPos = Position(32831, 32333, 11) },
	{ leverPos = Position(32820, 32345, 10), firewallPos = Position(32833, 32333, 11) },
	{ leverPos = Position(32847, 32339, 10), firewallPos = Position(32835, 32333, 11) },
	{ leverPos = Position(32847, 32327, 10), firewallPos = Position(32837, 32333, 11) },
	{ leverPos = Position(32813, 32329, 10), firewallPos = Position(32839, 32333, 11) },
}

local function doRemoveFirewalls(fwPos)
	local tile = Position(fwPos):getTile()
	if tile then
		local thing = tile:getItemById(6288)
		if thing then
			thing:remove()
		end
	end
end

local pitsOfInfernoWalls = Action()
function pitsOfInfernoWalls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #config do
		local data = config[i]
		if fromPosition == data.leverPos then
			local firewallPos = data.firewallPos
			if item.itemid == 2772 then
				doRemoveFirewalls(firewallPos)
				Position(firewallPos):sendMagicEffect(CONST_ME_FIREAREA)
			else
				Game.createItem(6288, 1, firewallPos)
				Position(firewallPos):sendMagicEffect(CONST_ME_FIREAREA)
			end
			item:transform(item.itemid == 2772 and 2773 or 2772)
		end
	end
	return true
end

for _, data in ipairs(config) do
	pitsOfInfernoWalls:position(data.leverPos)
end
pitsOfInfernoWalls:register()
