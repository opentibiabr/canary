local dusts = Action()

function dusts.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local dustsUsed = (item:getCount())
  player:addForgeDusts(dustsUsed)
  player:sendTextMessage(MESSAGE_INFO_DESCR, "You have added "..dustsUsed.." Dusts to your account.")
  item:remove()
  return true
end

dusts:id(37160)
dusts:register()