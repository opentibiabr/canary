local conditions = {
	CONDITION_POISON,
	CONDITION_FIRE,
	CONDITION_ENERGY,
	CONDITION_PARALYZE,
	CONDITION_DRUNK,
	CONDITION_DROWN,
	CONDITION_FREEZING,
	CONDITION_DAZZLED,
	CONDITION_CURSED,
	CONDITION_BLEEDING,
}
local condition_shield = Condition(CONDITION_ATTRIBUTES)
condition_shield:setParameter(CONDITION_PARAM_SUBID, AttrSubId_JeanPierreDefense)
condition_shield:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
condition_shield:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_shield:setParameter(CONDITION_PARAM_SKILL_SHIELD, 10)
condition_shield:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
local condition_ml = Condition(CONDITION_ATTRIBUTES)
condition_ml:setParameter(CONDITION_PARAM_SUBID, AttrSubId_JeanPierreMagic)
condition_ml:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
condition_ml:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_ml:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 5)
condition_ml:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
local condition_melee = Condition(CONDITION_ATTRIBUTES)
condition_melee:setParameter(CONDITION_PARAM_SUBID, AttrSubId_JeanPierreMelee)
condition_melee:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
condition_melee:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_melee:setParameter(CONDITION_PARAM_SKILL_MELEE, 10)
condition_melee:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
local condition_dist = Condition(CONDITION_ATTRIBUTES)
condition_dist:setParameter(CONDITION_PARAM_SUBID, AttrSubId_JeanPierreDistance)
condition_dist:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
condition_dist:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_dist:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 10)
condition_dist:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
local condition_f = Condition(CONDITION_ATTRIBUTES)
condition_f:setParameter(CONDITION_PARAM_SUBID, AttrSubId_JeanPierreFishing)
condition_f:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
condition_f:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_f:setParameter(CONDITION_PARAM_SKILL_FISHING, 50)
condition_f:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
local condition_speed = Condition(CONDITION_HASTE)
condition_speed:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
condition_speed:setParameter(CONDITION_PARAM_SPEED, 729)
local combat_i = Combat()
combat_i:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat_i:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
local condition_i = Condition(CONDITION_INVISIBLE)
condition_i:setParameter(CONDITION_PARAM_TICKS, 600000)
combat_i:addCondition(condition_i)
local itemIds = { [9079] = 0, [9080] = 1, [9081] = 2, [9082] = 3, [9083] = 4, [9084] = 5, [9085] = 6, [9086] = 7, [9087] = 8, [9088] = 9, [11584] = 10, [11586] = 11, [11587] = 12, [11588] = 13 }

local jeanPierreFood = Action()

function jeanPierreFood.onUse(player, item, frompos, item2, topos)
	local cid = player:getId()
	if player:getStorageValue(17110 + itemIds[item.itemid]) > os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end
	player:setStorageValue(17110 + itemIds[item.itemid], os.time() + (15 * 60))

	if item.itemid == 9079 then
		item:remove(1)
		Creature(cid):addHealth(getCreatureMaxHealth(cid) - getCreatureHealth(cid))
		player:say("Gulp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your health has been refilled.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9080 then
		item:remove(1)
		for i = 1, #conditions do
			doRemoveCondition(cid, conditions[i])
		end
		player:say("Chomp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel better body condition.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9081 then
		item:remove(1)
		Creature(cid):addCondition(condition_shield)
		player:say("Chomp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel less vulnerable.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9082 then
		item:remove(1)
		Creature(cid):addCondition(condition_ml)
		player:say("Chomp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel smarter.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9083 then
		item:remove(1)
		player:say("Slurp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't really know what this did to you, but suddenly you feel very happy.")
		player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
		return true
	elseif item.itemid == 9084 then
		item:remove(1)
		Creature(cid):addCondition(condition_melee)
		player:say("Yum.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel stronger.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9085 then
		item:remove(1)
		Creature(cid):addCondition(condition_speed)
		player:say("Munch.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your speed has been increased.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9086 then
		item:remove(1)
		Creature(cid):addMana(Creature(cid):getMaxMana() - Creature(cid):getMana())
		player:say("Chomp.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your mana has been refilled.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9087 then
		item:remove(1)
		Creature(cid):addCondition(condition_dist)
		player:say("Mmmm.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel more focused.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 9088 then
		item:remove(1)
		Creature(cid):addCondition(condition_f)
		player:say("Smack.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You felt fishing inspiration.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 11584 then
		item:remove(1)
		player:setStorageValue(15287, os.time() + 86400)
		player:say("Yum.", TALKTYPE_MONSTER_SAY)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Underwater walking speed increased.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 11586 then
		if math.random(1, 5) == 5 then
			item:remove(1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take the last gulp from the large bowl. No leftovers!")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take a gulp from the large bowl, but there's still some blackjack in it.")
		end
		Creature(cid):addHealth(getCreatureMaxHealth(cid) - getCreatureHealth(cid))
		player:say("Gulp.", TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 11587 then
		item:remove(1)
		local c = { condition_shield, condition_ml, condition_melee, condition_dist, condition_speed }
		local r = math.random(1, 4)
		if r == 1 then
			Creature(cid):addCondition(c[math.random(1, #c)])
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel stronger, but you have no idea what was increased.")
		elseif r == 2 then
			doSetCreatureLight(cid, 15, 154, 60 * 60 * 1000)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel enlightened.")
		elseif r == 3 then
			Creature(cid):addCondition(condition_i)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You became invisible.")
		elseif r == 4 then
			Creature(cid):addHealth(getCreatureMaxHealth(cid) - getCreatureHealth(cid))
			Creature(cid):addMana(Creature(cid):getMaxMana() - Creature(cid):getMana())
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your vitality has been restored.")
		end
		player:say("Smack.", TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	elseif item.itemid == 11588 then
		local ring = getPlayerSlotItem(cid, CONST_SLOT_RING)
		local r_t = {
			[3095] = 3092,
			[3096] = 3093,
			[6300] = 6299,
			[3099] = 3097,
			[3088] = 3051,
			[3089] = 3052,
			[3048] = 3048,
			[3087] = 3050,
			[16264] = 16114,
			[3100] = 3098,
			[12670] = 12669,
			[3086] = 3049,
			[3094] = 3091,
			[3090] = 3053,
		}
		if ring.itemid == 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No ring equipped.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end

		if r_t[ring.itemid] ~= nil then
			item:remove(1)
			if ring.itemid == r_t[ring.itemid] then
				r_m_am = 20
			else
				r_m_am = 1
			end

			for i = 1, 10 do
				doPlayerAddItem(cid, r_t[ring.itemid], r_m_am)
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your ring has been multiplied.")
			player:say("Slurp!", TALKTYPE_MONSTER_SAY)
			return true
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This ring cannot be multiplied.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
end

for index, value in pairs(itemIds) do
	jeanPierreFood:id(index)
end

jeanPierreFood:register()
