local info = {
	stages = {
		{ p = 75, v = 1 },
		{ p = 50, v = 2 },
		{ p = 25, v = 3 },
	},
	stg = Storage.Quest.U11_80.TheSecretLibrary.Library.Ghulosh,
}

local function nextStage(storage)
	if Game.getStorageValue(storage) < 1 then
		Game.setStorageValue(storage, 1)
	end
	Game.setStorageValue(storage, Game.getStorageValue(storage) + 1)
end

local creaturescripts_library_ghulosh = CreatureEvent("ghuloshThink")

function creaturescripts_library_ghulosh.onThink(creature, interval)
	local stage = 0

	for _, k in pairs(info.stages) do
		if Game.getStorageValue(info.stg) == k.v then
			stage = k.p
		end
	end

	local position = creature:getPosition()
	local cHealth = creature:getHealth()
	local percentageHealth = (cHealth / creature:getMaxHealth()) * 100

	if percentageHealth <= stage then
		local monster = Game.createMonster("ghulosh' deathgaze", position, true)
		nextStage(info.stg)
		creature:remove()
		if monster then
			monster:addHealth(-(monster:getHealth() - cHealth))
			monster:say("FEEL MY WRATH!!", TALKTYPE_MONSTER_SAY)
		end
	end
end

creaturescripts_library_ghulosh:register()

local function doSpawn(monster, k, position)
	if k <= 4 then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		k = k + 1
		addEvent(doSpawn, 2 * 1000, monster, k, position)
	else
		local monster = Game.createMonster(monster, position)
	end
end

local creaturescripts_library_ghulosh = CreatureEvent("ghuloshDeath")

function creaturescripts_library_ghulosh.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local cPos = creature:getPosition()

	if creature:getName():lower() == "the book of death" then
		Game.createMonster("Concentrated Death", cPos)
	elseif creature:getName():lower() == "concentrated death" then
		addEvent(doSpawn, 4 * 1000, "The Book of Death", 1, Position(32755, 32716, 10))
	end
end

creaturescripts_library_ghulosh:register()
