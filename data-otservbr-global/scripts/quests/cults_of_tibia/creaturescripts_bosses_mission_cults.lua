local bosses = {
	["ravenous hunger"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Mission, value = 6 },
	["the souldespoiler"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission, value = 4 },
	["essence of malice"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Humans.Mission, value = 2 },
	["the unarmored voidborn"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Orcs.Mission, value = 2 },
	["the false god"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission, value = 4 },
	["the sandking"] = { storage = Storage.Quest.U11_40.CultsOfTibia.Life.Mission, value = 8, global = "sandking", g_value = 5 },
	["the corruptor of souls"] = { createNew = "The Source Of Corruption", pos = Position(33039, 31922, 15), removeMonster = "zarcorix of yalahar", area1 = Position(33073, 31885, 15), area2 = Position(33075, 31887, 15) },
	["the source of corruption"] = { storage = Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission, value = 2 },
}

local bossesCults = CreatureEvent("CultsOfTibiaBossDeath")
function bossesCults.onDeath(creature)
	-- Deny summons and players
	if not creature or creature:isPlayer() or creature:getMaster() then
		return true
	end

	local monsterName = creature:getName():lower()
	local boss = bosses[monsterName]
	if not boss then
		return true
	end
	if boss.global and Game.getStorageValue(boss.global) < boss.g_value then
		return true
	end
	if boss.createNew then
		Game.setStorageValue("CheckTile", -1)
		Game.createMonster(boss.createNew, boss.pos)
		if removeMonster then
			for _x = boss.area1.x, boss.area2.x, 1 do
				for _y = boss.area1.y, boss.area2.y, 1 do
					for _z = boss.area1.z, boss.area2.z, 1 do
						if Tile(Position(_x, _y, _z)) then
							local monster = Tile(Position(_x, _y, _z)):getTopCreature()
							if monster and monster:isMonster() and monster:getName():lower() == string.lower(boss.removeMonster) then
								monster:remove()
							end
						end
					end
				end
			end
		end
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(boss.storage) < boss.value then
			player:setStorageValue(boss.storage, boss.value)
		end
	end)
	return true
end

bossesCults:register()
