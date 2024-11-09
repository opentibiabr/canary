local globalEvent = GlobalEvent("EventScheduleDoubleBosstiaryKV")
function globalEvent.onStartup()
	KV.scoped("eventscheduler"):set("double-bosstiary", true)
end

globalEvent:register()
