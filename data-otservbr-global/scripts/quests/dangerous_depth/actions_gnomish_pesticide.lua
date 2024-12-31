local dangerousDepthPesticide = Action()

function dangerousDepthPesticide.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:isCreature() then
		return false
	end

	local r = math.random(1, 100)
	local corpseId = 27494
	local posTarget = target:getPosition()

	if target:getId() == corpseId then
		if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw) == 1 and player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount) < 20 then
			if r <= 50 then
				posTarget:sendMagicEffect(CONST_ME_POISONAREA)
				local diremaw = Game.createMonster("Diremaw", target:getPosition())
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount) + 1)
				target:transform(30730)
			else
				posTarget:sendMagicEffect(CONST_ME_POISONAREA)
				player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount, player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount) + 1)
				target:transform(30730)
			end
		end
	elseif table.contains({ 27495, 27496, 27497 }, target:getId()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only half-decayed diremaw corpses can be neutralised with these pesticides.")
		return true
	end

	return true
end

dangerousDepthPesticide:id(27498)
dangerousDepthPesticide:register()
