local config = {
	[1] = "Coconut Shrimp Bake\n- 5 vials of milk\n- 5 brown mushrooms\n- 5 red mushrooms\n- 10 rice balls\n- 10 shrimps\n\n",
	[2] = "Pot of Blackjack\n- 5 sandcrawler shells\n- 2 vials of water\n- 20 carrots\n- 10 potatoes\n- 3 jalapeno peppers\n\n",
	[3] = "Demonic Candy Ball\n- 3 candies\n- 3 candy canes\n- 2 bar of chocolate\n- 15 gingerbreadmen\n- 1 concentrated demonic blood\n\n",
	[4] = "Sweet Mangonaise Elixir\n- 100 eggs\n- 50 mangoes\n- 10 honeycombs\n- 1 bottle of bug milk\n- 1 blessed wooden stake\n\n"
}

local hotCuisineCook2 = Action()
function hotCuisineCook2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = {}
	for i = 1, 4 do
		text[#text + 1] = config[i]
	end
	player:showTextDialog(item.itemid, table.concat(text))
	return true
end

hotCuisineCook2:id(12497)
hotCuisineCook2:register()