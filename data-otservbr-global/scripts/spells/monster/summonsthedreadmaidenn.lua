local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PLANTATTACK)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local blueSoulStealer = Game.createMonster("Green Soul Stealer", {x=creature:getPosition().x+math.random(-15, 15), y=creature:getPosition().y+math.random(-15, 15), z=creature:getPosition().z })
    if not blueSoulStealer then
        return
    end
    blueSoulStealer:say('', TALKTYPE_MONSTER_SAY)
    return combat:execute(creature, var)
end

spell:name("summonsthedreadmaidenn")
spell:words("###1011")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()