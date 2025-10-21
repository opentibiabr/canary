--[[
Items have been updated so that if the offer type is not one of the types: OFFER_TYPE_OUTFIT, OFFER_TYPE_OUTFIT_ADDON,
OFFER_TYPE_MOUNT, OFFER_TYPE_NAMECHANGE, OFFER_TYPE_SEXCHANGE, OFFER_TYPE_PROMOTION, OFFER_TYPE_EXPBOOST,
OFFER_TYPE_PREYSLOT, OFFER_TYPE_PREYBONUS, OFFER_TYPE_TEMPLE, OFFER_TYPE_BLESSINGS, OFFER_TYPE_PREMIUM,
OFFER_TYPE_ALLBLESSINGS
]]

-- Parser
dofile(CORE_DIRECTORY .. "/modules/scripts/gamestore/init.lua")
-- Config

HomeBanners = {
	images = { "home/banner_armouredarcher.png", "home/banner_podiumoftenacity.png" },
	delay = 10,
}

-- GameStore.SearchCategory = {
-- 	icons = {},
-- 	name = "Search Results",
-- 	rookgaard = true,
-- 	state = GameStore.States.STATE_NONE,
-- }

local catalog = dofile(CORE_DIRECTORY .. "/modules/scripts/gamestore/catalog/init.lua")

local categories = {}

for index, category in ipairs(catalog) do
	if type(category) == "table" then
		local hasOffers = type(category.offers) == "table"
		local hasSubclasses = type(category.subclasses) == "table"
		if not category.name or category.rookgaard == nil or (not hasOffers and not hasSubclasses) then
			error(string.format("Invalid Game Store category at position %d", index))
		end
		if category.offers ~= nil and not hasOffers then
			error(string.format("Invalid offers table in Game Store category at position %d", index))
		end
		categories[#categories + 1] = category
	end
end

GameStore.Categories = categories

-- Each outfit must be uniquely identified to distinguish between addons.
-- Here we dynamically assign ids for outfits. These ids must be unique.
local runningId = 45000
for k, category in ipairs(GameStore.Categories) do
	if category.offers then
		for m, offer in ipairs(category.offers) do
			if not offer.id then
				if type(offer.count) == "table" then
					for i = 1, #offer.price do
						offer.id[i] = runningId
						runningId = runningId + 1
					end
				else
					offer.id = runningId
					runningId = runningId + 1
				end
			end
			if not offer.type then
				offer.type = GameStore.OfferTypes.OFFER_TYPE_NONE
			end
			if not offer.coinType then
				offer.coinType = GameStore.CoinType.Transferable
			end
		end
	end
end
