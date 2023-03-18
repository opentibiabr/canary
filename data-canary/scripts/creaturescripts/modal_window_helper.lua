local creatureEvent = CreatureEvent("modalWindowHelper")

function creatureEvent.onModalWindow(player, modalWindowId, buttonId, choiceId)
	local playerId = player:getId()
	local modalWindows = ModalWindows[playerId]
	if not modalWindows then
		return true
	end

	local modalWindow = modalWindows[modalWindowId]
	if not modalWindow then
		return true
	end

	local button = modalWindow.buttons[buttonId] or {}
	local choice = modalWindow.choices[choiceId] or {}
	if button.callback then
		button.callback(player, button, choice)
	elseif choice.callback then
		choice.callback(player, button, choice)
	elseif modalWindow.defaultCallback then
		modalWindow.defaultCallback(player, button, choice)
	end

	modalWindow.using = modalWindow.using - 1
	if modalWindow.using == 0 then
		modalWindows[modalWindowId] = nil
		if not next(modalWindows) then
			ModalWindows[playerId] = nil
		end
	end
	return true
end

creatureEvent:register()
