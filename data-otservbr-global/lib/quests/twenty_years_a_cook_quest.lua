TwentyYearsACookQuest = {
	TheRestOfRatha = {
		MissionZone = Zone("mission.the-rest-of-ratha"),
		BossZone = Zone("boss.the-rest-of-ratha"),
		PositionsToTeleport = {
			Position(33309, 31393, 15),
			Position(33324, 31396, 15),
			Position(33323, 31405, 15),
			Position(33312, 31402, 15),
			Position(33317, 31393, 15),
		},
		Items = {
			EmptySpiritFlask = 44527,
			FullSpiritFlask = 44528,
			PotionRack = 44597,
			GhostItem = 44598,
			Harp = 44599,
			HarpCooldown = 44600,
		},
		LeverUID = 62133,
		FlaskBoxUID = 62134,
		TimeToDefeat = 10 * 60, -- 10 minutes
	},
	Fryclops = {
		BossZone = Zone("boss.fryclops"),
		Items = {
			AxeBox = 44562,
			Axe = 44525,
			CatapultRope = 44410,
		},
		LeverUID = 62135,
		TimeToDefeat = 10 * 60, -- 10 minutes
		MeleePoints = 5,
		BeamPoints = 10,
		Exit = Position(32299, 31698, 8),
		Catapult = {
			FryclopsPosition = Position(32349, 31595, 6),
			RopePosition = Position(32348, 31595, 6),
			CatapultUpdateMap = {
				[Position(32349, 31595, 6)] = { on = 0, off = 44411 },
				[Position(32348, 31595, 6)] = { on = 44419, off = 44410 },
				[Position(32350, 31595, 6)] = { on = 44420, off = 44412 },
				[Position(32351, 31595, 5)] = { on = 44426, off = 0 },
				[Position(32351, 31595, 6)] = { on = 44421, off = 44413 },
			},
			UpdateCatapult = function(on)
				for position, status in pairs(TwentyYearsACookQuest.Fryclops.Catapult.CatapultUpdateMap) do
					local tile = Tile(position)
					local updated = false
					if tile then
						local item = tile:getItemById(on and status.off or status.on)
						if item then
							item:remove()
						end
					else
						Game.createTile(position)
					end
					if (on and status.on ~= 0) or (not on and status.off ~= 0) then
						Game.createItem(on and status.on or status.off, 1, position)
					end
				end
			end,
		},
	},
}

-- Initializing zones
TwentyYearsACookQuest.TheRestOfRatha.MissionZone:addArea({ x = 33303, y = 31425, z = 15 }, { x = 33327, y = 31445, z = 15 })
TwentyYearsACookQuest.TheRestOfRatha.BossZone:addArea({ x = 33303, y = 31388, z = 15 }, { x = 33327, y = 31408, z = 15 })
TwentyYearsACookQuest.Fryclops.BossZone:addArea({ x = 32342, y = 31589, z = 6 }, { x = 32368, y = 31611, z = 6 })
