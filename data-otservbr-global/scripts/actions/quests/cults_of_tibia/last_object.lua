local config = {
	[1] = Position(32731, 31531, 9),
	[2] = Position(32739, 31489, 9),
	[3] = Position(32739, 31507, 9),
	[4] = Position(32761, 31518, 9),
	[5] = Position(32720, 31545, 8),
	[6] = Position(32745, 31423, 8),
	[7] = Position(32742, 31410, 8),
	[8] = Position(32685, 31430, 8),
	[9] = Position(32746, 31462, 8),
	[10] = Position(32683, 31537, 9),
	[11] = Position(32740, 31494, 9), -- Bancada Cult Object
	[12] = Position(32741, 31494, 9)  -- Bancada Cult Object

}

local cultsOfTibiaLastObject = Action()
function cultsOfTibiaLastObject.onUse(player, item)
	if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) == 4 then
		for i, position in pairs(config) do
			position:sendMagicEffect(CONST_ME_YELLOWENERGY)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The strange symbol in the wall in the back glows violently.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The cult object just lies there quietly. The dangerous area around it has been all but dissolved.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As you reach out to touch the cult object, a surge of energy burst from the skull. You banished its power.")
		player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 5)
		player:setStorageValue(Storage.CultsOfTibia.Barkless.BossAccessDoor, 1)
	end
	return true
end

cultsOfTibiaLastObject:aid(5536)
cultsOfTibiaLastObject:register()