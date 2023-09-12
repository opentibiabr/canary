local familiarOnLogin = CreatureEvent("FamiliarLogin")

function familiarOnLogin.onLogin(player)
	if not player then
		return false
	end

	local vocation = FAMILIAR_ID[player:getVocation():getBaseId()]

	local familiarName
	local familiarTimeLeft = player:getStorageValue(Global.Storage.FamiliarSummon) - player:getLastLogout()

	if vocation then
		if (not isPremium(player) and player:hasFamiliar(vocation.id)) or player:getLevel() < 200 then
			player:removeFamiliar(vocation.id)
		elseif isPremium(player) and player:getLevel() >= 200 then
			if familiarTimeLeft > 0 then
				familiarName = vocation.name
			end
			if player:getFamiliarLooktype() == 0 then
				player:setFamiliarLooktype(vocation.id)
			end
			if not player:hasFamiliar(vocation.id) then
				player:addFamiliar(vocation.id)
			end
		end
	end

	if not familiarName then
		return true
	end
	player:createFamiliar(familiarName, familiarTimeLeft)
	return true
end

familiarOnLogin:register()
