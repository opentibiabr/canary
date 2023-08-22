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

local function sendValidKeys(player)
	local flagsList = {}
	for flagName, _ in pairs(PlayerFlags_t) do
		table.insert(flagsList, flagName)
	end

	local text = "Invalid flag. Valid flags are: " .. table.concat(flagsList, "\n")
	player:showTextDialog(2019, text)
end

local function getFlagNumberOrName(flagType)
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

local function getFlagNameByType(flagType)
	for flagName, flagEnum in pairs(PlayerFlags_t) do
		if tonumber(flagEnum) == tonumber(flagType) then
			return flagName
		end
	end
	return nil
end

function Player.talkactionHasFlag(self, param, flagType)
	if not HasValidTalkActionParams(self, param, "Usage: /hasflag <playerName>, <flagnumber or name>") then
		return true
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return true
	end

	local flag = split[2]:trimSpace()
	local flagValue = getFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return true
	end

	if not targetPlayer:hasGroupFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not have flag type: " .. getFlagNameByType(flagValue) .. ".")
	else
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " have flag type: " .. getFlagNameByType(flagValue) .. ".")
	end

	return true
end

function Player.talkactionSetFlag(self, param, flagType)
	if not HasValidTalkActionParams(self, param, "Usage: /setflag <playerName>, <flagnumber or name>") then
		return true
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return true
	end

	local flag = split[2]:trimSpace()
	local flagValue = getFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return true
	end

	if targetPlayer:hasFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " already has flag " .. getFlagNameByType(flagValue) .. ".")
		return true
	end

	targetPlayer:setGroupFlag(flagValue)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Flag " .. getFlagNameByType(flagValue) .. " set for player " .. playerName .. ".")
	logger.info("[Player.talkactionSetFlag] Added flag {} to {} character by {}.", getFlagNameByType(flagValue), targetPlayer:getName(), self:getName())
	return true
end

function Player.talkactionRemoveFlag(self, param, flagType)
	if not HasValidTalkActionParams(self, param, "Usage: /removeflag <playerName>, <flagnumber or name>") then
		return true
	end

	local split = param:split(",")
	local playerName = split[1]:trimSpace()
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		self:sendCancelMessage("Player " .. playerName .. " not found.")
		return true
	end

	local flag = split[2]:trimSpace()
	local flagValue = getFlagNumberOrName(flag)
	if not flagValue then
		sendValidKeys(self)
		return true
	end

	if not targetPlayer:hasFlag(flagValue) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. playerName .. " not have flag " .. getFlagNameByType(flagValue) .. ".")
		return true
	end

	targetPlayer:removeGroupFlag(flagValue)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Flag " .. getFlagNameByType(flagValue) .. " removed from player " .. playerName .. ".")
	logger.info("[Player.talkactionRemoveFlag] Removed flag {} to {} character by {}.", getFlagNameByType(flagValue), targetPlayer:getName(), self:getName())
	return true
end

---------------- // ----------------
local hasFlag = TalkAction("/hasflag")

function hasFlag.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	return player:talkactionHasFlag(param)
end

hasFlag:separator(" ")
hasFlag:groupType("god")
hasFlag:register()

---------------- // ----------------
local setFlag = TalkAction("/setflag")

function setFlag.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	return player:talkactionSetFlag(param)
end

setFlag:separator(" ")
setFlag:groupType("god")
setFlag:register()

---------------- // ----------------
local removeFlag = TalkAction("/removeflag")

function removeFlag.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	return player:talkactionRemoveFlag(param)
end

removeFlag:separator(" ")
removeFlag:groupType("god")
removeFlag:register()
