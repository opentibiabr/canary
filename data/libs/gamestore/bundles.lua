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
		if not player:makeCoinTransaction(offer) then
			error({ code = 0, message = "Bundle payment failed. Your purchase was cancelled." })
		end
	end)
	if not ok then
		discardKits()
		error(failure)
	end

	-- These validated native operations are synchronous. Existing unlocks are
	-- retained; the full outfit includes both addons for both character sexes.
	player:addOutfitAddon(offer.sexId.male, 3)
	player:addOutfitAddon(offer.sexId.female, 3)
	player:addMount(offer.mountId)
	player:kv():scoped("store-bundles"):set(tostring(offer.id), true)
end

return bundles
