local setting = {
	--Carlin
	[9069] = {position = Position(32192, 31419, 2), storage = 10017}, --ice
	[9070] = {position = Position(32972, 32227, 7), storage = 10017}, --earth
	[9071] = {position = Position(32911, 32336, 15), storage = 10017}, --fire
	[9072] = {position = Position(33059, 32716, 5), storage = 10017}, --electric
	--Thais
	[9073] = {position = Position(32192, 31419, 2), storage = 10018}, --ice
	[9074] = {position = Position(32972, 32227, 7), storage = 10018}, --earth
	[9075] = {position = Position(32911, 32336, 15), storage = 10018}, --fire
	[9076] = {position = Position(33059, 32716, 5), storage = 10018}, --electric
	--Venore
	[9077] = {position = Position(32192, 31419, 2), storage = 10019}, --ice
	[9078] = {position = Position(32972, 32227, 7), storage = 10019}, --earth
	[9079] = {position = Position(32911, 32336, 15), storage = 10019}, --fire
	[9080] = {position = Position(33059, 32716, 5), storage = 10019}, --electric
	--Ab"Dendriel
	[9081] = {position = Position(32192, 31419, 2), storage = 10020}, --ice
	[9082] = {position = Position(32972, 32227, 7), storage = 10020}, --earth
	[9083] = {position = Position(32911, 32336, 15), storage = 10020}, --fire
	[9084] = {position = Position(33059, 32716, 5), storage = 10020}, --electric
	--Kazodron
	[9085] = {position = Position(32192, 31419, 2), storage = 10021 }, --ice
	[9086] = {position = Position(32972, 32227, 7), storage = 10021}, --earth
	[9087] = {position = Position(32911, 32336, 15), storage = 10021}, --fire
	[9088] = {position = Position(33059, 32716, 5), storage = 10021}, --electric
	--Darashia
	[9089] = {position = Position(32192, 31419, 2), storage = 10022}, --ice
	[9090] = {position = Position(32972, 32227, 7), storage = 10022}, --earth
	[9091] = {position = Position(32911, 32336, 15), storage = 10022}, --fire
	[9092] = {position = Position(33059, 32716, 5), storage = 10022}, --electric
	--Ankrahmun
	[9093] = {position = Position(32192, 31419, 2), storage = 10023}, --ice
	[9094] = {position = Position(32972, 32227, 7), storage = 10023}, --earth
	[9095] = {position = Position(32911, 32336, 15), storage = 10023}, --fire
	[9096] = {position = Position(33059, 32716, 5), storage = 10023}, --electric
	--Edron
	[9097] = {position = Position(32192, 31419, 2), storage = 10024}, --ice
	[9098] = {position = Position(32972, 32227, 7), storage = 10024}, --earth
	[9099] = {position = Position(32911, 32336, 15), storage = 10024}, --fire
	[9100] = {position = Position(33059, 32716, 5), storage = 10024}, --electric
	--Liberty Bay
	[9101] = {position = Position(32192, 31419, 2), storage = 10025}, --ice
	[9102] = {position = Position(32972, 32227, 7), storage = 10025}, --earth
	[9103] = {position = Position(32911, 32336, 15), storage = 10025}, --fire
	[9104] = {position = Position(33059, 32716, 5), storage = 10025}, --electric
	--Port Hope
	[9105] = {position = Position(32192, 31419, 2), storage = 10026}, --ice
	[9106] = {position = Position(32972, 32227, 7), storage = 10026}, --earth
	[9107] = {position = Position(32911, 32336, 15), storage = 10026}, --fire
	[9108] = {position = Position(33059, 32716, 5), storage = 10026}, --electric
	--Svargrond
	[9109] = {position = Position(32192, 31419, 2), storage = 10027}, --ice
	[9110] = {position = Position(32972, 32227, 7), storage = 10027}, --earth
	[9111] = {position = Position(32911, 32336, 15), storage = 10027}, --fire
	[9112] = {position = Position(33059, 32716, 5), storage = 10027}, --electric
	--Yalahar
	[9113] = {position = Position(32192, 31419, 2), storage = 10028}, --ice
	[9114] = {position = Position(32972, 32227, 7), storage = 10028}, --earth
	[9115] = {position = Position(32911, 32336, 15), storage = 10028}, --fire
	[9116] = {position = Position(33059, 32716, 5), storage = 10028}, --electric
	--Oramond
	[9117] = {position = Position(32192, 31419, 2), storage = 10029}, --ice
	[9118] = {position = Position(32972, 32227, 7), storage = 10029}, --earth
	[9119] = {position = Position(32911, 32336, 15), storage = 10029}, --fire
	[9120] = {position = Position(33059, 32716, 5), storage = 10029} --electric
}

local shrineEntrance = MoveEvent()

function shrineEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local portal = setting[item.uid]
	if not portal or player:getLevel() < 30 then
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Only players of level 30 or higher may enter this portal.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:teleportTo(portal.position)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:setStorageValue(portal.storage, 1)
	return true
end

shrineEntrance:type("stepin")

for index, value in pairs(setting) do
	shrineEntrance:uid(index)
end

shrineEntrance:register()
