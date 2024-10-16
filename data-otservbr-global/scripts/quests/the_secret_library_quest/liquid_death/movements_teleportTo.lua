local config = {
	teleports = {
		[1] = { fromPos = Position(32871, 32510, 7), toPos = Position(32881, 32471, 9), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, value = 1, effect = CONST_ME_WATERSPLASH, achievementName = "Spectulation" },
		[2] = { fromPos = Position(32881, 32473, 9), toPos = Position(32871, 32513, 7), effect = CONST_ME_WATERSPLASH },
		[3] = { fromPos = Position(33584, 31388, 13), toPos = Position(33584, 31391, 13), storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, value = 4, effect = CONST_ME_TELEPORT, message = "You squeeze through an ancient small passage. There are small symbols carved deep into the coral you cannot read." },
		[4] = { fromPos = Position(33560, 31395, 13), toPos = Position(33561, 31391, 13), effect = CONST_ME_TELEPORT },
	},
	defaultMessage = "You are not ready to pass yet.",
}

local movements_liquid_teleportTo = MoveEvent()

function movements_liquid_teleportTo.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	if player then
		for i = 1, #config.teleports do
			local tab = config.teleports
			if position == tab[i].fromPos then
				if tab[i].storage then
					if player:getStorageValue(tab[i].storage) >= tab[i].value then
						player:teleportTo(tab[i].toPos)
						if tab[i].message then
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tab[i].message)
						end
						if tab[i].achievementName and not player:hasAchievement(tab[i].achievementName) then
							player:addAchievement(tab[i].achievementName)
						end
						if player:getStorageValue(tab[i].storage) == tab[i].value then
							player:setStorageValue(tab[i].storage, player:getStorageValue(tab[i].storage) + 1)
						end
					else
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.defaultMessage)
						player:teleportTo(fromPosition, true)
						return true
					end
				else
					player:teleportTo(tab[i].toPos)
				end
				player:getPosition():sendMagicEffect(tab[i].effect)
			end
		end
	end

	return true
end

movements_liquid_teleportTo:aid(4900)
movements_liquid_teleportTo:register()
