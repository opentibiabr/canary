local config = {
	sorcerer = {
		id = 1367,
		name = "Bladespark",
	},
	druid = {
		id = 1364,
		name = "Mossmasher",
	},
	paladin = {
		id = 1366,
		name = "Sandscourge",
	},
	knight = {
		id = 1365,
		name = "Snowbash",
	},
	monk = {
		id = 1819,
		name = "Moonhunter",
	},
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local vocation = config[player:getVocation():getBase():getName():lower()]
	if not vocation then
		return true
	end
	if player:hasFamiliar(vocation.id) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the " .. vocation.name .. " familiar.")
		return false
	end

	player:addFamiliar(vocation.id)
	item:remove()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You obtained the " .. vocation.name .. " familiar.")
	return true
end

action:id(35508)
action:register()
