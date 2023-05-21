local taskTruffles = MoveEvent()

function taskTruffles.onStepIn(creature, item, position, fromPosition)
	if creature:getName():lower() ~= 'mushroom sniffer' then
		return true
	end

	local moldFloor = Tile(position):getItemById(15829)
	if moldFloor.actionid == 100 then
		return true
	end

	if math.random(3) < 3 then
		moldFloor:transform(15701)
		moldFloor:decay()
		position:sendMagicEffect(CONST_ME_POFF)
	else
		moldFloor:transform(15830)
		moldFloor:decay()
		position:sendMagicEffect(CONST_ME_GROUNDSHAKER)
	end
	return true
end

taskTruffles:type("stepin")
taskTruffles:id(15829)
taskTruffles:register()
