local globalEvent = GlobalEvent("EventScheduleDoubleBestiaryKV")
function globalEvent.onStartup()
	KV.scoped("eventscheduler"):set("double-bestiary", true)
end

globalEvent:register()
