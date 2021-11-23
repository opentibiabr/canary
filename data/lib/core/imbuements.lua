MESSAGEDIALOG_IMBUEMENT_ERROR = 1
MESSAGEDIALOG_IMBUEMENT_ROLL_FAILED = 2
MESSAGEDIALOG_IMBUING_STATION_NOT_FOUND = 3
MESSAGEDIALOG_CLEARING_CHARM_SUCCESS = 10
MESSAGEDIALOG_CLEARING_CHARM_ERROR = 11

-- tables
Imbuements_Weapons = {
	["armor"] = {19358, 3394, 3567, 3358, 3381, 3388, 3386, 3397, 11651, 3399, 28719, 3360, 21167, 9379, 3370, 3404, 3366, 7463, 8060, 21166, 3380, 13993, 8063, 16110, 34157, 34094, 34095}, -- ok
	["shield"] = {29430, 3437, 3418, 14088, 3435, 3419, 22758, 3420, 13998, 3416, 28722, 28721, 27650, 3422, 3433, 19373, 3414, 9372, 3436, 6432, 6390, 7460, 3424, 14000, 3439, 22726, 19363, 3444, 9380, 11688, 3537, 3409, 3442, 3428, 3434, 3431, 14042, 34154, 34099}, -- ok
	["boots"] = {29424, 22086, 3079, 3553, 9017, 3556, 10200, 13997, 10201, 4033, 7457, 819, 3555, 10323, 3552, 820, 818, 21169, 21981, 3550, 5461, 16112, 3551, 3554, 813, 22756, 19374, 10386, 30394, 31617, 34097, 34098}, --ok
	["helmet"] = {29427, 3393, 3022, 3408, 3352, 3385, 3391, 3387, 3396, 11689, 28715, 7458, 3365, 9382, 17852, 9381, 3573, 9374, 3392, 22192, 5741, 22754, 3369, 10385, 30397, 31577, 34156}, --ok
	["helmetmage"] = {9103, 3210, 10451, 7992, 9653, 8864, 28714, 27647, 31582}, -- ok
	["bow"] = {29417, 23290, 27455, 8027, 7438, 28718, 14246, 19362, 9378, 16164, 22866, 8029, 20083, 20084, 8026, 31581, 34088, 34150}, -- ok
	["crossbow"] = {23294, 8022, 3349, 27456, 8021, 22867, 8023, 8024, 8025, 14768, 19356, 20086, 20087, 30393, 34089}, -- ok
	["backpack"] = {2854, 2865, 2866, 2000, 2868, 2869, 2870, 2871, 3253, 2872, 3244, 5801, 5926, 5949, 7342, 8860, 9601, 9602, 9604, 9605, 10202, 10324, 10326, 10327, 10346, 14248, 14249, 14674, 16099, 16100, 19159, 20347, 21295, 21445, 22084, 23525, 24393, 24395, 30197, 28571},
	["wand"] = {25700, 3075, 8092, 8093, 8094}, --ok
	["rod"] = {8082, 8083, 22183}, --ok
	["axe"] = {27451, 3317, 3344, 7412, 27452, 16161, 8098, 3302, 10388, 7419, 3323, 7453, 3303, 3315, 7380, 8096, 7389, 14089, 7435, 3318, 7455, 7456, 3331, 22727, 7434, 6553, 8097, 3319, 3335, 20071, 20074, 20072, 20075, 3342, 14040, 10406}, --ok
	["club"] = {7414, 7426, 3341, 7429, 3311, 7415, 3333, 14250, 7431, 7430, 21172, 27454, 3332, 3340, 17813, 7424, 27453, 22762, 16162, 8100, 7421, 7392, 14001, 7410, 7437, 7451, 3312, 3324, 7423, 11692, 7452, 8101, 20080, 20077, 20081, 20078, 3309, 3279}, --ok
	["sword"] = {7404, 7403, 7406, 11693, 27449, 7416, 3295, 3301, 7385, 7382, 3339, 7402, 8102, 3326, 28723, 3281, 7407, 7405, 3288, 7384, 7418, 7383, 7417, 16175, 27450, 3271, 3264, 7391, 6527, 8103, 11657, 10392, 20065, 20069, 20066, 20068, 7408, 10390, 30398}, --ok
	["spellbooks"] = {22755, 3059, 8072, 8073, 20089, 20090, 25699, 29431, 29420, 29426, 34153}, -- ok
	["special_strike"] = {28717, 28716, 27458, 27457, 28826, 28825, 29425, 34090, 34091}, --ok
	["crit_wandrod"] = {30399, 34151},
	["life_wandrod"] = {30400, 34152},
	["elemental_swords"] = {27651, 29421, 29422, 31614, 34083, 34082, 34155},
	["elemental_axes"] = {28724, 30396, 34253, 34084, 34085, 32616},
	["elemental_clubs"] = {28725, 29419, 30395, 31580, 34087, 34086, 34254},
	-- Note: if an armor has native protection, it can't be imbue with this protection
	["armor_energy"] = {27648},
	["armor_only_energy"] = {29423},
	["armor_ice"] = {31579},
	["armor_earth"] = {29418, 31578},
	["armor_death"] = {13994, 31583, 34096}
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
	["lich shroud"] = Storage.Imbuement,
	["reap"] = Storage.Imbuement,
	["vampirism"] = Storage.Imbuement,
	["cloud fabric"] = Storage.Imbuement,
	["electrify"] = Storage.Imbuement,
	["swiftness"] = Storage.Imbuement,
	["snake skin"] = Storage.Imbuement,
	["venom"] = Storage.Imbuement,
	["slash"] = Storage.Imbuement,
	["chop"] = Storage.Imbuement,
	["bash"] = Storage.Imbuement,
	["dragon hide"] = Storage.Imbuement,
	["scorch"] = Storage.Imbuement,
	["void"] = Storage.Imbuement,
	["quara scale"] = Storage.Imbuement,
	["frost"] = Storage.Imbuement,
	["blockade"] = Storage.Imbuement,
	["demon presence"] = Storage.Imbuement,
	["precision"] = Storage.Imbuement,
	["strike"] = Storage.Imbuement,
	["epiphany"] = Storage.Imbuement,
	["featherweight"] = -1,
}

function Player.canImbueItem(self, imbuement, item)
	local item_type = ""
	for tp, items in pairs(Imbuements_Weapons) do
		if table.contains(items, item:getId()) then
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
