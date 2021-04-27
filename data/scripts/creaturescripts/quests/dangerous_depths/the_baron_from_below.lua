local function summonHungry(creature)
	local monster = Creature(creature)
	local organic = false
	if monster then
		monster:remove()
		local hungryBoss = Game.createMonster("the hungry baron from below", Position(33648, 32300, 15), true, true)
		local organicMatter = Game.createMonster("organic matter", Position(33647, 32300, 15), true, true)
		if hungryBoss then
			hungryBoss:registerEvent("the baron from below think")
			hungryBoss:addHealth(-(hungryBoss:getHealth() - monster:getHealth()))
			hungryBoss:say("Gulp!", TALKTYPE_MONSTER_SAY)
			addEvent(function()
				if hungryBoss then
					hungryBoss:say("Gulp!", TALKTYPE_MONSTER_SAY)
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
					local hungryBossHealth = hungryBoss:getHealth()
					local hungryBossPosition = hungryBoss:getPosition()
					hungryBoss:remove()
					local newBoss = Game.createMonster("the baron from below", hungryBossPosition, true, true)
					if newBoss then
						newBoss:registerEvent("the baron from below think")
						newBoss:addHealth( - (newBoss:getHealth() - hungryBossHealth))
						newBoss:addHealth(math.random(10000, 30000))
						for i = 1, 4 do
							Game.createMonster("Aggressive Matter", organicPosition, true, false)
						end
					end
				else
					local hungryBossHealth = hungryBoss:getHealth()
					local hungryBossPosition = hungryBoss:getPosition()
					hungryBoss:remove()
					local newBoss = Game.createMonster("the baron from below", hungryBossPosition, true, true)
					if newBoss then
						newBoss:registerEvent("the baron from below think")
						newBoss:addHealth( - (newBoss:getHealth() - hungryBossHealth))
					end
				end
			end, 10*1000)
		end
	end
end

local theBaronFromBelowThink = CreatureEvent("TheBaronFromBelowThink")
function theBaronFromBelowThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end

	if creature:getName():lower() == "the baron from below" then
		addEvent(summonHungry, 30*1000, creature:getId())
	end
	return true
end

theBaronFromBelowThink:register()

local theBaronFromBelowKill = CreatureEvent("TheBaronFromBelowKill")
function theBaronFromBelowKill.onKill(player, creature)
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

theBaronFromBelowKill:register()
