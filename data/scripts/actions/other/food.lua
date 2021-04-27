local foods = {
	[2695] = {6, 'Gulp.'}, -- egg
	[2362] = {5, 'Crunch.'}, -- carrot
	[2666] = {15, 'Munch.'}, -- meat
	[23516] = {15, 'Burp.'}, -- Bottle of Glooth Wine
	[23515] = {15, 'Slurp.'}, -- Bowl of Glooth Soup
	[23514] = {10, 'Munch.'}, -- Bowl of Glooth Soup
	[2667] = {12, 'Munch.'}, -- fish
	[2668] = {10, 'Mmmm.'}, -- salmon
	[26191] = {30, 'Mmmm.'}, -- energy bar
	[26201] = {30, 'Mmmm.'}, -- energy drink
	[2669] = {17, 'Munch.'}, -- northern pike
	[2670] = {4, 'Gulp.'}, -- shrimp
	[2671] = {30, 'Chomp.'}, -- ham
	[2672] = {60, 'Chomp.'}, -- dragon ham
	[2673] = {5, 'Yum.'}, -- pear
	[2674] = {6, 'Yum.'}, -- red apple
	[2675] = {13, 'Yum.'}, -- orange
	[2676] = {8, 'Yum.'}, -- banana
	[2677] = {1, 'Yum.'}, -- blueberry
	[2678] = {18, 'Slurp.'}, -- coconut
	[2679] = {1, 'Yum.'}, -- cherry
	[2680] = {2, 'Yum.'}, -- strawberry
	[2681] = {9, 'Yum.'}, -- grapes
	[7966] = {9, 'Hum.'}, -- cream cake
	[2682] = {20, 'Yum.'}, -- melon
	[2683] = {17, 'Munch.'}, -- pumpkin
	[2684] = {5, 'Crunch.'}, -- carrot
	[2685] = {6, 'Munch.'}, -- tomato
	[2686] = {9, 'Crunch.'}, -- corncob
	[2687] = {2, 'Crunch.'}, -- cookie
	[2688] = {2, 'Munch.'}, -- candy cane
	[2689] = {10, 'Crunch.'}, -- bread
	[2690] = {3, 'Crunch.'}, -- roll
	[2691] = {8, 'Crunch.'}, -- brown bread
	[2696] = {9, 'Smack.'}, -- cheese
	[2787] = {9, 'Munch.'}, -- white mushroom
	[2788] = {4, 'Munch.'}, -- red mushroom
	[2789] = {22, 'Munch.'}, -- brown mushroom
	[2790] = {30, 'Munch.'}, -- orange mushroom
	[2791] = {9, 'Munch.'}, -- wood mushroom
	[2792] = {6, 'Munch.'}, -- dark mushroom
	[2793] = {12, 'Munch.'}, -- some mushrooms
	[2794] = {3, 'Munch.'}, -- some mushrooms
	[2795] = {36, 'Munch.'}, -- fire mushroom
	[2796] = {5, 'Munch.'}, -- green mushroom
	[5097] = {4, 'Yum.'}, -- mango
	[22644] = {4, 'Mmmm.'}, -- Christmas Cookie Tray
	[6125] = {8, 'Gulp.'}, -- tortoise egg
	[6278] = {10, 'Mmmm.'}, -- cake
	[6279] = {15, 'Mmmm.'}, -- decorated cake
	[6393] = {12, 'Mmmm.'}, -- valentine's cake
	[6394] = {15, 'Mmmm.'}, -- cream cake
	[6501] = {20, 'Mmmm.'}, -- gingerbread man
	[6541] = {6, 'Gulp.'}, -- coloured egg (yellow)
	[6542] = {6, 'Gulp.'}, -- coloured egg (red)
	[6543] = {6, 'Gulp.'}, -- coloured egg (blue)
	[6544] = {6, 'Gulp.'}, -- coloured egg (green)
	[6545] = {6, 'Gulp.'}, -- coloured egg (purple)
	[6569] = {1, 'Mmmm.'}, -- candy
	[6574] = {5, 'Mmmm.'}, -- bar of chocolate
	[7158] = {15, 'Munch.'}, -- rainbow trout
	[7159] = {13, 'Munch.'}, -- green perch
	[7372] = {2, 'Yum.'}, -- ice cream cone (crispy chocolate chips)
	[7373] = {2, 'Yum.'}, -- ice cream cone (velvet vanilla)
	[7374] = {2, 'Yum.'}, -- ice cream cone (sweet strawberry)
	[7375] = {2, 'Yum.'}, -- ice cream cone (chilly cherry)
	[7376] = {2, 'Yum.'}, -- ice cream cone (mellow melon)
	[7377] = {2, 'Yum.'}, -- ice cream cone (blue-barian)
	[7909] = {4, 'Crunch.'}, -- walnut
	[7910] = {4, 'Crunch.'}, -- peanut
	[7963] = {60, 'Munch.'}, -- marlin
	[8112] = {9, 'Urgh.'}, -- scarab cheese
	[8838] = {10, 'Gulp.'}, -- potato
	[8839] = {5, 'Yum.'}, -- plum
	[8840] = {1, 'Yum.'}, -- raspberry
	[8841] = {1, 'Urgh.'}, -- lemon
	[8842] = {7, 'Munch.'}, -- cucumber
	[8843] = {5, 'Crunch.'}, -- onion
	[8844] = {1, 'Gulp.'}, -- jalapeño pepper
	[8845] = {5, 'Munch.'}, -- beetroot
	[8847] = {11, 'Yum.'}, -- chocolate cake
	[9005] = {7, 'Slurp.'}, -- yummy gummy worm
	[9114] = {5, 'Crunch.'}, -- bulb of garlic
	[10454] = {0, 'Your head begins to feel better.'}, -- headache pill
	[11246] = {15, 'Yum.'}, -- rice ball
	[11370] = {3, 'Urgh.'}, -- terramite eggs
	[11429] = {10, 'Mmmm.'}, -- crocodile steak
	[12415] = {20, 'Yum.'}, -- pineapple
	[12416] = {10, 'Munch.'}, -- aubergine
	[12417] = {8, 'Crunch.'}, -- broccoli
	[12418] = {9, 'Crunch.'}, -- cauliflower
	[12637] = {55, 'Gulp.'}, -- ectoplasmic sushi
	[12638] = {18, 'Yum.'}, -- dragonfruit
	[12639] = {2, 'Munch.'}, -- peas
	[13297] = {20, 'Crunch.'}, -- haunch of boar
	[15405] = {55, 'Munch.'}, -- sandfish
	[15487] = {14, 'Urgh.'}, -- larvae
	[15488] = {15, 'Munch.'}, -- deepling filet
	[16014] = {60, 'Mmmm.'}, -- anniversary cake
	[18306] = {0, 'Phew!'}, -- stale mushroom beer
	[18397] = {33, 'Munch.'}, -- mushroom pie
	[19737] = {10, 'Urgh.'}, -- insectoid eggs
	[20100] = {15, 'Smack.'}, -- soft cheese
	[20101] = {12, 'Smack.'}, -- rat cheese
	[23517] = {25, 'Chomp.'}, -- glooth steak
	[24843] = {25, 'Chomp.'}, -- Roasted Meat
	[24841] = {8, 'Yum.'}, -- pickle pear
	[27050] = {20, 'Urgh.'}, -- bug meat
	[27051] = {10, 'Gulp.'}, -- cave turnip
	[27064] = {60, 'Mmmm.'}, -- birthday cake
	[27616] = {10, 'Slurp.'}, -- bottle of tibian wine
	[28997] = {15, 'Mmmmm!'}, -- fresh fruit
	[35057] = {40, 'Mmmmm!'}, -- meringue cake
	[35060] = {15, 'Slurp.'} -- winterberry liquor
}

local food = Action()

function food.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local food = foods[item.itemid]
	if not food then
		return false
	end

	--player:removeCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (food[1] * 12)) >= 1200 then
		player:sendTextMessage(MESSAGE_FAILURE, 'You are full.')
		return true
	end

	player:feed(food[1] * 12)
	player:say(food[2], TALKTYPE_MONSTER_SAY)
	item:remove(1)
	player:updateSupplyTracker(item)

	return true
end

for index, value in pairs(foods) do
	food:id(index)
end

food:register()
