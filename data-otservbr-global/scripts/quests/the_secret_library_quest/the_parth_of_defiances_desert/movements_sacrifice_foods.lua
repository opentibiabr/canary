local foods = {
	3606,
	3250,
	3577,
	21145,
	21144,
	21143,
	3578,
	3579,
	23535,
	23545,
	3580,
	3581,
	3582,
	3583,
	3584,
	3585,
	3586,
	3587,
	3588,
	3589,
	3590,
	3591,
	3592,
	904,
	3593,
	3594,
	3595,
	3596,
	3597,
	3598,
	3599,
	3600,
	3601,
	3602,
	3607,
	3723,
	3724,
	3725,
	3726,
	3727,
	3728,
	3729,
	3730,
	3731,
	3732,
	5096,
	20310,
	5678,
	6125,
	6277,
	6278,
	6392,
	6393,
	6500,
	6541,
	6542,
	6543,
	6544,
	6545,
	6569,
	6574,
	7158,
	7159,
	229,
	7373,
	7374,
	7375,
	7376,
	7377,
	836,
	841,
	901,
	169,
	8010,
	8011,
	8012,
	8013,
	8014,
	8015,
	8016,
	8017,
	8019,
	8177,
	8197,
	9537,
	10329,
	10453,
	10219,
	11459,
	11460,
	11461,
	11462,
	11681,
	11682,
	11683,
	12310,
	13992,
	14084,
	14085,
	14681,
	15795,
	16103,
	17457,
	17820,
	17821,
	21146,
	22187,
	22185,
	24382,
	24383,
	24396,
	24948,
	25692,
	30198,
	30202,
	31560,
	32069,
	37530,
	37531,
	37532,
	37533,
}

local pillars = {
	{ position = Position(32963, 32280, 10), itemPosition = Position(32961, 32280, 10) },
	{ position = Position(32963, 32282, 10), itemPosition = Position(32961, 32282, 10) },
	{ position = Position(32963, 32284, 10), itemPosition = Position(32961, 32284, 10) },
	{ position = Position(32963, 32286, 10), itemPosition = Position(32961, 32286, 10) },
}

local storageValue = Storage.Quest.U11_80.TheSecretLibrary.Darashia.EatenFood
local transformTime = 5 * 60 * 1000

local perimeter1Min = Position(32964, 32278, 10)
local perimeter1Max = Position(32966, 32290, 10)

local perimeter2Min = Position(32961, 32288, 10)
local perimeter2Max = Position(32963, 32290, 10)

local function isFood(itemid)
	for _, foodid in ipairs(foods) do
		if foodid == itemid then
			return true
		end
	end
	return false
end

local function findPlayerInPerimeter()
	-- Verificar ambos os perímetros
	for x = perimeter1Min.x, perimeter1Max.x do
		for y = perimeter1Min.y, perimeter1Max.y do
			local tile = Tile(Position(x, y, perimeter1Min.z))
			if tile then
				local player = tile:getTopCreature()
				if player and player:isPlayer() then
					return player
				end
			end
		end
	end
	for x = perimeter2Min.x, perimeter2Max.x do
		for y = perimeter2Min.y, perimeter2Max.y do
			local tile = Tile(Position(x, y, perimeter2Min.z))
			if tile then
				local player = tile:getTopCreature()
				if player and player:isPlayer() then
					return player
				end
			end
		end
	end
	return nil
end

local foodSacrifice = MoveEvent()

function foodSacrifice.onAddItem(moveitem, tileitem, position)
	if not isFood(moveitem.itemid) then
		return true
	end

	for _, pillar in ipairs(pillars) do
		if position == pillar.position and tileitem:getActionId() == 4932 then
			local itemToTransform = Tile(pillar.itemPosition):getItemById(27987)
			if itemToTransform then
				-- Transformar item 27987 em 27989
				itemToTransform:transform(27989)

				-- Remover o item de comida e adicionar o item 24490 em seu lugar
				local foodPosition = moveitem:getPosition()
				moveitem:remove()
				Game.createItem(24490, 1, foodPosition)

				addEvent(function()
					local revertedTile = Tile(pillar.itemPosition)
					if revertedTile then
						local itemToRevert = revertedTile:getItemById(27989)
						if itemToRevert then
							itemToRevert:transform(27987)
						end
					end
					-- Reverter o item 24490 de volta (remover)
					local revertFoodItem = Tile(foodPosition):getItemById(24490)
					if revertFoodItem then
						revertFoodItem:remove()
					end
				end, transformTime)

				local player = findPlayerInPerimeter()
				if player then
					local currentProgress = player:getStorageValue(storageValue)
					if currentProgress < 0 then
						currentProgress = 0
					end
					if currentProgress < 4 then
						player:setStorageValue(storageValue, currentProgress + 1)
					end
					if player:getStorageValue(storageValue) == 4 then
						if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Questlog) < 6 then
							player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, 6)
						end
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have completed the food offering ritual!")
					end
				end

				return true
			end
		end
	end
	return true
end

foodSacrifice:type("additem")
foodSacrifice:aid(4932)
foodSacrifice:register()
