local function getDiagonalDistance(pos1, pos2)
	local dstX = math.abs(pos1.x - pos2.x)
	local dstY = math.abs(pos1.y - pos2.y)
	if dstX > dstY then
		return 14 * dstY + 10 * (dstX - dstY)
	else
		return 14 * dstX + 10 * (dstY - dstX)
	end
end
local function chain(player)
	local creatures = Game.getSpectators(player:getPosition(), false, false, 6, 6, 6, 6)
	local totalChain = 0
	local monsters = {}
	for _, creature in pairs(creatures) do
		if creature:isMonster() then
			if creature:getType():isRewardBoss() then
				return -1
			elseif creature:getMaster() == nil and creature:getType():getTargetDistance() > 1 then
				table.insert(monsters, creature)
			end
		end
	end
	local lastChain = player
	local lastChainPosition = player:getPosition()
	local closestMonster, closestMonsterIndex, closestMonsterPosition
	local path, tempPosition, updateLastChain
	while (totalChain < 3 and #monsters > 0) do
		closestMonster = nil
		for index, monster in pairs(monsters) do
			tempPosition = monster:getPosition()
			if not closestMonster or getDiagonalDistance(lastChain:getPosition(), tempPosition) < getDiagonalDistance(lastChain:getPosition(), closestMonsterPosition) then
				closestMonster = monster
				closestMonsterIndex = index
				closestMonsterPosition = tempPosition
			end
		end
		table.remove(monsters, closestMonsterIndex)
		updateLastChain = false
		if lastChainPosition:getDistance(closestMonsterPosition) == 1 then
			updateLastChain = true
		else
			path = lastChainPosition:getPathTo(closestMonsterPosition, 0, 1, true, true, 9)
			if path and #path > 0 then
				for i=1, #path do
					lastChainPosition:getNextPosition(path[i], 1)
					lastChainPosition:sendMagicEffect(CONST_ME_DIVINE_DAZZLE)
				end
				updateLastChain = true
			end
		end
		if updateLastChain then
			closestMonsterPosition:sendMagicEffect(CONST_ME_DIVINE_DAZZLE)
			closestMonster:changeTargetDistance(1)
			lastChain = closestMonster
			lastChainPosition = closestMonsterPosition
			totalChain = totalChain + 1
		end
	end
	return totalChain
end
function onCastSpell(creature, variant)
	local total = chain(creature)
	if total > 0 then
		return true
	elseif total == -1 then
		creature:sendCancelMessage("You can't use this spell if there's a boss.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	else
		creature:sendCancelMessage("There are no ranged monsters.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
end