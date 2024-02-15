local hirelingSave = GlobalEvent("HirelingSave")

function hirelingSave.onShutdown()
	local saved = SaveHirelings()
	if saved then
		logger.info("[Server Shutdown] Hirelings successfully saved.")
	else
		logger.warn("[Server Shutdown] Failed to save hirelings. Please check the logs for details.")
	end

	return true
end

hirelingSave:register()
