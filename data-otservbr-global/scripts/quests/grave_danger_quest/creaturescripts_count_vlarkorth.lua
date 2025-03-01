local config = {
	centerRoom = Position(33456, 31437, 13),
	newPosition = Position(33457, 31442, 13),
	exitPos = Position(33195, 31696, 8),
	x = 10,
	y = 10,
	summons = {
		[1] = { summon = "Dark Sorcerer" },
		[2] = { summon = "Dark Druid" },
		[3] = { summon = "Dark Paladin" },
		[4] = { summon = "Dark Knight" },
	},
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorth.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorth.Room,
}

local function summonDarks()
	local spectators = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	local boss = Creature("Count Vlarkorth")
	if not boss then
		return false
	end

	if #spectators > 0 then
		for _, player in pairs(spectators) do
			local vocationId = player:getVocation():getBase():getId()
			local toSummon = config.summons[vocationId]
			if toSummon then
				local newPosition = boss:getClosestFreePosition(boss:getPosition(), true)
				if newPosition then
					local dark = Game.createMonster(toSummon.summon, newPosition, false, true)
					if dark then
						local summonCount = boss:getStorageValue(3)
						boss:setStorageValue(3, math.max(0, summonCount) + 1)
					end
				end
			end
		end
		boss:say("Face your own darkness!")
	end

	return true
end

local count_vlarkorth_transform = CreatureEvent("count_vlarkorth_transform")

function count_vlarkorth_transform.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	local players = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	for _, player in pairs(players) do
		if player:isPlayer() then
			if player:getStorageValue(config.timer) < os.time() then
				player:setStorageValue(config.timer, os.time() + 20 * 3600)
			end
			if player:getStorageValue(config.room) < os.time() then
				player:setStorageValue(config.room, os.time() + 30 * 60)
			end
		end
	end

	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local health = creature:getMaxHealth() * 0.15
	local damageStorage = creature:getStorageValue(1)
	if damageStorage < 0 then
		creature:setStorageValue(1, 0)
		damageStorage = 0
	end

	if creature:getStorageValue(3) > 0 then
		creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	creature:setStorageValue(1, damageStorage + primaryDamage + secondaryDamage)

	if creature:getStorageValue(1) >= health then
		creature:setStorageValue(1, 0)
		creature:setStorageValue(3, 0)
		summonDarks()
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

count_vlarkorth_transform:register()
