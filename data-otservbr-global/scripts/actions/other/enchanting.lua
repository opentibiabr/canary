local config = {
	manaCost = 300,
	soulCost = 2,
}

local spheres = {
	[675] = { VOCATION.BASE_ID.PALADIN },
	[676] = { VOCATION.BASE_ID.SORCERER },
	[677] = { VOCATION.BASE_ID.DRUID },
	[678] = { VOCATION.BASE_ID.KNIGHT },
}

local enchantableGems = { 3030, 3029, 3032, 3033 }
local enchantableItems = { 3271, 7383, 7384, 7406, 7402, 3317, 3318, 7389, 7380, 3342, 3311, 3333, 7415, 7392, 3279, 3447, 8077 }

local enchantingAltars = {
	{ 146, 147, 148, 149 },
	{ 150, 151, 152, 153 },
	{ 158, 159, 160, 161 },
	{ 154, 155, 156, 157 },
}

local enchantedGems = { 676, 675, 677, 678 }
local enchantedItems = {
	[3271] = { 660, 679, 779, 794 },
	[7383] = { 661, 680, 780, 795 },
	[7384] = { 662, 681, 781, 796 },
	[7406] = { 663, 682, 782, 797 },
	[7402] = { 664, 683, 783, 798 },
	[3317] = { 665, 684, 784, 801 },
	[3318] = { 666, 685, 785, 802 },
	[7389] = { 667, 686, 786, 803 },
	[7380] = { 668, 687, 787, 804 },
	[3342] = { 669, 688, 788, 805 },
	[3311] = { 670, 689, 789, 806 },
	[3333] = { 671, 690, 790, 807 },
	[7415] = { 672, 691, 791, 808 },
	[7392] = { 673, 692, 792, 809 },
	[3279] = { 674, 693, 793, 810 },
	[3447] = { 763, 762, 774, 761 },
	[8077] = { 8078, 8079, 8081, 8080 },
}

local enchanting = Action()

function enchanting.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- The Dream Courts Quest
	if item.itemid == 675 and target.itemid == 21573 then
		return onGrindItem(player, item, fromPosition, target, toPosition)
	end

	if table.contains({ 33268, 33269 }, toPosition.x) and toPosition.y == 31830 and toPosition.z == 10 and player:getStorageValue(Storage.Quest.U8_2.ElementalSpheres.QuestLine) > 0 then
		if not table.contains(spheres[item.itemid], player:getVocation():getBaseId()) then
			return false
		elseif table.contains({ 842, 843 }, target.itemid) then
			player:say("Turn off the machine first.", TALKTYPE_MONSTER_SAY)
			return true
		else
			player:setStorageValue(Storage.Quest.U8_2.ElementalSpheres.MachineGemCount, math.max(1, player:getStorageValue(Storage.Quest.U8_2.ElementalSpheres.MachineGemCount) + 1))
			toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
			item:transform(item.itemid, item.type - 1)
			return true
		end
	end

	if item.itemid == 3030 and target.itemid == 3229 then
		target:transform(3230)
		target:decay()
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	if item.itemid == 676 and target.itemid == 9020 then
		target:transform(9019)
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	if table.contains(enchantableGems, item.itemid) then
		local subtype = item.type
		if subtype == 0 then
			subtype = 1
		end

		local mana = config.manaCost * subtype
		if player:getMana() < mana then
			player:say("Not enough mana, separate one gem in your backpack and try again.", TALKTYPE_MONSTER_SAY)
			return false
		end

		local soul = config.soulCost * subtype
		if player:getSoul() < soul then
			player:sendCancelMessage(RETURNVALUE_NOTENOUGHSOUL)
			return false
		end

		local targetId = table.find(enchantableGems, item.itemid)
		if not targetId or not table.contains(enchantingAltars[targetId], target.itemid) then
			return false
		end

		player:addMana(-mana)
		player:addSoul(-soul)
		item:transform(enchantedGems[targetId])
		player:addManaSpent(items.valuables.mana)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
		return true
	end

	if item.itemid == 677 and table.contains({ 9035, 9040 }, target.itemid) then
		target:transform(target.itemid - 1)
		target:decay()
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end

	if table.contains(enchantedGems, item.itemid) then
		if not table.contains(enchantableItems, target.itemid) then
			fromPosition:sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local targetId = table.find(enchantedGems, item.itemid)
		if not targetId then
			return false
		end

		local subtype = target.type
		if not table.contains({ 3447, 8077 }, target.itemid) then
			subtype = 1000
		end

		target:transform(enchantedItems[target.itemid][targetId], subtype)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		item:remove(1)
		return true
	end
	return false
end

enchanting:id(675, 676, 677, 678)
enchanting:register()
