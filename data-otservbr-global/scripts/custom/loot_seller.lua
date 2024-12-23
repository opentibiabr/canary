sellingTable = {}

local count = 0
for _, eachType in pairs(LootShopConfigTable) do
    for _, eachItem in ipairs(eachType) do
        local insertItem = {name = eachItem.itemName, sell = eachItem.sell}
        table.insert(sellingTable,eachItem.clientId, insertItem)
        count = count+1 
    end
end

logger.info("The price list for the Loot Seller has been updated, with "..count.." items.")

local conf = {
    toggleLogger = true, -- if send terminal message when player use the item
    itemSellerId = 30316, -- register the item
    exhaust = 15,
    lootPouchId = 23721, -- pouchId
    percentPrice = 0.8, -- if u want to change to lose price, use 0.9 to earn 90% of origin price, 0.55 to 55% etc...
    maxValueSell = 200, -- TAKE CARE, it is counted by slots NOT BY COUNT OF STACKABLES, 200 I think is a safe number
}

local itemSeller = Action()

function itemSeller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local inbox = player:getStoreInbox():getItems()
    local lootPouchStore = nil
    local lootPouch = player:getItemById(conf.lootPouchId, true)
    for _, lookPouch in pairs(inbox) do
        if lookPouch:getId() == conf.lootPouchId then
            lootPouchStore = Container(lookPouch:getUniqueId())
            break
        end
    end


    if player:getExhaustion("itemSellerExhaustion") > 0 then
        player:sendCancelMessage("You must to wait "..Game.getTimeInWords(player:getExhaustion("itemSellerExhaustion")).." to use this item again.")
        return true
    end

    if not lootPouch and not lootPouchStore then
        player:sendCancelMessage("You dont have a loot pouch.")
        player:setExhaustion("itemSellerExhaustion", conf.exhaust)
        return true
    end
    local normalPouch, storePouch = 0, 0
    if lootPouch then normalPouch = lootPouch:getItemHoldingCount() end
    if lootPouchStore then storePouch = lootPouchStore:getItemHoldingCount() end
    local amountItems =  normalPouch + storePouch

    if amountItems < 1 then
    return player:sendCancelMessage("You dont have anything to sell.")
    end


    local itemsToSell = {}
    local totalEarn = 0
    local totalSelled = 0
    local getcontainer = {}

        if lootPouchStore then
                    getcontainer = lootPouchStore:getItems()
                    for _, iten in pairs(getcontainer) do
                        if #itemsToSell < conf.maxValueSell then
                            if not iten:isContainer() and sellingTable[iten:getId()] then
                                table.insert(itemsToSell, iten)
                            end  
                        else break end
                    end
        end

        if lootPouch then
                    getcontainer = lootPouch:getItems()
                    for _, iten in pairs(getcontainer) do
                        if #itemsToSell < conf.maxValueSell then
                            if not iten:isContainer() and sellingTable[iten:getId()] then
                                table.insert(itemsToSell, iten)
                            end 
                        else break end
                    end
        end


         for _, it in pairs(itemsToSell) do
             local count = it:getCount()
                if not it:isContainer() then
                    if sellingTable[it:getId()] then
                        if it:remove() then
                        totalSelled = totalSelled + count
                        totalEarn = totalEarn + (count * sellingTable[it:getId()].sell * conf.percentPrice)
                        end
                    end
                end
         end

        player:setExhaustion("itemSellerExhaustion", conf.exhaust)
        if totalSelled < 1 then
            player:sendCancelMessage("You have some items, but none of them saleable.")
            return true 
        end
        
        Bank.credit(player:getName(), totalEarn)
        player:sendTextMessage(MESSAGE_TRADE, "You sold " ..totalSelled.. " items and received " ..totalEarn.. " golds, warrants to your bank account.")
        if conf.toggleLogger then logger.info(player:getName() .. ":: used itemSeller and sold " .. totalSelled .. " items, he received "..totalEarn.." golds.") end
    return true
end

itemSeller:id(conf.itemSellerId)
itemSeller:register()