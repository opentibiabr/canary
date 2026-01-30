local ambientZones = {
	{
		zone = "venore-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_WIND_NOISES_CREATURES_INSECTS_NIGHT,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	{
		zone = "thais-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES_CITY,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_WIND_NOISES_CREATURES_INSECTS_NIGHT,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	{
		zone = "carlin-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_SWAMP_INSECTS_BIRDS_NOISES_CITY,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_WIND_NOISES_CREATURES_INSECTS_NIGHT,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	{
		zone = "edron-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_INSECTS_CREATURES,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_INSECTS_CREATURES_NIGHT,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	{
		zone = "kazordoon-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_CAVE_WIND_NOISES,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_CAVE_HAMMERING_NOISES_HAMMERING,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	{
		zone = "port-hope-city",
		soundEnterDay = SOUND_EFFECT_TYPE_AMBIENT_CITY_NATURE_HUMANS,
		soundEnterNight = SOUND_EFFECT_TYPE_AMBIENT_NATURE_NIGHT,
		soundLeave = SOUND_EFFECT_TYPE_AMBIENT_SILENCE,
	},
	-- add new zones
}

-- Function to get the current sound based on period
local function getCurrentSound(zoneData, period)
	if period == LIGHT_STATE_NIGHT then
		return zoneData.soundEnterNight
	elseif period == LIGHT_STATE_SUNRISE then
		return zoneData.soundEnterDay
	elseif period == LIGHT_STATE_SUNSET then
		return zoneData.soundEnterNight
	end
	return zoneData.soundEnterDay -- Fallback to day sound if period is undefined
end

-- Function to determine the current period, respecting forcePeriod
local function getEffectivePeriod()
	if forcePeriod then
		return forcePeriod == "night" and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
	end
	return getTibiaTimerDayOrNight() == "night" and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
end

-- Register zone enter/leave events
for _, zoneData in ipairs(ambientZones) do
	local zone = Zone(zoneData.zone)
	local zoneEvent = ZoneEvent(zone)

	function zoneEvent.afterEnter(_, creature)
		local player = creature:getPlayer()
		if player then
			local currentPeriod = getEffectivePeriod()
			local sound = getCurrentSound(zoneData, currentPeriod)
			if sound then
				player:sendAmbientSoundEffect(sound)
				return true
			end
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

-- Global event to handle period changes
local ambientSoundPeriodChange = GlobalEvent("AmbientSoundPeriodChange")

function ambientSoundPeriodChange.onPeriodChange(period)
	for _, zoneData in ipairs(ambientZones) do
		local zone = Zone(zoneData.zone)
		local players = zone:getPlayers()
		local sound = getCurrentSound(zoneData, period)
		if sound then
			for _, player in ipairs(players) do
				if player:isPlayer() then
					player:sendAmbientSoundEffect(sound)
				end
			end
		end
	end
	return true
end

ambientSoundPeriodChange:register()
