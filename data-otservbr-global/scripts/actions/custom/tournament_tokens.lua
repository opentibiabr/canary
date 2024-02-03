local token = Action()

local tokenId = 14112 -- bar of gold (if you don't use custom item, you need to verify all drops in monsters)

function token.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(tokenId) > 0 then
		local tournamentCoins = player:getItemCount(tokenId)
		db.query("UPDATE `accounts` SET `tournament_coins` = `tournament_coins` + '" .. tournamentCoins .. "' WHERE `id` = '" .. player:getAccountId() .. "';")
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("You added %d %s to your account.", tournamentCoins, configManager.getString(configKeys.TOURNAMENT_COINS_NAME):lower()))
		player:removeItem(tokenId, tournamentCoins)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	end
	return true
end

token:id(tokenId)
token:register()
