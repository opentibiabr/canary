local config = {
	[26663] = {storage = GlobalStorage.ForgottenKnowledge.MechanismDiamond, counter = GlobalStorage.ForgottenKnowledge.DiamondServant, msg = "5 diamond entities are consuming too much raw energy for the cosmic chamber to awaken, it will be put to rest again in 10 minutes."},
	[26664] = {storage = GlobalStorage.ForgottenKnowledge.MechanismGolden, counter = GlobalStorage.ForgottenKnowledge.GoldenServant, msg = "5 golden entities are consuming too much raw energy for the cosmic chamber to awaken, it will be put to rest again in 10 minutes."}
}

local function clearGolems()
	local specs, spec = Game.getSpectators(Position(32815, 32874, 13), false, false, 63, 63, 63, 63)
	for i = 1, #specs do
		spec = specs[i]
		if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) < 1 then
			if spec:isMonster() and spec:getName():lower() == 'diamond servant replica' then
				spec:getPosition():sendMagicEffect(CONST_ME_POFF)
				spec:remove()
			end
		end
		if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) < 1 then
			if spec:isMonster() and spec:getName():lower() == 'golden servant replica' then
				spec:getPosition():sendMagicEffect(CONST_ME_POFF)
				spec:remove()
			end
		end
		if spec:isMonster() and spec:getName():lower() == 'iron servant replica' then
			if math.random(100) <= 40 then
				spec:getPosition():sendMagicEffect(CONST_ME_POFF)
				spec:remove()
			end
		end
	end
end

local function turnOff(storage, counter)
	Game.setStorageValue(storage, 0)
	Game.setStorageValue(counter, 0)
	clearGolems()
	local teleport = Tile(Position(32815, 32870, 13)):getItemById(11796)
	if teleport then
		teleport:getPosition():sendMagicEffect(CONST_ME_POFF)
		teleport:remove()
	end
end

local forgottenKnowledgeMechanism = Action()
function forgottenKnowledgeMechanism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = config[item.actionid]
	if item.itemid == 10044 then
		if Game.getStorageValue(lever.storage) >= 1 then
			player:say('seems that the mechanism still active.', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			return true
		end
		clearGolems()
		Game.setStorageValue(lever.storage, 1)
		Game.setStorageValue(lever.counter, 0)
		addEvent(turnOff, 10 * 60 * 1000, lever.storage, lever.counter)
		item:transform(10045)
		player:say('*click*', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, lever.msg)
	elseif item.itemid == 10045 then
		item:transform(10044)
	end
	return true
end

forgottenKnowledgeMechanism:aid(26663,26664)
forgottenKnowledgeMechanism:register()