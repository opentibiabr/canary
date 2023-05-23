local areas = {
	{ from = Position(33061, 32646, 6), to = Position(33081, 32665, 6) },
	{ from = Position(33027, 32634, 7), to = Position(33081, 32658, 7) },
	{ from = Position(32983, 32616, 7), to = Position(33026, 32631, 7) },
	{ from = Position(33007, 32612, 6), to = Position(33020, 32623, 6) },
	{ from = Position(32987, 32621, 6), to = Position(33043, 32661, 6) },
	{ from = Position(33002, 32614, 5), to = Position(33023, 32642, 5) },
	{ from = Position(32993, 32632, 7), to = Position(33042, 32688, 7) }
}

local adventurersGuildHunt = CreatureEvent("TheGreatDragonHuntKill")
function adventurersGuildHunt.onKill(creature, target)
	if not creature or not creature:isPlayer() then
		return true
	end

	if not target or not target:isMonster() then
		return true
	end

	if isInArray({ 'dragon lord', 'dragon' }, target:getName():lower()) then
		for _, area in ipairs(areas) do
			if creature:getPosition():isInRange(area.from, area.to) then
				creature:setStorageValue(Storage.AdventurersGuild.GreatDragonHunt.DragonCounter, creature:getStorageValue(Storage.AdventurersGuild.GreatDragonHunt.DragonCounter) + 1)
				break
			end
		end
	end
	return true
end

adventurersGuildHunt:register()
