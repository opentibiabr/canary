local protocolProbe = TalkAction("/protocolprobe", "/probeopcode", "/protocol1530")

local LOCAL_PROBE_FILE = "data/scripts/talkactions/god/protocol_probe.local.json"
local EXAMPLE_PROBE_FILE = "data/scripts/talkactions/god/protocol_probe.example.json"
local JSON_NULL = {}
local U64_MAX = 18446744073709551615
local I64_MIN = -9223372036854775808
local I64_MAX = 9223372036854775807

local function trim(value)
	return (value or ""):match("^%s*(.-)%s*$")
end

local function parseInteger(value)
	value = trim(tostring(value or ""))
	if value == "" then
		return nil
	end

	local sign = 1
	if value:sub(1, 1) == "-" then
		sign = -1
		value = value:sub(2)
	end

	local lowered = value:lower()
	local number
	if lowered:sub(1, 2) == "0x" then
		number = tonumber(lowered:sub(3), 16)
	else
		number = tonumber(value)
	end

	if not number then
		return nil
	end
	return sign * math.floor(number)
end

local function requireInteger(value, minValue, maxValue)
	local number = parseInteger(value)
	if not number then
		return nil, "invalid integer '" .. tostring(value) .. "'"
	end
	if number < minValue or number > maxValue then
		return nil, string.format("integer %d outside range %d..%d", number, minValue, maxValue)
	end
	return number
end

local function readNumber(value, defaultValue, minValue, maxValue)
	local number = parseInteger(value)
	if not number then
		return defaultValue
	end
	if number < minValue then
		return minValue
	end
	if number > maxValue then
		return maxValue
	end
	return number
end

local function readByte(value, defaultValue)
	return readNumber(value, defaultValue, 0, 0xFF)
end

local function readU16(value, defaultValue)
	return readNumber(value, defaultValue, 0, 0xFFFF)
end

local function readU32(value, defaultValue)
	return readNumber(value, defaultValue, 0, 0xFFFFFFFF)
end

local function parseArgs(param)
	local args = {}
	for token in string.gmatch(param or "", "%S+") do
		args[#args + 1] = token
	end
	return args
end

local function sliceArgs(args, startIndex)
	local values = {}
	for index = startIndex, #args do
		values[#values + 1] = args[index]
	end
	return values
end

local function readRemainingText(args, startIndex, defaultValue)
	if #args < startIndex then
		return defaultValue
	end

	local parts = {}
	for index = startIndex, #args do
		parts[#parts + 1] = args[index]
	end
	return table.concat(parts, " ")
end

local function readFile(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()
	return content
end

local function decodeJson(text)
	local index = 1
	local length = #text

	local function fail(message)
		return nil, string.format("%s at byte %d", message, index)
	end

	local function skipWhitespace()
		while index <= length and text:sub(index, index):match("%s") do
			index = index + 1
		end
	end

	local function parseString()
		if text:sub(index, index) ~= '"' then
			return fail("expected string")
		end
		index = index + 1

		local buffer = {}
		while index <= length do
			local char = text:sub(index, index)
			if char == '"' then
				index = index + 1
				return table.concat(buffer)
			end
			if char == "\\" then
				index = index + 1
				local escaped = text:sub(index, index)
				if escaped == '"' or escaped == "\\" or escaped == "/" then
					buffer[#buffer + 1] = escaped
				elseif escaped == "b" then
					buffer[#buffer + 1] = "\b"
				elseif escaped == "f" then
					buffer[#buffer + 1] = "\f"
				elseif escaped == "n" then
					buffer[#buffer + 1] = "\n"
				elseif escaped == "r" then
					buffer[#buffer + 1] = "\r"
				elseif escaped == "t" then
					buffer[#buffer + 1] = "\t"
				elseif escaped == "u" then
					local hex = text:sub(index + 1, index + 4)
					local codepoint = tonumber(hex, 16)
					if not codepoint or #hex ~= 4 then
						return fail("invalid unicode escape")
					end
					buffer[#buffer + 1] = codepoint <= 0x7F and string.char(codepoint) or "?"
					index = index + 4
				else
					return fail("invalid escape")
				end
			else
				buffer[#buffer + 1] = char
			end
			index = index + 1
		end

		return fail("unterminated string")
	end

	local parseValue

	local function parseArray()
		index = index + 1
		local array = {}

		skipWhitespace()
		if text:sub(index, index) == "]" then
			index = index + 1
			return array
		end

		while index <= length do
			local value, error = parseValue()
			if error then
				return nil, error
			end
			array[#array + 1] = value

			skipWhitespace()
			local char = text:sub(index, index)
			if char == "]" then
				index = index + 1
				return array
			end
			if char ~= "," then
				return fail("expected ',' or ']'")
			end
			index = index + 1
		end

		return fail("unterminated array")
	end

	local function parseObject()
		index = index + 1
		local object = {}

		skipWhitespace()
		if text:sub(index, index) == "}" then
			index = index + 1
			return object
		end

		while index <= length do
			skipWhitespace()
			local key, error = parseString()
			if error then
				return nil, error
			end

			skipWhitespace()
			if text:sub(index, index) ~= ":" then
				return fail("expected ':'")
			end
			index = index + 1

			local value
			value, error = parseValue()
			if error then
				return nil, error
			end
			object[key] = value

			skipWhitespace()
			local char = text:sub(index, index)
			if char == "}" then
				index = index + 1
				return object
			end
			if char ~= "," then
				return fail("expected ',' or '}'")
			end
			index = index + 1
		end

		return fail("unterminated object")
	end

	local function parseNumber()
		local startIndex = index
		if text:sub(index, index) == "-" then
			index = index + 1
		end

		if text:sub(index, index) == "0" then
			index = index + 1
		else
			if not text:sub(index, index):match("%d") then
				return fail("expected number")
			end
			while index <= length and text:sub(index, index):match("%d") do
				index = index + 1
			end
		end

		if text:sub(index, index) == "." then
			index = index + 1
			if not text:sub(index, index):match("%d") then
				return fail("invalid number fraction")
			end
			while index <= length and text:sub(index, index):match("%d") do
				index = index + 1
			end
		end

		local exponent = text:sub(index, index)
		if exponent == "e" or exponent == "E" then
			index = index + 1
			local sign = text:sub(index, index)
			if sign == "+" or sign == "-" then
				index = index + 1
			end
			if not text:sub(index, index):match("%d") then
				return fail("invalid number exponent")
			end
			while index <= length and text:sub(index, index):match("%d") do
				index = index + 1
			end
		end

		local number = tonumber(text:sub(startIndex, index - 1))
		if not number then
			return fail("invalid number")
		end
		return number
	end

	parseValue = function()
		skipWhitespace()
		local char = text:sub(index, index)
		if char == '"' then
			return parseString()
		elseif char == "{" then
			return parseObject()
		elseif char == "[" then
			return parseArray()
		elseif char == "-" or char:match("%d") then
			return parseNumber()
		elseif text:sub(index, index + 3) == "true" then
			index = index + 4
			return true
		elseif text:sub(index, index + 4) == "false" then
			index = index + 5
			return false
		elseif text:sub(index, index + 3) == "null" then
			index = index + 4
			return JSON_NULL
		end

		return fail("unexpected token")
	end

	local value, error = parseValue()
	if error then
		return nil, error
	end

	skipWhitespace()
	if index <= length then
		return fail("trailing content")
	end
	return value
end

local function addBool(msg, value)
	msg:addByte(value ~= 0 and value ~= false and value ~= "false" and 1 or 0)
end

local function addHexBytes(msg, value)
	if type(value) == "table" and value ~= JSON_NULL then
		for _, byteValue in ipairs(value) do
			local byte, error = requireInteger(byteValue, 0, 0xFF)
			if not byte then
				return false, error
			end
			msg:addByte(byte)
		end
		return true
	end

	local hex = tostring(value == JSON_NULL and "" or value or ""):gsub("[%s:_-]", "")
	if hex == "" then
		return true
	end
	if #hex % 2 ~= 0 then
		return false, "hex payload must have an even number of digits"
	end

	for index = 1, #hex, 2 do
		local byte = tonumber(hex:sub(index, index + 1), 16)
		if not byte then
			return false, "invalid hex byte '" .. hex:sub(index, index + 1) .. "'"
		end
		msg:addByte(byte)
	end
	return true
end

local function defaultFieldValue(fieldType)
	if fieldType == "bool" then
		return false
	elseif fieldType == "string" or fieldType == "str" or fieldType == "hex" or fieldType == "bytes" then
		return ""
	end
	return 0
end

local function addTypedValue(msg, fieldType, value)
	if type(fieldType) ~= "string" then
		return false, "field type must be a string"
	end

	fieldType = fieldType:lower()
	if value == nil or value == JSON_NULL then
		value = defaultFieldValue(fieldType)
	end

	if fieldType == "u8" or fieldType == "byte" then
		local number, error = requireInteger(value, 0, 0xFF)
		if not number then
			return false, error
		end
		msg:addByte(number)
	elseif fieldType == "u16" then
		local number, error = requireInteger(value, 0, 0xFFFF)
		if not number then
			return false, error
		end
		msg:addU16(number)
	elseif fieldType == "u32" then
		local number, error = requireInteger(value, 0, 0xFFFFFFFF)
		if not number then
			return false, error
		end
		msg:addU32(number)
	elseif fieldType == "u64" then
		local number, error = requireInteger(value, 0, U64_MAX)
		if not number then
			return false, error
		end
		msg:addU64(number)
	elseif fieldType == "i8" then
		local number, error = requireInteger(value, -0x80, 0x7F)
		if not number then
			return false, error
		end
		msg:add8(number)
	elseif fieldType == "i16" then
		local number, error = requireInteger(value, -0x8000, 0x7FFF)
		if not number then
			return false, error
		end
		msg:add16(number)
	elseif fieldType == "i32" then
		local number, error = requireInteger(value, -0x80000000, 0x7FFFFFFF)
		if not number then
			return false, error
		end
		msg:add32(number)
	elseif fieldType == "i64" then
		local number, error = requireInteger(value, I64_MIN, I64_MAX)
		if not number then
			return false, error
		end
		msg:add64(number)
	elseif fieldType == "bool" then
		if type(value) == "boolean" then
			addBool(msg, value)
		else
			local normalized = tostring(value):lower()
			if normalized == "true" or normalized == "false" then
				addBool(msg, normalized)
			else
				local number, error = requireInteger(value, 0, 1)
				if not number then
					return false, error
				end
				msg:addByte(number)
			end
		end
	elseif fieldType == "string" or fieldType == "str" then
		msg:addString(tostring(value))
	elseif fieldType == "hex" or fieldType == "bytes" then
		return addHexBytes(msg, value)
	else
		return false, "unsupported field type '" .. fieldType .. "'"
	end

	return true
end

local function getEquippedWeaponId(player)
	for _, slot in ipairs({ CONST_SLOT_LEFT, CONST_SLOT_RIGHT }) do
		local item = player:getSlotItem(slot)
		if item then
			local itemId = item:getId()
			local itemType = ItemType(itemId)
			if itemType and itemType:isWeapon() then
				return itemId
			end
		end
	end
	return 0
end

local function resolveWeaponId(value, player)
	if value ~= nil and string.lower(tostring(value)) ~= "confirm" then
		local weaponId, error = requireInteger(value, 1, 0xFFFF)
		if not weaponId then
			return nil, error
		end

		local itemType = ItemType(weaponId)
		if not itemType or not itemType:isWeapon() then
			return nil, string.format("item id %d is not a weapon", weaponId)
		end
		return weaponId
	end

	local weaponId = getEquippedWeaponId(player)
	if weaponId == 0 then
		return nil, "equip a weapon or pass a valid weapon item id"
	end
	return weaponId
end

local function validateWeaponProbe(args, player)
	local _, error = resolveWeaponId(args[2], player)
	if error then
		return false, error
	end
	return true
end

local function validateSpecialStatusIcon(args)
	if args[2] == nil then
		return true
	end

	local _, error = requireInteger(args[2], 0, 9)
	if error then
		return false, "special status icon must be one of the known ids from 0 to 9"
	end
	return true
end

local function addCreatureIconEntry(msg, icon, category, count)
	msg:addByte(icon)
	msg:addByte(category)
	msg:addU16(count)
	msg:addByte(0) -- 15.25/15.30 reserved flag
end

local function addTaskboardTalismanLine(msg, level, canUpgrade, cost)
	msg:addU16(level)
	msg:addByte(canUpgrade and 1 or 0)
	msg:addU16(cost)
end

local probes = {
	pingback = {
		opcode = 0x1E,
		usage = "/protocolprobe pingback",
		build = function() end,
	},
	["pingback-candidate"] = {
		opcode = 0x1E,
		usage = "/protocolprobe pingback-candidate [u32] [u8]",
		build = function(msg, args)
			msg:addU32(readU32(args[2], 0))
			msg:addByte(readByte(args[3], 0))
		end,
	},
	["close-trade"] = {
		opcode = 0x7F,
		usage = "/protocolprobe close-trade",
		build = function() end,
	},
	["close-trade-candidate"] = {
		opcode = 0x7F,
		usage = "/protocolprobe close-trade-candidate [u8] [u8]",
		build = function(msg, args)
			msg:addByte(readByte(args[2], 0))
			msg:addByte(readByte(args[3], 0))
		end,
	},
	["update-target"] = {
		opcode = 0xA3,
		usage = "/protocolprobe update-target [creatureId]",
		build = function(msg, args)
			msg:addU32(readU32(args[2], 0))
		end,
	},
	["update-target-candidate"] = {
		opcode = 0xA3,
		usage = "/protocolprobe update-target-candidate [creatureId] [secondaryId]",
		build = function(msg, args)
			msg:addU32(readU32(args[2], 0))
			msg:addU32(readU32(args[3], 0))
		end,
	},
	["set-tactics"] = {
		opcode = 0xA7,
		usage = "/protocolprobe set-tactics [u8] [u8] [u8]",
		build = function(msg, args)
			msg:addByte(readByte(args[2], 0))
			msg:addByte(readByte(args[3], 0))
			msg:addByte(readByte(args[4], 0))
		end,
	},
	["own-channel"] = {
		opcode = 0xB2,
		usage = "/protocolprobe own-channel [channelId] [name]",
		build = function(msg, args, player)
			msg:addU16(readU16(args[2], 0xFFFF))
			msg:addString(readRemainingText(args, 3, "Protocol Probe"))
			msg:addU16(1)
			msg:addString(player:getName())
			msg:addU16(0)
		end,
	},
	["own-channel-candidate"] = {
		opcode = 0xB2,
		usage = "/protocolprobe own-channel [channelId] [name]",
		build = function(msg, args)
			msg:addU16(readU16(args[2], 0xFFFF))
			msg:addString(readRemainingText(args, 3, "Protocol Probe"))
		end,
	},
	["close-imbuing"] = {
		opcode = 0xEC,
		usage = "/protocolprobe close-imbuing",
		build = function() end,
	},
	["close-imbuing-candidate"] = {
		opcode = 0xEC,
		usage = "/protocolprobe close-imbuing [bool] [bool] [message]",
		build = function(msg, args)
			addBool(msg, readByte(args[2], 0))
			addBool(msg, readByte(args[3], 0))
			msg:addString(readRemainingText(args, 4, ""))
		end,
	},
	["1530-status-special"] = {
		opcode = 0xA2,
		usage = "/protocol1530 status-special [specialIcon]",
		description = "Replaces the normal status mask with one known special status icon (0-9); use 0 to clear it.",
		layout = "normalIcons:u64=0, specialIcon:u8",
		evidence = "Canary ProtocolGame::sendIconBakragore and the 15.30 client decoder",
		confidence = "repo/static",
		validate = validateSpecialStatusIcon,
		build = function(msg, args)
			msg:addU64(0)
			msg:addByte(readByte(args[2], 0))
		end,
	},
	["1530-target-clear"] = {
		opcode = 0xA3,
		usage = "/protocol1530 target-clear confirm",
		description = "Clears both target identifiers in the two-u32 15.30 candidate layout.",
		layout = "primaryCreatureId:u32=0, secondaryCreatureId:u32=0",
		evidence = "15.30 static decoder; the second u32 has no live wire capture yet",
		confidence = "candidate",
		requiresConfirmation = true,
		build = function(msg)
			msg:addU32(0)
			msg:addU32(0)
		end,
	},
	["1530-tactics"] = {
		opcode = 0xA7,
		usage = "/protocol1530 tactics [chase] [secure] [pvp]",
		description = "Applies the compact three-byte tactics state used by the current client.",
		layout = "chaseMode:u8, secureMode:u8, pvpMode:u8",
		evidence = "15.25/15.30 static decoder and current Canary sender",
		confidence = "static/repo",
		build = function(msg, args)
			msg:addByte(readByte(args[2], 0))
			msg:addByte(readByte(args[3], 1))
			msg:addByte(readByte(args[4], 0))
		end,
	},
	["1530-stance-clear"] = {
		opcode = 0xC1,
		usage = "/protocol1530 stance-clear",
		description = "Clears the client-side list of active vocation stance spells.",
		layout = "type:u8=2, spellCount:u8=0",
		evidence = "15.25/15.30 static decoder and ProtocolGame::sendVocationSpecificActiveSpells",
		confidence = "static/repo",
		build = function(msg)
			msg:addByte(2)
			msg:addByte(0)
		end,
	},
	["1530-stance-spell"] = {
		opcode = 0xC1,
		usage = "/protocol1530 stance-spell [spellId]",
		description = "Displays one active vocation stance spell; the default is Harmony (274).",
		layout = "type:u8=2, spellCount:u8=1, spellId:u16",
		evidence = "15.25/15.30 static decoder and ProtocolGame::sendVocationSpecificActiveSpells",
		confidence = "static/repo",
		build = function(msg, args)
			msg:addByte(2)
			msg:addByte(1)
			msg:addU16(readU16(args[2], 274))
		end,
	},
	["1530-icons-clear"] = {
		opcode = 0x8B,
		usage = "/protocol1530 icons-clear",
		description = "Clears primary creature icons on the invoking player.",
		layout = "creatureId:u32, updateType:u8=14, iconCount:u8=0",
		evidence = "15.25/15.30 static decoder and ProtocolGame::sendCreatureIcon",
		confidence = "static/repo",
		build = function(msg, _, player)
			msg:addU32(player:getId())
			msg:addByte(0x0E)
			msg:addByte(0)
		end,
	},
	["1530-icons-tasks"] = {
		opcode = 0x8B,
		usage = "/protocol1530 icons-tasks",
		description = "Displays the Weekly Task and Bounty Task creature icons on the invoking player.",
		layout = "creatureId:u32, updateType:u8=14, count:u8=2, entries{icon:u8,category:u8,count:u16,reserved:u8}",
		evidence = "15.25/15.30 static decoder; icon ids 8 and 9 in category 1",
		confidence = "static",
		build = function(msg, _, player)
			msg:addU32(player:getId())
			msg:addByte(0x0E)
			msg:addByte(2)
			addCreatureIconEntry(msg, 8, 1, 0) -- Weekly Task Monster
			addCreatureIconEntry(msg, 9, 1, 0) -- Bounty Task Monster
		end,
	},
	["1530-icons-secondary-clear"] = {
		opcode = 0x8B,
		usage = "/protocol1530 icons-secondary-clear confirm",
		description = "Clears the second 0x8B icon list; its entries remain semantically unknown.",
		layout = "creatureId:u32, updateType:u8=15, valueCount:u8=0",
		evidence = "15.25/15.30 static decoder; empty list only",
		confidence = "static/unknown-semantics",
		requiresConfirmation = true,
		build = function(msg, _, player)
			msg:addU32(player:getId())
			msg:addByte(0x0F)
			msg:addByte(0)
		end,
	},
	["1530-gameevent-level"] = {
		opcode = 0x75,
		usage = "/protocol1530 gameevent-level [level]",
		description = "Emits a level-up GameEvent using the player's current level by default.",
		layout = "eventType:u8=4, level:u16",
		evidence = "15.25/15.30 static decoder and ProtocolGame::sendTakeScreenshot",
		confidence = "static/repo",
		build = function(msg, args, player)
			msg:addByte(0x04)
			msg:addU16(readU16(args[2], math.min(player:getLevel(), 0xFFFF)))
		end,
	},
	["1530-gameevent-bounty"] = {
		opcode = 0x75,
		usage = "/protocol1530 gameevent-bounty [raceId]",
		description = "Emits the Bounty Task finished GameEvent; Cyclops (22) is the default race.",
		layout = "eventType:u8=11, raceId:u16",
		evidence = "15.25/15.30 static client decoder",
		confidence = "static",
		build = function(msg, args)
			msg:addByte(0x0B)
			msg:addU16(readU16(args[2], 22))
		end,
	},
	["1530-gameevent-weekly"] = {
		opcode = 0x75,
		usage = "/protocol1530 gameevent-weekly [raceId]",
		description = "Emits the Weekly Task finished GameEvent; Cyclops (22) is the default race.",
		layout = "eventType:u8=12, raceId:u16",
		evidence = "15.25/15.30 static client decoder",
		confidence = "static",
		build = function(msg, args)
			msg:addByte(0x0C)
			msg:addU16(readU16(args[2], 22))
		end,
	},
	["1530-gameevent-spell"] = {
		opcode = 0x75,
		usage = "/protocol1530 gameevent-spell [spellId]",
		description = "Emits the new spell GameEvent; Harmony (274) is the default spell.",
		layout = "eventType:u8=13, spellId:u32",
		evidence = "15.25/15.30 static client decoder",
		confidence = "static",
		build = function(msg, args)
			msg:addByte(0x0D)
			msg:addU32(readU32(args[2], 274))
		end,
	},
	["1530-proficiency-empty"] = {
		opcode = 0xC4,
		usage = "/protocol1530 proficiency-empty [weaponId] [experience]",
		description = "Opens an empty proficiency state for the equipped or supplied weapon and includes the mandatory shaped-perk count.",
		layout = "weaponId:u16, experience:u32, selectedCount:u8=0, shapedCount:u8=0",
		evidence = "15.30 static decoder and ProtocolGame::sendWeaponProficiencyWindow",
		confidence = "static/repo",
		validate = validateWeaponProbe,
		build = function(msg, args, player)
			local weaponId = resolveWeaponId(args[2], player)
			msg:addU16(weaponId)
			msg:addU32(readU32(args[3], 0))
			msg:addByte(0)
			msg:addByte(0)
		end,
	},
	["1530-reshape-empty"] = {
		opcode = 0xBB,
		usage = "/protocol1530 reshape-empty [weaponId] [level] [index] confirm",
		description = "Sends an empty proficiency reshape offer list for a real equipped or supplied weapon.",
		layout = "weaponId:u16, level:u8, index:u8, offerCount:u8=0",
		evidence = "15.30 static decoder and ProtocolGame::sendWeaponProficiencyReshapeOffers",
		confidence = "static/repo",
		requiresConfirmation = true,
		validate = validateWeaponProbe,
		build = function(msg, args, player)
			local weaponId = resolveWeaponId(args[2], player)
			msg:addU16(weaponId)
			msg:addByte(readByte(args[3], 0))
			msg:addByte(readByte(args[4], 0))
			msg:addByte(0)
		end,
	},
	["1530-taskboard-bounty"] = {
		opcode = 0x5B,
		usage = "/protocol1530 taskboard-bounty [raceId] confirm",
		description = "Opens a one-entry Bounty Task window using a known 15.23+ reference layout.",
		layout = "view:u8=0, tasks:u8+records, rerolls:u8, rerollState:u8, difficulty:u8, talismans[4], preferenceSlots",
		evidence = "private 15.23 Task Board writer plus the current 15.25/15.30 empty-window shim",
		confidence = "reference-needs-15.30-wire",
		requiresConfirmation = true,
		build = function(msg, args)
			local raceId = readU16(args[2], 22)
			msg:addByte(0x00)
			msg:addByte(1)
			msg:addByte(0) -- task index
			msg:addU16(raceId)
			msg:addU16(100) -- required kills
			msg:addU32(1000) -- experience reward
			msg:addByte(3) -- bounty points
			msg:addU16(25) -- current kills
			msg:addByte(1) -- selected
			msg:addByte(0) -- normal task
			msg:addByte(1) -- daily rerolls
			msg:addByte(0) -- reroll available
			msg:addByte(0) -- beginner difficulty
			for _ = 1, 4 do
				addTaskboardTalismanLine(msg, 0, false, 100)
			end
			msg:addByte(1)
			msg:addByte(1) -- preference slot unlocked
			msg:addU16(raceId)
			msg:addU16(0)
		end,
	},
	["1530-taskboard-weekly"] = {
		opcode = 0x5B,
		usage = "/protocol1530 taskboard-weekly [raceId] [itemId] [nextReset] confirm",
		description = "Opens a non-empty Weekly Task window including the post-15.21 Soulseals reward tail.",
		layout = "view:u8=1, anyCreature:u16+u16, killRecords, itemRecords, rewards, reset:u32, thirdSlot:bool, taskPoints:u32, soulseals:u32",
		evidence = "private 15.23 Task Board writer plus the current 15.25/15.30 empty-window shim",
		confidence = "reference-needs-15.30-wire",
		requiresConfirmation = true,
		build = function(msg, args)
			local raceId = readU16(args[2], 22)
			local itemId = readU32(args[3], 5888)
			local nextReset = readU32(args[4], os.time() + (7 * 24 * 60 * 60))
			msg:addByte(0x01)
			msg:addU16(100)
			msg:addU16(25)
			msg:addByte(1)
			msg:addU16(raceId)
			msg:addU16(10)
			msg:addU16(2)
			msg:addByte(1)
			msg:addByte(0) -- item task index
			msg:addU32(itemId)
			msg:addU32(2)
			msg:addU32(0)
			msg:addByte(0)
			msg:addByte(0) -- beginner difficulty
			msg:addU32(1000)
			msg:addU32(500)
			msg:addByte(0)
			msg:addByte(0)
			msg:addByte(0) -- difficulty selection unavailable
			msg:addByte(0) -- suggested difficulty
			msg:addU32(nextReset)
			msg:addByte(0) -- third slot locked
			msg:addU32(10) -- task hunting points
			msg:addU32(1) -- Soulseals reward tail
		end,
	},
	["1530-boss-difficulty"] = {
		opcode = 0x2F,
		usage = "/protocol1530 boss-difficulty [bossRaceId] confirm",
		description = "Opens a synthetic difficulty selection for Morshabaal (2118 by default).",
		layout = "action:u8=0, bossRaceId:u32, enabled:bool, fourDifficultyFields:u16, badLuck:u32, bossName:string, labels[4], selected:u16, cons[], pros[]",
		evidence = "15.25/15.30 static client decoder; no live 15.30 S2C capture",
		confidence = "static-needs-wire",
		requiresConfirmation = true,
		build = function(msg, args)
			msg:addByte(0)
			msg:addU32(readU32(args[2], 2118))
			msg:addByte(1)
			msg:addU16(0) -- selected difficulty
			msg:addU16(0) -- lowest difficulty
			msg:addU16(0) -- group highest
			msg:addU16(0) -- personal highest
			msg:addU32(0) -- bad-luck bonus scaled by 1000
			msg:addString("Morshabaal")
			msg:addString("I")
			msg:addString("II")
			msg:addString("III")
			msg:addString("IV")
			msg:addU16(0) -- selected difficulty update
			msg:addByte(0) -- cons
			msg:addByte(0) -- pros
		end,
	},
	["1530-boss-close"] = {
		opcode = 0x2F,
		usage = "/protocol1530 boss-close confirm",
		description = "Sends the no-payload action 1 of the boss-difficulty packet family.",
		layout = "action:u8=1",
		evidence = "15.25/15.30 static client decoder; no live 15.30 S2C capture",
		confidence = "static-needs-wire",
		requiresConfirmation = true,
		build = function(msg)
			msg:addByte(1)
		end,
	},
	["1530-bestiary-empty"] = {
		opcode = 0xD6,
		usage = "/protocol1530 bestiary-empty",
		description = "Sends an empty bestiary search result followed by zero Animus points.",
		layout = "search:string='', raceCount:u16=0, animusPoints:u16=0",
		evidence = "15.25/15.30 static decoder and the current bestiary packet family",
		confidence = "static",
		build = function(msg)
			msg:addString("")
			msg:addU16(0)
			msg:addU16(0)
		end,
	},
	["1530-map-marker"] = {
		opcode = 0xDD,
		usage = "/protocol1530 map-marker [description]",
		description = "Adds a minimap marker at the invoking player's current position.",
		layout = "type:u8=0, position:u16+u16+u8, markerType:u8=0, description:string",
		evidence = "ProtocolGame::sendAddMarker and the 15.25/15.30 static decoder",
		confidence = "repo/static",
		build = function(msg, args, player)
			msg:addByte(0)
			msg:addPosition(player:getPosition())
			msg:addByte(0)
			msg:addString(readRemainingText(args, 2, "Protocol QA 15.30"))
		end,
	},
}

for probeName, probe in pairs(probes) do
	if probeName:sub(1, 5) == "1530-" then
		probe.minClientVersion = 1530
		probe.maxClientVersion = 1530
		probe.boundaryMarker = true
	end
end

local aliases = {
	["0x1e"] = "pingback",
	["1e"] = "pingback",
	ping = "pingback",
	["0x7f"] = "close-trade",
	["7f"] = "close-trade",
	trade = "close-trade",
	["0xa3"] = "update-target",
	a3 = "update-target",
	target = "update-target",
	["0xa7"] = "set-tactics",
	a7 = "set-tactics",
	tactics = "set-tactics",
	["0xb2"] = "own-channel",
	b2 = "own-channel",
	channel = "own-channel",
	["0xec"] = "close-imbuing",
	ec = "close-imbuing",
	imbuing = "close-imbuing",
}

local function normalizeLocalProbe(name, spec)
	if type(spec) ~= "table" or spec == JSON_NULL then
		return name, { error = "probe must be a JSON object" }
	end

	local probeName = spec.name or name
	if type(probeName) ~= "string" or trim(probeName) == "" then
		return name or "invalid-probe", { error = "probe name must be a non-empty string" }
	end
	probeName = trim(probeName)

	if spec.raw ~= nil and spec.raw ~= JSON_NULL then
		return probeName, {
			rawHex = spec.raw,
			description = spec.description,
		}
	end

	local opcode = parseInteger(spec.opcode)
	if not opcode or opcode < 0 or opcode > 0xFF then
		return probeName, { error = "invalid opcode '" .. tostring(spec.opcode) .. "'" }
	end

	local fields = {}
	local sourceFields = spec.fields or {}
	if sourceFields == JSON_NULL then
		sourceFields = {}
	end
	if type(sourceFields) ~= "table" then
		return probeName, { error = "fields must be a JSON array" }
	end

	for index, field in ipairs(sourceFields) do
		if type(field) ~= "table" or field == JSON_NULL then
			return probeName, { error = string.format("field %d must be a JSON object", index) }
		end

		local fieldType = field.type
		if type(fieldType) ~= "string" or trim(fieldType) == "" then
			return probeName, { error = string.format("field %d is missing type", index) }
		end

		local argumentIndex
		if field.arg ~= nil and field.arg ~= JSON_NULL then
			local parsedArgument, error = requireInteger(field.arg, 1, 64)
			if not parsedArgument then
				return probeName, { error = string.format("field %d has invalid arg: %s", index, error) }
			end
			argumentIndex = parsedArgument
		end

		fields[#fields + 1] = {
			type = trim(fieldType),
			value = field.value,
			arg = argumentIndex,
			name = field.name,
		}
	end

	return probeName, {
		opcode = opcode,
		fields = fields,
		description = spec.description,
	}
end

local function loadLocalProbes()
	local content = readFile(LOCAL_PROBE_FILE)
	if not content then
		return {}
	end

	local document, error = decodeJson(content)
	if error then
		return {
			["json-error"] = {
				error = error,
			},
		}, error
	end
	if type(document) ~= "table" or document == JSON_NULL then
		return {
			["json-error"] = {
				error = "root must be a JSON object",
			},
		}, "root must be a JSON object"
	end

	local source = document.probes or document
	if type(source) ~= "table" or source == JSON_NULL then
		return {
			["json-error"] = {
				error = "probes must be a JSON object or array",
			},
		}, "probes must be a JSON object or array"
	end

	local loaded = {}
	if source[1] ~= nil then
		for index, spec in ipairs(source) do
			local probeName, probe = normalizeLocalProbe("probe-" .. index, spec)
			loaded[probeName] = probe
		end
	else
		for probeName, spec in pairs(source) do
			if type(probeName) == "string" and probeName:sub(1, 1) ~= "_" then
				local normalizedName, probe = normalizeLocalProbe(probeName, spec)
				loaded[normalizedName] = probe
			end
		end
	end

	return loaded
end

local function buildLocalProbe(localProbe, values)
	if localProbe.error then
		return nil, localProbe.error
	end

	local msg = NetworkMessage()
	if localProbe.rawHex then
		local ok, error = addHexBytes(msg, localProbe.rawHex)
		if not ok then
			return nil, error
		end
		return msg
	end

	msg:addByte(localProbe.opcode)
	for index, field in ipairs(localProbe.fields) do
		local value = field.value
		if field.arg and values[field.arg] ~= nil then
			value = values[field.arg]
		end

		local ok, error = addTypedValue(msg, field.type, value)
		if not ok then
			return nil, string.format("field %d%s failed: %s", index, field.name and " (" .. field.name .. ")" or "", error)
		end
	end
	return msg
end

local function sortedKeys(tableValue, prefix)
	local keys = {}
	for key in pairs(tableValue) do
		if not prefix or key:sub(1, #prefix) == prefix then
			keys[#keys + 1] = key
		end
	end
	table.sort(keys)
	return keys
end

local function is1530Command(words)
	local command = tostring(words or ""):match("^%s*(%S+)")
	return string.lower(command or "") == "/protocol1530"
end

local function resolveBuiltInProbeName(name, suite1530)
	name = string.lower(name or "")
	if suite1530 and name:sub(1, 5) ~= "1530-" then
		return "1530-" .. name
	end
	return aliases[name] or name
end

local function hasExplicitConfirmation(args)
	return #args > 1 and string.lower(args[#args]) == "confirm"
end

local function sendUsage(player, suite1530)
	if suite1530 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /protocol1530 <case> [values] [confirm] | /protocol1530 list | /protocol1530 info <case>")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A boundary message is queued after each packet. Candidate/reference probes require the literal final argument 'confirm'.")
		return
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: /protocolprobe <name> [values] | /protocolprobe list | /protocolprobe info <name>")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Local probes are read from " .. LOCAL_PROBE_FILE .. " on every command.")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'JSON example: {"probes":{"test":{"opcode":"0xA7","fields":[{"type":"u8","value":0}]}}}')
end

local function sendProbeList(player, prefix)
	local names = sortedKeys(probes, prefix)
	if prefix then
		for index, name in ipairs(names) do
			names[index] = name:sub(#prefix + 1)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "15.30 probes: " .. table.concat(names, ", "))
		return
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Built-in probes: " .. table.concat(names, ", "))

	local localProbes, error = loadLocalProbes()
	if error then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Local probe file failed: " .. error)
		return
	end

	local names = sortedKeys(localProbes)
	if #names == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No local probes found. See " .. EXAMPLE_PROBE_FILE)
		return
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Local probes: " .. table.concat(names, ", "))
end

local function sendProbeInfo(player, probeName)
	local probe = probes[probeName]
	if not probe then
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Probe '%s': opcode=0x%02X, confidence=%s", probeName, probe.opcode, probe.confidence or "unspecified"))
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: " .. probe.usage)
	if probe.description then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Purpose: " .. probe.description)
	end
	if probe.layout then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Payload: " .. probe.layout)
	end
	if probe.evidence then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Evidence: " .. probe.evidence)
	end
	return true
end

local function sendBuiltInProbe(player, probeName, args)
	local probe = probes[probeName]
	if not probe then
		return false
	end

	if probe.minClientVersion then
		local client = player:getClient()
		local clientVersion = client and tonumber(client.version) or 0
		if clientVersion < probe.minClientVersion or clientVersion > probe.maxClientVersion then
			player:sendCancelMessage(string.format("Probe '%s' requires a 15.30 client; connected protocol is %d.", probeName, clientVersion))
			return true
		end
	end

	if probe.requiresConfirmation and not hasExplicitConfirmation(args) then
		player:sendCancelMessage("This probe is not wire-confirmed for 15.30. Inspect it with 'info', then rerun with the final argument 'confirm'.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Usage: " .. probe.usage)
		return true
	end

	if probe.validate then
		local valid, error = probe.validate(args, player)
		if not valid then
			player:sendCancelMessage(string.format("Protocol probe '%s' failed validation: %s", probeName, error or "unknown error"))
			return true
		end
	end

	local msg = NetworkMessage()
	msg:addByte(probe.opcode)
	probe.build(msg, args, player)
	logger.info(string.format("[ProtocolProbe] player='%s' probe='%s' source='built-in' opcode=0x%02X confidence='%s' layout='%s' usage='%s'", player:getName(), probeName, probe.opcode, probe.confidence or "unspecified", probe.layout or "unspecified", probe.usage))
	msg:sendToPlayer(player)
	if probe.boundaryMarker then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[ProtocolProbe] boundary OK after '%s'. Move, say something, and open a container before the next probe.", probeName:sub(6)))
	end
	return true
end

local function sendLocalProbe(player, probeName, values)
	local localProbes, loadError = loadLocalProbes()
	if loadError then
		player:sendCancelMessage("Local protocol probe file failed: " .. loadError)
		return true
	end

	local localProbe = localProbes[probeName]
	if not localProbe then
		return false
	end

	local msg, error = buildLocalProbe(localProbe, values or {})
	if not msg then
		player:sendCancelMessage(string.format("Local protocol probe '%s' failed: %s", probeName, error))
		return true
	end

	local opcodeText = localProbe.rawHex and "raw" or string.format("0x%02X", localProbe.opcode)
	logger.info(string.format("[ProtocolProbe] player='%s' probe='%s' source='local' opcode='%s'", player:getName(), probeName, opcodeText))
	msg:sendToPlayer(player)
	return true
end

function protocolProbe.onSay(player, words, param)
	logCommand(player, words, param)

	local suite1530 = is1530Command(words)
	local args = parseArgs(param)
	if #args == 0 or args[1] == "help" then
		sendUsage(player, suite1530)
		return true
	end

	if args[1] == "list" then
		sendProbeList(player, suite1530 and "1530-" or nil)
		return true
	end

	if args[1] == "info" then
		if not args[2] then
			player:sendCancelMessage(suite1530 and "Usage: /protocol1530 info <case>" or "Usage: /protocolprobe info <name>")
			return true
		end
		local infoProbeName = resolveBuiltInProbeName(args[2], suite1530)
		if not sendProbeInfo(player, infoProbeName) then
			player:sendCancelMessage("Unknown built-in protocol probe.")
		end
		return true
	end

	local probeName = string.lower(args[1])
	local forceLocal = probeName == "file" or probeName == "local"
	local localValues
	if forceLocal then
		if not args[2] then
			player:sendCancelMessage("Usage: /protocolprobe file <local-probe-name> [values]")
			return true
		end
		probeName = string.lower(args[2])
		localValues = sliceArgs(args, 3)
	else
		probeName = resolveBuiltInProbeName(probeName, suite1530)
		localValues = sliceArgs(args, 2)
	end

	if not forceLocal and sendBuiltInProbe(player, probeName, args) then
		return true
	end

	if sendLocalProbe(player, probeName, localValues) then
		return true
	end

	player:sendCancelMessage("Unknown protocol probe.")
	sendUsage(player, suite1530)
	return true
end

protocolProbe:separator(" ")
protocolProbe:groupType("god")
protocolProbe:register()
