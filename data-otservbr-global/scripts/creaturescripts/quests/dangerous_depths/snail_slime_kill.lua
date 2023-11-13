local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local monsters = {
	"the count of the core",
}

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= cid then
			targetName = target:getName():lower()
			casterName = cid:getName():lower()
			if table.contains(monsters, targetName) and casterName ~= targetName then
				target:addHealth(math.random(0, 2000))
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function summonSlimes(master)
	local count = 0
	local slimeCheck = Game.getSpectators(master:getPosition(), false, false, 20, 20, 20, 20)
	for _, slime in pairs(slimeCheck) do
		if slime:isMonster() then
			if slime:getName():lower() == "snail slime" then
				count = count + 1
			end
		end
	end
	if count < 3 then
		Game.createMonster("Snail Slime", master:getPosition(), true)
	end
end

local snailSlimeThink = CreatureEvent("SnailSlimeThink")
function snailSlimeThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end
	if creature:getName():lower() == "the count of the core" then
		local percHealth = (creature:getHealth() / creature:getMaxHealth()) * 100
		if percHealth <= 50 then
			summonSlimes(creature)
		end
	end
	return true
end

snailSlimeThink:register()

local snailSlimeKill = CreatureEvent("SnailSlimeDeath")
function snailSlimeKill.onDeath(creature)
	creature:say("!!", TALKTYPE_ORANGE_2)
	local var = { type = 1, number = creature:getId() }
	combat:execute(creature, var)
	return true
end

snailSlimeKill:register()
