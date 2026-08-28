function registerHealKeyword(keywordHandler, npcHandler, text, condition, effect, minimumHealth)
	keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = text }, function(player)
		return player:getCondition(condition) ~= nil
	end, function(player)
		if minimumHealth then
			local health = player:getHealth()
			if health < minimumHealth then
				player:addHealth(minimumHealth - health)
			end
		end

		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end)
end
