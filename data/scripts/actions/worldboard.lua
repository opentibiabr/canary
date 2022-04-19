local communicates = {
	"Welcome to Canary Server! Visit the organization to see all our work: https://github.com/opentibiabr",
	"Did you like it? Help support what we do here with a donation by visiting the link: https://docs.opentibiabr.org/donate/",
	"Visit our discord to ask questions or report issues: https://discord.com/invite/3NxYnyV"
}

local worldBoard = Action()

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in pairs(communicates) do
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value)
	end
	return true
end

local registerPositions = {
	{x = 4998, y = 5000, z = 7},
	{x = 4971, y = 5300, z = 5},
	{x = 4802, y = 5088, z = 7},
	{x = 5518, y = 5126, z = 6},
	{x = 5852, y = 5295, z = 5},
	{x = 1940, y = 1345, z = 7},
	{x = 4709, y = 4186, z = 7}
}

-- Usage: action:position(position, itemId)
-- Explanation: The variable "item id" is optional, the id or the name of the item can be added, the item will be created in the map if it does not exist. If it already exists on the map, it will send a warning informing (in the distro) so the id must be removed so that the warning disappears keeping only the position)
for index, value in pairs(registerPositions) do
	worldBoard:position(value, 19236)
end

worldBoard:register()
