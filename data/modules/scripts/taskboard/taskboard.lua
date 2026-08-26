local taskboardPath = CORE_DIRECTORY .. "/modules/scripts/taskboard/"
local Taskboard = rawget(_G, "Taskboard")

if type(Taskboard) ~= "table" or Taskboard.__entrypoint ~= taskboardPath or type(Taskboard.diagnostics) ~= "table" or type(Taskboard.diagnostics.trace) ~= "function" then
	Taskboard = {}
	for _, component in ipairs({
		"settings",
		"diagnostics",
		"catalog",
		"state",
		"rules",
		"wire",
		"expansion",
		"admin",
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
	Taskboard.diagnostics.trace("init", "module loaded enabled={} clientOpcode=0x{} serverOpcode=0x{} soulpitOpcode=0x{}", Taskboard.isEnabled(), Taskboard.diagnostics.hexByte(Taskboard.packet.clientTaskboard), Taskboard.diagnostics.hexByte(Taskboard.packet.serverTaskboard), Taskboard.diagnostics.hexByte(Taskboard.packet.clientSoulpit))
end

rawset(_G, "Taskboard", Taskboard)

function onRecvbyte(player, msg, byte)
	local version, build = Taskboard.diagnostics.client(player)
	Taskboard.diagnostics.trace("recv", "player='{}' opcode=0x{} unread={} client={} build='{}' enabled={}", Taskboard.diagnostics.playerName(player), Taskboard.diagnostics.hexByte(byte), Taskboard.diagnostics.unreadBytes(msg), version, build, Taskboard.isEnabled())
	if not Taskboard.isEnabled() then
		return
	end
	if byte == Taskboard.packet.clientTaskboard then
		Taskboard.actions.handle(player, msg)
	elseif byte == Taskboard.packet.clientSoulpit then
		Taskboard.soulpit.handleSelection(player, msg)
	end
end
