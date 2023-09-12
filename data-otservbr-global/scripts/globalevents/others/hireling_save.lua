local hirelingSave = GlobalEvent("hirelingSave")
function hirelingSave.onShutdown()
	logger.info("Saving Hirelings")
	SaveHirelings()
	return true
end

hirelingSave:register()
