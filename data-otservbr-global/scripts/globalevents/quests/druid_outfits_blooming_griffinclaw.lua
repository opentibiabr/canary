local flowerPosition = Position(32024, 32830, 4)

local function decayFlower(tile)
	local item = tile:getItemById(5658)
	if tile and item then
		item:transform(5687)
	end
end

local function bloom()
	if math.random(7) ~= 1 then
		addEvent(bloom, 60 * 60 * 1000)
		return
	end

	local tile = Tile(flowerPosition)
	if not tile then
		return false
	end
	local item = tile:getItemById(5687)
	if item then
		item:transform(5658)
		flowerPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
	end

	local bloomHours = math.random(2, 6)
	addEvent(decayFlower, bloomHours * 60 * 60 * 1000, tile)
	addEvent(bloom, bloomHours * 60 * 60 * 1000)
end

local druidOutfit = GlobalEvent("blooming griffinclaw")

function druidOutfit.onStartup()
	bloom()
	return true
end

druidOutfit:register()
