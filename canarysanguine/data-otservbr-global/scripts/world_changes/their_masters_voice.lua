local theirMastersVoiceEvent = GlobalEvent("TheirMastersVoice")

function theirMastersVoiceEvent.onStartup()
	if math.random(100) <= 20 then
		for x = 33306, 33369 do
			for y = 31847, 31919 do
				local position = Position(x, y, 9)
				local tile = Tile(position)
				if tile then
					local fungus = tile:getItemById(12065)
					if fungus and math.random(100) <= 30 then
						fungus:transform(math.random(12059, 12063))
						fungus:getPosition():sendMagicEffect(CONST_ME_YELLOW_RINGS)
					end
				end
			end
		end
	end
end

theirMastersVoiceEvent:register()
