local area = createCombatArea({
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 0, 3, 0, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1 },
})

local combat = Combat()
combat:setArea(area)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)

function onTargetTile(creature, position)
	local duration = 16000
	local creaturesOnTile = Tile(position):getCreatures()
	if creaturesOnTile and #creaturesOnTile > 0 then
		for _, creatureUid in pairs(creaturesOnTile) do
			local creature = Creature(creatureUid)
			if creature then
				if creature:isMonster() and creature:getType():getTargetDistance() > 1 then
					creature:changeTargetDistance(1, duration)
				end
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local spectators = Game.getSpectators(creature:getPosition(), false, false)
	for _, spectator in pairs(spectators) do
		if spectator then
			if spectator:isMonster() and spectator:getType():isRewardBoss() then
				creature:sendCancelMessage("You can't use this spell if there's a boss.")
				creature:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			end
		end
	end

	if not combat:execute(creature, variant) then
		creature:sendCancelMessage("There are no ranged monsters.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return true
end

spell:group("support")
spell:id(280)
spell:name("Balanced Brawl")
spell:words("exori mas res")
spell:level(175)
spell:mana(80)
spell:needDirection(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:groupCooldown(2000)
spell:cooldown(10000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
