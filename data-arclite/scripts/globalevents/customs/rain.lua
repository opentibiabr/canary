if configManager.getBoolean(configKeys.WEATHER_RAIN) then
	local weatherStartup = GlobalEvent("WeatherStartup")

	function weatherStartup.onStartup()
		local rain = math.random(100)
		if rain > 95 then
			Game.setStorageValue('Weather', 1)
		else
			Game.setStorageValue('Weather', 0)
		end
		return true
	end

	weatherStartup:register()

	local weather = GlobalEvent("Weather")

	function weather.onThink(interval, lastExecution)
		local rain = math.random(100)
		if rain > 95 then
			Game.setStorageValue('Weather', 1)
		else
			Game.setStorageValue('Weather', 0)
		end
		return true
	end

	weather:interval(200000) -- how often to randomize rain / weather
	weather:register()

	local weatherRain = GlobalEvent("WeatherRain")

	function weatherRain.onThink(interval, lastExecution)
		if Game.getStorageValue('Weather') == 1 then
			local players = Game.getPlayers()
			if #players == 0 then
				return true
			end
			local player
			for i = 1, #players do
				player = players[i]
				player:sendWeatherEffect(weatherConfig.groundEffect, weatherConfig.fallEffect, weatherConfig.thunderEffect)
			end
		end
		return true
	end

	weatherRain:interval(50) -- less rain = greater value
	weatherRain:register()
end
