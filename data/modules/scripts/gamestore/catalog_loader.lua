local loader = {}

local categories = {}

local function ensureType(value, expectedType, context)
	if type(value) ~= expectedType then
		error(string.format("Invalid %s: expected %s but got %s", context, expectedType, type(value)))
	end
end

local function ensureArrayOfStrings(list, context)
	ensureType(list, "table", context)
	if #list == 0 then
		error(string.format("%s must not be empty", context))
	end
	for index, entry in ipairs(list) do
		if type(entry) ~= "string" then
			error(string.format("Invalid %s[%d]: expected string but got %s", context, index, type(entry)))
		end
	end
end

local function ensureBoolean(value, context)
	if type(value) ~= "boolean" then
		error(string.format("Invalid %s: expected boolean but got %s", context, type(value)))
	end
end

local function ensureOptionalString(value, context)
	if value ~= nil and type(value) ~= "string" then
		error(string.format("Invalid %s: expected string but got %s", context, type(value)))
	end
end

function loader.registerOffer(categoryName, offer, offerIndex)
	offerIndex = offerIndex or #offer
	if type(offer) ~= "table" then
		error(string.format("Invalid offer in %s at position %d", categoryName, offerIndex))
	end

	ensureArrayOfStrings(offer.icons, string.format("%s offer %d icons", categoryName, offerIndex))
	ensureType(offer.name, "string", string.format("%s offer %d name", categoryName, offerIndex))
	ensureType(offer.price, "number", string.format("%s offer %d price", categoryName, offerIndex))
	if offer.id ~= nil and type(offer.id) ~= "number" then
		error(string.format("Invalid %s offer %d id: expected number but got %s", categoryName, offerIndex, type(offer.id)))
	end
	if offer.type ~= nil and type(offer.type) ~= "number" then
		error(string.format("Invalid %s offer %d type: expected number but got %s", categoryName, offerIndex, type(offer.type)))
	end
	if offer.coinType ~= nil and type(offer.coinType) ~= "number" then
		error(string.format("Invalid %s offer %d coinType: expected number but got %s", categoryName, offerIndex, type(offer.coinType)))
	end

	GameStore.normalizeOffer(offer)
	return offer
end

function loader.registerCategory(category, source)
	source = source or "catalog"
	if type(category) ~= "table" then
		error(string.format("Invalid Game Store category from %s", source))
	end

	ensureArrayOfStrings(category.icons, string.format("%s.icons", source))
	ensureType(category.name, "string", string.format("%s.name", source))
	ensureBoolean(category.rookgaard, string.format("%s.rookgaard", source))
	ensureOptionalString(category.parent, string.format("%s.parent", source))

	if category.subclasses ~= nil then
		ensureArrayOfStrings(category.subclasses, string.format("%s.subclasses", source))
	end

	if category.offers == nil and category.subclasses == nil then
		error(string.format("Category %s must define offers or subclasses", category.name))
	end

	if category.offers ~= nil then
		ensureType(category.offers, "table", string.format("%s.offers", source))
		local normalizedOffers = {}
		for index, offer in ipairs(category.offers) do
			normalizedOffers[#normalizedOffers + 1] = loader.registerOffer(category.name, offer, index)
		end
		category.offers = normalizedOffers
	end

	category.state = GameStore.resolveState(category.state, string.format("%s.state", category.name))

	categories[#categories + 1] = category
	return category
end

function loader.getCategories()
	return categories
end

return loader
