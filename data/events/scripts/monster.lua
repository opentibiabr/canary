function Monster:onDropLoot(corpse)
	local ec = EventCallback.onDropLoot
	if ec then
		ec(self, corpse)
	end
end

function Monster:onSpawn(position)
	local ec = EventCallback.onSpawn
	if ec then
		return ec(self, position)
	end
	return true
end
