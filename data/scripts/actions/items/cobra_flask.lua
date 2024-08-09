local applyCobraFlaskEffectOnMonsterSpawn = EventCallback("CobraFlaskEffectOnMonsterSpawn")

applyCobraFlaskEffectOnMonsterSpawn.monsterOnSpawn = function(monster, position)
	if table.contains({ "cobra scout", "cobra vizier", "cobra assassin" }, monster:getName():lower()) then
		if Game.getStorageValue(Global.Storage.CobraFlask) >= os.time() then
			monster:setHealth(monster:getMaxHealth() * 0.75)
			monster:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		else
			Game.setStorageValue(Global.Storage.CobraFlask, -1)
		end
	end
	return true
end

applyCobraFlaskEffectOnMonsterSpawn:register()

local cobraFlask = Action()

function cobraFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({ 31284, 31285, 31286, 31287 }, target:getId()) then
		target:getPosition():sendMagicEffect(CONST_ME_GREENSMOKE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You carefully pour just a tiny, little, finely dosed... and there goes the whole content of the bottle. Stand back!")
		item:transform(31297)
		Game.setStorageValue(Global.Storage.CobraFlask, os.time() + 30 * 60)
	end
	return true
end

cobraFlask:id(31296)
cobraFlask:register()

local cobraFlask = Action()

function cobraFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({ 4188, 4189, 4190 }, target:getId()) then
		item:transform(31296)
	end
	return true
end

cobraFlask:id(31297)
cobraFlask:register()
