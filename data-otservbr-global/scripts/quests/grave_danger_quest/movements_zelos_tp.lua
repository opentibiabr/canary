local zelos_tp = MoveEvent()

function zelos_tp.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local knights = Creature("Nargol The Impaler") or Creature("Magnor Mournbringer") or Creature("The Red Knight") or Creature("Rewar The Bloody") or Creature("Shard Of Magnor") or Creature("Regenerating Mass")

	if knights then
		creature:teleportTo(fromPosition)
	else
		creature:teleportTo(Position(33443, 31536, 13))
	end

	return true
end

zelos_tp:aid(14579)
zelos_tp:register()
