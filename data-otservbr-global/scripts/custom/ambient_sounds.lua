local ambientZones = {
    {
        zone = "venore-city",
        soundEnter = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES,
        soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE
    },
    {
        zone = "thais-city",
        soundEnter = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES_CITY,
        soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE
    },
    {
        zone = "carlin-city",
        soundEnter = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES_CITY,
        soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE
    },
    {
        zone = "edron-city",
        soundEnter = SOUND_EFFECT_TYPE_AMBIENT_INSECTS_CREATURES,
        soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE
    },
    {
        zone = "kazordoon-city",
        soundEnter = SOUND_EFFECT_TYPE_AMBIENT_CAVE_WIND_NOISES,
        soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE
    },
    {
        zone = "port-hope-city",
        soundEnter = SOUND_EFFECT_TYPE_SPELL_WHIRLWIND_THROW,
        soundLeave = SOUND_EFFECT_TYPE_SPELL_ENERGY_WAVE
    }
    -- Adicione mais zonas conforme necessário
}

for _, zoneData in ipairs(ambientZones) do
    local zone = Zone(zoneData.zone)
    local zoneEvent = ZoneEvent(zone)

    function zoneEvent.afterEnter(_, creature)
        local player = creature:getPlayer()
        if player and zoneData.soundEnter then
            player:sendAmbientSoundEffect(zoneData.soundEnter)
            return true
        end
        return false
    end

    function zoneEvent.afterLeave(_, creature)
        local player = creature:getPlayer()
        if player then
            player:sendAmbientSoundEffect(zoneData.soundLeave or 0)
            return true
        end
        return false
    end

    zoneEvent:register()
end