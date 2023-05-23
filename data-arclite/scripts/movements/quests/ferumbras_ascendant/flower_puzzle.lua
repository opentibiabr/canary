local positions = {
	[1] = {
		squarePos = Position(33452, 32721, 14),
		flowerOne = Position(33455, 32685, 14),
		flowerTwo = Position(33455, 32691, 14),
		flowerThree = Position(33455, 32707, 14)
	},
	[2] = {
		squarePos = Position(33455, 32721, 14),
		flowerOne = Position(33456, 32685, 14),
		flowerTwo = Position(33456, 32691, 14),
		flowerThree = Position(33456, 32707, 14)
	},
	[3] = {
		squarePos = Position(33458, 32721, 14),
		flowerOne = Position(33457, 32685, 14),
		flowerTwo = Position(33457, 32691, 14),
		flowerThree = Position(33457, 32707, 14)
	},
	[4] = {
		squarePos = Position(33461, 32721, 14),
		flowerOne = Position(33458, 32685, 14),
		flowerTwo = Position(33458, 32691, 14),
		flowerThree = Position(33458, 32707, 14)
	},
	[5] = {
		squarePos = Position(33464, 32721, 14),
		flowerOne = Position(33459, 32685, 14),
		flowerTwo = Position(33459, 32691, 14),
		flowerThree = Position(33459, 32707, 14)
	},
	[6] = {
		squarePos = Position(33467, 32721, 14),
		flowerOne = Position(33460, 32685, 14),
		flowerTwo = Position(33460, 32691, 14),
		flowerThree = Position(33460, 32707, 14)}, -- done
	[7] = {
		squarePos = Position(33452, 32724, 14),
		flowerOne = Position(33455, 32686, 14),
		flowerTwo = Position(33455, 32692, 14),
		flowerThree = Position(33455, 32708, 14)
	},
	[8] = {
		squarePos = Position(33455, 32724, 14),
		flowerOne = Position(33456, 32686, 14),
		flowerTwo = Position(33456, 32692, 14),
		flowerThree = Position(33456, 32708, 14)
	},
	[9] = {
		squarePos = Position(33458, 32724, 14),
		flowerOne = Position(33457, 32686, 14),
		flowerTwo = Position(33457, 32692, 14),
		flowerThree = Position(33457, 32708, 14)
	},
	[10] = {
		squarePos = Position(33461, 32724, 14),
		flowerOne = Position(33458, 32686, 14),
		flowerTwo = Position(33458, 32692, 14),
		flowerThree = Position(33458, 32708, 14)
	},
	[11] = {
		squarePos = Position(33464, 32724, 14),
		flowerOne = Position(33459, 32686, 14),
		flowerTwo = Position(33459, 32692, 14),
		flowerThree = Position(33459, 32708, 14)
	},
	[12] = {
		squarePos = Position(33467, 32724, 14),
		flowerOne = Position(33460, 32686, 14),
		flowerTwo = Position(33460, 32692, 14),
		flowerThree = Position(33460, 32708, 14)}, -- done
	[13] = {
		squarePos = Position(33452, 32727, 14),
		flowerOne = Position(33455, 32687, 14),
		flowerTwo = Position(33455, 32693, 14),
		flowerThree = Position(33455, 32709, 14)
	},
	[14] = {
		squarePos = Position(33455, 32727, 14),
		flowerOne = Position(33456, 32687, 14),
		flowerTwo = Position(33456, 32693, 14),
		flowerThree = Position(33456, 32709, 14)
	},
	[15] = {
		squarePos = Position(33458, 32727, 14),
		flowerOne = Position(33457, 32687, 14),
		flowerTwo = Position(33457, 32693, 14),
		flowerThree = Position(33457, 32709, 14)
	},
	[16] = {
		squarePos = Position(33461, 32727, 14),
		flowerOne = Position(33458, 32687, 14),
		flowerTwo = Position(33458, 32693, 14),
		flowerThree = Position(33458, 32709, 14)
	},
	[17] = {
		squarePos = Position(33464, 32727, 14),
		flowerOne = Position(33459, 32687, 14),
		flowerTwo = Position(33459, 32693, 14),
		flowerThree = Position(33459, 32709, 14)
	},
	[18] = {
		squarePos = Position(33467, 32727, 14),
		flowerOne = Position(33460, 32687, 14),
		flowerTwo = Position(33460, 32693, 14),
		flowerThree = Position(33460, 32709, 14)}

}

local flowerPuzzle = MoveEvent()

function flowerPuzzle.onStepIn(creature, item, position, fromPosition)
	for i = 1, #positions do
		local itempos = positions[i]
		if position == itempos.squarePos then
			if item.itemid == 22538 then
				item:transform(22539)
				local flowerOne = Tile(itempos.flowerOne):getItemById(3676)
				or Tile(itempos.flowerOne):getItemById(3678)
				or Tile(itempos.flowerOne):getItemById(3677)
				local flowerTwo = Tile(itempos.flowerTwo):getItemById(3676)
				or Tile(itempos.flowerTwo):getItemById(3678)
				or Tile(itempos.flowerTwo):getItemById(3677)
				local flowerThree = Tile(itempos.flowerThree):getItemById(3676)
				or Tile(itempos.flowerThree):getItemById(3678)
				or Tile(itempos.flowerThree):getItemById(3677)
				if not flowerOne then
					flowerOne = Game.createItem(3677, 1, itempos.flowerOne)
				end
				if not flowerTwo then
					flowerTwo = Game.createItem(3677, 1, itempos.flowerTwo)
				end
				if not flowerThree then
					flowerThree = Game.createItem(3677, 1, itempos.flowerThree)
				end
				flowerOne:transform(3677)
				flowerTwo:transform(3677)
				flowerThree:transform(3677)
			elseif item.itemid == 22539 then
				item:transform(22540)
				local flowerOne = Tile(itempos.flowerOne):getItemById(3676)
				or Tile(itempos.flowerOne):getItemById(3678)
				or Tile(itempos.flowerOne):getItemById(3677)
				local flowerTwo = Tile(itempos.flowerTwo):getItemById(3676)
				or Tile(itempos.flowerTwo):getItemById(3678)
				or Tile(itempos.flowerTwo):getItemById(3677)
				local flowerThree = Tile(itempos.flowerThree):getItemById(3676)
				or Tile(itempos.flowerThree):getItemById(3678)
				or Tile(itempos.flowerThree):getItemById(3677)
				if not flowerOne then
					flowerOne = Game.createItem(3678, 1, itempos.flowerOne)
				end
				if not flowerTwo then
					flowerTwo = Game.createItem(3678, 1, itempos.flowerTwo)
				end
				if not flowerThree then
					flowerThree = Game.createItem(3678, 1, itempos.flowerThree)
				end
				flowerOne:transform(3678)
				flowerTwo:transform(3678)
				flowerThree:transform(3678)
			elseif item.itemid == 22540 then
				item:transform(22541)
				local flowerOne = Tile(itempos.flowerOne):getItemById(3676)
				or Tile(itempos.flowerOne):getItemById(3678)
				or Tile(itempos.flowerOne):getItemById(3677)
				local flowerTwo = Tile(itempos.flowerTwo):getItemById(3676)
				or Tile(itempos.flowerTwo):getItemById(3678)
				or Tile(itempos.flowerTwo):getItemById(3677)
				local flowerThree = Tile(itempos.flowerThree):getItemById(3676)
				or Tile(itempos.flowerThree):getItemById(3678)
				or Tile(itempos.flowerThree):getItemById(3677)
				if not flowerOne then
					flowerOne = Game.createItem(3676, 1, itempos.flowerOne)
				end
				if not flowerTwo then
					flowerTwo = Game.createItem(3676, 1, itempos.flowerTwo)
				end
				if not flowerThree then
					flowerThree = Game.createItem(3676, 1, itempos.flowerThree)
				end
				flowerOne:transform(3676)
				flowerTwo:transform(3676)
				flowerThree:transform(3676)
			elseif item.itemid == 22541 then
				item:transform(22538)
				local flowerOne = Tile(itempos.flowerOne):getItemById(3676)
				or Tile(itempos.flowerOne):getItemById(3678)
				or Tile(itempos.flowerOne):getItemById(3677)
				local flowerTwo = Tile(itempos.flowerTwo):getItemById(3676)
				or Tile(itempos.flowerTwo):getItemById(3678)
				or Tile(itempos.flowerTwo):getItemById(3677)
				local flowerThree = Tile(itempos.flowerThree):getItemById(3676)
				or Tile(itempos.flowerThree):getItemById(3678)
				or Tile(itempos.flowerThree):getItemById(3677)
				if flowerOne then
					flowerOne:remove()
				end
				if flowerTwo then
					flowerTwo:remove()
				end
				if flowerThree then
					flowerThree:remove()
				end
			end
		end
	end
	return true
end

flowerPuzzle:type("stepin")
flowerPuzzle:id(22538, 22539, 22540, 22541)
flowerPuzzle:register()
