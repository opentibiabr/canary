local serverShutdown = GlobalEvent("ServerShutdown")

function serverShutdown.onShutdown()
	local hirelingSave = SaveHirelings()
	if hirelingSave then
		logger.info("[Server Shutdown] Hirelings successfully saved.")
	else
		logger.warn("[Server Shutdown] Failed to save hirelings. Please check the logs for details.")
	end

	return true
end

serverShutdown:register()
