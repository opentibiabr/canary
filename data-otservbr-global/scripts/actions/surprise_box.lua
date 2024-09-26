local prize = {
    [1] = {chance = 2, id = 31578, amount = 1 }, --bear skin
    [2] = {chance = 2, id = 14086, amount = 1 }, -- calopteryx cape
    [3] = {chance = 2, id = 8050, amount = 1 }, --crystalline armor
    [4] = {chance = 2, id = 39164, amount = 1 }, -- dawnfire sherwani
    [5] = {chance = 2, id = 29423, amount = 1 }, --dream shroud
    [6] = {chance = 2, id = 31579, amount = 1 }, -- embrace of nature 
	[7] = {chance = 2, id = 16105, amount = 1 }, --gill coat
	[8] = {chance = 2, id = 21164, amount = 1 }, --glooth cape
	[9] = {chance = 2, id = 27651, amount = 1}, -- gnome sword
	[10] = {chance = 2, id = 27450, amount = 1}, -- slayer of destruction
	[11] = {chance = 2, id = 31614, amount = 1}, -- tagralt sword
	[12] = {chance = 2, id = 825, amount = 1}, --lightning robe
	[13] = {chance = 2, id = 3366, amount = 1 }, --magic plate armor
	[14] = {chance = 2, id = 826, amount = 1 }, --magma coat
	[15] = {chance = 2, id = 8060, amount = 1 }, --master archer armor
	[16] = {chance = 2, id = 13993, amount = 1}, --ornate chestplate
	[17] = {chance = 2, id = 16111, amount = 1}, --prismatic armor
	[18] = {chance = 2, id = 11686, amount = 1 }, --royal draken mail
	[19] = {chance = 2, id = 39155, amount = 1}, -- naga sword
	[20] = {chance = 2, id = 29421, amount = 1}, -- summerblade
	[21] = {chance = 2, id = 29422, amount = 1}, -- winterblade
	[22] = {chance = 2, id = 8052, amount = 1}, --swamplair armor
	[23] = {chance = 2, id = 25779, amount = 1 }, --swanfeather cloak
	[24] = {chance = 2, id = 8862, amount = 1 }, --yalahari armor
	[25] = {chance = 2, id = 3387, amount = 1 }, --demon helmet
	[26] = {chance = 2, id = 27449, amount = 1}, -- blade of destruction 
	[27] = {chance = 2, id = 31577, amount = 1}, -- terra helmet
	[28] = {chance = 2, id = 5741, amount = 1}, --skull helmet
	[29] = {chance = 2, id = 3392, amount = 1}, --royal helmet
	[30] = {chance = 2, id = 16109, amount = 1}, --prismatic helmet
	[31] = {chance = 2, id = 11689, amount = 1}, --elite draken helmet
	[32] = {chance = 2, id = 39156, amount = 1}, -- naga axe
	[33] = {chance = 2, id = 3369, amount = 1}, --warrior helmet
	[34] = {chance = 2, id = 40588, amount = 1}, --antler-horn helmet
	[35] = {chance = 2, id = 27452, amount = 1}, -- chopper of destruction
	[36] = {chance = 2, id = 13995, amount = 1}, --depth galea
	[37] = {chance = 2, id = 27451, amount = 1}, -- axe of destruction
	[38] = {chance = 2, id = 32616, amount = 1}, -- phantasmal axe 
	[39] = {chance = 2, id = 39157, amount = 1}, -- naga club
	[40] = {chance = 2, id = 29427, amount = 1}, -- dark whispers
	[41] = {chance = 2, id = 3385, amount = 1}, --crown helmet
	[42] = {chance = 2, id = 21892, amount = 1}, -- crest of the deep seas
	[43] = {chance = 2, id = 3408, amount = 1}, -- bonelord helmet
	[44] = {chance = 2, id = 3396, amount = 1}, --dwarven helmet
	[45] = {chance = 2, id = 8864, amount = 1}, --yalahari mask
	[46] = {chance = 2, id = 21165, amount = 1}, --rubber cap
	[47] = {chance = 2, id = 830, amount = 1}, --terra hood
	[48] = {chance = 2, id = 827, amount = 1}, --magma monocle
	[49] = {chance = 2, id = 828, amount = 1}, --lightning headband
	[50] = {chance = 2, id = 829, amount = 1}, --glacier mask
	[51] = {chance = 2, id = 16104, amount = 1}, --gill gugel
	[52] = {chance = 2, id = 3374, amount = 1}, -- legion helmet
	[53] = {chance = 2, id = 3575, amount = 1}, -- wood cape
	[54] = {chance = 2, id = 3210, amount = 1}, -- hat of the mad
	[55] = {chance = 2, id = 11674, amount = 1}, -- cobra crown
	[56] = {chance = 2, id = 9103, amount = 1}, -- batwing hat
	[57] = {chance = 2, id = 5460, amount = 1}, -- helmet of the deep
	[58] = {chance = 2, id = 3406, amount = 1}, -- feather headdress
	[59] = {chance = 2, id = 3407, amount = 1}, -- charmer's tiara
	[60] = {chance = 2, id = 23488, amount = 1}, -- surprise box
	[61] = {chance = 2, id = 139, amount = 1}, -- mining helmet
	[62] = {chance = 2, id = 24397, amount = 1}, -- ferumbras' candy hat
	[63] = {chance = 2, id = 23488, amount = 1}, -- surprise box
	[64] = {chance = 2, id = 23488, amount = 1}, -- surprise box
	[65] = {chance = 2, id = 23488, amount = 1}, -- surprise box
	[66] = {chance = 2, id = 3560, amount = 1}, -- bast skirt
	[67] = {chance = 2, id = 21168, amount = 1}, -- alloy legs
	[68] = {chance = 2, id = 3398, amount = 1}, -- dwarven legs
	[69] = {chance = 2, id = 16106, amount = 1}, -- gill legs
	[70] = {chance = 2, id = 14087, amount = 1}, -- grasshopper legs
	[71] = {chance = 2, id = 35517, amount = 1}, -- bast legs
	[72] = {chance = 2, id = 645, amount = 1}, -- blue legs
	[73] = {chance = 2, id = 3382, amount = 1}, -- crown legs
	[74] = {chance = 2, id = 39166, amount = 1}, -- dawnfire pantaloons
	[75] = {chance = 2, id = 13996, amount = 1}, -- depth ocrea
	[76] = {chance = 2, id = 35516, amount = 1}, -- exotic legs
	[77] = {chance = 2, id = 823, amount = 1}, -- glacier kilt
	[78] = {chance = 2, id = 3371, amount = 1}, -- knight legs
	[79] = {chance = 2, id = 822, amount = 1}, -- lightning legs
	[80] = {chance = 2, id = 821, amount = 1}, -- magma legs
	[81] = {chance = 2, id = 39167, amount = 1}, -- midnight sarong
	[82] = {chance = 2, id = 40595, amount = 1}, -- mutant bone kilt
	[83] = {chance = 2, id = 13999, amount = 1}, -- ornate legs
	[84] = {chance = 2, id = 16111, amount = 1}, -- prismatic legs
	[85] = {chance = 2, id = 32618, amount = 1}, -- soulful legs
	[86] = {chance = 2, id = 812, amount = 1}, -- terra legs
	[87] = {chance = 2, id = 8863, amount = 1}, -- yalahari leg piece
	[88] = {chance = 2, id = 10387, amount = 1}, -- zaoan legs
	[89] = {chance = 2, id = 3389, amount = 1}, -- demon legs
	[90] = {chance = 2, id = 20078, amount = 1}, -- umbral master mace
	[91] = {chance = 2, id = 20081, amount = 1}, -- umbral master hammer 
	[92] = {chance = 2, id = 27453, amount = 1}, -- mace of destruction
	[93] = {chance = 2, id = 3364, amount = 1}, -- golden legs
	[94] = {chance = 2, id = 40590, amount = 1}, -- mutated skin legs
	[95] = {chance = 2, id = 40589, amount = 1}, -- stitched mutant hide legs
	[96] = {chance = 2, id = 27454, amount = 1}, -- hammer of destruction
	[97] = {chance = 2, id = 14001, amount = 1}, -- ornate mace
	[98] = {chance = 2, id = 3079, amount = 1}, -- boots of haste
	[99] = {chance = 2, id = 6529, amount = 1}, -- soft boots
	[100] = {chance = 2, id = 3556, amount = 1}, -- crocodile boots
	[101] = {chance = 2, id = 10386, amount = 1}, -- zaoan shoes
	[102] = {chance = 2, id = 21169, amount = 1}, -- metal spats
	[103] = {chance = 2, id = 22086, amount = 1}, -- badger boots
	[104] = {chance = 2, id = 39161, amount = 1}, -- feverbloom boots
	[105] = {chance = 2, id = 818, amount = 1}, -- magma boots
	[106] = {chance = 2, id = 819, amount = 1}, -- glacier shoes
	[107] = {chance = 2, id = 820, amount = 1}, -- lightning boots
	[108] = {chance = 2, id = 35520, amount = 1}, -- make-do boots
	[109] = {chance = 2, id = 35519, amount = 1}, -- makeshift boots
	[110] = {chance = 2, id = 40593, amount = 1}, -- mutant bone boots
	[111] = {chance = 2, id = 21981, amount = 1}, -- oriental shoes
	[112] = {chance = 2, id = 29424, amount = 1}, -- pair of dreamwalkers
	[113] = {chance = 2, id = 32619, amount = 1}, -- pair of nightmare boots
	[114] = {chance = 2, id = 5461, amount = 1}, -- pirate boots
	[115] = {chance = 2, id = 813, amount = 1}, -- terra boots
	[116] = {chance = 2, id = 23476, amount = 1}, -- void boots
	[117] = {chance = 2, id = 31617, amount = 1}, -- winged boots
	[118] = {chance = 2, id = 7429, amount = 1}, -- blessed sceptre 
	[119] = {chance = 2, id = 13997, amount = 1}, -- depth calcei
	[120] = {chance = 2, id = 39158, amount = 1}, -- frostflower boots
	[121] = {chance = 2, id = 10323, amount = 1}, -- guardian boots
	[122] = {chance = 2, id = 3333, amount = 1}, -- crystal mace 
	[123] = {chance = 2, id = 16112, amount = 1}, -- prismatic boots
	[124] = {chance = 2, id = 3554, amount = 1}, -- steel boots
	[125] = {chance = 2, id = 3324, amount = 1}, -- skull staff 
	[126] = {chance = 2, id = 6131, amount = 1}, -- tortoise shield
	[127] = {chance = 2, id = 3418, amount = 1}, -- bonelord shield
	[128] = {chance = 2, id = 3436, amount = 1}, -- medusa shield
	[129] = {chance = 2, id = 3428, amount = 1}, -- tower shield
	[130] = {chance = 2, id = 3420, amount = 1}, -- demon shield
	[131] = {chance = 2, id = 14000, amount = 1}, -- ornate shield
	[132] = {chance = 2, id = 29430, amount = 1}, -- ectoplasmic shield
	[133] = {chance = 2, id = 16116, amount = 1}, -- prismatic shield
	[134] = {chance = 2, id = 22726, amount = 1}, -- rift shield
	[135] = {chance = 2, id = 3322, amount = 1}, -- dragon hammer
	[136] = {chance = 2, id = 20084, amount = 1}, -- umbral master bow
	[137] = {chance = 2, id = 29417, amount = 1}, -- living vine bow
	[138] = {chance = 2, id = 8072, amount = 1}, -- spellbook of elightenment
	[139] = {chance = 2, id = 8073, amount = 1}, -- spellbook of warding
	[140] = {chance = 2, id = 8074, amount = 1}, -- spellbook of mind control
	[141] = {chance = 2, id = 8090, amount = 1}, -- spellbook of dark mysteries
	[142] = {chance = 2, id = 20088, amount = 1}, -- crude umbral spellbook
	[143] = {chance = 2, id = 25699, amount = 1}, -- wooden spellbook
	[144] = {chance = 2, id = 16107, amount = 1}, -- spellbook of vigilance
	[145] = {chance = 2, id = 14769, amount = 1}, -- spellbook of ancient arcana
	[146] = {chance = 2, id = 20089, amount = 1}, -- umbral spellbook
	[147] = {chance = 2, id = 29426, amount = 1}, -- brain in a jar
	[148] = {chance = 2, id = 29420, amount = 1}, -- shoulder plate
	[149] = {chance = 2, id = 29431, amount = 1}, -- spirit guide
	[150] = {chance = 2, id = 22866, amount = 1}, -- rift bow
	[151] = {chance = 2, id = 20090, amount = 1}, -- umbral master spellbook
	[152] = {chance = 2, id = 3071, amount = 1}, -- wand of inferno
	[153] = {chance = 2, id = 16115, amount = 1}, -- wand of everblazing
	[154] = {chance = 2, id = 27457, amount = 1}, -- wand of destruction
	[155] = {chance = 2, id = 16164, amount = 1}, -- mycological bow
	[156] = {chance = 2, id = 28826, amount = 1}, -- deepling fork
	[157] = {chance = 2, id = 8026, amount = 1}, -- warsinger bow
	[158] = {chance = 2, id = 8027, amount = 1}, -- composite hornbow
	[159] = {chance = 2, id = 27455, amount = 1}, -- crossbow of destruction
	[160] = {chance = 2, id = 27458, amount = 1}, -- rod of destruction
	[161] = {chance = 2, id = 8084, amount = 1}, -- springsprout rod
	[162] = {chance = 2, id = 16118, amount = 1}, -- glacial rod
	[163] = {chance = 2, id = 25700, amount = 1}, -- dream blossom staff
	[164] = {chance = 2, id = 35521, amount = 1}, -- jungle rod
	[165] = {chance = 2, id = 27650, amount = 1}, -- gnome shield
	[166] = {chance = 2, id = 32628, amount = 1 }, -- ghost chestplate
	[167] = {chance = 2, id = 31582, amount = 1}, -- galea mortis
	[168] = {chance = 2, id = 39163, amount = 1}, -- naga rod
	[169] = {chance = 2, id = 31581, amount = 1}, -- bow of cataclysm
	[170] = {chance = 2, id = 39162, amount = 1}, -- naga wand
	[171] = {chance = 2, id = 27647, amount = 1}, --gnome helmet
	[172] = {chance = 2, id = 36667, amount = 1}, -- eldritch breeches
	[173] = {chance = 2, id = 27649, amount = 1}, -- gnome legs
	[174] = {chance = 2, id = 32617, amount = 1}, -- fabulougs legs
	[175] = {chance = 2, id = 30394, amount = 1}, -- cobra boots
	--[176] = {chance = 2, id = 28722, amount = 1}, -- falcon escutcheon
	[177] = {chance = 2, id = 34153, amount = 1}, -- lion spellbook
	[178] = {chance = 2, id = 34152, amount = 1}, -- lion wand
	[179] = {chance = 2, id = 30399, amount = 1}, -- cobra wand
	--[180] = {chance = 2, id = 28717, amount = 1}, -- falcon wand
	[180] = {chance = 2, id = 30400, amount = 1}, -- cobra rod
	[181] = {chance = 2, id = 34151, amount = 1}, -- lion rod
	--[183] = {chance = 2, id = 28716, amount = 1}, -- falcon rod
	[182] = {chance = 2, id = 34150, amount = 1}, -- lion longbow
	--[185] = {chance = 2, id = 28718, amount = 1}, -- falcon bow
	[183] = {chance = 2, id = 30395, amount = 1}, -- cobra club 
	[184] = {chance = 2, id = 30396, amount = 1}, -- cobra axe
	--[188] = {chance = 2, id = 28724, amount = 1}, -- falcon battleaxe
	[185] = {chance = 2, id = 30398, amount = 1}, -- cobra sword
	--[190] = {chance = 2, id = 30197, amount = 1}, -- latin backpack 
	--[191] = {chance = 2, id = 12669, amount = 1}, -- latin ring
	--[192] = {chance = 2, id = 21124, amount = 1}, -- Forge Device
	--[193] = {chance = 2, id = 31633, amount = 1}, -- supreme latin cube
	[186] = {chance = 2, id = 3043, amount = 100}, -- crystal coins
	[187] = {chance = 2, id = 34155, amount = 1}, -- lion longsword
	--[196] = {chance = 2, id = 28723, amount = 1}, -- falcon longsword
	[188] = {chance = 2, id = 34157, amount = 1}, --lion plate
	--[198] = {chance = 2, id = 28719, amount = 1 }, --falcon plate
	--[199] = {chance = 2, id = 28715, amount = 1}, -- falcon coif
	[189] = {chance = 2, id = 30397, amount = 1}, --cobra hood
	--[201] = {chance = 2, id = 28714, amount = 1}, --falcon circlet
	[190] = {chance = 2, id = 34156, amount = 1}, --lion spangenhelm
	[191] = {chance = 2, id = 39159, amount = 1}, --naga crossbow
--[[	[203] = {chance = 2, id = 34099, amount = 1}, -- soulbastion
	[204] = {chance = 2, id = 34096, amount = 1},--soulshroud	
	[205] = {chance = 2, id = 34094, amount = 1 }, --soulshell
	[206] = {chance = 2, id = 34095, amount = 1 }, --soulmantle
	[207] = {chance = 2, id = 34092, amount = 1}, -- soulshanks
	[208] = {chance = 2, id = 34093, amount = 1}, -- soulstrider
	[209] = {chance = 2, id = 34097, amount = 1}, -- pair of soulwalkers
	[210] = {chance = 2, id = 34098, amount = 1}, -- pair of soulstalkers
	[211] = {chance = 2, id = 34090, amount = 1}, -- soultainter
	[212] = {chance = 2, id = 34091, amount = 1}, -- soulhexer
	[213] = {chance = 2, id = 34088, amount = 1}, -- soulbleeder
	[214] = {chance = 2, id = 34086, amount = 1}, -- soulcrusher
	[215] = {chance = 2, id = 34087, amount = 1}, -- soulmaimer
	[216] = {chance = 2, id = 34084, amount = 1}, -- soulbiter
	[217] = {chance = 2, id = 34085, amount = 1}, -- souleater
	[218] = {chance = 2, id = 34082, amount = 1}, -- soulcutter
	[219] = {chance = 2, id = 34083, amount = 1}, -- soulshredder
	[220] = {chance = 2, id = 39177, amount = 1}, -- charged spiritthorn ring 
	[221] = {chance = 2, id = 39147, amount = 1}, -- spiritthorn armor
	[222] = {chance = 2, id = 39148, amount = 1}, -- spiritthorn helmet
	[223] = {chance = 2, id = 39149, amount = 1}, -- alicorn headguard
	[224] = {chance = 2, id = 39150, amount = 1}, -- alicorn quiver
	[225] = {chance = 2, id = 39180, amount = 1}, -- charged alicorn ring
	[226] = {chance = 2, id = 39152, amount = 1}, -- arcanomancer folio
	[227] = {chance = 2, id = 39151, amount = 1}, -- arcanomancer regalia
	[228] = {chance = 2, id = 39183, amount = 1}, -- charged arcanomancer sigil
	[229] = {chance = 2, id = 39153, amount = 1}, -- arboreal crown
	[230] = {chance = 2, id = 39186, amount = 1}, -- charged arboreal ring
	[231] = {chance = 2, id = 39154, amount = 1}, -- arboreal tome
	[232] = {chance = 2, id = 16244, amount = 1}, -- music box
	[233] = {chance = 2, id = 37110, amount = 1}, -- exalted core
	]]
	} 

local surpriseBox = Action()

function surpriseBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #prize do
		local number = math.random() * 100
		if prize[i].chance > 100 - number then
			player:getPosition():sendMagicEffect(31)
			player:addItem(prize[i].id, prize[i].amount)
			item:remove()
			break
		end
	end
	return true
end

surpriseBox:id(23488)
surpriseBox:register()
