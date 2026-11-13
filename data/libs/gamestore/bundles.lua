local bundles = {}

function bundles.unavailableReason(player, offer)
	if player:getClient().version < 1525 then
		return "This bundle requires client 15.25 or newer."
	end
	if not offer.sexId or not offer.mountId or not Mount(offer.mountId) or not offer.decorations or #offer.decorations == 0 then
		return "This bundle is unavailable."
	end
	local lookType = player:getSex() == PLAYERSEX_MALE and offer.sexId.male or offer.sexId.female
	if not lookType then
		return "This bundle has no outfit for your character."
	end
	if player:kv():scoped("store-bundles"):get(tostring(offer.id)) or (player:hasOutfit(lookType, 3) and player:hasMount(offer.mountId)) then
		return "You already own this bundle's outfit and mount."
	end
	for _, id in ipairs(offer.decorations) do
		local itemType = ItemType(id)
		if not itemType or itemType:getId() == 0 or itemType:getName() == "" then
			return "A decoration in this bundle is unavailable."
		end
	end
	local canReceive, reason = player:canReceiveStoreItems(ITEM_DECORATION_KIT, #offer.decorations)
	if not canReceive then
		return reason
	end
end

function bundles.purchase(player, offer)
	local reason = bundles.unavailableReason(player, offer)
	if reason then
		error({ code = 0, message = reason })
	end
	if not player:canPayForOffer(offer.price, offer.coinType) then
		error({ code = 0, message = "You do not have enough coins for this bundle." })
	end

	-- Prepare every physical component before payment or cosmetic unlocks.
	-- Failed delivery/payment removes only the kits created by this purchase.
	local inbox = player:getStoreInbox()
	local kits = {}
	local function discardKits()
		for _, kit in ipairs(kits) do
			kit:remove()
		end
	end
	-- Snapshot raw ownership for both sexes, including partially purchased addons.
	-- hasOutfit without ownedOnly checks wearability and rejects the opposite sex.
	local outfits = {}
	for _, lookType in ipairs({ offer.sexId.male, offer.sexId.female }) do
		local addons = 0
		for _, addon in ipairs({ 1, 2 }) do
			if player:hasOutfit(lookType, addon, true) then
				addons = addons + addon
			end
		end
		outfits[#outfits + 1] = { id = lookType, owned = player:hasOutfit(lookType, 0, true), addons = addons }
	end
	local ownedMount = player:hasMount(offer.mountId)
	local function restoreCosmetics()
		for _, outfit in ipairs(outfits) do
			if not outfit.owned then
				player:removeOutfit(outfit.id)
			elseif outfit.addons ~= 3 then
				player:removeOutfitAddon(outfit.id, 3 - outfit.addons)
			end
		end
		if not ownedMount then
			player:removeMount(offer.mountId)
		end
	end
	local ok, failure = pcall(function()
		for _, id in ipairs(offer.decorations) do
			local kit = inbox:addItem(ITEM_DECORATION_KIT, 1)
			if not kit then
				error({ code = 0, message = "Could not deliver the complete bundle. No coins were charged." })
			end
			kits[#kits + 1] = kit
			kit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "You bought this item in the Store.\nUnwrap it in your own house to create a <" .. ItemType(id):getName() .. ">.")
			kit:setCustomAttribute("unWrapId", id)
			kit:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
			kit:setOwner(player)
		end
		for _, outfit in ipairs(outfits) do
			if not player:addOutfitAddon(outfit.id, 3) or not player:hasOutfit(outfit.id, 3, true) then
				error({ code = 0, message = "Bundle outfit unlock failed. No coins were charged." })
			end
		end
		if not player:addMount(offer.mountId) or not player:hasMount(offer.mountId) then
			error({ code = 0, message = "Bundle mount unlock failed. No coins were charged." })
		end
		if not player:makeCoinTransaction(offer) then
			error({ code = 0, message = "Bundle payment failed. Your purchase was cancelled." })
		end
	end)
	if not ok then
		restoreCosmetics()
		discardKits()
		error(failure)
	end

	player:kv():scoped("store-bundles"):set(tostring(offer.id), true)
end

return bundles
