local inServiceYalaharMorik = Action()
function inServiceYalaharMorik.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid == 1015 then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.MorikSummon) < 1 then
			local ret = Game.createMonster("Morik the Gladiator", fromPosition)
			ret:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.MorikSummon, 1)
		end
	end
	return true
end

inServiceYalaharMorik:uid(1015)
inServiceYalaharMorik:register()
