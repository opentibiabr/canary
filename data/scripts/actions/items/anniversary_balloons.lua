local settings = {
	[37471] = 37414,
	[37414] = 37471, -- blue balloon
	[37472] = 37416,
	[37416] = 37472, -- green balloon
	[37491] = 37417,
	[37417] = 37491, -- orange balloon
	[37496] = 37418,
	[37418] = 37496, -- pink balloon
	[37497] = 37419,
	[37419] = 37497, -- purple balloon
	[37498] = 37420,
	[37420] = 37498, -- red balloon
	[37499] = 37421,
	[37421] = 37499, -- teal balloon
	[37500] = 37422,
	[37422] = 37500, -- yellow balloon
	[37501] = 37423,
	[37423] = 37501, -- colourful balloons
	[37502] = 37424,
	[37424] = 37502, -- bonelord balloon
	[37503] = 37425,
	[37425] = 37503, -- cyclops balloon
	[37504] = 37426,
	[37426] = 37504, -- cyclops head balloon
	[37505] = 37427,
	[37427] = 37505, -- dwarf balloon
	[37506] = 37428,
	[37428] = 37506, -- hydra balloon
	[37507] = 37429,
	[37429] = 37507, -- orc balloon
	[37508] = 37430,
	[37430] = 37508, -- orc head balloon
	[37509] = 37431,
	[37431] = 37509, -- Tibianus balloon
	[37510] = 37432,
	[37432] = 37510, -- Eloise balloon
	[37511] = 37433,
	[37433] = 37511, -- rotworm balloon
	[37512] = 37434,
	[37434] = 37512, -- rotworm head balloon
	[37513] = 37435,
	[37435] = 37513, -- yellow 25 years balloon
	[37514] = 37436,
	[37436] = 37514, -- red 25 years balloon
	[37515] = 37437,
	[37437] = 37515, -- teal 25 years balloon
	[37516] = 37438,
	[37438] = 37516, -- green 25 years balloon
	[37517] = 37439,
	[37439] = 37517, -- orange 25 years balloon
	[37518] = 37440,
	[37440] = 37518, -- pink 25 years balloon
	[39669] = 39681,
	[39681] = 39669, -- purple 25 years balloon
	[39670] = 39682,
	[39682] = 39670, -- blue 25 years balloon
	[39671] = 39683,
	[39683] = 39671, -- balloon no.0
	[39672] = 39684,
	[39684] = 39672, -- balloon no.1
	[39673] = 39685,
	[39685] = 39673, -- balloon no.2
	[39674] = 39686,
	[39686] = 39674, -- balloon no.3
	[39675] = 39687,
	[39687] = 39675, -- balloon no.4
	[39676] = 39688,
	[39688] = 39676, -- balloon no.5
	[39677] = 39689,
	[39689] = 39677, -- balloon no.6
	[39678] = 39690,
	[39690] = 39678, -- balloon no.7
	[39679] = 39691,
	[39691] = 39679, -- balloon no.8
	[39680] = 39692,
	[39692] = 39680, -- balloon no.9
}

local anniversaryBalloons = Action()

function anniversaryBalloons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local balloon = settings[item.itemid]
	if not balloon then
		return true
	end

	local fromPosition = item:getPosition()
	local tile = Tile(fromPosition)

	if not tile:getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may use this only inside a house.")
		return true
	end

	item:transform(balloon, 1)
	return true
end

for itemId in pairs(settings) do
	anniversaryBalloons:id(itemId)
end

anniversaryBalloons:register()
