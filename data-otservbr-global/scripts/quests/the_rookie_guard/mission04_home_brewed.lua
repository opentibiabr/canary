-- The Rookie Guard Quest - Mission 04: Home-Brewed

local missionTiles = {
	[50317] = {
		states = 1,
		message = "This is not the way to Lily. Follow the road leading to the south-west to find her shop.",
		arrowPosition = {x = 32090, y = 32201, z = 7}
	},
	[50318] = {
		states = 2,
		message = "This is not the way to Hyacinth. Follow the path to the north exit of the village.",
		arrowPosition = {x = 32090, y = 32190, z = 7}
	},
	[50320] = {
		states = 2,
		message = "This is not the way to Hyacinth. Follow the path to the east to find Hyacinth's little house.",
		arrowPosition = {x = 32092, y = 32164, z = 7}
	},
	[50322] = {
		states = 2,
		message = "This is not the way to Hyacinth. Stay on the path a little more to the north to find Hyacinth's little house."
	}
}

-- Mission tutorial tiles

local missionGuide = MoveEvent()

function missionGuide.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission04)
	-- Skip if not was started or finished
	if missionState == -1 or missionState > 2 then
		return true
	end
	local missionTile = missionTiles[item.actionid]
	-- Check if the tile is active
	if missionTile.states == missionState then
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, missionTile.message)
			if missionTile.arrowPosition then
				Position(missionTile.arrowPosition):sendMagicEffect(CONST_ME_TUTORIALARROW)
			end
		end
	end
	return true
end

for index, value in pairs(missionTiles) do
	missionGuide:aid(index)
end
missionGuide:register()
