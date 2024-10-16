local config = {
	accesses = {
		[1] = { fromPos = Position(33525, 31464, 14), toPos = Position(33525, 31464, 15), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, value = 6, message = "Without the help of other Njey you will probably not make enough of a difference in this battle.", timer = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.BrokulTimer },
	},
	defaultMessage = "You are not ready to pass yet.",
	notime = "You need to wait 20 hours to face this boss again.",
}

local movements_liquid_bossWay = MoveEvent()

function movements_liquid_bossWay.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	if player then
		local accesses = config.accesses
		for i = 1, #accesses do
			if accesses[i].fromPos == position then
				if player:getStorageValue(accesses[i].storage) < accesses[i].value then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, accesses[i].message)
					player:teleportTo(fromPosition, true)
				else
					if player:getStorageValue(accesses[i].timer) > os.time() then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.notime)
						player:teleportTo(fromPosition, true)
					else
						player:teleportTo(accesses[i].toPos, true)
					end
				end
			end
		end
	end

	return true
end

movements_liquid_bossWay:aid(4901)
movements_liquid_bossWay:register()
