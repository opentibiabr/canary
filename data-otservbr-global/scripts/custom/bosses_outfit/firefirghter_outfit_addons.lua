local config = {
   [39544] = {female = 1569, male = 1568, addon = 1, effect = CONST_ME_GREEN_RINGS},
   [39545] = {female = 1569, male = 1568, addon = 2, effect = CONST_ME_GREEN_RINGS},
}

local addons = Action()

function addons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
   local useItem = config[item.itemid]
   if not useItem then
       return true
   end

   local looktype = player:getSex() == PLAYERSEX_FEMALE and useItem.female or useItem.male

   if useItem.addon then
       if not player:isPremium()
               or not player:hasOutfit(looktype)
               or player:hasOutfit(looktype, useItem.addon) then
           player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You own no premium account, lack the base outfit or already own this outfit part.')
           return true
       end

       player:addOutfitAddon(looktype, useItem.addon)
       player:getPosition():sendMagicEffect(useItem.effect or CONST_ME_GIFT_WRAPS)
       item:remove()
   else
       if not player:isPremium() or player:hasOutfit(looktype) then
           player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You own no premium account or already own this outfit part.')
           return true
       end

       player:addOutfit(useItem.female)
       player:addOutfit(useItem.male)
       player:getPosition():sendMagicEffect(useItem.effect or CONST_ME_GIFT_WRAPS)
       item:remove()
   end
   return true
end

addons:id(39544, 39545)
addons:register()