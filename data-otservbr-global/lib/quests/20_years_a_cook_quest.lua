TwentyYearsACookQuest = {
    TheRestOfRatha = {
        MissionZone = Zone("mission.the-rest-of-ratha"),
        BossZone = Zone("boss.the-rest-of-ratha"),
        Items = {
            GhostItem = 44598,
            EmptySpiritFlask = 44527,
            FullSpiritFlask = 44528,
            Harp = 44599,
            HarpCooldown = 44600,
        },
        FlaskBoxUID = 62134,
        SpiritContainerPoints = 0,
    },
}

-- Initializing zones
TwentyYearsACookQuest.TheRestOfRatha.MissionZone:addArea({ x = 33303, y = 31425, z = 15 }, { x = 33327, y = 31445, z = 15 })
TwentyYearsACookQuest.TheRestOfRatha.BossZone:addArea({ x = 33303, y = 31388, z = 15 }, { x = 33327, y = 31408, z = 15 })
