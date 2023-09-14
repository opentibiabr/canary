local rewards = {
    { id_male = 128, id_female = 136, name = "Citizen" },
    { id_male = 129, id_female = 137, name = "Hunter" },
	{ id_male = 131, id_female = 139, name = "Knight" },
	{ id_male = 132, id_female = 140, name = "Nobleman" },
	{ id_male = 133, id_female = 141, name = "Summoner" },
	{ id_male = 134, id_female = 142, name = "Warrior" },
	{ id_male = 143, id_female = 147, name = "Barbarian" },
	{ id_male = 144, id_female = 148, name = "Druid" },
	{ id_male = 145, id_female = 149, name = "Wizard" },
	{ id_male = 146, id_female = 150, name = "Oriental" },
	{ id_male = 151, id_female = 155, name = "Pirate" },
	{ id_male = 152, id_female = 156, name = "Assassin" },
	{ id_male = 153, id_female = 157, name = "Beggar" },
	{ id_male = 154, id_female = 158, name = "Shaman" },
	{ id_male = 251, id_female = 252, name = "Norseman" },
	{ id_male = 268, id_female = 269, name = "Nightmare" },
	{ id_male = 273, id_female = 270, name = "Jester" },
	{ id_male = 178, id_female = 279, name = "Brotherhood" },
	{ id_male = 289, id_female = 288, name = "Demon Hunter" },
	{ id_male = 325, id_female = 324, name = "Yalaharian" },
	{ id_male = 335, id_female = 336, name = "Warmaster" },
	{ id_male = 367, id_female = 366, name = "Wayfarer" },
	{ id_male = 432, id_female = 433, name = "Elementalist" },
	{ id_male = 472, id_female = 471, name = "Entrepeneur" },
	{ id_male = 541, id_female = 542, name = "Demon" },
	{ id_male = 574, id_female = 575, name = "Cave Explorer" },
	{ id_male = 633, id_female = 632, name = "Champion" },
	{ id_male = 634, id_female = 635, name = "Conjurer" },
	{ id_male = 637, id_female = 636, name = "Beastmaster" },
	{ id_male = 665, id_female = 664, name = "Chaos Acolyte" },
	{ id_male = 667, id_female = 666, name = "Death Herald" },
	{ id_male = 684, id_female = 683, name = "Ranger" },
	{ id_male = 695, id_female = 694, name = "Cerimonial Garb" },
	{ id_male = 697, id_female = 696, name = "puppeteer" },
	{ id_male = 699, id_female = 698, name = "Spirit Caller" },
	{ id_male = 725, id_female = 724, name = "Evoker" },
	{ id_male = 733, id_female = 732, name = "Seaweaver" },
	{ id_male = 750, id_female = 749, name = "Sea Dog" },
	{ id_male = 760, id_female = 758, name = "Royal Pumpkin" },
	{ id_male = 853, id_female = 852, name = "Winter Warden" },
	{ id_male = 873, id_female = 874, name = "Philosopher" },
	{ id_male = 884, id_female = 885, name = "Arena Champion" },
	{ id_male = 899, id_female = 900, name = "Lupine Warden" },
	{ id_male = 908, id_female = 909, name = "Groove Keeper" },
	{ id_male = 955, id_female = 956, name = "Pharaoh" },
	{ id_male = 957, id_female = 958, name = "Trophy Hunter" },
}

local outfit_rand = Action()

function outfit_rand.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardRand = rewards[randId]
	player:addOutfitAddon(rewardRand.id_male, 3)
	player:addOutfitAddon(rewardRand.id_female, 3)
	item:remove(1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardRand.name .. ' outfit.')
	return true
end

outfit_rand:id(44065)
outfit_rand:register()
