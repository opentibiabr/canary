function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 1.8) + 11
	local max = (level / 5) + (maglevel * 3) + 19
	return -min, -max
end

local initCombat = Combat()
initCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function createCombat(combat, area, areaDiagonal)
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
	combat:setArea(createCombatArea(area, areaDiagonal))
	return combat
end
local combat = createCombat(initCombat, AREA_BEAM5, AREADIAGONAL_BEAM5)
local combatWOD = createCombat(initCombat, AREA_BEAM7, AREADIAGONAL_BEAM7)

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
spell:id(22)
spell:name("Energy Beam")
spell:words("exevo vis lux")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ENERGY_BEAM)
spell:level(23)
spell:mana(40)
spell:isPremium(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
