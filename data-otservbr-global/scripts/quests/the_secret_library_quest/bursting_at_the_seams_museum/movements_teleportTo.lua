local teleports = {
	[1] = { fromPos = Position(33246, 32107, 8), toPos = Position(33246, 32096, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, value = 2, nextValue = 3 },
	[2] = { fromPos = Position(33246, 32098, 8), toPos = Position(33246, 32109, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, value = 2 },
}

local lastroom_enter = Position(33344, 32117, 10)
local lastroom_exit = Position(33365, 32147, 10)

local function sendFire(position)
	for x = position.x - 1, position.x + 1 do
		local newPos = Position(x, position.y, position.z)
		newPos:sendMagicEffect(CONST_ME_FIREATTACK)
	end
end

local movements_museum_teleportTo = MoveEvent()

function movements_museum_teleportTo.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	if item.actionid == 4905 then
		for _, p in pairs(teleports) do
			if position == p.fromPos then
				if player:getStorageValue(p.storage) >= p.value then
					player:teleportTo(p.toPos)
					sendFire(p.toPos)
					if p.nextValue and player:getStorageValue(p.storage) < p.nextValue then
						player:setStorageValue(p.storage, p.nextValue)
					end
				else
					player:teleportTo(fromPosition, true)
				end
			end
		end
	elseif item.actionid == 4906 then
		local hasPermission = false

		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.YellowGem) >= 1 and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.GreenGem) >= 1 and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.RedGem) >= 1 then
			hasPermission = true
		end

		if not hasPermission then
			player:teleportTo(Position(33226, 32084, 9))
		end
	elseif item.actionid == 4907 then
		if position == lastroom_enter then
			player:teleportTo(Position(33363, 32146, 10))
		elseif position == lastroom_exit and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.TrialTimer) < os.time() then
			player:teleportTo(Position(33336, 32117, 10))
		else
			if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) < 6 then
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.TrialTimer, os.time() + 3 * 60)
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 6)
				player:say("rkawdmawfjawkjnfjkawnkjnawkdjawkfmalkwmflkmawkfnzxc", TALKTYPE_MONSTER_SAY)
			end
		end
	end

	return true
end

movements_museum_teleportTo:aid(4905, 4906, 4907)
movements_museum_teleportTo:register()
