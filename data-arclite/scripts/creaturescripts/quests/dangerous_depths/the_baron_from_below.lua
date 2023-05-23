local timers = {}

local function summonHungry(creature)
	local monster = Monster(creature)
	local organic = false
	if monster and monster:getName():lower() == "the baron from below" then
		local oldBossHealth = monster:getHealth()
		monster:setType("The Hungry Baron From Below")
		monster:addHealth(-(monster:getHealth() - oldBossHealth))
		monster:teleportTo(Position(33648, 32300, 15))
		local organicMatter = Game.createMonster("organic matter", Position(33647, 32300, 15), true, true)
		if organicMatter then
			organicMatter:registerEvent("OrganicMatterKill")
		end
		if monster and monster:getName():lower() == "the hungry baron from below" then
			monster:addHealth(-(monster:getHealth() - oldBossHealth))
			monster:say("Gulp!", TALKTYPE_MONSTER_SAY)
			addEvent(function()
				if monster then
					monster:say("Gulp!", TALKTYPE_MONSTER_SAY)
				end
			end, 2*1000)
			addEvent(function()
				local spectators = Game.getSpectators(Position(33648, 32303, 15), false, false, 20, 20, 20, 20)
				for _, checagem in pairs(spectators) do
					if checagem then
						if checagem:getName():lower() == "organic matter" then
							organic = true
						end
					end
				end
				if organic == true then
					local organicPosition = organicMatter:getPosition()
					organicMatter:remove()
					local hungryBossHealth = monster:getHealth()
					monster:setType("The Baron From Below")
					monster:addHealth(-(monster:getHealth() - hungryBossHealth))
					monster:addHealth(math.random(10000, 30000))
					for i = 1, 4 do
						Game.createMonster("Aggressive Matter", organicPosition, true, false)
					end
				else
					local hungryBossHealth = monster:getHealth()
					monster:setType("The Baron From Below")
					monster:addHealth(-(monster:getHealth() - hungryBossHealth))
				end
			end, 10*1000)
		end
	end
	timers[creature] = false
end

local theBaronFromBelowThink = CreatureEvent("TheBaronFromBelowThink")
function theBaronFromBelowThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end

	if creature:getName():lower() == "the baron from below" then
		if not timers[creature:getId()] then
			timers[creature:getId()] = addEvent(summonHungry, 30*1000, creature:getId())
		end
	end
	return true
end

theBaronFromBelowThink:register()

local organicMatterKill = CreatureEvent("OrganicMatterKill")
function organicMatterKill.onKill(player, creature)
	if not player:isPlayer() then
		return true
	end

	if not creature:isMonster() then
		return true
	end

	if creature:getName():lower() == "organic matter" then
		for i = 1, 4 do
			Game.createMonster("aggressive matter", creature:getPosition(), true, false)
		end
	end
end

organicMatterKill:register()
