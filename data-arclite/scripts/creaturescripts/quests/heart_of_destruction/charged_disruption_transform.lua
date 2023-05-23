local explodeExhaust = 18 --in seconds
local minionExhaust = {}

local function minionExplode(creature)
    if not creature:isMonster() then
        return true
    end

    local cid = creature:getId()
    local exhaust = minionExhaust[cid]

    if not exhaust then
        minionExhaust[cid] = 1
        return
    end

    if exhaust >= explodeExhaust then
        Game.createMonster("overcharged disruption", creature:getPosition(), false, true)
        creature:remove()
    else
        minionExhaust[cid] = exhaust + 1
    end
end

local chargedDisruptionTransform = CreatureEvent("ChargedDisruptionTransform")
function chargedDisruptionTransform.onThink(creature)
    minionExplode(creature)
end

chargedDisruptionTransform:register()
