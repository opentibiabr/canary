-- <action itemid="23574" script="other/glooth_bag.lua"/>

local items = {
	glooth_spears = 23529,
	glooth_amulet = 23554,
	glooth_club = 23549,
	glooth_axe = 23551,
	glooth_blade = 23550,
	glooth_backpack = 23666,
	glooth_sandwiches = 23514,
	glooth_soup = 23515,
	glooth_steaks = 23517,
	control_unit = 23557,
}

local gloothBag = Action()

function gloothBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rand = math.random(1, 100)

	if rand <= 15 then
		player:addItem(items.glooth_spears, 2)
	elseif rand >= 16 and rand <= 23 then
		player:addItem(items.glooth_amulet, 1)
	elseif rand >= 24 and rand <= 32 then
		player:addItem(items.glooth_club, 1)
	elseif rand >= 33 and rand <= 50 then
		player:addItem(items.glooth_axe, 1)
	elseif rand >= 51 and rand <= 64 then
		player:addItem(items.glooth_blade, 1)
	elseif rand >= 65 and rand <= 75 then
		player:addItem(items.glooth_backpack, 1)
	elseif rand >= 76 and rand <= 86 then
		player:addItem(items.glooth_sandwiches, 10)
	elseif rand >= 87 and rand <= 96 then
		player:addItem(items.glooth_soup, 10)
	elseif rand >= 97 and rand <= 99 then
		player:addItem(items.control_unit, 1)
	elseif rand == 100 then
		player:addItem(items.glooth_steaks, 10)
	end

	item:remove(1)

	return true
end

gloothBag:id(23574)
gloothBag:register()
