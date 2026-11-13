local portals = {
	[14562] = {
		boss = "Lord Azaram",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.LordAzaram.Timer,
		newPos = Position(33425, 31499, 13),
	},
	[14563] = {
		boss = "Duke Krule",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKrule.Timer,
		newPos = Position(33456, 31499, 13),
	},
	[14564] = {
		boss = "Sir Baeloc",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.BaelocNictros.Timer,
		newPos = Position(33428, 31406, 13),
	},
	[14565] = {
		boss = "Earl Osam",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.EarlOsam.Timer,
		newPos = Position(33519, 31439, 13),
	},
	[14566] = {
		boss = "Count Vlarkorth",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorth.Timer,
		newPos = Position(33458, 31406, 13),
	},
	[14567] = {
		boss = "King Zelos",
		stor = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Timer,
		newPos = Position(33491, 31546, 13),
	},
}

function secondsToClock(seconds)
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hours, mins, secs)
end

local grave_enter = MoveEvent()

function grave_enter.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local thing = portals[item.actionid]

	if not thing then
		return true
	end

	-- BossLever writes the Bosstiary cooldown; preserve older storage cooldowns too.
	local cooldown = math.max(creature:getStorageValue(thing.stor), creature:getBossCooldown(thing.boss) or 0)
	if item.actionid == 14564 then
		cooldown = math.max(cooldown, creature:getBossCooldown("Sir Nictros") or 0)
	end
	if cooldown > os.time() then
		local eq = cooldown - os.time()
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait " .. secondsToClock(eq) .. " before trying to challenge " .. thing.boss .. " again!")
		creature:teleportTo(fromPosition)
		return true
	end

	creature:teleportTo(thing.newPos)

	return true
end

grave_enter:aid(14562, 14563, 14564, 14565, 14566, 14567)
grave_enter:register()
