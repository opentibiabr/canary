local token = Action()

local tokenId = ITEM_REVOADA_COIN -- revoada coin

function token.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(tokenId) > 0 then
		local tournamentCoins = player:getItemCount(tokenId)
		--db.query("UPDATE `accounts` SET `tournament_coins` = `tournament_coins` + '" .. tournamentCoins .. "' WHERE `id` = '" .. player:getAccountId() .. "';")
		player:removeItem(tokenId, tournamentCoins)
		player:addTibiaCoins(tournamentCoins)
		player:sendTextMessage(MESSAGE_TRADE, string.format("You have added %d tibia coins to your account.", tournamentCoins))
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	end
	return true
end

token:id(tokenId)
token:register()
