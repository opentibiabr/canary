local foods = {
	[3606] = { 6, "Gulp." }, -- egg
	[3250] = { 5, "Crunch." }, -- carrot
	[3577] = { 15, "Munch." }, -- meat
	[21145] = { 15, "Burp." }, -- bottle of glooth wine
	[21144] = { 15, "Slurp." }, -- bowl of glooth soup
	[21143] = { 10, "Munch." }, -- bowl of glooth soup
	[3578] = { 12, "Munch." }, -- fish
	[3579] = { 10, "Mmmm." }, -- salmon
	[23535] = { 30, "Mmmm." }, -- energy bar
	[23545] = { 30, "Mmmm." }, -- energy drink
	[3580] = { 17, "Munch." }, -- northern pike
	[3581] = { 4, "Gulp." }, -- shrimp
	[3582] = { 30, "Chomp." }, -- ham
	[3583] = { 60, "Chomp." }, -- dragon ham
	[3584] = { 5, "Yum." }, -- pear
	[3585] = { 6, "Yum." }, -- red apple
	[3586] = { 13, "Yum." }, -- orange
	[3587] = { 8, "Yum." }, -- banana
	[3588] = { 1, "Yum." }, -- blueberry
	[3589] = { 18, "Slurp." }, -- coconut
	[3590] = { 1, "Yum." }, -- cherry
	[3591] = { 2, "Yum." }, -- strawberry
	[3592] = { 9, "Yum." }, -- grapes
	[904] = { 9, "Hum." }, -- cream cake
	[3593] = { 20, "Yum." }, -- melon
	[3594] = { 17, "Munch." }, -- pumpkin
	[3595] = { 5, "Crunch." }, -- carrot
	[3596] = { 6, "Munch." }, -- tomato
	[3597] = { 9, "Crunch." }, -- corncob
	[3598] = { 2, "Crunch." }, -- cookie
	[3599] = { 2, "Munch." }, -- candy cane
	[3600] = { 10, "Crunch." }, -- bread
	[3601] = { 3, "Crunch." }, -- roll
	[3602] = { 8, "Crunch." }, -- brown bread
	[3607] = { 9, "Smack." }, -- cheese
	[3723] = { 9, "Munch." }, -- white mushroom
	[3724] = { 4, "Munch." }, -- red mushroom
	[3725] = { 22, "Munch." }, -- brown mushroom
	[3726] = { 30, "Munch." }, -- orange mushroom
	[3727] = { 9, "Munch." }, -- wood mushroom
	[3728] = { 6, "Munch." }, -- dark mushroom
	[3729] = { 12, "Munch." }, -- some mushrooms
	[3730] = { 3, "Munch." }, -- some mushrooms
	[3731] = { 36, "Munch." }, -- fire mushroom
	[3732] = { 5, "Munch." }, -- green mushroom
	[5096] = { 4, "Yum." }, -- mango
	[20310] = { 4, "Mmmm." }, -- christmas cookie tray
	[5678] = { 8, "Gulp." }, -- tortoise egg
	[6125] = { 8, "Gulp." }, -- tortoise egg from nargor
	[6277] = { 10, "Mmmm." }, -- cake
	[6278] = { 15, "Mmmm." }, -- decorated cake
	[6392] = { 12, "Mmmm." }, -- valentine's cake
	[6393] = { 15, "Mmmm." }, -- cream cake
	[6500] = { 20, "Mmmm." }, -- gingerbread man
	[6541] = { 6, "Gulp." }, -- coloured egg (yellow)
	[6542] = { 6, "Gulp." }, -- coloured egg (red)
	[6543] = { 6, "Gulp." }, -- coloured egg (blue)
	[6544] = { 6, "Gulp." }, -- coloured egg (green)
	[6545] = { 6, "Gulp." }, -- coloured egg (purple)
	[6569] = { 1, "Mmmm." }, -- candy
	[6574] = { 5, "Mmmm." }, -- bar of chocolate
	[7158] = { 15, "Munch." }, -- rainbow trout
	[7159] = { 13, "Munch." }, -- green perch
	[229] = { 2, "Yum." }, -- ice cream cone (crispy chocolate chips)
	[7373] = { 2, "Yum." }, -- ice cream cone (velvet vanilla)
	[7374] = { 2, "Yum." }, -- ice cream cone (sweet strawberry)
	[7375] = { 2, "Yum." }, -- ice cream cone (chilly cherry)
	[7376] = { 2, "Yum." }, -- ice cream cone (mellow melon)
	[7377] = { 2, "Yum." }, -- ice cream cone (blue-barian)
	[836] = { 4, "Crunch." }, -- walnut
	[841] = { 4, "Crunch." }, -- peanut
	[901] = { 60, "Munch." }, -- marlin
	[169] = { 9, "Urgh." }, -- scarab cheese
	[8010] = { 10, "Gulp." }, -- potato
	[8011] = { 5, "Yum." }, -- plum
	[8012] = { 1, "Yum." }, -- raspberry
	[8013] = { 1, "Urgh." }, -- lemon
	[8014] = { 7, "Munch." }, -- cucumber
	[8015] = { 5, "Crunch." }, -- onion
	[8016] = { 1, "Gulp." }, -- jalapeño pepper
	[8017] = { 5, "Munch." }, -- beetroot
	[8019] = { 11, "Yum." }, -- chocolate cake
	[8177] = { 7, "Slurp." }, -- yummy gummy worm
	[8197] = { 5, "Crunch." }, -- bulb of garlic
	[9537] = { 0, "Your head begins to feel better." }, -- headache pill
	[10329] = { 15, "Yum." }, -- rice ball
	[10453] = { 3, "Urgh." }, -- terramite eggs
	[10219] = { 10, "Mmmm." }, -- crocodile steak
	[11459] = { 20, "Yum." }, -- pineapple
	[11460] = { 10, "Munch." }, -- aubergine
	[11461] = { 8, "Crunch." }, -- broccoli
	[11462] = { 9, "Crunch." }, -- cauliflower
	[11681] = { 55, "Gulp." }, -- ectoplasmic sushi
	[11682] = { 18, "Yum." }, -- dragonfruit
	[11683] = { 2, "Munch." }, -- peas
	[12310] = { 20, "Crunch." }, -- haunch of boar
	[13992] = { 55, "Munch." }, -- sandfish
	[14084] = { 14, "Urgh." }, -- larvae
	[14085] = { 15, "Munch." }, -- deepling filet
	[14681] = { 60, "Mmmm." }, -- anniversary cake
	[15795] = { 0, "Phew!" }, -- stale mushroom beer
	[16103] = { 33, "Munch." }, -- mushroom pie
	[17457] = { 10, "Urgh." }, -- insectoid eggs
	[17820] = { 15, "Smack." }, -- soft cheese
	[17821] = { 12, "Smack." }, -- rat cheese
	[21146] = { 25, "Chomp." }, -- glooth steak
	[22187] = { 25, "Chomp." }, -- Roasted Meat
	[22185] = { 8, "Yum." }, -- pickle pear
	[24382] = { 20, "Urgh." }, -- bug meat
	[24383] = { 10, "Gulp." }, -- cave turnip
	[24396] = { 60, "Mmmm." }, -- birthday cake
	[24948] = { 10, "Slurp." }, -- bottle of tibian wine
	[25692] = { 15, "Mmmmm!" }, -- fresh fruit
	[30198] = { 40, "Mmmmm!" }, -- meringue cake
	[30202] = { 15, "Slurp." }, -- winterberry liquor
	[31560] = { 40, "Slurp." }, -- goanna meat
	[32069] = { 15, "Slurp." }, -- candy floss
	[37530] = { 10, "Slurp." }, -- bottle of champagne
	[37531] = { 5, "Mmmm." }, -- candy floss
	[37532] = { 15, "Mmmm." }, -- ice cream cone
	[37533] = { 60, "Mmmm." }, -- birthday layer cake
	[48116] = { 35, "Yum." }, -- gummy rotworms
	[48251] = { 25, "Yum." }, -- wafer paper flower
	[48252] = { 45, "Yum." }, -- brigadeiro
	[48253] = { 45, "Yum." }, -- beijinho
	[48254] = { 65, "Yum." }, -- churro heart
	[48255] = { 125, "Yum." }, -- lime tart
	[48256] = { 605, "Yum." }, -- pastry dragon
	[48273] = { 185, "Yum." }, -- taiyaki ice cream
	[48508] = { 125, "Yum." }, -- amber souvenir
	[48509] = { 120, "Yum." }, -- resinous fish fin
	[48511] = { 120, "Yum." }, -- resin parasite
	[48544] = { 124, "Yum." }, -- wad of fairy floss
}

local food = Action()

function food.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemFood = foods[item.itemid]
	if not itemFood then
		return false
	end

	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (itemFood[1] * 12)) >= 1200 then
		player:sendTextMessage(MESSAGE_FAILURE, "You are full.")
		return true
	end

	player:feed(itemFood[1] * 12)
	player:say(itemFood[2], TALKTYPE_MONSTER_SAY)
	player:updateSupplyTracker(item)
	player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT, player:isInGhostMode() and nil or player)
	item:remove(1)
	return true
end

for index, value in pairs(foods) do
	food:id(index)
end

food:register()
