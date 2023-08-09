function Player.getStorageValueTalkaction(self, param)
	-- Sanity check for parameters
	-- Example: /getstorage god, wheel.scroll.abridged
	-- Example: /getstorage god, 10000
	if not HasValidTalkActionParams(self, param, "Usage: /getstorage <playername>, <storage key or name>") then
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

local storageGet = TalkAction("/getstorage")

function storageGet.onSay(player, words, param)
	return player:getStorageValueTalkaction(param)
end

storageGet:separator(" ")
storageGet:groupType("gamemaster")
storageGet:register()
