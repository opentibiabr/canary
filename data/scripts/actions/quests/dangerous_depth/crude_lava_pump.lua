local transformid = {
	[30735] = 30737,
}

local dangerousDepthPump = Action()
function dangerousDepthPump.onUse(player, item)
	if not player then
		return true
	end

	local positionItem = item:getPosition()

	if item:getActionId() == 57300 then -- Warzone VI
		local spectators = Game.getSpectators(positionItem, false, true, 5, 5, 5, 5)
		for _, spectator in pairs(spectators) do
			if spectator:isPlayer() then
				local playerSpectator = spectator
				if playerSpectator:getStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneVI) < 1 then
					playerSpectator:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneVI, 1)
				end
			end
		end
		player:say("With the pump destroyed, the lava stream has been stopped. Zone VI is acessible now!", TALKTYPE_MONSTER_SAY, false, false, positionItem)
		item:transform(transformid[item:getId()])
		addEvent(function()
			if item then
				item:transform(30735)
			end
		end, 10 * 60 * 1000) -- 10 minutos para o item voltar ao normal.
	end
	if item:getActionId() == 57302 then -- Warzone V
		local spectators = Game.getSpectators(positionItem, false, true, 5, 5, 5, 5)
		for _, spectator in pairs(spectators) do
			if spectator:isPlayer() then
				local playerSpectator = spectator
				if playerSpectator:getStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneV) < 1 then
					playerSpectator:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneV, 1)
				end
			end
		end
		player:say("With the pump destroyed, the lava stream has been stopped. Zone V is acessible now!", TALKTYPE_MONSTER_SAY, false, false, positionItem)
		item:transform(transformid[item:getId()])
		addEvent(function()
			if item then
				item:transform(30735)
			end
		end, 10 * 60 * 1000) -- 10 minutos para o item voltar ao normal.
	end
	if item:getActionId() == 57301 then -- Warzone IV
		local spectators = Game.getSpectators(positionItem, false, true, 5, 5, 5, 5)
		for _, spectator in pairs(spectators) do
			if spectator:isPlayer() then
				local playerSpectator = spectator
				if playerSpectator:getStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneIV) < 1 then
					playerSpectator:setStorageValue(Storage.DangerousDepths.Access.LavaPumpWarzoneIV, 1)
				end
			end
		end
		player:say("With the pump destroyed, the lava stream has been stopped. Zone IV is acessible now!", TALKTYPE_MONSTER_SAY, false, false, positionItem)
		item:transform(transformid[item:getId()])
		addEvent(function()
			if item then
				item:transform(30735)
			end
		end, 10 * 60 * 1000) -- 10 minutos para o item voltar ao normal.
	end
	return true
end

dangerousDepthPump:aid(57300,57301,57302)
dangerousDepthPump:register()