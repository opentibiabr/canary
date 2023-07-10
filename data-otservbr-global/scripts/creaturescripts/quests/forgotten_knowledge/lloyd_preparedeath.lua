local monsters = {
	{cosmicNormal = 'cosmic energy prism a', cosmicInvu = 'cosmic energy prism a invu', pos = Position(32801, 32827, 14)},
	{cosmicNormal = 'cosmic energy prism b', cosmicInvu = 'cosmic energy prism b invu', pos = Position(32798, 32827, 14)},
	{cosmicNormal = 'cosmic energy prism c', cosmicInvu = 'cosmic energy prism c invu', pos = Position(32803, 32826, 14)},
	{cosmicNormal = 'cosmic energy prism d', cosmicInvu = 'cosmic energy prism d invu', pos = Position(32796, 32826, 14)}
}

local function revertLloyd(prismId)
	local lloydTile = Tile(Position(32799, 32826, 14))
	if lloydTile then
		local lloyd = lloydTile:getTopCreature()
		lloyd:teleportTo(Position(32799, 32829, 14))
		lloyd:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	Tile(monsters[prismId].pos):getTopCreature():remove()
	Game.createMonster(monsters[prismId].cosmicInvu, Position(monsters[prismId].pos), true, true)
end

local lloydPrepareDeath = CreatureEvent("LloydPrepareDeath")
function lloydPrepareDeath.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	local targetMonster = creature:getMonster()
	if not creature or not targetMonster then
		return true
	end

    local prismCount = 1
    for m = 1, #monsters do
        local cosmic = Tile(Position(monsters[m].pos)):getTopCreature()
        if not cosmic then
            prismCount = prismCount + 1
        end
    end

    local reborn = false
    if prismCount <= 4 then
        Tile(monsters[prismCount].pos):getTopCreature():remove()
        Game.createMonster(monsters[prismCount].cosmicNormal, Position(monsters[prismCount].pos), true, true)
        reborn = true
    end

    if reborn then
        creature:teleportTo(Position(32799, 32826, 14))
        creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        creature:addHealth(300000, true)
        creature:say('The cosmic energies in the chamber refocus on Lloyd.', TALKTYPE_MONSTER_SAY)
        Storage.ForgottenKnowledge.LloydEvent = addEvent(revertLloyd, 10 * 1000, prismCount)
    end
    return true
end
lloydPrepareDeath:register()
