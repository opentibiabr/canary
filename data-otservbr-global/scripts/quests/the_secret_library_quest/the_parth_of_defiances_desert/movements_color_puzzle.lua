local color = {
	[1] = { itemid = 4858, position = Position(32945, 32288, 10), value = 2, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.RedColor },
	[2] = { itemid = 5581, position = Position(32948, 32288, 10), value = 1, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.GreenColor },
	[3] = { itemid = 8695, position = Position(32951, 32288, 10), value = 3, storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.BlueColor },
}

local movements_desert_color_puzzle = MoveEvent()

function movements_desert_color_puzzle.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	local player = Player(creature:getId())
	if player then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.ColorPuzzle) < 1 then
			for _, k in pairs(color) do
				if item.itemid == k.itemid and position == k.position then
					if player:getStorageValue(k.storage) < k.value then
						if player:getStorageValue(k.storage) < 0 then
							player:setStorageValue(k.storage, 0)
						end
						player:setStorageValue(k.storage, player:getStorageValue(k.storage) + 1)
					else
						for i = 1, #color do
							player:setStorageValue(color[i].storage, 0)
						end
					end
				end
			end
			if player:getStorageValue(color[1].storage) == color[1].value and player:getStorageValue(color[2].storage) == color[2].value and player:getStorageValue(color[3].storage) == color[3].value then
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.ColorPuzzle, 1)
				player:say("Access granted!", TALKTYPE_MONSTER_SAY)
			end
		end
	end

	return true
end

movements_desert_color_puzzle:aid(4933)
movements_desert_color_puzzle:register()
