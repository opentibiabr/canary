function Player.setStorageValueTalkaction(self, param)
	-- Sanity check for parameters
	-- Example: /setstorage wheel.scroll.abridged, 1, god
	-- Example: /setstorage 10001, 1
	-- If you don't add the player's name, the storage will be added to whoever is using the talkaction (self)
	if not HasValidTalkActionParams(self, param, "Usage: /setstorage <storagekey or name>, <value>, <player name>=default self") then
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
		storageKey = split[1]
		-- The key is a name, so call setStorageValueByName instead of setStorageValue
		if split[3] then
			local targetPlayer = Player(string.trim(split[3]))
			if not targetPlayer then
				self:sendCancelMessage("Player not found.")
				return false
			else
				local message = "Set storage: "..storageKey.." to player "..split[3].." newValue: "..value.."."
				self:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
				targetPlayer:setStorageValueByName(storageKey, value)
				targetPlayer:save()
				return false
			end
		else
			local message = "Set storage: "..storageKey.." to player "..self:getName()..", newValue: "..value.."."
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			self:setStorageValueByName(split[1], value)
			self:save()
		end
	else
		-- The key is a number, so call setStorageValue as before
		if split[3] then
			local targetPlayer = Player(string.trim(split[3]))
			if not targetPlayer then
				self:sendCancelMessage("Player not found.")
				return false
			else
				local message = "Set storage: "..storageKey.." to player "..split[3].." newValue: "..value.."."
				self:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
				targetPlayer:setStorageValue(storageKey, value)
				targetPlayer:save()
				return false
			end
		else
			local message = "Set storage: "..storageKey.." to player "..self:getName()..", newValue: "..value.."."
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			self:setStorageValue(storageKey, value)
			self:save()
		end
	end
	return false
end

local talkaction = TalkAction("/setstorage")

function talkaction.onSay(player, words, param)
	return player:setStorageValueTalkaction(param)
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()
