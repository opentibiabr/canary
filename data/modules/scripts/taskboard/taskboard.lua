local taskboardPath = CORE_DIRECTORY .. "/modules/scripts/taskboard/"
local Taskboard = rawget(_G, "Taskboard")

if type(Taskboard) ~= "table" or Taskboard.__entrypoint ~= taskboardPath then
	Taskboard = {}
	for _, component in ipairs({
		"settings",
		"catalog",
		"state",
		"rules",
		"wire",
		"actions",
		"soulpit",
		"lifecycle",
	}) do
		local loader = dofile(taskboardPath .. component .. ".lua")
		if type(loader) == "function" then
			loader(Taskboard)
		end
	end

	Taskboard.getLootBonus = Taskboard.rules.getLootBonus
	Taskboard.getCombatBonuses = Taskboard.rules.getCombatBonuses
	Taskboard.getDamageBonus = Taskboard.rules.getDamageBonus
	Taskboard.getLifeLeechBonus = Taskboard.rules.getLifeLeechBonus
	Taskboard.onMonsterKilled = Taskboard.rules.onMonsterKilled
	Taskboard.openSoulpitWindow = Taskboard.soulpit.openWindow
	Taskboard.__entrypoint = taskboardPath
end

rawset(_G, "Taskboard", Taskboard)

function onRecvbyte(player, msg, byte)
	if not Taskboard.isEnabled() then
		return
	end
	if byte == Taskboard.packet.clientTaskboard then
		Taskboard.actions.handle(player, msg)
	elseif byte == Taskboard.packet.clientSoulpit then
		Taskboard.soulpit.handleSelection(player, msg)
	end
end
