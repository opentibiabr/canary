--[[
	Gesior Shop System Revscript v3.0

	Originally written by Gesior, modified by slawkens for MyAAC.
	This script works with TFS 1.3+, otservbr-global and canary
]]--

local messageType = MESSAGE_EVENT_ADVANCE

-- don't edit anything below this line
if(not messageType) then
	messageType = MESSAGE_STATUS_CONSOLE_ORANGE
	if(not messageType) then
		messageType = MESSAGE_EVENT_ADVANCE
	end
end

function getResults()
	local resultId = db.storeQuery("SELECT * FROM z_ots_comunication;")
	if(resultId == false) then
		return false
	end

	local results = {}
	repeat
		local tmp = {}
		tmp.name = result.getString(resultId, "name")

		-- better performance when no player found
		tmp.exist = false
		tmp.player = nil

		local player = Player(tmp.name)
		if(player) then
			tmp.exist = true
			tmp.player = player

			tmp.id = result.getNumber(resultId, "id")
			tmp.action = result.getString(resultId, "action")
			tmp.delete_it = result.getNumber(resultId, "delete_it")

			tmp.param1 = result.getNumber(resultId, "param1")
			tmp.param2 = result.getNumber(resultId, "param2")
			tmp.param3 = result.getNumber(resultId, "param3")
			tmp.param4 = result.getNumber(resultId, "param4")
			tmp.param5 = result.getString(resultId, "param5")
			tmp.param6 = result.getString(resultId, "param6")
		end

		table.insert(results, tmp)
	until not result.next(resultId)
	result.free(resultId)

	return results
end

local shopSystemGlobalEvent = GlobalEvent("myaac-gesior-shop-system")
function shopSystemGlobalEvent.onThink(interval)
	interval = interval / 1000

	local started = os.mtime and os.mtime() or os.time()
	local addedItems, waitingItems = 0, 0
	local added = false

	local results = getResults()
	if(not results) then
		return true
	end

	for i, v in ipairs(results) do
		added = false
		local id = v.id
		local action = v.action
		local delete = v.delete_it

		if(v.exist) then
			local player = v.player
			local param1, param2, param3, param4 = v.param1, v.param2, v.param3, v.param4
			local add_item_type = v.param5
			local add_item_name = v.param6
			local received_item, full_weight, items_weight, item_weigth = 0, 0, 0, 0
			local item_doesnt_exist = false

			if(add_item_type == 'container' or add_item_type == 'item') then
				local itemType = ItemType(param1)
				if(not itemType) then -- item doesn't exist
					print("[ERROR - gesior-shop-system] Invalid item id: " .. param1 .. ". Change/Fix `itemid1` in `z_shop_offers` then delete it from `z_ots_comunication`")
					item_doesnt_exist = true
				else
					local item_weigth = itemType:getWeight()
					if(add_item_type == 'container') then
						local containerItemType = ItemType(param3)
						if(not containerItemType) then -- container item doesn't exist
							print("[ERROR - gesior-shop-system] Invalid container id: " .. param3 .. ". Change/Fix `itemid2` in `z_shop_offers` then delete it from `z_ots_comunication`")
							item_doesnt_exist = true
						else
							local container_weight = containerItemType:getWeight()
							if(itemType:isRune()) then
								items_weight = param4 * item_weigth
							else
								items_weight = param4 * itemType:getWeight(param2)
							end

							full_weight = items_weight + container_weight
						end
					elseif(add_item_type == 'item') then
						full_weight = itemType:getWeight(param2)
						if(itemType:isRune()) then
							full_weight = itemType:getWeight()
						end
					end
				end

				if(not item_doesnt_exist) then
					local free_cap = player:getFreeCapacity()
					if(full_weight <= free_cap) then
						if(add_item_type == 'container') then
							local new_container = Game.createItem(param3, 1)
							for x = 1, param4 do
								new_container:addItem(param1, param2)
							end
							received_item = player:addItemEx(new_container)
						else
							received_item = player:addItem(param1, param2)
						end

						if(received_item) then
							player:sendTextMessage(messageType, "You received >> ".. add_item_name .." << from OTS shop.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `z_shop_history` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE comunication_id = " .. id .. ";")
							player:save()
							added = true
						else
							player:sendTextMessage(messageType, '>> '.. add_item_name ..' << from OTS shop is waiting for you. Please make place for this item in your backpack/hands and wait about '.. interval ..' seconds to get it.')
						end
					else
						player:sendTextMessage(messageType, '>> '.. add_item_name ..' << from OTS shop is waiting for you. It weight is '.. (full_weight / 100) ..' oz., you have only '.. (free_cap / 100) ..' oz. free capacity. Put some items in depot and wait about '.. interval ..' seconds to get it.')
					end
				end
			elseif(add_item_type == 'addon') then
				player:sendTextMessage(messageType, "You received >> ".. add_item_name .." << from OTS shop.")
				player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
				player:addOutfitAddon(param1, param3)
				player:addOutfitAddon(param2, param4)
				db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
				db.query("UPDATE `z_shop_history` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE comunication_id = " .. id .. ";")
				player:save()
				added = true
			elseif(add_item_type == 'mount') then
				player:addMount(param1)
				player:sendTextMessage(messageType, "You received >> ".. add_item_name .." << from OTS shop.")
				player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

				db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
				db.query("UPDATE `z_shop_history` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE comunication_id = " .. id .. ";")
				player:save()
				added = true
			end
		end

		if(added) then
			addedItems = addedItems + 1
		else
			waitingItems = waitingItems + 1
		end
	end

	print(">> Shopsystem, added " .. addedItems .. " items. Still waiting with " .. waitingItems .. " items.")
	return true
end

shopSystemGlobalEvent:interval(30000)
shopSystemGlobalEvent:register()
