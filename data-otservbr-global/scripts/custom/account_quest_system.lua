local CONFIG_PATH = "data-otservbr-global/account_quests.lua"

local function loadAccountQuestConfig()
	local ok, loaded = pcall(dofile, CONFIG_PATH)
	if not ok then
		logger.error("[AccountQuest] Failed to load {}: {}", CONFIG_PATH, loaded)
		return {
			enabled = false,
			shareAccess = false,
			defaultRewardMode = "oncePerAccount",
			allowSelfReset = false,
			quests = {},
		}
	end

	if type(loaded) ~= "table" then
		logger.error("[AccountQuest] {} must return a table.", CONFIG_PATH)
		return {
			enabled = false,
			shareAccess = false,
			defaultRewardMode = "oncePerAccount",
			allowSelfReset = false,
			quests = {},
		}
	end

	loaded.quests = loaded.quests or {}
	loaded.defaultRewardMode = loaded.defaultRewardMode or "oncePerAccount"
	return loaded
end

AccountQuest = AccountQuest or {}
AccountQuest.config = loadAccountQuestConfig()

local REWARD_ONCE_PER_ACCOUNT = "oncePerAccount"
local REWARD_ONCE_PER_CHARACTER = "oncePerCharacter"

local function normalizeQuestId(questId)
	if type(questId) ~= "string" then
		return nil
	end

	questId = questId:lower():gsub("^%s+", ""):gsub("%s+$", "")
	if questId == "" or not questId:match("^[%w_%-%.]+$") then
		return nil
	end

	return questId
end

local function getQuestDefinition(questId)
	questId = normalizeQuestId(questId)
	if not questId then
		return nil, nil
	end

	return AccountQuest.config.quests[questId], questId
end

local function getRewardMode(definition)
	local mode = definition and definition.rewardMode or AccountQuest.config.defaultRewardMode
	if mode ~= REWARD_ONCE_PER_ACCOUNT and mode ~= REWARD_ONCE_PER_CHARACTER then
		return REWARD_ONCE_PER_ACCOUNT
	end
	return mode
end

local function getPlayerAccountId(player)
	local accountId = player:getAccountId()
	if not accountId or accountId <= 0 then
		return nil
	end
	return accountId
end

local function rewardPlayerId(player, mode)
	if mode == REWARD_ONCE_PER_CHARACTER then
		return player:getGuid()
	end
	return 0
end

function AccountQuest.isEnabled()
	return AccountQuest.config.enabled == true
end

function AccountQuest.reload()
	AccountQuest.config = loadAccountQuestConfig()
	return true
end

function AccountQuest.hasAccess(player, questId)
	if not AccountQuest.isEnabled() or AccountQuest.config.shareAccess ~= true then
		return false
	end

	local _, normalizedId = getQuestDefinition(questId)
	local accountId = getPlayerAccountId(player)
	if not normalizedId or not accountId then
		return false
	end

	local query = db.storeQuery(string.format("SELECT 1 FROM `account_quest_access` WHERE `account_id` = %d AND `quest_id` = %s LIMIT 1", accountId, db.escapeString(normalizedId)))

	if not query then
		return false
	end

	result.free(query)
	return true
end

function AccountQuest.unlockAccess(player, questId)
	if not AccountQuest.isEnabled() or AccountQuest.config.shareAccess ~= true then
		return false
	end

	local _, normalizedId = getQuestDefinition(questId)
	local accountId = getPlayerAccountId(player)
	if not normalizedId or not accountId then
		return false
	end

	return db.query(string.format("INSERT IGNORE INTO `account_quest_access` (`account_id`, `quest_id`, `unlocked_by`) VALUES (%d, %s, %d)", accountId, db.escapeString(normalizedId), player:getGuid()))
end

function AccountQuest.canClaimReward(player, questId)
	if not AccountQuest.isEnabled() then
		return true
	end

	local definition, normalizedId = getQuestDefinition(questId)
	local accountId = getPlayerAccountId(player)
	if not normalizedId or not accountId then
		return false
	end

	local mode = getRewardMode(definition)
	local playerId = rewardPlayerId(player, mode)
	local query = db.storeQuery(string.format("SELECT 1 FROM `account_quest_rewards` WHERE `account_id` = %d AND `quest_id` = %s AND `reward_mode` = %s AND `player_id` = %d LIMIT 1", accountId, db.escapeString(normalizedId), db.escapeString(mode), playerId))

	if not query then
		return true
	end

	result.free(query)
	return false
end

function AccountQuest.claimReward(player, questId)
	if not AccountQuest.isEnabled() then
		return true
	end

	local definition, normalizedId = getQuestDefinition(questId)
	local accountId = getPlayerAccountId(player)
	if not normalizedId or not accountId then
		return false
	end

	local mode = getRewardMode(definition)
	local playerId = rewardPlayerId(player, mode)

	if not AccountQuest.canClaimReward(player, normalizedId) then
		return false
	end

	return db.query(string.format("INSERT IGNORE INTO `account_quest_rewards` (`account_id`, `player_id`, `quest_id`, `reward_mode`, `claimed_by`) VALUES (%d, %d, %s, %s, %d)", accountId, playerId, db.escapeString(normalizedId), db.escapeString(mode), player:getGuid()))
end

function AccountQuest.resetCharacterProgress(player, questId)
	local definition, normalizedId = getQuestDefinition(questId)
	if not definition or not normalizedId then
		return false, "Quest is not registered."
	end

	local storages = definition.progressStorages
	if type(storages) ~= "table" or #storages == 0 then
		return false, "Quest has no progressStorages configured."
	end

	for _, storage in ipairs(storages) do
		if type(storage) ~= "number" or storage < 0 then
			return false, "Quest contains an invalid progress storage key."
		end
	end

	for _, storage in ipairs(storages) do
		player:setStorageValue(storage, -1)
	end

	return true, string.format("Quest '%s' progress was reset for this character. Account access and reward history were preserved.", normalizedId)
end

function Player.hasAccountQuestAccess(self, questId)
	return AccountQuest.hasAccess(self, questId)
end

function Player.unlockAccountQuestAccess(self, questId)
	return AccountQuest.unlockAccess(self, questId)
end

function Player.canClaimAccountQuestReward(self, questId)
	return AccountQuest.canClaimReward(self, questId)
end

function Player.claimAccountQuestReward(self, questId)
	return AccountQuest.claimReward(self, questId)
end

function Player.resetAccountQuestProgress(self, questId)
	return AccountQuest.resetCharacterProgress(self, questId)
end

local startup = GlobalEvent("AccountQuestStartup")

function startup.onStartup()
	db.query([[
        CREATE TABLE IF NOT EXISTS `account_quest_access` (
            `account_id` INT(11) UNSIGNED NOT NULL,
            `quest_id` VARCHAR(128) NOT NULL,
            `unlocked_by` INT(11) NOT NULL DEFAULT 0,
            `unlocked_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`account_id`, `quest_id`),
            CONSTRAINT `account_quest_access_account_fk`
                FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

	db.query([[
        CREATE TABLE IF NOT EXISTS `account_quest_rewards` (
            `account_id` INT(11) UNSIGNED NOT NULL,
            `player_id` INT(11) NOT NULL DEFAULT 0,
            `quest_id` VARCHAR(128) NOT NULL,
            `reward_mode` VARCHAR(32) NOT NULL,
            `claimed_by` INT(11) NOT NULL DEFAULT 0,
            `claimed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`account_id`, `quest_id`, `reward_mode`, `player_id`),
            CONSTRAINT `account_quest_rewards_account_fk`
                FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

	if AccountQuest.isEnabled() then
		logger.info("[AccountQuest] Account-wide quest system enabled with {} registered quests.", #AccountQuest.config.quests)
	else
		logger.info("[AccountQuest] Account-wide quest system disabled.")
	end

	return true
end

startup:register()

local questReset = TalkAction("/questreset")

function questReset.onSay(player, words, param)
	local separator = param:find(",", 1, true)
	if not separator then
		player:sendCancelMessage("Usage: /questreset Player Name, quest-id")
		return true
	end

	local playerName = param:sub(1, separator - 1):gsub("^%s+", ""):gsub("%s+$", "")
	local questId = param:sub(separator + 1):gsub("^%s+", ""):gsub("%s+$", "")
	local target = Player(playerName)
	if not target then
		player:sendCancelMessage("The target player must be online.")
		return true
	end

	local ok, message = AccountQuest.resetCharacterProgress(target, questId)
	if not ok then
		player:sendCancelMessage(message)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	if target ~= player then
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	end
	return true
end

questReset:separator(" ")
questReset:groupType("god")
questReset:register()

local selfReset = TalkAction("!questreset")

function selfReset.onSay(player, words, param)
	if AccountQuest.config.allowSelfReset ~= true then
		player:sendCancelMessage("Self-service quest reset is disabled.")
		return true
	end

	local ok, message = AccountQuest.resetCharacterProgress(player, param)
	if not ok then
		player:sendCancelMessage(message)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	return true
end

selfReset:separator(" ")
selfReset:register()
