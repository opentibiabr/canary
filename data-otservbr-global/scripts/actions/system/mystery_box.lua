local storeBox = Action()

local REWARD = {2471, 2496, 2343, 7902, 18398, 8868, 8867, 15489, 12643, 8887, 8886, 8885, 8877, 8878, 15407, 8884, 8881, 12607, 8889, 8865, 8890, 6132, 11117, 11118, 11240, 9933, 2358, 9777, 18405, 2469}
local JEWEL = {2171, 2661, 2168, 2214, 2165, 2213, 2207, 2169, 2122, 2127, 2124, 2121, 7697, 13825, 6300}
function storeBox.onUse(cid, item, fromPosition, itemEx, toPosition)
      local randomChance = math.random(1, #REWARD)
      doPlayerAddItem(cid, REWARD[randomChance], 1)

local randomLoot = math.random(1,20)
    if randomLoot == 1 then
    doPlayerSendTextMessage(cid, 19, "You found an extra item!")
             local randomChance = math.random(1, #REWARD)
              doPlayerAddItem(cid, REWARD[randomChance], 1)
    end

local randomJewel = math.random(1,10)
    if randomJewel == 1 then
    doPlayerSendTextMessage(cid, 19, "You found a jewel!")
	  local charges = math.random(50, 150)	
      local randomChance = math.random(1, #JEWEL)
      doPlayerAddItem(cid, JEWEL[randomChance], 1)
    end
 
doSendMagicEffect(getPlayerPosition(cid), 73)
   doRemoveItem(item.uid, 1)
   return true
end

storeBox:id(23488)
storeBox:register()