local storeBox = Action()

local REWARD = {27449, 27450, 27451, 27452, 27453, 27454, 27455, 27456, 27457, 27458, 30400, 30399, 30398, 30397, 30396, 30395, 30394, 31631, 30393, 27651, 27650, 27649, 27648, 27647, 34253, 34154, 34254, 34158, 34157, 34156, 34155, 34153, 34152, 34151, 34150, 28725, 28724, 28723, 28722, 28721, 28720, 28719, 28718, 28717, 28716, 28715, 28714}
local JEWEL = {8150, 36727, 9597, 28493, 25975, 25976, 25977, 3119, 36728}
function storeBox.onUse(cid, item, fromPosition, itemEx, toPosition)
      local randomChance = math.random(1, #REWARD)
      doPlayerAddItem(cid, REWARD[randomChance], 1)

local randomLoot = math.random(1,20)
    if randomLoot == 1 then
    doPlayerSendTextMessage(cid, 19, "Deu bom, pegou um item de bonus!")
             local randomChance = math.random(1, #REWARD)
              doPlayerAddItem(cid, REWARD[randomChance], 1)
    end

local randomJewel = math.random(1,10)
    if randomJewel == 1 then
    doPlayerSendTextMessage(cid, 19, "Achou o bonus!!!")
	  local charges = math.random(50, 150)	
      local randomChance = math.random(1, #JEWEL)
      doPlayerAddItem(cid, JEWEL[randomChance], 1)
    end
 
doSendMagicEffect(getPlayerPosition(cid), 73)
   doRemoveItem(item.uid, 1)
   return true
end

storeBox:id(30316)
storeBox:register()