local callback = EventCallback("MonsterOnDropLootGemAtelier")

function callback.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	corpse:addLoot(monster:generateGemAtelierLoot())
end

callback:register()
