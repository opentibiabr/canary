local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_PURPLE)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local config = {
	[1] = { name = "unpleasant dream" },
	[2] = { name = "horrible dream" },
	[3] = { name = "nightmarish dream" },
	[4] = { name = "mind-wrecking dream" },
}

local maxsummons = 5

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local monsterName = ""
	local randomName = math.random(1, #config)
	local randomSummon = math.random(1, 4)
	local summonsKilled = Game.getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunSummonsKilled) or -1

	if summonsKilled >= 0 and summonsKilled <= 9 then
		monsterName = config[1].name
	elseif summonsKilled > 9 and summonsKilled <= 18 then
		monsterName = config[2].name
	elseif summonsKilled > 18 and summonsKilled <= 27 then
		monsterName = config[3].name
	elseif summonsKilled > 27 and summonsKilled <= 36 then
		monsterName = config[4].name
	else
		monsterName = config[randomName].name
	end

	local summoncount = creature:getSummons()

	if #summoncount < maxsummons then
		for i = 1, randomSummon do
			local mid = Game.createMonster(monsterName, creature:getPosition())
			if not mid then
				return
			end
			mid:setMaster(creature)
			mid:registerEvent("dreamCourtsDeath")
		end
	end

	return combat:execute(creature, var)
end

spell:name("alptramun summon")
spell:words("###553")
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
