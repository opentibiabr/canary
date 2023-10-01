local tournamentToken = Action()

function tournamentToken.onUse(player, item, fromPosition, target, toPosition, isHotkey)

local coins = (item:getCount())
  db.query("UPDATE `accounts` SET `tournament_coins` = `tournament_coins` + '" .. coins .. "' WHERE `id` = '" .. player:getAccountId() .. "';")
  player:sendTextMessage(MESSAGE_INFO_DESCR, "You received "..coins.." Tournament Coins.")
  item:remove()
  return true
end

tournamentToken:id(19082)
tournamentToken:register()