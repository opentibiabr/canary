local theirmastersvoice = GlobalEvent("theirmastersvoice")
function theirmastersvoice.onStartup()
	local eventEnabled = true
	local eventChance = 20
	local function fillFungus(fromPosition, toPosition)
		for x = fromPosition.x, toPosition.x do
			for y = fromPosition.y, toPosition.y do
				local position = Position(x, y, 9)
				local tile = Tile(position)
				if tile then
					local item = tile:getItemById(13590)
					if item then
						local slimeChance = math.random(100)
						if slimeChance <= 30 then
							item:transform(math.random(13585, 13589))
							position:sendMagicEffect(CONST_ME_YELLOW_RINGS)
						end
					end
				end
			end
		end
	end

	if eventEnabled then
		if math.random(100) <= eventChance then
			fillFungus({x = 33306, y = 31847}, {x = 33369, y = 31919})
		end
	end
end
theirmastersvoice:register()
