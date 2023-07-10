local config = {
	[Position(32731, 31531, 9)] = {base = 0},
	[Position(32739, 31489, 9)] = {base = 1},
	[Position(32739, 31507, 9)] = {base = 2},
	[Position(32761, 31518, 9)] = {base = 3},
	[Position(32720, 31545, 8)] = {base = 4},
	[Position(32745, 31423, 8)] = {base = 5},
	[Position(32742, 31410, 8)] = {base = 6},
	[Position(32685, 31430, 8)] = {base = 7},
	[Position(32746, 31462, 8)] = {base = 8},
	[Position(32683, 31537, 9)] = {base = 9},
	[Position(32740, 31494, 9)] = {base = 10},
	[Position(32741, 31494, 9)] = {base = 11},
	[Position(32745, 31523, 9)] = {base = 12},

}

local cultsOfTibiaCult = Action()
function cultsOfTibiaCult.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stg = math.max(player:getStorageValue(Storage.CultsOfTibia.Barkless.Objects), 0)
	if stg >= 10 then
		if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) >= 4 then
			-- continue
		else
			player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 4)
		end
		return false
	end
	local mancha = false
	for pos, pid in pairs(config) do
		if item:getPosition():compare(pos) then
			mancha = pid
			break;
		end
	end
	local stgTemp = math.max(player:getStorageValue(Storage.CultsOfTibia.Barkless.Temp), 0)
	local manchaMeta = NewBit(stgTemp)
	local base = bit.lshift(1, mancha.base)
	if manchaMeta:hasFlag(base) then
		return false
	end
	manchaMeta:updateFlag(base)
	player:setStorageValue(Storage.CultsOfTibia.Barkless.Temp, manchaMeta:getNumber())
	player:setStorageValue(Storage.CultsOfTibia.Barkless.Objects, stg + 1)
	if (player:getStorageValue(Storage.CultsOfTibia.Barkless.Objects) >= 10) then
		player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 4)
	end
	local msg = (player:getStorageValue(Storage.CultsOfTibia.Barkless.Objects) < 10 and "Your body reacts to this strange green substance as you reach out to touch it. You feel an urge for more of this energy." or "You gathered an impressive amount of power from simply touching the strange green symbols of the Barkless. But how...?")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
	return true
end

cultsOfTibiaCult:aid(5535)
cultsOfTibiaCult:register()