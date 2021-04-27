local condition = Condition(CONDITION_INVISIBLE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
local function invisible(fromPosition, toPosition)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			for z = fromPosition.z, toPosition.z do
				local creature = Tile(Position(x, y, z)):getTopCreature()
				if creature then
					if creature:isMonster() and creature:getName():lower() == 'zamulosh' then
						creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						creature:addCondition(condition)
					end
				end
			end
		end
	end
end

function onCastSpell(creature, var)
	invisible(Position(33634, 32749, 11), Position(33654, 32765, 11))
	return
end
