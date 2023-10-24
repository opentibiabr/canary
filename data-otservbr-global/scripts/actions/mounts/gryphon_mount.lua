local config = {
	maskId = 31369,
	tamedId = 31576,
	31561,
	monsterName = "Gryphon",
	achievement = "Gryphon Rider",
	mountId = 144,
	chance = 100,
}

local action = Action()

function action.onUse(player, item, fromPos, target, toPos, isHotkey)
	if not target or not target:isMonster() or target:getName() ~= config.monsterName then
		return true
	end

	if player:hasMount(config.mountId) then
		player:sendCancelMessage("You already have this mount.")
		return true
	end

	local mask = player:getSlotItem(CONST_SLOT_HEAD)
	if not mask or mask:getId() ~= config.maskId then
		player:sendCancelMessage("You must have the mask equipped.")
		return true
	end

	item:remove(1)

	if config.chance >= math.random(1, 100) then
		target:remove()
		toPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:addMount(config.mountId)
		doCreatureSay(player, "The gryphon will now accompany you as a friend and ally.", TALKTYPE_ORANGE_1)
	else
		player:sendCancelMessage("Taming has failed, try again.")
		toPos:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

action:id(config.tamedId)
action:register()
