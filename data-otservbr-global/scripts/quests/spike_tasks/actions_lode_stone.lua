local area = {
	Position(32152, 32502, 11),
	Position(32365, 32725, 12),
}

local spikeTasksStone = Action()

function spikeTasksStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local currentProgress = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main)
	if currentProgress == 3 then
		return false
	end

	if not target or type(target) ~= "userdata" or not target:isItem() or (target:getId() ~= 19217) then
		return false
	end

	if target:getId() == 19217 then
		target:transform(19379)
		target:decay()
	end

	local itemId = item:getId()

	if itemId == 19207 then
		item:transform(19216)
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main, 1) -- Define o progresso inicial
	elseif itemId == 19216 then
		local useCount = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main)
		if useCount == -1 then
			useCount = 0
		end

		useCount = useCount + 1
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main, useCount)

		if useCount == 3 then -- Corrigido para checar se o uso é 3
			item:transform(19218)
			player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Middle_Charge_Main, 3) -- Finaliza a missão
			return true
		end
	end

	if math.random(100) > 60 then
		player:teleportTo(Position.getFreePosition(area[1], area[2]))
	end

	return toPosition:sendMagicEffect(12)
end

local itemIds = { 19207, 19216 }

for _, id in ipairs(itemIds) do
	spikeTasksStone:id(id)
end

spikeTasksStone:register()
