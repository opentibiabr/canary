MESSAGEDIALOG_IMBUEMENT_ERROR = 1
MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED = 2
MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND = 3
MESSAGEDIALOG_CLEARING_CHARM_SUCCESS = 10
MESSAGEDIALOG_CLEARING_CHARM_ERROR = 11

-- tables
Imbuements_Weapons = {
	["armor"] = {21692, 2500, 2656, 2464, 2487, 2494, 2492, 2503, 12607, 2505, 32419, 2466, 23538, 10296, 2476, 3968, 2472, 7463, 8888, 23537, 2486, 15406, 8891, 18404, 38992, 38929, 38930}, -- ok
	["shield"] = {34068, 2537, 2518, 15491, 2535, 2519, 25414, 2520, 15411, 2516, 32422, 32421, 30885, 2522, 2533, 21707, 2514, 10289, 2536, 6433, 6391, 7460, 2524, 15413, 2539, 25382, 21697, 3974, 10297, 12644, 10294, 2509, 2542, 2528, 2534, 2531, 15453, 38989, 38934}, -- ok
	["boots"] = {34062, 24742, 2195, 2644, 9931, 3982, 11117, 15410, 11118, 12646, 7457, 7892, 2646, 11240, 2643, 7893, 7891, 23540, 24637, 2641, 5462, 18406, 2642, 2645, 7886, 25412, 21708, 11303, 35229, 36452, 38932, 38933}, --ok
	["helmet"] = {34065, 2499, 2139, 3972, 2458, 2491, 2497, 2493, 2502, 12645, 32415, 7458, 2471, 10299, 20132, 10298, 2662, 10291, 2498, 24848, 5741, 25410, 2475, 11302, 35232, 36412, 38991}, --ok
	["helmetmage"] = {10016, 2323, 11368, 8820, 10570, 9778, 32414, 30882, 36417}, -- ok
	["bow"] = {34055, 25946, 30690, 8855, 7438, 32418, 15643, 21696, 10295, 18454, 25522, 8857, 22417, 22418, 8854, 36416, 38923, 38985}, -- ok
	["crossbow"] = {25950, 8850, 2455, 30691, 8849, 25523, 8851, 8852, 8853, 16111, 21690, 22420, 22421, 35228, 38924}, -- ok
	["backpack"] = {1988, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2365, 3940, 3960, 5801, 5926, 5949, 7342, 9774, 10518, 10519, 10521, 10522, 11119, 11241, 11243, 11244, 11263, 15645, 15646, 16007, 18393, 18394, 21475, 22696, 23666, 23816, 24740, 26181, 27061, 27063, 35056, 33318},
	["wand"] = {29005, 2191, 8920, 8921, 8922}, --ok
	["rod"] = {8910, 8911, 24839}, --ok
	["axe"] = {30686, 2429, 3962, 7412, 30687, 18451, 8926, 2414, 11305, 7419, 2435, 7453, 2415, 2427, 7380, 8924, 7389, 15492, 7435, 2430, 7455, 7456, 2443, 25383, 7434, 6553, 8925, 2431, 2447, 22405, 22408, 22406, 22409, 2454, 15451, 11323}, --ok
	["club"] = {7414, 7426, 2453, 7429, 2423, 7415, 2445, 15647, 7431, 7430, 23543, 30689, 2444, 2452, 20093, 7424, 30688, 25418, 18452, 8928, 7421, 7392, 15414, 7410, 7437, 7451, 2424, 2436, 7423, 12648, 7452, 8929, 22414, 22411, 22415, 22412, 2421, 2391}, --ok
	["sword"] = {7404, 7403, 7406, 12649, 30684, 7416, 2407, 2413, 7385, 7382, 2451, 7402, 8930, 2438, 32423, 2393, 7407, 7405, 2400, 7384, 7418, 7383, 7417, 18465, 30685, 2383, 2376, 7391, 6528, 8931, 12613, 11309, 22399, 22403, 22400, 22402, 7408, 11307, 35233}, --ok
	["spellbooks"] = {25411, 2175, 8900, 8901, 22423, 22424, 29004, 34069, 34058, 34064, 38988}, -- ok
	["special_strike"] = {32417, 32416, 30693, 30692, 32523, 32522, 34063, 38925, 38926}, --ok
	["crit_wandrod"] = {35234, 38986},
	["life_wandrod"] = {35235, 38987},
	["elemental_swords"] = {30886, 34059, 34060, 36449, 38918, 38917, 38990},
	["elemental_axes"] = {32424, 35231, 39088, 38919, 38920, 37451},
	["elemental_clubs"] = {32425, 34057, 35230, 36415, 38922, 38921, 39089},
	-- Note: if an armor has native protection, it can't be imbue with this protection
	["armor_energy"] = {30883},
	["armor_only_energy"] = {34061},
	["armor_ice"] = {36414},
	["armor_earth"] = {34056, 36413},
	["armor_death"] = {15407, 36418, 38931}
}

local equipitems = {
	["lich shroud"] = {"armor", "armor_energy", "armor_only_energy", "armor_ice", "armor_earth", "spellbooks", "shield"},
	["reap"] = {"axe", "club", "sword", "bow", "crossbow"},
	["vampirism"] = {"axe", "club", "sword", "wand", "rod", "special_strike", "bow", "crossbow", "armor", "armor_energy", "armor_only_energy", "armor_ice", "armor_earth", "armor_death", "elemental_swords", "elemental_axes", "elemental_clubs", "crit_wandrod"},
	["cloud fabric"] = {"armor", "armor_earth", "armor_death", "spellbooks", "shield"},
	["electrify"] = {"axe", "club", "sword", "bow", "crossbow"},
	["swiftness"] = {"boots"},
	["snake skin"] = {"armor", "armor_energy", "armor_only_energy", "armor_ice", "armor_death", "spellbooks", "shield"},
	["venom"] = {"axe", "club", "sword", "bow", "crossbow"},
	["slash"] = {"sword", "helmet", "elemental_swords"},
	["chop"] = {"axe", "helmet", "elemental_axes"},
	["bash"] = {"club", "helmet", "elemental_clubs"},
	["dragon hide"] = {"armor", "armor_energy", "armor_only_energy", "armor_ice", "armor_death", "spellbooks", "shield"},
	["scorch"] = {"axe", "club", "sword", "bow", "crossbow"},
	["void"] = {"axe", "club", "sword", "wand", "rod", "special_strike", "bow", "crossbow", "helmet","helmetmage", "elemental_swords", "elemental_axes", "elemental_clubs", "crit_wandrod", "life_wandrod"}, -- Mana
	["quara scale"] = {"armor", "armor_only_energy", "armor_earth", "armor_death", "spellbooks", "shield"},
	["frost"] = {"axe", "club", "sword", "bow", "crossbow"},
	["blockade"] = {"shield", "helmet", "spellbooks", "shield"},
	["demon presence"] = {"armor", "armor_energy", "armor_only_energy", "armor_ice", "armor_earth", "armor_death", "spellbooks", "shield"},
	["precision"] = {"bow", "crossbow", "helmet"},
	["strike"] = {"axe", "club", "sword", "bow", "crossbow", "special_strike", "elemental_swords", "elemental_axes", "elemental_clubs", "life_wandrod"},
	["epiphany"] = {"wand", "rod", "helmetmage", "special_strike", "special_wand", "special_rod", "crit_wandrod", "life_wandrod"},
	["featherweight"] = {"backpack"},
}

local enablingStorages = {
	["lich shroud"] = Storage.ForgottenKnowledge.LadyTenebrisKilled,
	["reap"] = Storage.ForgottenKnowledge.LadyTenebrisKilled,
	["vampirism"] = Storage.ForgottenKnowledge.LadyTenebrisKilled,
	["cloud fabric"] = Storage.ForgottenKnowledge.LloydKilled,
	["electrify"] = Storage.ForgottenKnowledge.LloydKilled,
	["swiftness"] = Storage.ForgottenKnowledge.LloydKilled,
	["snake skin"] = Storage.ForgottenKnowledge.ThornKnightKilled,
	["venom"] = Storage.ForgottenKnowledge.ThornKnightKilled,
	["slash"] = Storage.ForgottenKnowledge.ThornKnightKilled,
	["chop"] = Storage.ForgottenKnowledge.ThornKnightKilled,
	["bash"] = Storage.ForgottenKnowledge.ThornKnightKilled,
	["dragon hide"] = Storage.ForgottenKnowledge.DragonkingKilled,
	["scorch"] = Storage.ForgottenKnowledge.DragonkingKilled,
	["void"] = Storage.ForgottenKnowledge.DragonkingKilled,
	["quara scale"] = Storage.ForgottenKnowledge.HorrorKilled,
	["frost"] = Storage.ForgottenKnowledge.HorrorKilled,
	["blockade"] = Storage.ForgottenKnowledge.HorrorKilled,
	["demon presence"] = Storage.ForgottenKnowledge.TimeGuardianKilled,
	["precision"] = Storage.ForgottenKnowledge.TimeGuardianKilled,
	["strike"] = Storage.ForgottenKnowledge.LastLoreKilled,
	["epiphany"] = Storage.ForgottenKnowledge.LastLoreKilled,
	["featherweight"] = -1,
}

function Player.canImbueItem(self, imbuement, item)
	local item_type = ""
	for tp, items in pairs(Imbuements_Weapons) do
		if isInArray(items, item:getId()) then
			item_type = tp
			break
		end
	end
	local imb_type = ""
	for ibt, imb_n in pairs(enablingStorages) do
		if string.find(ibt, imbuement:getName():lower()) then
			imb_type = ibt
			break
		end
	end
	if imb_type == "" then
		Spdlog.error(string.format("[Imbuement::canImbueItem] - Error on searching imbuement %s"),
			imbuement:getName())
		return false
	end

	local equip = equipitems[imb_type]
	if not equip then
		Spdlog.error(string.format("[Imbuement::canImbueItem] - Error on searching weapon imbuement %s",
			imbuement:getName()))
		return false
	end

	local imbuable = false
	for i, p in pairs(equip) do
		if p:lower() == item_type then
			imbuable = true
			break
		end
	end
	if not imbuable then
		return false
	end
	local stg = enablingStorages[imb_type]
	if not stg then
		Spdlog.error("[Imbuement::canImbueItem] - Error on search storage imbuement '" .. imbuement:getName())
		return false
	end

	if imbuement:getBase().id == 3 and not self:getGroup():getAccess() and stg > -1 and self:getStorageValue(stg) < 1 then
		return false
	end

	return true
end

-- Player functions
function Player.sendImbuementResult(self, errorType, message)
	local msg = NetworkMessage()
	msg:addByte(0xED)
	msg:addByte(errorType or 0x01)
	msg:addString(message)
	msg:sendToPlayer(self)
	msg:delete()
	return
end

function Player.closeImbuementWindow(self)
	local msg = NetworkMessage()
	msg:addByte(0xEC)
	msg:sendToPlayer(self)
end

-- Items functions
function Item.getImbuementDuration(self, slot)
	local info = 0
	local binfo = tonumber(self:getCustomAttribute(IMBUEMENT_SLOT + slot))
	if binfo then
		info = bit.rshift(binfo, 8)
	end

	return info
end

function Item.getImbuement(self, slot)
	local binfo = tonumber(self:getCustomAttribute(IMBUEMENT_SLOT + slot))
	if not binfo then
		return false
	end
	local id = bit.band(binfo, 0xFF)
	if id == 0 then
		return false
	end
	return Imbuement(id)
end

function Item.addImbuement(self, slot, id)
	local imbuement = Imbuement(id)
	if not imbuement then return false end
	local duration = imbuement:getBase().duration

	local imbue = bit.bor(bit.lshift(duration, 8), id)
	self:setCustomAttribute(IMBUEMENT_SLOT + slot, imbue)
	return true
end

function Item.cleanImbuement(self, slot)
	self:setCustomAttribute(IMBUEMENT_SLOT + slot, 0)
	return true
end
