local spoon = Action()

function spoon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isItem() then
		return false
	end

	-- Obtenha o ID do item alvo
	local targetId = target:getId()

	--The Ice Islands Quest - Cure the Dogs
	if targetId == 390 then
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.SulphurLava) < 1 then
				player:addItem(7247, 1) -- fine sulphur
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.SulphurLava, 1)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
				player:say("You retrive a fine sulphur from a lava hole.", TALKTYPE_MONSTER_SAY)
			end
		end
	elseif targetId == 3920 then
		if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.SporesMushroom) < 1 then
				player:addItem(7251, 1)
				player:setStorageValue(Storage.Quest.U8_0.TheIceIslands.SporesMushroom, 1)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
				player:say("You retrive spores from a mushroom.", TALKTYPE_MONSTER_SAY)
			end
		end
	end

	return onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end

spoon:id(3468)
spoon:register()
