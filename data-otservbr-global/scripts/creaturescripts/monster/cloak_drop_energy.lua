local delayEnergy = {}

function removeEnergy(itemId, position)
    local item = Tile(position):getItemById(itemId)
	if not item then
		return true
	end
    item:remove()
end

function unlockDrop(uid)
    delayEnergy[uid] = nil
end

local cloakDropEnergy = CreatureEvent("cloakDropEnergy")
function cloakDropEnergy.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName()== 'Cloak Of Terror' and not delayEnergy[creature.uid] then
        local pos = creature:getPosition()
        local itemTilePos = Tile(pos):getItemById(34005)
        if not itemTilePos then
            local energy = Game.createItem(34005, 1, pos)
            energy:setActionId(24361)
            delayEnergy[creature.uid] = energy.uid
            addEvent(removeEnergy, 20 * 1000, energy.itemid, pos)
            addEvent(unlockDrop, 5 * 1000, creature.uid)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

cloakDropEnergy:register()

