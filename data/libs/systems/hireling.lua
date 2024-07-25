HIRELINGS = {}
PLAYER_HIRELINGS = {}
HIRELING_OUTFIT_CHANGING = {}

-- This is for server registration only, high ids to avoid conflicting with the gamestore subaction
HIRELING_SKILLS = {
	BANKER = { 1001, "banker" },
	COOKING = { 1002, "cooker" },
	STEWARD = { 1003, "steward" },
	TRADER = { 1004, "trader" },
}

HIRELING_OUTFITS = {
	BANKER = { 2001, "banker" },
	COOKING = { 2002, "cooker" },
	STEWARD = { 2003, "steward" },
	TRADER = { 2004, "trader" },
	SERVANT = { 2005, "servant" },
	HYDRA = { 2006, "hydra" },
	FERUMBRAS = { 2007, "ferumbras" },
	BONELORD = { 2008, "bonelord" },
	DRAGON = { 2009, "dragon" },
}

HIRELING_SEX = {
	FEMALE = 2,
	MALE = 1,
}

HIRELING_OUTFIT_DEFAULT = { name = "Citizen", female = 1107, male = 1108 }

HIRELING_OUTFITS_TABLE = {
	BANKER = { name = "Banker Dress", female = 1109, male = 1110 },
	BONELORD = { name = "Bonelord Dress", female = 1123, male = 1124 },
	COOKING = { name = "Cook Dress", female = 1113, male = 1114 },
	DRAGON = { name = "Dragon Dress", female = 1125, male = 1126 },
	FERUMBRAS = { name = "Ferumbras Dress", female = 1131, male = 1132 },
	HYDRA = { name = "Hydra Dress", female = 1129, male = 1130 },
	SERVANT = { name = "Servant Dress", female = 1117, male = 1118 },
	STEWARD = { name = "Stewart Dress", female = 1115, male = 1116 },
	TRADER = { name = "Trader Dress", female = 1111, male = 1112 },
}

HIRELING_FOODS_BOOST = {
	MAGIC = 29410,
	MELEE = 29411,
	SHIELDING = 29408,
	DISTANCE = 35173,
}

HIRELING_FOODS_IDS = {
	29412,
	29413,
	29414,
	29415,
	29416,
}

local function printTable(t)
	local str = "{"

	for k, v in pairs(t) do
		str = str .. string.format("\n %s = %s", tostring(k), tostring(v))
	end
	str = str .. "\n}"
	logger.debug(str)
end

local function checkHouseAccess(hireling)
	-- Check if owner still have access to the house
	if not hireling or hireling.active == 0 then
		return false
	end

	local tile = hireling:getPosition():getTile()
	if not tile then
		return false
	end

	local house = tile:getHouse()
	if not house then
		return false
	end
	local player = Player(hireling:getOwnerId())
	if not player then
		player = Game.getOfflinePlayer(hireling:getOwnerId())
	end

	if house:getOwnerGuid() == hireling:getOwnerId() then
		return true
	end

	-- Player is not invited anymore, return to lamp
	logger.debug("Returning Hireling: {} to owner '{}' Inbox", hireling:getName(), player:getName())
	local inbox = player:getStoreInbox()
	if not inbox then
		return false
	end

	-- Using FLAG_NOLIMIT to avoid losing the hireling after being kicked out of the house and having no slots available in the store inbox
	local lamp = inbox:addItem(HIRELING_LAMP, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
	if lamp then
		lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
		lamp:setCustomAttribute("Hireling", hireling:getId())
	end

	player:save()
	hireling.active = 0
	hireling.cid = -1
	hireling:setPosition({ x = 0, y = 0, z = 0 })
end

local function spawnNPCs()
	logger.info("Spawning Hirelings")
	local hireling
	for i = 1, #HIRELINGS do
		hireling = HIRELINGS[i]

		if checkHouseAccess(hireling) then
			hireling:spawn()
		end
	end
end

Hireling = {
	id = -1,
	player_id = -1,
	name = "hireling",
	skills = 0,
	active = 0,
	sex = 0,
	posx = 0,
	posy = 0,
	posz = 0,
	lookbody = 34,
	lookfeet = 116,
	lookhead = 97,
	looklegs = 3,
	looktype = 0,
	cid = -1,
}

function Hireling:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Hireling:getOwnerId()
	return self.player_id
end

function Hireling:getId()
	return self.id
end

function Hireling:getName()
	return self.name
end

function Hireling:canTalkTo(player)
	if not player then
		return false
	end

	local tile = Tile(player:getPosition())
	if not tile then
		return false
	end
	local house = tile:getHouse()
	if not house then
		return false
	end

	local hirelingHouse = Tile(self:getPosition()):getHouse()

	return house:getId() == hirelingHouse:getId()
end

function Hireling:getPosition()
	return Position(self.posx, self.posy, self.posz)
end

function Hireling:setPosition(pos)
	self.posx = pos.x
	self.posy = pos.y
	self.posz = pos.z
end

function Hireling:getOutfit()
	local outfit = {
		lookType = self.looktype,
		lookHead = self.lookhead,
		lookAddons = 0,
		lookMount = 0,
		lookLegs = self.looklegs,
		lookBody = self.lookbody,
		lookFeet = self.lookfeet,
	}

	return outfit
end

function Hireling:getAvailableOutfits()
	local player = Player(self:getOwnerId())
	if not player then
		return
	end

	local outfitsAvailable = {}
	local sex = (self.sex == HIRELING_SEX.FEMALE) and "female" or "male"
	-- Add default outfit
	table.insert(outfitsAvailable, { name = HIRELING_OUTFIT_DEFAULT.name, lookType = HIRELING_OUTFIT_DEFAULT[sex] })
	for key, outfit in pairs(HIRELING_OUTFITS) do
		local outfitName = outfit[2]
		local haveOutfit = player:kv():scoped("hireling-outfits"):get(outfitName)
		if haveOutfit == true then
			logger.debug("[getAvailableOutfits] found outfit {}", outfitName)
			tempOutfit = {
				name = HIRELING_OUTFITS_TABLE[key].name,
				lookType = HIRELING_OUTFITS_TABLE[key][sex],
			}
			table.insert(outfitsAvailable, tempOutfit)
		end
	end
	return outfitsAvailable
end

function Hireling:requestOutfitChange()
	local player = Player(self:getOwnerId())

	HIRELING_OUTFIT_CHANGING[self:getOwnerId()] = self:getId()
	player:sendHirelingOutfitWindow(self)
end

function Hireling:hasOutfit(lookType)
	local outfits = self:getAvailableOutfits()
	local found = false
	for _, outfit in ipairs(outfits) do
		if outfit.lookType == lookType then
			return true
		end
	end

	return found
end

function Hireling:setOutfit(outfit)
	self.looktype = outfit.lookType
	self.lookhead = outfit.lookHead
	self.lookbody = outfit.lookBody
	self.looklegs = outfit.lookLegs
	self.lookfeet = outfit.lookHead
	self.lookAddons = outfit.lookAddons
end

function Hireling:changeOutfit(outfit)
	HIRELING_OUTFIT_CHANGING[self:getOwnerId()] = nil --clear flag

	if not self:hasOutfit(outfit.lookType) then
		return
	end

	local npc = Npc(self.cid)
	local creature = Creature(npc) --maybe self.cid works here too

	creature:setOutfit(outfit)
	self:setOutfit(outfit)
end

function Hireling:hasSkill(skillName)
	local function hasSkillFromPlayer(player)
		if player then
			return player:kv():scoped("hireling-skills"):get(skillName) or false
		end
	end

	local player = Player(self:getOwnerId()) or Game.getOfflinePlayer(self:getOwnerId())
	return hasSkillFromPlayer(player)
end

function Hireling:hasSkill(skillName)
	local function hasSkillFromPlayer(player)
		if player then
			return player:kv():scoped("hireling-skills"):get(skillName) or false
		end

		return false
	end
	local player = Player(self:getOwnerId()) or Game.getOfflinePlayer(self:getOwnerId())
	return hasSkillFromPlayer(player)
end

function Hireling:setCreature(cid)
	self.cid = cid
end

function Hireling:save()
	local sql = "UPDATE `player_hirelings` SET"
	sql = sql .. " `name`=" .. db.escapeString(self.name)
	sql = sql .. ", `active`=" .. tostring(self.active)
	sql = sql .. ", `sex`=" .. tostring(self.sex)
	sql = sql .. ", `posx`=" .. tostring(self.posx)
	sql = sql .. ", `posy`=" .. tostring(self.posy)
	sql = sql .. ", `posz`=" .. tostring(self.posz)
	sql = sql .. ", `lookbody`=" .. tostring(self.lookbody)
	sql = sql .. ", `lookfeet`=" .. tostring(self.lookfeet)
	sql = sql .. ", `lookhead`=" .. tostring(self.lookhead)
	sql = sql .. ", `looklegs`=" .. tostring(self.looklegs)
	sql = sql .. ", `looktype`=" .. tostring(self.looktype)

	sql = sql .. " WHERE `id`=" .. tostring(self.id)

	return db.query(sql)
end

function Hireling:spawn()
	self.active = 1
	-- Creating new hireling with player choose name
	createHirelingType("Hireling " .. self:getName())

	local npc = Npc(Game.generateNpc("Hireling " .. self:getName()))
	local creature = Creature(npc)
	creature:setOutfit(self:getOutfit())
	npc:setSpeechBubble(7)

	npc:place(self:getPosition())
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	self:setCreature(npc:getId())
end

function Hireling:returnToLamp(player_id)
	if self.active ~= 1 then
		return
	end

	local player = Player(player_id)
	if self:getOwnerId() ~= player_id then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return player:sendTextMessage(MESSAGE_FAILURE, "You are not the master of this hireling.")
	end

	self.active = 0
	addEvent(function(npcId, ownerGuid, hirelingId)
		local npc = Npc(npcId)
		if not npc then
			return logger.error("[Hireling:returnToLamp] - Npc not found or is nil.")
		end

		local owner = Player(ownerGuid)
		if not owner then
			return
		end

		local lampType = ItemType(HIRELING_LAMP)
		if owner:getFreeCapacity() < lampType:getWeight(1) then
			owner:getPosition():sendMagicEffect(CONST_ME_POFF)
			return owner:sendTextMessage(MESSAGE_FAILURE, "You do not have enough capacity.")
		end

		local inbox = owner:getStoreInbox()
		local inboxItems = inbox:getItems()
		if not inbox or #inboxItems >= inbox:getMaxCapacity() then
			owner:getPosition():sendMagicEffect(CONST_ME_POFF)
			return owner:sendTextMessage(MESSAGE_FAILURE, "You don't have enough room in your inbox.")
		end

		local hireling = getHirelingById(hirelingId)
		if not hireling then
			return logger.error("[Hireling:returnToLamp] - Hireling not found or is nil for hireling name for player {}.", owner:getName())
		end

		npc:say("As you wish!", TALKTYPE_PRIVATE_NP, false, owner, npc:getPosition())
		local lamp = inbox:addItem(HIRELING_LAMP, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
		npc:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)
		npc:remove() --remove hireling
		lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. self:getName() .. ".")
		lamp:setCustomAttribute("Hireling", hirelingId) --save hirelingId on item
		hireling:setPosition({ x = 0, y = 0, z = 0 })
	end, 1000, self.cid, player:getGuid(), self.id)
end

-- [[ END CLASS DEFINITION ]]

-- [[ GLOBAL FUNCTIONS DEFINITIONS ]]

function SaveHirelings()
	local successCount = 0
	local failedCount = 0

	for _, hireling in ipairs(HIRELINGS) do
		local success = hireling:save() or false

		if not success then
			failedCount = failedCount + 1
			logger.warn("Failed to save hireling: {} (ID: {}).", hireling:getName(), hireling:getId())
		else
			successCount = successCount + 1
		end
	end

	if successCount == #HIRELINGS then
		logger.info("All hirelings successfully saved.")
	else
		logger.warn("Failed to save {} hirelings.", failedCount)
	end
end

function getHirelingById(id)
	local hireling
	for i = 1, #HIRELINGS do
		hireling = HIRELINGS[i]
		if hireling:getId() == tonumber(id) then
			return hireling
		end
	end
	return nil
end

function getHirelingByPosition(position)
	local hireling
	for i = 1, #HIRELINGS do
		hireling = HIRELINGS[i]
		if hireling.posx == position.x and hireling.posy == position.y and hireling.posz == position.z then
			return hireling
		end
	end
	return nil
end

function GetHirelingSkillNameById(id)
	for _, skill in pairs(HIRELING_SKILLS) do
		if skill[1] == id then
			return skill[2]
		end
	end
	return nil
end

function GetHirelingOutfitNameById(id)
	local outfitName = nil
	for _, outfit in pairs(HIRELING_OUTFITS) do
		if outfit[1] == id then
			logger.debug("[GetHirelingOutfitNameById] returning outfit name {}", outfit[2])
			outfitName = outfit[2]
			break
		end
	end

	return outfitName
end

function HirelingsInit()
	local rows = db.storeQuery("SELECT * FROM `player_hirelings`")
	if rows then
		local player_id, hireling
		repeat
			player_id = Result.getNumber(rows, "player_id")
			if not PLAYER_HIRELINGS[player_id] then
				PLAYER_HIRELINGS[player_id] = {}
			end

			hireling = Hireling:new()
			hireling.id = Result.getNumber(rows, "id")
			hireling.player_id = player_id
			hireling.name = Result.getString(rows, "name")
			hireling.active = Result.getNumber(rows, "active")
			hireling.sex = Result.getNumber(rows, "sex")
			hireling.posx = Result.getNumber(rows, "posx")
			hireling.posy = Result.getNumber(rows, "posy")
			hireling.posz = Result.getNumber(rows, "posz")
			hireling.lookbody = Result.getNumber(rows, "lookbody")
			hireling.lookfeet = Result.getNumber(rows, "lookfeet")
			hireling.lookhead = Result.getNumber(rows, "lookhead")
			hireling.looklegs = Result.getNumber(rows, "looklegs")
			hireling.looktype = Result.getNumber(rows, "looktype")

			table.insert(PLAYER_HIRELINGS[player_id], hireling)
			table.insert(HIRELINGS, hireling)
		until not Result.next(rows)
		Result.free(rows)

		spawnNPCs()
	end
end

function PersistHireling(hireling)
	db.query(
		string.format(
			"INSERT INTO `player_hirelings` (`player_id`,`name`,`active`,`sex`,`posx`,`posy`,`posz`,`lookbody`,`lookfeet`,`lookhead`,`looklegs`,`looktype`) VALUES (%d, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)",
			hireling.player_id,
			db.escapeString(hireling.name),
			hireling.active,
			hireling.sex,
			hireling.posx,
			hireling.posy,
			hireling.posz,
			hireling.lookbody,
			hireling.lookfeet,
			hireling.lookhead,
			hireling.looklegs,
			hireling.looktype
		)
	)

	local hirelings = PLAYER_HIRELINGS[hireling.player_id] or {}
	local ids = ""
	for i = 1, #hirelings do
		if i > 1 then
			ids = ids .. "','"
		end
		ids = ids .. tostring(hirelings[i].id)
	end
	local query = string.format("SELECT `id` FROM `player_hirelings` WHERE `player_id`= %d and `id` NOT IN ('%s')", hireling.player_id, ids)
	local resultId = db.storeQuery(query)

	if resultId then
		local id = Result.getNumber(resultId, "id")
		hireling.id = id
		return true
	else
		return false
	end
end

function Player:getHirelings()
	return PLAYER_HIRELINGS[self:getGuid()] or {}
end

function Player:getHirelingsCount()
	local hirelings = self:getHirelings()
	return #hirelings
end

function Player:addNewHireling(name, sex)
	local hireling = Hireling:new()
	hireling.name = name
	hireling.player_id = self:getGuid()
	if sex == HIRELING_SEX.FEMALE then
		-- Citizen female
		hireling.looktype = 136
		hireling.sex = HIRELING_SEX.FEMALE
	else
		-- Citizen male
		hireling.looktype = 128
		hireling.sex = HIRELING_SEX.MALE
	end

	local lampType = ItemType(HIRELING_LAMP)
	if not lampType or self:getFreeCapacity() < lampType:getWeight(1) then
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		self:sendTextMessage(MESSAGE_FAILURE, "You do not have enough capacity.")
		return false
	end

	local inbox = self:getStoreInbox()
	local inboxItems = inbox:getItems()
	if not inbox or #inboxItems >= inbox:getMaxCapacity() then
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		self:sendTextMessage(MESSAGE_FAILURE, "You don't have enough room in your inbox.")
		return false
	end

	local saved = PersistHireling(hireling)
	if not saved then
		logger.error("[Player:addNewHireling] error to saving Hireling '{}' for player '{}'", name, self:getName())
		return false
	end

	local lamp = inbox:addItem(HIRELING_LAMP, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
	if not lamp then
		logger.error("[Player:addNewHireling] error to add hireling lamp '{}' for player {}", name, self:getName())
		return false
	end

	if not PLAYER_HIRELINGS[self:getGuid()] then
		PLAYER_HIRELINGS[self:getGuid()] = {}
	end
	table.insert(PLAYER_HIRELINGS[self:getGuid()], hireling)
	table.insert(HIRELINGS, hireling)

	lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
	lamp:setCustomAttribute("Hireling", hireling:getId())
	hireling.active = 0
	return hireling
end

function Player:isChangingHirelingOutfit()
	return HIRELING_OUTFIT_CHANGING[self:getGuid()] and HIRELING_OUTFIT_CHANGING[self:getGuid()] > 0 or false
end

function Player:getHirelingChangingOutfit()
	local id = HIRELING_OUTFIT_CHANGING[self:getGuid()]
	if not id then
		return nil
	end

	return getHirelingById(id)
end

function Player:sendHirelingOutfitWindow(hireling)
	local outfit = hireling:getOutfit()
	local msg = NetworkMessage()
	-- 'ProtocolGame::sendOutfitWindow()' header
	msg:addByte(0xC8)
	msg:addU16(outfit.lookType)

	if outfit.lookType == 0 then
		msg:addU16(outfit.lookTypeEx)
	else
		msg:addByte(outfit.lookHead)
		msg:addByte(outfit.lookBody)
		msg:addByte(outfit.lookLegs)
		msg:addByte(outfit.lookFeet)
		msg:addByte(outfit.lookAddons)
	end
	msg:addU16(outfit.lookMount)

	msg:addByte(0x00) -- Mount head
	msg:addByte(0x00) -- Mount body
	msg:addByte(0x00) -- Mount legs
	msg:addByte(0x00) -- Mount feet
	msg:addU16(0x00) -- Familiar

	local availableOutfits = hireling:getAvailableOutfits()
	msg:addU16(#availableOutfits)
	for _, outfit in ipairs(availableOutfits) do
		msg:addU16(outfit.lookType)
		msg:addString(outfit.name, "Player:sendHirelingOutfitWindow - outfit.name")
		msg:addByte(0x00) -- addons
		msg:addByte(0x00) -- Store bool
	end

	msg:addU16(0x00) -- Mounts count
	msg:addU16(0x00) -- Familiar count
	msg:addByte(0x00) -- Try outfit bool
	msg:addByte(0x00) -- Is mounted bool
	msg:addByte(0x00) -- Random outfit bool

	msg:sendToPlayer(self)
end

function Player:hasHirelings()
	return PLAYER_HIRELINGS[self:getGuid()] and #PLAYER_HIRELINGS[self:getGuid()] > 0 or false
end

function Player:findHirelingLamp(hirelingId)
	local inbox = self:getStoreInbox()
	if not inbox then
		return nil
	end

	local lastIndex = inbox:getSize() - 1
	for i = 0, lastIndex do
		local item = inbox:getItem(i)
		if item and item:getId() == HIRELING_LAMP and item:getCustomAttribute("Hireling") == hirelingId then
			return item
		end
	end
	return nil
end

function Player:sendHirelingSelectionModal(title, message, callback, data)
	-- callback(playerId, data, hireling)
	-- get all hireling list
	local hirelings = self:getHirelings()
	local modal = ModalWindow({
		title = title,
		message = message,
	})
	local hireling
	for i = 1, #hirelings do
		hireling = hirelings[i]
		local choice = modal:addChoice(string.format("#%d - %s", i, hireling:getName()))
		choice.hireling = hireling
	end

	local playerId = self:getId()
	local internalConfirm = function(button, choice)
		local hrlng = choice and choice.hireling or nil
		callback(playerId, data, hrlng)
	end

	local internalCancel = function(btn, choice)
		callback(playerId, data, nil)
	end

	modal:addButton("Select", internalConfirm)
	modal:setDefaultEnterButton("Select")
	modal:addButton("Cancel", internalCancel)
	modal:setDefaultEscapeButton("Cancel")

	modal:sendToPlayer(self)
end

function Player:hasHirelingSkill(skillName)
	return self:kv():scoped("hireling-skills"):get(skillName)
end

function Player:enableHirelingSkill(skillName)
	local skillScoped = self:kv():scoped("hireling-skills")
	if skillScoped:get(skillName) then
		logger.debug("Player '{}' already have hireling skill name '{}'", self:getName(), skillName)
		return
	end

	skillScoped:set(skillName, true)
end

function Player:hasHirelingOutfit(outfitName)
	return self:kv():scoped("hireling-outfits"):get(outfitName)
end

function Player:enableHirelingOutfit(outfitName)
	local outfitScoped = self:kv():scoped("hireling-outfits")
	if outfitScoped:get(outfitName) then
		logger.debug("Player '{}' already have hireling outfit name '{}'", self:getName(), outfitName)
		return
	end

	outfitScoped:set(outfitName, true)
end

function Player:clearAllHirelingStats()
	local skillsScoped = self:kv():scoped("hireling-skills")
	for key, skills in pairs(HIRELING_SKILLS) do
		if skillsScoped:get(skills[2]) then
			skillsScoped:set(skills[2], false)
		end
	end

	local outfitsScoped = self:kv():scoped("hireling-outfits")
	for key, outfits in pairs(HIRELING_OUTFITS) do
		if outfitsScoped:get(outfits[2]) then
			outfitsScoped:set(outfits[2], false)
		end
	end
end
