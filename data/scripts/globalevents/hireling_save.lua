local hirelingSave = GlobalEvent("HirelingSave")

function hirelingSave.onShutdown()
	SaveHirelings()
	return true
end

hirelingSave:register()
