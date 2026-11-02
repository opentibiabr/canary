-- Run from the repository root: lua tests/lua/test_encounter_auto_advance.lua

dofile("data/libs/systems/encounters.lua")

local function createEncounter(monsters)
	return {
		name = "auto-advance regression",
		monsters = monsters,
		advances = 0,
		debug = function() end,
		addEvent = function(self, callback, delay)
			self.delayCallback = callback
			self.delay = delay
		end,
		countMonsters = function(self)
			return self.monsters
		end,
		nextStage = function(self)
			self.advances = self.advances + 1
		end,
	}
end

local encounter = createEncounter(1)
local ticks = 0
local stage = EncounterStage({
	encounter = encounter,
	tick = function()
		ticks = ticks + 1
		encounter.monsters = 0
	end,
})
stage:autoAdvance({ delay = 100, monstersKilled = true })
stage.start()
assert(encounter.delay == 100)
stage.tick()
assert(ticks == 1, "autoAdvance must preserve the stage's original tick")
assert(encounter.advances == 0, "the stage must wait for its delay")

encounter.monsters = 1
encounter.delayCallback()
assert(encounter.advances == 0, "the timer must wait for the monstersKilled tick")
stage.tick()
assert(ticks == 2)
assert(encounter.advances == 1, "the original tick must run before checking monster count")

local noTickEncounter = createEncounter(1)
local noTickStage = EncounterStage({ encounter = noTickEncounter })
noTickStage:autoAdvance({ monstersKilled = true })
noTickStage.start()
assert(noTickEncounter.delay == 50)
noTickEncounter.delayCallback()
noTickStage.tick()
assert(noTickEncounter.advances == 0)
noTickEncounter.monsters = 0
noTickStage.tick()
assert(noTickEncounter.advances == 1, "stages without an original tick must still advance")

local timedEncounter = createEncounter(1)
local timedStage = EncounterStage({ encounter = timedEncounter })
timedStage:autoAdvance(100)
timedStage.start()
timedEncounter.delayCallback()
assert(timedEncounter.advances == 1, "timer-only stages must retain their behavior")

print("Encounter auto-advance regression tests passed")
