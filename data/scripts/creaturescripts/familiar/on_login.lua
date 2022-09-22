local familiarOnLogin = CreatureEvent("FamiliarLogin")

function familiarOnLogin.onLogin(player)
	if not player then
		return false
	end

	local vocation = FAMILIAR_ID[player:getVocation():getBaseId()]

	local familiarName
	local familiarTimeLeft = player:getStorageValue(Storage.FamiliarSummon) - player:getLastLogout()

	if vocation then
		if (not player:isPremium() and player:hasFamiliar(vocation.id)) or player:getLevel() < 200 then
			player:removeFamiliar(vocation.id)
		elseif player:isPremium() and player:getLevel() >= 200 then
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

	if familiarName then
		local position = player:getPosition()
		local familiarMonster = Game.createMonster(familiarName, position, true, false, player)
		if familiarMonster then

			familiarMonster:setOutfit({lookType = player:getFamiliarLooktype()})
			familiarMonster:registerEvent("FamiliarDeath")
			position:sendMagicEffect(CONST_ME_MAGIC_BLUE)

			local deltaSpeed = math.max(player:getSpeed() - familiarMonster:getSpeed(), 0)
			familiarMonster:changeSpeed(deltaSpeed)

			player:setStorageValue(Storage.FamiliarSummon, os.time() + familiarTimeLeft)
			addEvent(RemoveFamiliar, familiarTimeLeft*1000, familiarMonster:getId(), player:getId())

			for sendMessage = 1, #FAMILIAR_TIMER do
				if player:getStorageValue(FAMILIAR_TIMER[sendMessage].storage) == -1 and familiarTimeLeft >= FAMILIAR_TIMER[sendMessage].countdown then
					player:setStorageValue(FAMILIAR_TIMER[sendMessage].storage, addEvent(SendMessageFunction, (familiarTimeLeft-FAMILIAR_TIMER[sendMessage].countdown)*1000, player:getId(), FAMILIAR_TIMER[sendMessage].message))
				end
			end
		end
	end
	return true
end

familiarOnLogin:register()
