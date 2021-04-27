local config = {
	[1] = "Rotworm Stew\n- 2 Pieces of meat\n- 2 Vials of beer\n- 20 Potatoes\n- 1 Onion\n- 1 Garlic\n- 5 Ounces of flour\n\n",
	[2] = "Hydra Tongue Salad\n- 2 Hydra tongues\n- 2 Tomatoes\n- 1 Cucumber\n- 2 Eggs\n- 1 Troll green\n- 1 Vial of wine\n\n",
	[3] = "Roasted Dragon Wings\n- 1 Fresh dead bat\n- 3 Jalape�o peppers\n- 5 Brown breads\n- 2 Eggs\n- 1 Powder herb\n- 5 Red mushrooms\n\n",
	[4] = "Tropical Fried Terrorbird\n- 1 Fresh dead chicken\n- 2 Lemons\n- 2 Oranges\n- 2 Mangos\n- 2 Vials of coconut milk\n- 1 Stone herb\n\n",
	[5] = "Banana Chocolate Shake\n- 1 Bar of chocolate\n- 1 Cream cake\n- 2 Bananas\n- 2 Vials of milk\n- 1 Sling herb\n- 1 Star herb\n\n",
	[6] = "Veggie Casserole\n- 2 Carrots\n- 2 Tomatoes\n- 2 Corncobs\n- 2 Cucumbers\n- 1 Onion\n- 1 Garlic\n- 1 Cheese\n- 20 White mushrooms\n- 5 Brown mushrooms\n\n",
	[7] = "Filled Jalape�o Peppers\n- 10 Jalape�o peppers\n- 2 Cheese\n- 1 Troll green\n- 1 Shadow herb\n- 1 Vial of mead\n- 2 Eggs\n\n",
	[8] = "Blessed Steak\n- 1 Piece of ham\n- 5 Plums\n- 1 Onions\n- 2 Beetroot\n- 1 Pumpkin\n- 2 Jalape�o peppers\n\n",
	[9] = "Northern Fishburger\n- 1 Northern pike\n- 1 Rainbow trout\n- 1 Green perch\n- 5 Shrimps\n- 2 Rolls- 1 Fern\n\n",
	[10] = "Carrot Cake\n- 5 Carrots\n- 1 Vial of milk\n- 1 Lemon\n- 10 Ounces of flour\n- 2 Eggs\n- 10 Cookies\n- 2 Peanuts"
}

local hotCuisineCook1 = Action()
function hotCuisineCook1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = {}
	for i = 1, 10 do
		text[#text + 1] = config[i]
	end
	player:showTextDialog(item.itemid, table.concat(text))
	return true
end

hotCuisineCook1:id(10006)
hotCuisineCook1:register()