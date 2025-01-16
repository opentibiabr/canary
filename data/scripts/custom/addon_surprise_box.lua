local config = {
	females = { 136, 137, 139, 140, 142, 147, 148, 149, 150, 155, 156, 157, 158, 252, 269, 270, 279, 431, 433, 466, 513, 514 },
	males = { 128, 129, 131, 132, 134, 143, 144, 145, 146, 151, 152, 153, 154, 251, 268, 273, 278, 430, 432, 465, 512, 516 },
}

local checks = 0
local function checkHasAddon(player)
	checks = checks + 1
	if checks < 4 then
		local random = math.random(1, #config.females)
		local lookTypes = { female = config.females[random], male = config.males[random] }
		if player:hasOutfit(lookTypes.female, 3) and player:hasOutfit(lookTypes.male, 3) then
			checkHasAddon(player)
		end
		return lookTypes
	end

	return nil
end

local addonBox = Action()
function addonBox.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
	checks = 0
	local amount = player:kv():scoped("surprise-addon"):get("amount") or 0
	if amount >= #config.females then
		player:sendCancelMessage("You already have all addons!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local addonsToWin = {}
	local lookTypes = checkHasAddon(player)
	if lookTypes ~= nil then
		table.insert(addonsToWin, lookTypes)
	end

	if #addonsToWin == 0 then
		player:sendCancelMessage("You do not have addon to win!")
		return true
	end

	for k, lookType in pairs(addonsToWin) do
		player:addOutfitAddon(lookType.female, 3)
		player:addOutfitAddon(lookType.male, 3)
	end

	player:sendCancelMessage(string.format("Congratulations! You have won %i addon%s.", #addonsToWin, #addonsToWin > 1 and "s" or ""))
	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	player:kv():scoped("surprise-addon"):set("amount", amount + #addonsToWin)
	item:remove(1)

	return true
end

addonBox:id(64050)
addonBox:register()
