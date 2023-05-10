function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4)
	local max = (level / 5) + (maglevel * 7)
	return -min, -max
end

local initCombat = Combat()
initCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function createCombat(combat, area)
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
	combat:setArea(createCombatArea(AREA_BEAM8))
	return combat
end

local combat = createCombat(initCombat, AREA_BEAM8)
local combatWOD = createCombat(initCombat, AREA_BEAM10)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if creature and player and player:instantSkillWOD("Beam Mastery") then
		var.runeName = "Beam Mastery"
		return combatWOD:execute(creature, var)
	end

	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(23)
spell:name("Great Energy Beam")
spell:words("exevo gran vis lux")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_GREAT_ENERGY_BEAM)
spell:level(29)
spell:mana(110)
spell:isPremium(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
