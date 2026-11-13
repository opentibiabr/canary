dofile("tests/lua/test_store_bundles.lua")
local category = dofile("data/modules/scripts/gamestore/catalog/bundles.lua")
local senders = require("gamestore.senders")
local player = Player(10)
assert(require("gamestore.helpers").convertType(GameStore.OfferTypes.OFFER_TYPE_BUNDLE) == GameStore.ConverType.SHOW_NONE)
local packets = {}
function NetworkMessage()
	local msg = { bytes = {} }
	function msg:addByte(n)
		assert(type(n) == "number")
		self.bytes[#self.bytes + 1] = string.char(n)
	end
	function msg:addU16(n)
		self:addByte(n % 256)
		self:addByte(math.floor(n / 256) % 256)
	end
	function msg:addU32(n)
		for _ = 1, 4 do
			self:addByte(n % 256)
			n = math.floor(n / 256)
		end
	end
	function msg:addString(text)
		self:addU16(#text)
		self.bytes[#self.bytes + 1] = text
	end
	function msg:sendToPlayer()
		packets[#packets + 1] = table.concat(self.bytes)
	end
	function msg:delete() end
	return msg
end
function player:getOutfit()
	return { lookHead = 10, lookBody = 20, lookLegs = 30, lookFeet = 40 }
end
function player:canBuyOffer()
	return { disabled = 0 }
end
function player:sendButtonIndication() end
local prefix = os.getenv("CANARY_STORE_BUNDLE_PACKET")
for _, case in ipairs({
	{ "male", 1525, 5, PLAYERSEX_MALE },
	{ "female", 1525, 5, PLAYERSEX_FEMALE },
	{ "otclient", 1525, 11, PLAYERSEX_MALE },
	{ "other-version", 1530, 5, PLAYERSEX_MALE },
}) do
	function player:getClient()
		return { version = case[2], os = case[3] }
	end
	function player:getSex()
		return case[4]
	end
	packets = {}
	senders.sendShowStoreOffers(player:getId(), category)
	assert(#packets == 7, "all descriptions and the complete offer packet must be emitted")
	local packet = packets[#packets]
	assert(packet:byte(1) == GameStore.SendingPackets.S_StoreOffers)
	if prefix then
		local file = assert(io.open(prefix .. "-" .. case[1] .. ".bin", "wb"))
		file:write(packet)
		file:close()
	end
end
for _, offer in ipairs(category.offers) do
	assert(offer.count == 1 and #offer.products == (offer.id == 70011 and 4 or 3))
	assert(offer.products[1].type == GameStore.ConverType.SHOW_OUTFIT)
	assert(offer.products[2].type == GameStore.ConverType.SHOW_MOUNT)
	assert(offer.description:find("colours can be changed using the Outfit dialog", 1, true))
	assert(offer.description:find("{speedboost}", 1, true))
	assert(offer.description:find("{backtoinbox}", 1, true))
	assert(not offer.description:find("\226", 1, true), "description must not contain raw UTF-8 punctuation")
	if offer.id == 70015 then
		assert(offer.description:find("You can save 360 Tibia Coins", 1, true))
		assert(offer.description:find("Full Phoenix Evoker Outfit\n{character}", 1, true))
		assert(offer.description:find("Barebone Grill\n{house}\n{box}\n{storeinbox}\n{useicon} use it to change its appearance\n{backtoinbox}", 1, true))
		assert(offer.description:find("<i>What fades in time may seem lost...", 1, true))
	end
end
print("PASS: component descriptions, savings, native images/names, both sexes, OTClient/version fallback and complete actual offer packets")
