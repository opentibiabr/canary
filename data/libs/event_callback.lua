local valid_methods = {
	"onAreaCombat",
	"onChangeOutfit",
	"onDrainHealth",
	"onHear",
	"onTargetCombat",
	"onDropLoot",
	"onSpawn",
	"onDisband",
	"onJoin",
	"onLeave",
	"onShareExperience",
	"onBrowseField",
	"onChangeZone",
	"onGainExperience",
	"onGainSkillTries",
	"onItemMoved",
	"onInventoryUpdate",
	"onLook",
	"onLookInBattleList",
	"onLookInShop",
	"onLookInTrade",
	"onLoseExperience",
	"onMoveCreature",
	"onMoveItem",
	"onReportBug",
	"onReportRuleViolation",
	"onRequestQuestLine",
	"onRequestQuestLog",
	"onStorageUpdate",
	"onTradeAccept",
	"onTradeRequest",
	"onTurn",
	"onCombat",
	"onRemoveCount",
}

-- Empty table to store callbacks
local callbacks = {} 
-- Counter to generate unique IDs for callback functions
local callback_id = 0

function contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local callback_mt = {
	__index = function(t, k)
		-- If the key name is a valid method, return an anonymous function that calls the real callback 
		if type(k) == "string" and contains(valid_methods, k) then
			-- Get the real callback function from the callbacks table
			local cb_func = rawget(t, k)
			return function(...)
				cb_func(...)
			end
		else
			-- If the key name is not a valid method, return the key as is
			return rawget(t, k)
		end
	end,
	__newindex = function(t, k, v)
		if type(k) == "string" and contains(valid_methods, k) then
			-- Store the callback function name in the callbacks table
			callbacks[k] = k
			-- Store the callback function in the callbacks table with the key name
			rawset(t, k, v)
		else
			Spdlog.error("[EventCallback] registered an invalid method: " .. k)
		end
	end
}

EventCallback = setmetatable({}, callback_mt)
