dofile(DATA_DIRECTORY .. "/scripts/spells/monster/gaz_functions.lua")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local t, spectator = Game.getSpectators(creature:getPosition(), false, false, 25, 25, 25, 25)
    local check = 0
    if #t ~= nil then
        for i = 1, #t do
            spectator = t[i]
            if spectator:getName() == "Minion of Gaz'haragoth" then
                check = check + 1
            end
        end
    end

    if (check >= GazVariables.MaxSummons) then
        return false
    else
        if (check < GazVariables.MinionsNow) then
            local monster
            for i = 1, (GazVariables.MinionsNow - check) do
                monster = Game.createMonster("Minion of Gaz'haragoth", creature:getPosition(), true, false)
                creature:say("Minions! Follow my call!", TALKTYPE_ORANGE_1)
                if monster then
                    creature:setSummon(monster)
                end
            end
            creature:getPosition():sendMagicEffect(CONST_ME_SOUND_RED)
        else
            if (math.random(0, 100) < 25) then
                local monster = Game.createMonster("Minion of Gaz'haragoth", creature:getPosition(), true, false)
                creature:say("Minions! Follow my call!", TALKTYPE_ORANGE_1)
                if monster then
                    creature:setSummon(monster)
                end
                creature:getPosition():sendMagicEffect(CONST_ME_SOUND_RED)
                GazVariables.MinionsNow = GazVariables.MinionsNow + 1
            end
        end
    end
    return true
end

spell:name("gaz'haragoth summon")
spell:words("###125")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
