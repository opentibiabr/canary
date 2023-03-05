WheelOfDestinySystem.bonus.paladin = {
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_200] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_200)) then
            reference.instant.positionalTatics = true -- Positional Tatics
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ICE] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ICE] + (200) -- 2%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100)) then
            reference.leech.lifeLeech = reference.leech.lifeLeech + (0.75) -- 0,75%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100)) then
            reference.skills.distance = reference.skills.distance + (1) -- 1
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150)) then
            reference.leech.manaLeech = reference.leech.manaLeech + (0.25) -- 0,25%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_200] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_200)) then
            table.insert(reference.spells, "Sharpshooter")
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150)) then
            reference.leech.manaLeech = reference.leech.manaLeech + (0.25) -- 0,25%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            table.insert(reference.spells, "Strong Ethereal Spear")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] + (100) -- 1%
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] + (100) -- 1%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] + (200) -- 2%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            table.insert(reference.spells, "Divine Dazzle")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] + (100) -- 1%
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] + (100) -- 1%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100)) then
            table.insert(reference.spells, "Swift Foot")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75)) then
            reference.skills.distance = reference.skills.distance + (1) -- 1
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_GREEN_50] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_GREEN_50)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_EARTH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_EARTH] + (200) -- 2%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_RED_50] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_50)) then
            table.insert(reference.spells, "Divine Caldera")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75)) then
            reference.leech.lifeLeech = reference.leech.lifeLeech + (0.75) -- 0,75%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_FIRE] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_FIRE] + (200) -- 2%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] + (200) -- 2%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75)) then
            reference.leech.manaLeech = reference.leech.manaLeech + (0.25) -- 0,25%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_50] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_50)) then
            table.insert(reference.spells, "Sharpshooter")
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ICE] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ICE] + (200) -- 2%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75)) then
            reference.skills.distance = reference.skills.distance + (1) -- 1
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100)) then
            table.insert(reference.spells, "Strong Ethereal Spear")
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] + (100) -- 1%
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] + (100) -- 1%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            table.insert(reference.spells, "Divine Dazzle")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_FIRE] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_FIRE] + (200) -- 2%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] + (100) -- 1%
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] + (100) -- 1%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            table.insert(reference.spells, "Swift Foot")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150)) then
            reference.leech.lifeLeech = reference.leech.lifeLeech + (0.75) -- 0,75%
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_200] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_200)) then
            table.insert(reference.spells, "Divine Caldera")
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150)) then
            reference.leech.lifeLeech = reference.leech.lifeLeech + (0.75) -- 0,75%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100] = {get = function(player, points, reference)
        reference.mitigation = reference.mitigation + (0.03*points) -- 0,03%
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100)) then
            reference.skills.distance = reference.skills.distance + (1) -- 1
        end
    end},

    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100] = {get = function(player, points, reference)
        reference.stats.capacity = reference.stats.capacity + (4*points) -- 4
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100)) then
            reference.leech.manaLeech = reference.leech.manaLeech + (0.25) -- 0,25%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150] = {get = function(player, points, reference)
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150)) then
            reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_EARTH] = reference.resistance[WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_EARTH] + (200) -- 2%
        end
    end},
    [WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200] = {get = function(player, points, reference)
        reference.stats.health = reference.stats.health + (2*points) -- 2
        reference.stats.mana = reference.stats.mana + (3*points) -- 3
        if (points == WheelOfDestinySystem.getMaxPointsPerSlot(WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200)) then
            reference.instant.ballisticMastery = true -- Ballistic Mastery
        end
    end}
}
