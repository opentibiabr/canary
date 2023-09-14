local Dollbox = Action()
local items = {
    {itemId = 10277, count = 1, chance = 50}, -- ITEM, QUANTIDADE, CHANCE
    {itemId = 8154, count = 1, chance = 50},
    {itemId = 6567, count = 1, chance = 50},
  }
  local broadcastitems = {2160, 2161}
  
  function Dollbox.onUse(cid, item, frompos, item2, topos)
  
    local config = {
      pos = getCreaturePosition(cid), -- posição do player
      exhaustionSeconds = 3600, -- exausted em segundos
      storageUse = 44231, -- storage usado.
  
    }
  
    if(exhaustion.check(cid, config.storageUse)) then
      if (exhaustion.get(cid, config.storageUse) >= 60) then
        doPlayerSendCancel(cid, "Voce so poderar abrir o bau novamente em " .. math.floor(exhaustion.get(cid, config.storageUse) / 60 + 1) .." minutos.")
      end
      if (exhaustion.get(cid, config.storageUse) <= 60) then
        doPlayerSendCancel(cid, "Voce precisa esperar " .. exhaustion.get(cid, config.storageUse).." segundos.")
      end
      return true
    end
  
    local totalChance, randomTable, randomNumber = 0, {}, 0
  
    addEvent(doPlayerSendTextMessage, 1*1000, cid, 27, "Procurando algo...")
    addEvent(doPlayerSendTextMessage, 2*1000, cid, 27, "Procurando algo...")
    addEvent(doPlayerSendTextMessage, 3*1000, cid, 27, "Procurando algo...")
    addEvent(doPlayerSendTextMessage, 4*1000, cid, 27, "Procurando algo...")
    addEvent(doPlayerSendTextMessage, 5*1000, cid, 27, "Procurando algo...")
    addEvent(doSendAnimatedText, 1*1000, config.pos, "[5]", 180)
    addEvent(doSendAnimatedText, 2*1000, config.pos, "[4]", 180)
    addEvent(doSendAnimatedText, 3*1000, config.pos, "[3]", 180)
    addEvent(doSendAnimatedText, 4*1000, config.pos, "[2]", 180)
    addEvent(doSendAnimatedText, 5*1000, config.pos, "[1]", 180)
    addEvent(doSendAnimatedText, 6*1000, config.pos, "DONE!", 180)
  
    for _, itemInfo in pairs (items) do
      randomTable[itemInfo.itemId] = {min = totalChance + 1, max = itemInfo.chance, count = itemInfo.count or 1}
      totalChance = totalChance + itemInfo.chance
    end
  
    randomNumber = math.random(1, totalChance)
    for itemId, itemInfo in pairs (randomTable) do
      local min, max = itemInfo.min, itemInfo.min + itemInfo.max
      if randomNumber >= min and randomNumber <= max then
        local newItem = addEvent(doPlayerAddItem, 6*1000, cid, itemId, itemInfo.count, false)
        if not newItem then return doPlayerSendCancel(cid, "Voce nao tem espaco para receber o item!") end
        doRemoveItem(item.uid, 0)
        exhaustion.set(cid, config.storageUse, config.exhaustionSeconds)
        local iInfo = getItemInfo(itemId)
        addEvent(doPlayerSendTextMessage, 6*1000, cid, 27, "Voce achou ("..iInfo.name..")!")
        for i, broaditem in ipairs(broadcastitems) do
          if itemId==broaditem then addEvent(doBroadcastMessage, 6*1000, getCreatureName(cid).." acabou de ganhar: "..iInfo.name.." na Mystery Box.") end
        end
        break
      end
    end
    Item(item.uid):remove(1)
    return true
  end
Dollbox:id(3997)
Dollbox:register()