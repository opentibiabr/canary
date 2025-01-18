local sides = {
	{ fromPosition = Position(32208, 32040, 14), toPosition = Position(32216, 32055, 14) },
	{ fromPosition = Position(32198, 32039, 14), toPosition = Position(32207, 32055, 14) },
}

local changes = {
	[1] = "izcandar champion of winter",
	[2] = "izcandar champion of summer",
}

local function transformIzcandar(cid, name, health, position)
	local creature = Creature(cid)

	if not creature then
		return true
	end

	local id = creature:getId()

	if isInArray({ "izcandar champion of winter", "izcandar champion of summer" }, creature:getName():lower()) then
		creature:remove()
		local oldIzcandar = Game.createMonster("Izcandar the Banished", position, true, true)
		if oldIzcandar then
			oldIzcandar:registerEvent("izcandarThink")
			oldIzcandar:addHealth(-(oldIzcandar:getHealth() - health))
			id = oldIzcandar:getId()
		end
	end

	addEvent(function(cid_)
		local c = Creature(cid_)

		if not c then
			return true
		end

		if isInArray({ "izcandar the banished" }, c:getName():lower()) then
			local h_ = c:getHealth()
			local p_ = c:getPosition()

			c:remove()

			local newIzcandar = Game.createMonster(name, p_, true, true)

			if newIzcandar then
				newIzcandar:registerEvent("izcandarThink")
				newIzcandar:addHealth(-(newIzcandar:getHealth() - h_))
			end
		else
			return true
		end
	end, math.random(10, 20) * 1000, id)
end

local creaturescripts_Izcandar = CreatureEvent("izcandarThink")

function creaturescripts_Izcandar.onThink(creature, interval)
	if not creature:isMonster() then
		return true
	end

	local health = creature:getHealth()
	local position = creature:getPosition()
	local cName = creature:getName():lower()

	if position:isInRange(sides[1].fromPosition, sides[1].toPosition) and not (cName == "izcandar champion of winter") then
		transformIzcandar(creature:getId(), "izcandar champion of winter", health, position)
		Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.izcandarOutfit, 1)
	elseif position:isInRange(sides[2].fromPosition, sides[2].toPosition) and not (cName == "izcandar champion of summer") then
		transformIzcandar(creature:getId(), "izcandar champion of summer", health, position)
		Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.izcandarOutfit, 2)
	end

	return true
end

creaturescripts_Izcandar:register()
