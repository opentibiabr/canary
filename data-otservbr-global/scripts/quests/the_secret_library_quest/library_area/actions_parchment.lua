local deskPosition = Position(32743, 32689, 10)
local center = Position(32751, 32689, 10)

local function isStuck(mustFree)
	local c = Tile(center):getTopCreature()

	if c and c:isMonster() then
		if c:getName():lower() == "lokathmor" and c:getSpeed() == 0 then
			if mustFree then
				c:say("THE DISCHARGE OF THE BOOK BREAKS LOKATHMORS STANCE!", TALKTYPE_MONSTER_SAY)
				local cHealth = c:getHealth()
				local monster = Game.createMonster("Lokathmor", center, true)
				c:remove()
				if monster then
					monster:addHealth(-(monster:getHealth() - cHealth))
				end
			else
				return true
			end
		end
	end

	return false
end

local function freeRoom()
	local spectators = Game.getSpectators(center, false, false, 9, 9, 9, 9)
	for _, p in pairs(spectators) do
		if p and p:isMonster() then
			if p:getName():lower() == "force field" then
				p:remove()
			end
		end
	end

	isStuck(true)
end

local actions_library_parchment = Action()

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition == deskPosition then
		if isStuck(false) then
			player:say("THE DARK KNOWLEDGE PILLS THE BOOK WITH RAW POWER. READY TO BE UNLEASHED!", TALKTYPE_MONSTER_SAY)
			freeRoom()
			item:remove(1)
		end
	end

	return true
end

actions_library_parchment:id(28488)
actions_library_parchment:register()
