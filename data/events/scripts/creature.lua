function Creature:onChangeOutfit(outfit)
	local ec = EventCallback.onChangeOutfit
	if ec then
		return ec(self, outfit)
	end
	return true
end

function Creature:onHear(speaker, words, type)
	local ec = EventCallback.onHear
	if ec then
		ec(self, speaker, words, type)
	end
end

function Creature:onAreaCombat(tile, isAggressive)
	local ec = EventCallback.onAreaCombat
	if ec then
		return ec(self, tile, isAggressive)
	end
	return true
end

function Creature:onTargetCombat(target)
	local ec = EventCallback.onTargetCombat
	if ec then
		return ec(self, target)
	return true
end

function Creature:onDrainHealth(attacker, typePrimary, damagePrimary,
				typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	local ec = EventCallback.onDrainHealth
	if ec then
		return ec(self, attacker, typePrimary, damagePrimary,
				typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	end
	return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
end
