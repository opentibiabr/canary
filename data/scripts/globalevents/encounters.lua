local encounterTick = GlobalEvent("encounters.tick.onThink")
function encounterTick.onThink(interval, lastExecution)
	for _, encounter in pairs(Encounter.registry) do
		local stage = encounter:getStage()
		if stage and stage.tick then
			stage.tick(encounter, interval, lastExecution)
		end
	end
	return true
end

encounterTick:interval(1000)
encounterTick:register()
