local znoteShop = TalkAction("!Shop")

function znoteShop.onSay(cid, words, param)
    local storage = 54073 -- Make sure to select non-used storage. This is used to prevent SQL load attacks.
    local cooldown = 15 -- in seconds.
    local player = Player(cid)

    if player:getStorageValue(storage) <= os.time() then
        player:setStorageValue(storage, os.time() + cooldown)

        local type_desc = {
            "itemids",
            "pending premium (skip)",
            "pending gender change (skip)",
            "pending character name change (skip)",
            "Outfit and addons",
            "Mounts",
            "Instant house purchase"
        }
        print("Player: " .. player:getName() .. " triggered !shop talkaction.")
        -- Create the query
        local orderQuery = db.storeQuery("SELECT `id`, `type`, `itemid`, `count`, `cost_points` FROM `znote_shop_orders` WHERE `account_id` = " .. player:getAccountId() .. ";")
        local served = false

        if orderQuery ~= false then
			local anyOrders = false -- Flag to check if there are any orders
		
			repeat
				-- Fetch order values
				local q_id = result.getNumber(orderQuery, "id")
				local q_type = result.getNumber(orderQuery, "type")
				local q_itemid = result.getNumber(orderQuery, "itemid")
				local q_count = result.getNumber(orderQuery, "count")
				local cost_points = result.getNumber(orderQuery, "cost_points")
		
				local description = "Unknown or custom type"
				if type_desc[q_type] ~= nil then
					description = type_desc[q_type]
				end
				print("Processing type "..q_type..": ".. description)

                -- ORDER TYPE 1 (Regular item shop products)
                if q_type == 1 then
                    served = true
                    -- Get weight
                    if player:getFreeCapacity() >= ItemType(q_itemid):getWeight(q_count) then
                        db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                        player:addItem(q_itemid, q_count)
                        player:sendTextMessage(MESSAGE_INFO_DESCR, "Congratulations! You have received " .. q_count .. " x " .. ItemType(q_itemid):getName() .. "!")
                    else
                        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Need more CAP!")
                    end
                end

                -- ORDER TYPE 5 (Outfit and addon)
                if q_type == 5 then
                    served = true

                    local itemid = q_itemid
                    local outfits = {}

                    if itemid > 1000 then
                        local first = math.floor(itemid/1000)
                        table.insert(outfits, first)
                        itemid = itemid - (first * 1000)
                    end
                    table.insert(outfits, itemid)

                    for _, outfitId in pairs(outfits) do
                        -- Make sure player don't already have this outfit and addon
                        
                        
                        if not player:hasOutfit(outfitId, q_count) then
                            player:addOutfit(outfitId)
                            player:addOutfitAddon(outfitId, 3)
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Congratulations! You have received a new outfit!")
                            db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                        else
                            db.query("UPDATE `znote_accounts` SET `points` = `points` + '".. cost_points .."' WHERE `znote_accounts`.`account_id` = " .. player:getAccountId() .. ";")
                            player:sendTextMessage(MESSAGE_STATUS_WARNING, "You already have this outfit! Your ".. cost_points .." of points will be recovered")
                            db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                        end
                    end
                end

                -- ORDER TYPE 6 (Mounts)
                if q_type == 6 then
                    served = true
                    -- Make sure player doesn't already have this mount
                    if not player:hasMount(q_itemid) then
                        db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                        player:addMount(q_itemid)
                        player:sendTextMessage(MESSAGE_INFO_DESCR, "Congratulations! You have received a new mount!")
                    else
                        db.query("UPDATE `znote_accounts` SET `points` = `points` + '".. cost_points .."' WHERE `znote_accounts`.`account_id` = " .. player:getAccountId() .. ";")
                        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You already have this mount! Your ".. cost_points .." of points will be recovered")
                        db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                    end
                end

                -- ORDER TYPE 7 (Direct house purchase)
                if q_type == 7 then
                    served = true
                    local house = House(q_itemid)
                    -- Logged-in player is not necessarily the player that bought the house. So we need to load the player from the database.
                    local buyerQuery = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = "..q_count.." LIMIT 1")
                    if buyerQuery ~= false then
                        local buyerName = result.getString(buyerQuery, "name")
                        result.free(buyerQuery)
                        if house then
                            db.query("DELETE FROM `znote_shop_orders` WHERE `id` = " .. q_id .. ";")
                            house:setOwnerGuid(q_count)
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully bought the house "..house:getName().." from "..buyerName..". Be sure to have the money for the rent in the bank.")
                            print("Process complete. [".. buyerName .."] has received house: ["..house:getName().."]")
                        end
                    end
                end

                -- Add custom order types here
                -- Type 1 is for itemids (Already coded here)
                -- Type 2 is for premium (Coded on web)
                -- Type 3 is for gender change (Coded on web)
                -- Type 4 is for character name change (Coded on web)
                -- Type 5 is for character outfit and addon (Already coded here)
                -- Type 6 is for mounts (Already coded here)
                -- Type 7 is for Instant house purchase (Already coded here)
                -- So use type 8+ for custom stuff, like etc packages.
                -- if q_type == 8 then
                -- end

				anyOrders = true -- Set the flag to true since there is at least one order

			until not result.next(orderQuery)
		
			result.free(orderQuery)
		
			if not anyOrders then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have any orders to process in-game.")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have any orders.")
		end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only execute this command once every " .. cooldown .. " seconds. Remaining cooldown: " .. player:getStorageValue(storage) - os.time())
    end

    return false
end

znoteShop:separator(" ")
znoteShop:register()
