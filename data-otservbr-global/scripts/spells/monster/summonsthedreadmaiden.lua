local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local blueSoulStealer = Game.createMonster("Blue Soul Stealer", {x=creature:getPosition().x+math.random(-15, 15), y=creature:getPosition().y+math.random(-15, 15), z=creature:getPosition().z })
    if not blueSoulStealer then
        return
    end
    blueSoulStealer:say('', TALKTYPE_MONSTER_SAY)
    return combat:execute(creature, var)
end

spell:name("summonsthedreadmaiden")
spell:words("###1008")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()