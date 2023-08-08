local PlayerFlags_t = {
	["CannotUseCombat"] = CannotUseCombat,
	["CannotAttackPlayer"] = CannotAttackPlayer,
	["CannotAttackMonster"] = CannotAttackMonster,
	["CannotBeAttacked"] = CannotBeAttacked,
	["CanConvinceAll"] = CanConvinceAll,
	["CanSummonAll"] = CanSummonAll,
	["CanIllusionAll"] = CanIllusionAll,
	["CanSenseInvisibility"] = CanSenseInvisibility,
	["IgnoredByMonsters"] = IgnoredByMonsters,
	["NotGainInFight"] = NotGainInFight,
	["HasInfiniteMana"] = HasInfiniteMana,
	["HasInfiniteSoul"] = HasInfiniteSoul,
	["HasNoExhaustion"] = HasNoExhaustion,
	["CannotUseSpells"] = CannotUseSpells,
	["CannotPickupItem"] = CannotPickupItem,
	["CanAlwaysLogin"] = CanAlwaysLogin,
	["CanBroadcast"] = CanBroadcast,
	["CanEditHouses"] = CanEditHouses,
	["CannotBeBanned"] = CannotBeBanned,
	["CannotBePushed"] = CannotBePushed,
	["HasInfiniteCapacity"] = HasInfiniteCapacity,
	["CanPushAllCreatures"] = CanPushAllCreatures,
	["CanTalkRedPrivate"] = CanTalkRedPrivate,
	["CanTalkRedChannel"] = CanTalkRedChannel,
	["TalkOrangeHelpChannel"] = TalkOrangeHelpChannel,
	["NotGainExperience"] = NotGainExperience,
	["NotGainMana"] = NotGainMana,
	["NotGainHealth"] = NotGainHealth,
	["NotGainSkill"] = NotGainSkill,
	["SetMaxSpeed"] = SetMaxSpeed,
	["SpecialVIP"] = SpecialVIP,
	["NotGenerateLoot"] = NotGenerateLoot,
	["CanTalkRedChannelAnonymous"] = CanTalkRedChannelAnonymous,
	["IgnoreProtectionZone"] = IgnoreProtectionZone,
	["IgnoreSpellCheck"] = IgnoreSpellCheck,
	["IgnoreWeaponCheck"] = IgnoreWeaponCheck,
	["CannotBeMuted"] = CannotBeMuted,
	["IsAlwaysPremium"] = IsAlwaysPremium,
	["CanMapClickTeleport"] = CanMapClickTeleport,
	["IgnoredByNpcs"] = IgnoredByNpcs,
}

local function notAccountTypeGod(player)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
end

local function sendValidKeys(player)
	local flagsList = {}
	for flagName, _ in pairs(PlayerFlags_t) do
		table.insert(flagsList, flagName)
	end

	local text = "Invalid flag. Valid flags are: ".. table.concat(flagsList, "\n")
	player:showTextDialog(2019, text)
end

local function hasValidParams(player, param, usage)
	if not param or param == "" then
		player:sendCancelMessage("Command param required. Usage: ".. usage)
		return false
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: ".. usage)
		return false
	end

	return true
end

function GetFlagNumberOrName(flagType)
	for flagName, flagEnum in pairs(PlayerFlags_t) do
		if tonumber(flagEnum) == tonumber(flagType) then
			return flagEnum
		end
		if type(flagType) == "string" and string.lower(flagType) == string.lower(flagName) then
			return flagEnum
		end
	end
	return nil
end

function GetFlagNameByType(flagType)
	for flagName, flagEnum in pairs(PlayerFlags_t) do
		if tonumber(flagEnum) == tonumber(flagType) then
			return flagName
		end
	end
	return nil
end

function Player.talkactionHasFlag(self, param, flagType)
	if notAccountTypeGod(self) then
		return true
	end

	if not hasValidParams(self, param, "Usage: /hasflag <playerName>, <flagnumber or name>") then
		return false
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local flag = split[2]:trimSpace()
	local flagValue = GetFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return false
	end

	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return false
	end

	if not targetPlayer:hasGroupFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not have flag type: " .. GetFlagNameByType(flagValue) .. ".")
	else
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " have flag type: " .. GetFlagNameByType(flagValue) .. ".")
	end

	return true
end

function Player.talkactionSetFlag(self, param, flagType)
	if notAccountTypeGod(self) then
		return true
	end

	if not hasValidParams(self, param, "Usage: /setflag <playerName>, <flagnumber or name>") then
		return false
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local flag = split[2]:trimSpace()
	local flagValue = GetFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return false
	end

	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return false
	end

	if targetPlayer:hasFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Player " .. playerName .. " already has flag " .. GetFlagNameByType(flagValue) .. ".")
		return false
	end

	targetPlayer:setGroupFlag(flagValue)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Flag " .. GetFlagNameByType(flagValue)  .. " set for player " .. playerName .. ".")
	Spdlog.info("[Player.talkactionSetFlag] Added flag " .. GetFlagNameByType(flagValue) .. " to ".. targetPlayer:getName().. " character by " .. self:getName() .. ".")
	return true
end

function Player.talkactionRemoveFlag(self, param, flagType)
	if notAccountTypeGod(self) then
		return true
	end

	if not hasValidParams(self, param, "Usage: /removeflag <playerName>, <flagnumber or name>") then
		return false
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local flag = split[2]:trimSpace()
	local flagValue = GetFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return false
	end

	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return false
	end

	if not targetPlayer:hasFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not have flag " .. GetFlagNameByType(flagValue) .. ".")
		return false
	end

	targetPlayer:removeGroupFlag(flagValue)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Flag " .. GetFlagNameByType(flagValue) .. " removed from player " .. playerName .. ".")
	Spdlog.info("[Player.talkactionRemoveFlag] Removed flag " .. GetFlagNameByType(flagValue) .. " from ".. targetPlayer:getName().. " character by " .. self:getName() .. ".")
	return true
end

function Player.reloadTalkaction(self, words, param)
	local reloadTypes = {
		["all"] = RELOAD_TYPE_ALL,

		["chat"] = RELOAD_TYPE_CHAT,
		["channel"] = RELOAD_TYPE_CHAT,
		["chatchannels"] = RELOAD_TYPE_CHAT,

		["config"] = RELOAD_TYPE_CONFIG,
		["configuration"] = RELOAD_TYPE_CONFIG,

		["events"] = RELOAD_TYPE_EVENTS,

		["items"] = RELOAD_TYPE_ITEMS,

		["module"] = RELOAD_TYPE_MODULES,
		["modules"] = RELOAD_TYPE_MODULES,

		["monster"] = RELOAD_TYPE_MONSTERS,
		["monsters"] = RELOAD_TYPE_MONSTERS,

		["mount"] = RELOAD_TYPE_MOUNTS,
		["mounts"] = RELOAD_TYPE_MOUNTS,

		["npc"] = RELOAD_TYPE_NPCS,
		["npcs"] = RELOAD_TYPE_NPCS,

		["raid"] = RELOAD_TYPE_RAIDS,
		["raids"] = RELOAD_TYPE_RAIDS,

		["scripts"] = RELOAD_TYPE_SCRIPTS,

		["rate"] = RELOAD_TYPE_CORE,
		["rates"] = RELOAD_TYPE_CORE,
		["stage"] = RELOAD_TYPE_CORE,
		["stages"] = RELOAD_TYPE_CORE,
		["global"] = RELOAD_TYPE_CORE,
		["core"] = RELOAD_TYPE_CORE,
		["lib"] = RELOAD_TYPE_CORE,
		["libs"] = RELOAD_TYPE_CORE,

		["imbuements"] = RELOAD_TYPE_IMBUEMENTS,

		["talkaction"] = RELOAD_TYPE_TALKACTION,
		["talkactions"] = RELOAD_TYPE_TALKACTION,
		["talk"] = RELOAD_TYPE_TALKACTION,

		["group"] = RELOAD_TYPE_GROUPS,
		["groups"] = RELOAD_TYPE_GROUPS
	}

	if notAccountTypeGod(self) then
		return true
	end

	if not configManager.getBoolean(configKeys.ALLOW_RELOAD) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Reload command is disabled.")
		return true
	end

	if param == "" then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Command param required.")
		return false
	end

	logCommand(self, "/reload", param)

	local reloadType = reloadTypes[param:lower()]
	if reloadType then
		Game.reload(reloadType)
		self:sendTextMessage(MESSAGE_LOOK, string.format("Reloaded %s.", param:lower()))
		Spdlog.info("Reloaded " .. param:lower() .. "")
		return true
	elseif not reloadType then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Reload type not found.")
		Spdlog.warn("[reload.onSay] - Reload type '".. param.. "' not found")
		return false
	end
	return false
end

function Player.setStorageValueTalkaction(self, param)
	-- Sanity check for parameters
	-- Example: /setstorage wheel.abridged, 1, god
	-- Example: /setstorage 10001, 1
	-- If you don't add the player's name, the storage will be added to whoever is using the talkaction (self)
	if not hasValidParams(self, param, "Usage: /setstorage <storagekey or name>, <value>, <player name>=default self") then
		return false
	end

	local split = param:split(",")
	local value = 1
	if split[2] then
		value = split[2]
	end

	-- Try to convert the first parameter to a number. If it's not a number, treat it as a storage name
	local storageKey = tonumber(split[1])
	if storageKey == nil then
		-- The key is a name, so call setStorageValueByName instead of setStorageValue
		if split[3] then
			local targetPlayer = Player(split[3])
			if not targetPlayer then
				self:sendCancelMessage("Player not found.")
				return false
			else
				targetself:setStorageValueByName(split[1], value)
				return false
			end
		else
			self:setStorageValueByName(split[1], value)
		end
	else
		-- The key is a number, so call setStorageValue as before
		if split[3] then
			local targetPlayer = Player(split[3])
			if not targetPlayer then
				self:sendCancelMessage("Player not found.")
				return false
			else
				targetself:setStorageValue(storageKey, value)
				return false
			end
		else
			self:setStorageValue(storageKey, value)
		end
	end
	return false
end

function Player.getStorageValueTalkaction(self, param)
	-- Sanity check for parameters
	-- Example: /getstorage god, wheel.abridged
	-- Example: /getstorage god, 10000
	if not hasValidParams(self, param, "Usage: /getstorage <playername>, <storage key or name>") then
		return false
	end

	local split = param:split(",")
	if split[2] == nil then
		player:sendCancelMessage("Insufficient parameters.")
		return false
	end

	local target = Player(split[1])
	if target == nil then
		self:sendCancelMessage("A player with that name is not online.")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")

	-- Try to convert the second parameter to a number. If it's not a number, treat it as a storage name
	local storageKey = tonumber(split[2])
	if storageKey == nil then
		-- Get the key for this storage name
		local storageName = tostring(split[2])
		local storageValue = self:getStorageValueByName(storageName)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The storage with id: "..storageName.." from player "..split[1].." is: "..storageValue..".")
		return false
	end

	local storageValue = self:getStorageValue(storageKey)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The storage with id: "..storageKey.." from player "..split[1].." is: "..storageValue..".")
	return false
end
