local necromanticMinion = CreatureEvent("NecromanticMinion")
function necromanticMinion.onThink(creature)
    addEvent(function(cid)
        local creature = Creature(cid)
        if not creature then
            return
        end
        local pos = creature:getPosition()
        pos:sendMagicEffect(CONST_ME_MORTAREA)
        creature:remove()
        local summon = Game.createMonster("necromantic energy", pos, false, true)
        if not summon then
            return
        end
        return true
    end, 7000, creature:getId())
end
necromanticMinion:register()
