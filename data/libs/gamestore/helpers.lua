local constants = require("gamestore.constants")

local helpers = {}

function helpers.convertType(type)
	local types = {
		[constants.OfferTypes.OFFER_TYPE_OUTFIT] = constants.ConverType.SHOW_OUTFIT,
		[constants.OfferTypes.OFFER_TYPE_OUTFIT_ADDON] = constants.ConverType.SHOW_OUTFIT,
		[constants.OfferTypes.OFFER_TYPE_MOUNT] = constants.ConverType.SHOW_MOUNT,
		[constants.OfferTypes.OFFER_TYPE_ITEM] = constants.ConverType.SHOW_ITEM,
		[constants.OfferTypes.OFFER_TYPE_STACKABLE] = constants.ConverType.SHOW_ITEM,
		[constants.OfferTypes.OFFER_TYPE_HOUSE] = constants.ConverType.SHOW_ITEM,
		[constants.OfferTypes.OFFER_TYPE_CHARGES] = constants.ConverType.SHOW_ITEM,
		[constants.OfferTypes.OFFER_TYPE_HIRELING] = constants.ConverType.SHOW_HIRELING,
		[constants.OfferTypes.OFFER_TYPE_ITEM_BED] = constants.ConverType.SHOW_NONE,
		[constants.OfferTypes.OFFER_TYPE_ITEM_UNIQUE] = constants.ConverType.SHOW_ITEM,
	}

	if not types[type] then
		return constants.ConverType.SHOW_NONE
	end

	return types[type]
end

function helpers.useOfferConfigure(type)
	local types = {
		[constants.OfferTypes.OFFER_TYPE_NAMECHANGE] = constants.ConfigureOffers.SHOW_CONFIGURE,
		[constants.OfferTypes.OFFER_TYPE_HIRELING] = constants.ConfigureOffers.SHOW_CONFIGURE,
		[constants.OfferTypes.OFFER_TYPE_HIRELING_NAMECHANGE] = constants.ConfigureOffers.SHOW_CONFIGURE,
		[constants.OfferTypes.OFFER_TYPE_HIRELING_SEXCHANGE] = constants.ConfigureOffers.SHOW_CONFIGURE,
	}

	if not types[type] then
		return constants.ConfigureOffers.SHOW_NORMAL
	end

	return types[type]
end

return helpers
