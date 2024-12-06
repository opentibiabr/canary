local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local hasCasted = Game.getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.LastBossCurse)

	if hasCasted == 0 then
		local players = Game.getSpectators(cid:getPosition(), false, true, 14, 14, 14, 14)
		local randomNumber = math.random(1, #players)

		for _, k in pairs(players) do
			local player = Player(k)
			if player then
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse, -1)
			end
		end

		local newPlayer = Player(players[randomNumber]:getId())

		newPlayer:registerEvent("nightmareCurse")
		newPlayer:setStorageValue("nightmareCurse", 1)
		newPlayer:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse, 1)
		newPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The beast laid a terrible curse on you!")

		Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.LastBossCurse, 1)
	end
end

spell:name("nightmare beast curse")
spell:words("###560")
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
