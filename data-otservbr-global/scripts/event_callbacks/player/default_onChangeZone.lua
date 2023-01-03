local ec = EventCallback

function ec.onChangeZone(player, zone)
	if player:isPremium() then
		local event = staminaBonus.eventsPz[player:getId()]

		if configManager.getBoolean(configKeys.STAMINA_PZ) then
			if zone == ZONE_PROTECTION then
				if player:getStamina() < 2520 then
					if not event then
						local delay = configManager.getNumber(configKeys.STAMINA_ORANGE_DELAY)
						if player:getStamina() > 2400 and player:getStamina() <= 2520 then
							delay = configManager.getNumber(configKeys.STAMINA_GREEN_DELAY)
						end

						player:sendTextMessage(MESSAGE_STATUS,
                                             string.format("In protection zone. \
                                                           Every %i minutes, gain %i stamina.",
                                                           delay, configManager.getNumber(configKeys.STAMINA_PZ_GAIN)
                                             )
                        )
						staminaBonus.eventsPz[player:getId()] = addEvent(addStamina, delay * 60 * 1000, nil, player:getId(), delay * 60 * 1000)
					end
				end
			else
				if event then
					player:sendTextMessage(MESSAGE_STATUS, "You are no longer refilling stamina, \z
                                         since you left a regeneration zone.")
					stopEvent(event)
					staminaBonus.eventsPz[player:getId()] = nil
				end
			end
			--return not configManager.getBoolean(configKeys.STAMINA_PZ)
		end
	end
end

ec:register(--[[0]])
