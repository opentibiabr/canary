local globalEvent = GlobalEvent("EventScheduleForgeTimeKV")
function globalEvent.onStartup()
	KV.scoped("eventscheduler"):set("forge-chance", 20)
end

globalEvent:register()
