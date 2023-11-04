-- Utility to combine onDeath event with a "kill" event for a player with a party (or not).

function onDeathForParty(creature, player, func)
	if not player or not player:isPlayer() then
		return
	end

	local participants = Participants(player, true)
	for _, participant in ipairs(participants) do
		func(creature, participant)
	end
end

function onDeathForDamagingPlayers(creature, func)
	for key, value in pairs(creature:getDamageMap()) do
		local player = Player(key)
		if player then
			func(creature, player)
		end
	end
end
