local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

function spellCallbackTemp(param)
	local tile = Tile(Position(param.pos))
	if tile then
		if tile:getTopCreature() and tile:getTopCreature():isMonster() then
			if tile:getTopCreature():getName():lower() == "the duke of the depths" then
				tile:getTopCreature():addHealth(math.random(0, 5000))
			end
		elseif tile:getTopCreature() and tile:getTopCreature():isPlayer() then
			tile:getTopCreature():addHealth(- math.random(0, 1500))
		end
	end
end

function onTargetTile(cid, pos)
	local param = {}
	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackTemp(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function suicideHeart(creature)
	local monster = Creature(creature)
	if monster then
		local monsterPos = monster:getPosition()
		monster:remove()
		local fieryBlood = Game.createMonster("fiery blood", monsterPos, true, true)
		if fieryBlood then
			local var = {type = 1, number = fieryBlood:getId()}
			combat:execute(fieryBlood, var)
		end
	end
end

local fieryHeartThink = CreatureEvent("FieryHeartThink")
function fieryHeartThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end
	local contadorHearts = 0
	local bossId
	if creature:getName():lower() == "the duke of the depths" then
		bossId = Creature(creature:getId())
		local spectators = Game.getSpectators(creature:getPosition(), false, false, 20, 20, 20, 20)
		for _, spectator in pairs(spectators) do
			if spectator:getName():lower() == "fiery heart" then
				contadorHearts = contadorHearts + 1
			end
		end
		if contadorHearts < 1 then
			if bossId then
				local oldBossHealth = bossId:getHealth()
				local oldBossPosition = bossId:getPosition()
				bossId:remove()
				local newBoss = Game.createMonster("the duke of the depths", oldBossPosition, true, true)
				if newBoss then
					newBoss:registerEvent("the duke heal fire damage")
					newBoss:addHealth(-(newBoss:getHealth() - oldBossHealth))
				end
			end
		end
	end

	if creature:getName():lower() == "fiery heart" then
		if creature then
			addEvent(suicideHeart, 20*1000, creature:getId())
		end
	end

	return true
end

fieryHeartThink:register()
