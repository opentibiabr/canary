local globalEvent = GlobalEvent("EventScheduleFastExerciseKV")
function globalEvent.onStartup()
	KV.scoped("eventscheduler"):set("fast-exercise", true)
end

globalEvent:register()
