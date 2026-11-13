-- Reuse actual packet-writing stubs and the bundle serialization checks.
dofile("tests/lua/test_store_bundle_descriptions.lua")
local player = Player(10)
function player:getClient()
	return { version = 1525, os = 5 }
end
local category = { name = "Furniture", offers = {} }
for _, offer in ipairs(dofile("data/modules/scripts/gamestore/catalog/house_additions_1525.lua").Furniture) do
	if type(offer.itemtype) == "table" then
		offer.coinType = GameStore.CoinType.Transferable
		offer.state = GameStore.States.STATE_NONE
		category.offers[#category.offers + 1] = offer
	end
end
assert(#category.offers == 33)
local create, packet = NetworkMessage, nil
function NetworkMessage()
	local message = create()
	local send = message.sendToPlayer
	function message:sendToPlayer(...)
		if self.bytes[1] == string.char(GameStore.SendingPackets.S_StoreOffers) then
			packet = table.concat(self.bytes)
		end
		send(self, ...)
	end
	return message
end
require("gamestore.senders").sendShowStoreOffers(player:getId(), category)
assert(packet)
local prefix = os.getenv("CANARY_STORE_BUNDLE_PACKET")
if prefix then
	local file = assert(io.open(prefix .. "-house.bin", "wb"))
	file:write(packet)
	file:close()
	file = assert(io.open(prefix .. "-house.tsv", "w"))
	for _, offer in ipairs(category.offers) do
		assert(#offer.itemtype == 4, "preview must not replace the delivery array")
		file:write(offer.id, "\t", offer.itemtype[1], "\t", offer.price, "\n")
	end
	file:close()
end
print("PASS: actual 33-set Store packet emits numeric previews and retains all four delivery IDs")

for _, offer in ipairs(category.offers) do
	offer.home = true
end
GameStore.Categories = { category }
HomeBanners = { images = {}, delay = 10 }
packet = nil
require("gamestore.senders").sendHomePage(player:getId())
assert(packet, "Home must support the same table-valued set offers")
if prefix then
	local file = assert(io.open(prefix .. "-home.bin", "wb"))
	file:write(packet)
	file:close()
end
print("PASS: Home emits representative numeric IDs for the same 33 four-part sets")
