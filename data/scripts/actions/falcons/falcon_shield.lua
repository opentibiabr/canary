local falconShield = Action()

function falconShield.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= 'userdata' or not target:isItem() then
		return false
	end

	if player:getItemCount(32521) < 1 or player:getItemCount(32518) < 1 then
		return false
	end

	if target:getId() ~= 8671 or target:getPosition() ~= Position(33363, 31342, 7) then
		return false
	end

	local mould = Position(33361, 31341, 7)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	toPosition:sendMagicEffect(CONST_ME_HITAREA)
	mould:sendMagicEffect(CONST_ME_SMOKE)
	player:removeItem(32518, 1)
	player:addItem(32422, 1)
	item:remove(1)
	return true
end

falconShield:id(32421)
falconShield:register()
