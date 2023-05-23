local config = {
	[34315] = {name = 'lovely frazzlemaw', centerPos = Position(33618, 32666, 12)},
	[34316] = {name = 'lovely deer', centerPos = Position(33641, 32666, 12)},
	[34317] = {name = 'lovely rotworm', centerPos = Position(33618, 32684, 12)},
	[34318] = {name = 'lovely scorpion', centerPos = Position(33641, 32684, 12)},
	[34319] = {name = 'lovely snake', centerPos = Position(33618, 32702, 12)},
	[34320] = {name = 'lovely polar bear', centerPos = Position(33641, 32702, 12)},
	[34321] = {name = 'lovely souleater', centerPos = Position(33618, 32720, 12)},
	[34322] = {name = 'lovely yielothax', centerPos = Position(33641, 32720, 12)}
}

local lovelyMonsters = MoveEvent()

function lovelyMonsters.onStepIn(creature, item, position, fromPosition)
	local config = config[item.actionid]
	if not config then
		return true
	end

	if creature:isPlayer() then
		return true
	end

	local monster = creature:getMonster()
	if monster:getName():lower() == config.name then
		monster:say('That seemed correct!', TALKTYPE_MONSTER_SAY)
		monster:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		monster:remove()
		local spectators = Game.getSpectators(config.centerPos, false, true, 9, 9, 9, 9)
		for _, spectator in pairs(spectators) do
			if spectator:isPlayer() then
				local player = spectator
				if player:getStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports) < 0 then
					player:setStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports, 0)
				end
				player:setStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports,
				player:getStorageValue(Storage.FerumbrasAscension.ZamuloshTeleports) + 1)
			end
		end
		return true
	end
	return true
end

lovelyMonsters:type("stepin")

for index, value in pairs(config) do
	lovelyMonsters:aid(index)
end

lovelyMonsters:register()
