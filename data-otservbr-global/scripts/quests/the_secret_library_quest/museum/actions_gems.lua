local basins = {
	[1] = { position = Position(33219, 32100, 9), item = 27868, storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.YellowGem },
	[2] = { position = Position(33260, 32084, 9), item = 27867, storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.GreenGem },
	[3] = { position = Position(33318, 32090, 9), item = 27869, storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.RedGem },
}

local actions_museum_gems = Action()

function actions_museum_gems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, p in pairs(basins) do
		if p.item == item.itemid then
			if player:getStorageValue(p.storage) < 1 then
				target:getPosition():sendMagicEffect(CONST_ME_SOUND_PURPLE)
				player:setStorageValue(p.storage, 1)
				item:remove(1)
			end
		end
	end

	return true
end

for _, gem in pairs(basins) do
	actions_museum_gems:id(gem.item)
end

actions_museum_gems:register()
