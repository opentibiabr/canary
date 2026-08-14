local callback = EventCallback("TaskboardMonsterOnDropLoot")

function callback.monsterOnDropLoot(monster, corpse)
	local taskboard = rawget(_G, "Taskboard")
	if not taskboard or not taskboard.isEnabled() or not monster or not corpse then
		return
	end

	local player = Player(corpse:getCorpseOwner())
	if not player then
		return
	end

	local monsterType = monster:getType()
	if not monsterType then
		return
	end

	taskboard.onMonsterKilled(player, monsterType:raceId())
end

callback:register()
