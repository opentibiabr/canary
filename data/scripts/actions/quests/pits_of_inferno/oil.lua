local bridgePosition = Position(32801, 32336, 11)

local function revertBridge()
	Tile(bridgePosition):getItemById(5770):transform(493)
end

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

local pitsOfInfernoOil = Action()
function pitsOfInfernoOil.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return false
	end

	if not Tile(Position(32800, 32339, 11)):getItemById(2016, 11) then
		player:say('The lever is creaking and rusty.', TALKTYPE_MONSTER_SAY)
		return true
	end

	local water = Tile(bridgePosition):getItemById(493)
	if water then
		water:transform(5770)
		addEvent(revertBridge, 10 * 60 * 1000)
	end

	item:transform(1946)
	addEvent(revertLever, 10 * 60 * 1000, toPosition)
	return true
end

pitsOfInfernoOil:uid(1037)
pitsOfInfernoOil:register()