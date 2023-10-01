local entrance = Action()

function entrance.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item:getActionId() == 27508 then
			player:teleportTo(Position(33636, 32840, 15))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   elseif item:getActionId() == 27509 then
      player:teleportTo(Position(33764, 32908, 15))
      player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   elseif item:getActionId() == 27510 then
      player:teleportTo(Position(33662, 32976, 15))
      player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   elseif item:getActionId() == 27511 then
      player:teleportTo(Position(33542, 32912, 15))
      player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   elseif item:getActionId() == 27512 then
      player:teleportTo(Position(33545, 32911, 15))
      player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   elseif item:getActionId() == 27513 then
      player:teleportTo(Position(33548, 32912, 15))
      player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
   end
		end

entrance:aid(27508, 27509, 27510, 27511, 27512, 27513)
entrance:register()
