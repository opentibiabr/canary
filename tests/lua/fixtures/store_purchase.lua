-- Engine interfaces for isolated tests; Store parser, senders and purchases remain real.
package.path = "data/libs/?.lua;" .. package.path
GameStore = require("gamestore.constants")
package.loaded["gamestore.taskboard"] = {}
for key, value in pairs(require("gamestore.purchases")) do
	GameStore[key] = value
end
require("gamestore.parsers")
MESSAGE_EVENT_ADVANCE = 1
function table.contains(values, expected)
	for _, value in pairs(values) do
		if value == expected then
			return true
		end
	end
	return false
end
local values = {}
local kv = {}
function kv:scoped()
	return self
end
function kv:get(key)
	return values[key]
end
function kv:set(key, value)
	values[key] = value
end
local player = { id = 10, guid = 99, world = 1, coins = 1000, charges = 0 }
function player:getId()
	return self.id
end
function player:getGuid()
	return self.guid
end
function player:getWorldId()
	return self.world
end
function player:getClient()
	return { version = 1525, os = 5 }
end
function player:getPosition()
	return { x = 100, y = 100, z = 7 }
end
function player:getVocation()
	return {
		getId = function()
			return 4
		end,
	}
end
function player:kv()
	return kv
end
function player:canPayForOffer(price)
	return self.coins >= price
end
function player:makeCoinTransaction(offer)
	self.coins = self.coins - offer.price
	self.charges = self.charges + 1
	return true
end
function player:getTibiaCoins()
	return self.coins
end
function player:getTransferableCoins()
	return 0
end
function player:sendTextMessage() end
function player:updateUIExhausted() end
function player:showInfoModal()
	error("unexpected modal")
end
Player = function(id)
	if id == player.id then
		return player
	end
end
logger = { warn = function() end, error = function() end }
function addEvent() end
function addPlayerEvent() end
function NetworkMessage()
	local msg = { bytes = {} }
	function msg:addByte(value)
		self.bytes[#self.bytes + 1] = string.char(value)
	end
	function msg:addU16(value)
		self:addByte(value % 256)
		self:addByte(math.floor(value / 256) % 256)
	end
	function msg:addU32(value)
		for _ = 1, 4 do
			self:addByte(value % 256)
			value = math.floor(value / 256)
		end
	end
	function msg:addString(value)
		self:addU16(#value)
		self.bytes[#self.bytes + 1] = value
	end
	function msg:sendToPlayer() end
	return msg
end
return player
