-- Both map triggers share the same world/session-owned vortex cooldown.
for _, position in ipairs({ Position(33443, 31545, 13), Position(33443, 31539, 13) }) do
	local cleanse = MoveEvent()
	function cleanse.onStepIn(creature)
		if creature:isPlayer() then
			GraveDanger.cleanseHex(creature)
		end
		return true
	end
	cleanse:position(position)
	cleanse:register()
end
