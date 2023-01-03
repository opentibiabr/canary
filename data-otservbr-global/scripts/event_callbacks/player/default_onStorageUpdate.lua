local ec = EventCallback

function ec.onStorageUpdate(player, key, value, oldValue, currentFrameTime)
	player:updateStorage(key, value, oldValue, currentFrameTime)
end

ec:register(--[[0]])
