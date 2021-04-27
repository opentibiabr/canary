HIRELING_CREDITS = {
	Developer = 'Leonardo "Leu" Pereira (jlcvp)',
	Version = "1.0-CoronaVaires",
	Date = "29/04/2020"
}

local DEBUG = true -- print debug to console

HIRELING_CACHE_STORAGE = {}
HIRELINGS = {}
PLAYER_HIRELINGS = {}
HIRELING_OUTFIT_CHANGING = {}

function DebugPrint(str)
	if DEBUG == true then
		Spdlog.debug(str)
	end
end

function printTable(t)
	local str = '{'

		for k,v in pairs(t) do
			str = str .. string.format( "\n %s = %s",tostring(k), tostring(v))
		end
	str = str.. '\n}'
	Spdlog.debug(str)
end

-- [[ Constants and ENUMS ]]

HIRELING_SKILLS = {
	BANKER = 1, -- 1<<0
	COOKING = 2, -- 1<<1
	STEWARD = 4, -- 1<<2
	TRADER = 8 -- 1<<3
}

HIRELING_SEX = {
	FEMALE = 0,
	MALE = 1
}

HIRELING_OUTFIT_DEFAULT = { name = "Citizen", female = 1107, male = 1108 }

HIRELING_OUTFITS = {
	BANKER = 1, -- 1<<0
	COOKING = 2, -- 1<<1
	STEWARD = 4, -- 1<<2
	TRADER = 8, -- 1<<3 ...
	SERVANT = 16,
	HYDRA = 32,
	FERUMBRAS = 64,
	BONELORD = 128,
	DRAGON = 256
}

HIRELING_OUTFITS_TABLE = {
	BANKER = {name = "Banker Dress", female = 1109, male = 1110},
	BONELORD = {name = "Bonelord Dress", female = 1123, male = 1124},
	COOKING = {name = "Cook Dress", female = 1113, male = 1114},
	DRAGON = {name = "Dragon Dress", female = 1125, male = 1126},
	FERUMBRAS = {name = "Ferumbras Dress", female = 1131, male = 1132},
	HYDRA = {name = "Hydra Dress", female = 1129, male = 1130},
	SERVANT = {name = "Servant Dress", female = 1117, male = 1118},
	STEWARD = {name = "Stewart Dress", female = 1115, male = 1116},
	TRADER = {name = "Trader Dress", female = 1111, male = 1112}
}

HIRELING_STORAGE = {
	SKILL = 28800,
	OUTFIT = 28900
}

HIRELING_LAMP_ID = 34070
HIRELING_ATTRIBUTE = "HIRELING_ID"

HIRELING_FOODS_BOOST = {
	MAGIC = 35174,
	MELEE = 35175,
	SHIELDING = 35172,
	DISTANCE = 35173,
}

HIRELING_FOODS = { -- only the non-skill ones
	35176, 35177, 35178, 35179, 35180
}

-- [[ LOCAL FUNCTIONS AND UTILS ]]

local function checkHouseAccess(hireling)
	--check if owner still have access to the house
	if hireling.active == 0 then return false end

	local house = hireling:getPosition():getTile():getHouse()
	local player = Player(hireling:getOwnerId())
	if not player then
		player = Game.getOfflinePlayer(hireling:getOwnerId())
	end

	if house:getOwnerGuid() == hireling:getOwnerId() then return true end

	-- player is not invited anymore, return to lamp
	Spdlog.info("Returning Hireling:" .. hireling:getName() .. " to owner Inbox")
	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	local lamp = inbox:addItem(HIRELING_LAMP_ID, 1)
	lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
	lamp:setSpecialAttribute(HIRELING_ATTRIBUTE, hireling:getId()) --save hirelingId on item
	player:save()
	hireling.active = 0
	hireling.cid = -1
	hireling:setPosition({x=0,y=0,z=0})

end

local function spawnNPCs()
	Spdlog.info("Spawning Hirelings")
	local hireling
	for i=1,#HIRELINGS do
		hireling = HIRELINGS[i]

		if checkHouseAccess(hireling) then
			hireling:spawn()
		end
	end
end

local function addStorageCacheValue(player_id, storage, value)
	if not HIRELING_CACHE_STORAGE[player_id] then
		HIRELING_CACHE_STORAGE[player_id] = {}
	end
	HIRELING_CACHE_STORAGE[player_id][storage] = value
end

local function initStorageCache()
	local sql = string.format("SELECT `player_id`, `key`, `value` FROM `player_storage` "..
	"WHERE `key` IN (%d,%d)", HIRELING_STORAGE.SKILL, HIRELING_STORAGE.OUTFIT)

	local resultId = db.storeQuery(sql)
	if resultId ~= false then
		local player_id, key, value
		repeat
			player_id = result.getNumber(resultId,"player_id")
			key = result.getNumber(resultId,"key")
			value = result.getNumber(resultId,"value")

			addStorageCacheValue(player_id, key, value)
		until not result.next(resultId)
		result.free(resultId)
	end
end

local function getStorageForPlayer(player_id, storage)
	local player = Player(player_id)
	if player then
		return player:getStorageValue(storage)
	else
		return HIRELING_CACHE_STORAGE[player_id] and HIRELING_CACHE_STORAGE[player_id][storage] or -1
	end
end

-- [[ DEFINING HIRELING CLASS ]]

Hireling = {
	id = -1,
	player_id = -1,
	name = 'hireling',
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
	cid = -1
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
	if not player then return false end

	local tile = Tile(player:getPosition())
	if not tile then return false end
	local house = tile:getHouse()
	if not house then return false end

	local hirelingHouse = Tile(self:getPosition()):getHouse()

	return house:getId() == hirelingHouse:getId()
end

function Hireling:getPosition()
	return Position(self.posx,self.posy, self.posz)
end

function Hireling:setPosition(pos)
	self.posx = pos.x
	self.posy = pos.y
	self.posz = pos.z
end

function Hireling:getOutfit()
	local outfit = 	{
		lookType=self.looktype,
		lookHead=self.lookhead,
		lookAddons=0,
		lookMount=0,
		lookLegs=self.looklegs,
		lookBody=self.lookbody,
		lookFeet=self.lookfeet
	}

	return outfit
end

function Hireling:getAvailableOutfits()

	local flags = getStorageForPlayer(self:getOwnerId(),HIRELING_STORAGE.OUTFIT)
	local sex = (self.sex == HIRELING_SEX.FEMALE) and 'female' or 'male'

	local outfits = {}
	-- add default outfit
	table.insert(outfits, { name = HIRELING_OUTFIT_DEFAULT.name, lookType = HIRELING_OUTFIT_DEFAULT[sex] })
	if flags >0 then
		local outfit
		for key, value in pairs(HIRELING_OUTFITS) do
			if hasBitSet(value, flags) then
				outfit = {
					name = HIRELING_OUTFITS_TABLE[key].name,
					lookType = HIRELING_OUTFITS_TABLE[key][sex]
				}
				table.insert(outfits, outfit)
			end
		end
	end

	return outfits
end

function Hireling:requestOutfitChange()
	local player = Player(self:getOwnerId())

	HIRELING_OUTFIT_CHANGING[self:getOwnerId()] = self:getId()
	player:sendHirelingOutfitWindow(self)
end

function Hireling:hasOutfit(lookType)
	local outfits = self:getAvailableOutfits()
	local found = false
	for _,outfit in ipairs(outfits) do
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

	if not self:hasOutfit(outfit.lookType) then return end

	local npc = Npc(self.cid)
	local creature = Creature(npc) --maybe self.cid works here too

	creature:setOutfit(outfit)
	self:setOutfit(outfit)
end


function Hireling:hasSkill(SKILL)
	local skills = getStorageForPlayer(self:getOwnerId(), HIRELING_STORAGE.SKILL)
	if skills <= 0 then
		return false
	else
		return hasBitSet(SKILL, skills)
	end
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

	db.query(sql)
end

function Hireling:spawn()
	self.active = 1
	local npc = Npc(Game.generateNpc('hireling'))
	npc:setName(self:getName())
	local creature = Creature(npc)
	creature:setOutfit(self:getOutfit())
	npc:setSpeechBubble(7)

	npc:place(self:getPosition())
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
end

function Hireling:returnToLamp(player_id)
	local creature = Creature(self.cid)
	local player = Player(player_id)
	local lampType = ItemType(HIRELING_LAMP_ID)

	if self:getOwnerId() ~= player_id then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return player:sendTextMessage(MESSAGE_FAILURE, "You are not the master of this hireling.")
	end

	if player:getFreeCapacity() < lampType:getWeight(1) then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return player:sendTextMessage(MESSAGE_FAILURE, "You do not have enough capacity.")
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not inbox or inbox:getEmptySlots() == 0 then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough room in your inbox.")
	end


	local lamp = inbox:addItem(HIRELING_LAMP_ID, 1)
	creature:getPosition():sendMagicEffect(CONST_ME_PURPLESMOKE)
	creature:remove() --remove hireling
	lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. self:getName() .. ".")
	lamp:setSpecialAttribute(HIRELING_ATTRIBUTE, self:getId()) --save hirelingId on item
	self.active = 0
	self.cid = -1
	self:setPosition({x=0,y=0,z=0})
end
-- [[ END CLASS DEFINITION ]]

-- [[ GLOBAL FUNCTIONS DEFINITIONS ]]

function SaveHirelings()
	for _, hireling in ipairs(HIRELINGS) do
		hireling:save()
	end
end
function getHirelingById(id)
	local hireling
	for i = 1, #HIRELINGS do
		hireling = HIRELINGS[i]
		if hireling:getId() == id then
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

function HirelingsInit()
	local rows = db.storeQuery("SELECT * FROM `player_hirelings`")

	if rows then
		repeat
			local player_id = result.getNumber(rows, "player_id")

			if not PLAYER_HIRELINGS[player_id] then
				PLAYER_HIRELINGS[player_id] = {}
			end

			local hireling = Hireling:new()
			hireling.id = result.getNumber(rows, "id")
			hireling.player_id = player_id
			hireling.name = result.getString(rows, "name")
			hireling.active = result.getNumber(rows, "active")
			hireling.sex = result.getNumber(rows, "sex")
			hireling.posx = result.getNumber(rows, "posx")
			hireling.posy = result.getNumber(rows, "posy")
			hireling.posz = result.getNumber(rows, "posz")
			hireling.lookbody = result.getNumber(rows, "lookbody")
			hireling.lookfeet = result.getNumber(rows, "lookfeet")
			hireling.lookhead = result.getNumber(rows, "lookhead")
			hireling.looklegs = result.getNumber(rows, "looklegs")
			hireling.looktype = result.getNumber(rows, "looktype")

			table.insert(PLAYER_HIRELINGS[player_id], hireling)
			table.insert(HIRELINGS, hireling)
		until not result.next(rows)
		result.free(rows)

		spawnNPCs()
		initStorageCache()

	end
end

function PersistHireling(hireling)

	db.query(string.format("INSERT INTO `player_hirelings` (`player_id`,`name`,`active`,`sex`,`posx`,`posy`,`posz`,`lookbody`,`lookfeet`,`lookhead`,`looklegs`,`looktype`) VALUES (%d, %s, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)",
	hireling.player_id, db.escapeString(hireling.name), hireling.active, hireling.sex, hireling.posx, hireling.posy, hireling.posz, hireling.lookbody, hireling.lookfeet, hireling.lookhead, hireling.looklegs, hireling.looktype)
	)

	local hirelings = PLAYER_HIRELINGS[hireling.player_id] or {}
	local ids = ""
	for i=1,#hirelings do
		if i > 1 then
			ids = ids .. "','"
		end
		ids = ids .. tostring(hirelings[i].id)
	end
	local query = string.format("SELECT `id` FROM `player_hirelings` WHERE `player_id`= %d and `id` NOT IN ('%s')", hireling.player_id, ids)
	local resultId = db.storeQuery(query)

	if resultId then
		local id = result.getNumber(resultId, 'id')
		hireling.id = id
		return true
	else
		return false
	end
end



-- [[ END GLOBAL FUNCTIONS ]]

-- [[ Player extension ]]
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
		hireling.looktype=136 -- citizen female
		hireling.sex = HIRELING_SEX.FEMALE
	else
		hireling.looktype=128 -- citizen male
		hireling.sex = HIRELING_SEX.MALE
	end

	local lampType = ItemType(HIRELING_LAMP_ID)
	if self:getFreeCapacity() < lampType:getWeight(1) then
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		self:sendTextMessage(MESSAGE_FAILURE, "You do not have enough capacity.")
		return false
	end

	local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not inbox or inbox:getEmptySlots() == 0 then
		self:getPosition():sendMagicEffect(CONST_ME_POFF)
		self:sendTextMessage(MESSAGE_FAILURE, "You don't have enough room in your inbox.")
		return false
	end

	local saved = PersistHireling(hireling)
	if not saved then
		DebugPrint('Error saving Hireling:' .. name .. ' - player:' .. self:getName())
		return false
	else
		if not PLAYER_HIRELINGS[self:getGuid()] then
			PLAYER_HIRELINGS[self:getGuid()] = {}
		end
		table.insert(PLAYER_HIRELINGS[self:getGuid()], hireling)
		table.insert(HIRELINGS, hireling)
		local lamp = inbox:addItem(HIRELING_LAMP_ID, 1)
		lamp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious lamp summons your very own personal hireling.\nThis item cannot be traded.\nThis magic lamp is the home of " .. hireling:getName() .. ".")
		lamp:setSpecialAttribute(HIRELING_ATTRIBUTE, hireling:getId()) --save hirelingId on item
		hireling.active = 0
		return hireling
	end
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

local function addOutfit(msg, outfit)
	msg:addU16(outfit.lookType)

	msg:addByte(outfit.lookHead)
	msg:addByte(outfit.lookBody)
	msg:addByte(outfit.lookLegs)
	msg:addByte(outfit.lookFeet)
	msg:addByte(outfit.lookAddons)
	msg:addU16(outfit.lookMount)
	msg:addByte(0)
	msg:addByte(0)
	msg:addByte(0)
	msg:addByte(0)
	msg:addU16(0)
end

function Player:sendHirelingOutfitWindow(hireling)
	local msg = NetworkMessage()
	local client = self:getClient()
	msg:addByte(200) -- header
	addOutfit(msg, hireling:getOutfit()) -- current outfit

	local availableOutfits = hireling:getAvailableOutfits()

	if client.version >= 1185 then
		msg:addU16(#availableOutfits)
	else
		msg:addByte(#availableOutfits)
	end

	for _,outfit in ipairs(availableOutfits) do
		msg:addU16(outfit.lookType)
		msg:addString(outfit.name)
		msg:addByte(0x00) -- addons

		if client.version >= 1185 then
			-- something related to the store button (offer_id maybe) not using now
			msg:addByte(0x00)
		end
	end

	-- mounts disabled for hirelings
	if client.version >= 1185 then
		msg:addU16(0x00) --mounts count
		msg:addU16(0x00) --familiar count
		msg:addByte(0x00) -- dunno
		msg:addByte(0x00) -- dunno2
	else
		msg:addByte(0x00)
	end

	msg:sendToPlayer(self)
end

function Player:hasHirelings()
	return PLAYER_HIRELINGS[self:getGuid()] and #PLAYER_HIRELINGS[self:getGuid()] > 0 or false
end

function Player:copyHirelingStorageToCache()
	if(self:hasHirelings()) then
		local storageSkill = self:getStorageValue(HIRELING_STORAGE.SKILL)
		local storageOutfit = self:getStorageValue(HIRELING_STORAGE.OUTFIT)
		addStorageCacheValue(self:getGuid(),HIRELING_STORAGE.SKILL, storageSkill)
		addStorageCacheValue(self:getGuid(),HIRELING_STORAGE.OUTFIT, storageOutfit)
	end
end

function Player:findHirelingLamp(hirelingId)
	local inbox = self:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not inbox then return nil end

	local lastIndex = inbox:getSize() - 1
	for i=0,lastIndex do
		local item = inbox:getItem(i)
		if item and item:getId() == HIRELING_LAMP_ID and item:getSpecialAttribute(HIRELING_ATTRIBUTE) == hirelingId then
			return item
		end
	end
	return nil
end

function Player:sendHirelingSelectionModal(title, message, callback, data)
	-- callback(playerId, data, hireling)
	-- get all hireling list
	local hirelings = self:getHirelings()
	local modal = ModalWindow {
		title = title,
		message = message
	}
	local hireling
	for i=1,#hirelings do
		hireling = hirelings[i]
		local choice = modal:addChoice(string.format('#%d - %s', i, hireling:getName()))
		choice.hireling = hireling
	end

	local playerId = self:getId()
	local internalConfirm = function(button, choice)
		local hrlng = choice and choice.hireling or nil
		callback(playerId, data, hrlng)
	end

	local internalCancel = function(btn, choice) callback(playerId, data, nil) end

	modal:addButton('Select',internalConfirm)
	modal:setDefaultEnterButton('Select')
	modal:addButton('Cancel',internalCancel)
	modal:setDefaultEscapeButton('Cancel')

	modal:sendToPlayer(self)
end

function Player:showInfoModal(title, message, buttonText)
	local modal = ModalWindow {
		title = title,
		message = message
	}
	buttonText = buttonText or 'Close'
	modal:addButton(buttonText,function()end)
	modal:setDefaultEscapeButton(buttonText)

	modal:sendToPlayer(self)
end

function Player:hasHirelingSkill(SKILL)
	local skills = self:getStorageValue(HIRELING_STORAGE.SKILL)
	if skills <= 0 then
		return false
	else
		return hasBitSet(SKILL, skills)
	end
end

function Player:enableHirelingSkill(SKILL)
	local skills = self:getStorageValue(HIRELING_STORAGE.SKILL)
	if skills < 0 then skills = 0 end
	skills = setFlag(SKILL, skills)
	self:setStorageValue(HIRELING_STORAGE.SKILL, skills)
	self:copyHirelingStorageToCache()
end

function Player:hasHirelingOutfit(OUTFIT)
	local outfits = self:getStorageValue(HIRELING_STORAGE.OUTFIT)
	if outfits <= 0 then
		return false
	else
		return hasBitSet(OUTFIT, outfits)
	end
end

function Player:enableHirelingOutfit(OUTFIT)
	local outfits = self:getStorageValue(HIRELING_STORAGE.OUTFIT)
	if outfits < 0 then outfits = 0 end
	outfits = setFlag(OUTFIT, outfits)
	self:setStorageValue(HIRELING_STORAGE.OUTFIT, outfits)
	self:copyHirelingStorageToCache()
end
-- [[ END PLAYER EXTENSION ]]
