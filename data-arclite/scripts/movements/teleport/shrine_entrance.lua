local shrinesEntrance = {
	ice = {
		{x = 32356, y = 31780, z = 9},--Carlin
		{x = 32358, y = 32242, z = 6},--Thais
		{x = 32954, y = 32076, z = 5},--Venore
		{x = 32678, y = 31688, z = 2},--Ab'Dendriel
		{x = 32643, y = 31928, z = 11},--Kazodroon
		{x = 33229, y = 32389, z = 5},--Darashia
		{x = 33126, y = 32812, z = 4},--Ankrahmun
		{x = 33264, y = 31837, z = 9},--Edron
		{x = 32333, y = 32838, z = 8},--Liberty Bay
		{x = 32624, y = 32744, z = 4},--Port Hope
		{x = 32212, y = 31130, z = 8},--Svargrond
		{x = 32784, y = 31243, z = 5},--Yalahar
		{x = 33592, y = 31896, z = 4}--Oramond
	},
	earth = {
		{x = 32364, y = 31780, z = 9},--Carlin
		{x = 32360, y = 32239, z = 6},--Thais
		{x = 32958, y = 32079, z = 5},--Venore
		{x = 32678, y = 31686, z = 2},--Ab'Dendriel
		{x = 32649, y = 31928, z = 11},--Kazodroon
		{x = 33232, y = 32389, z = 5},--Darashia
		{x = 33131, y = 32806, z = 4},--Ankrahmun
		{x = 33266, y = 31831, z = 9},--Edron
		{x = 32339, y = 32842, z = 8},--Liberty Bay
		{x = 32625, y = 32740, z = 4},--Port Hope
		{x = 32215, y = 31130, z = 8},--Svargrond
		{x = 32787, y = 31243, z = 5},--Yalahar
		{x = 33596, y = 31901, z = 4}--Oramond
	},
	fire = {
		{x = 32356, y = 31783, z = 9},--Carlin
		{x = 32379, y = 32242, z = 6},--Thais
		{x = 32961, y = 32076, z = 5},--Venore
		{x = 32678, y = 31684, z = 2},--Ab'Dendriel
		{x = 32649, y = 31921, z = 11},--Kazodroon
		{x = 33235, y = 32389, z = 5},--Darashia
		{x = 33126, y = 32820, z = 4},--Ankrahmun
		{x = 33271, y = 31831, z = 9},--Edron
		{x = 32343, y = 32838, z = 8},--Liberty Bay
		{x = 32632, y = 32740, z = 4},--Port Hope
		{x = 32208, y = 31133, z = 8},--Svargrond
		{x = 32790, y = 31243, z = 5},--Yalahar
		{x = 33592, y = 31901, z = 4}--Oramond
	},
	energy = {
		{x = 32364, y = 31783, z = 9},--Carlin
		{x = 32377, y = 32239, z = 6},--Thais
		{x = 32958, y = 32072, z = 5},--Venore
		{x = 32681, y = 31683, z = 2},--Ab'Dendriel
		{x = 32643, y = 31921, z = 11},--Kazodroon
		{x = 33226, y = 32389, z = 5},--Darashia
		{x = 33131, y = 32823, z = 4},--Ankrahmun
		{x = 33271, y = 31837, z = 9},--Edron
		{x = 32339, y = 32832, z = 8},--Liberty Bay
		{x = 32632, y = 32744, z = 4},--Port Hope
		{x = 32209, y = 31130, z = 8},--Svargrond
		{x = 32781, y = 31243, z = 5},--Yalahar
		{x = 33596, y = 31896, z = 4}--Oramond
	}
}

local function toShrine(player, entrance, destination)
	for a = 1, #entrance do
		if player:getPosition() == Position(entrance[a]) then
			player:teleportTo(destination)
			player:setStorageValue(Storage.ShrineEntrance, a)
		end
	end
end

local shrineEntrance = MoveEvent()
function shrineEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getLevel() < 30 then
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Only players of level 30 or higher may enter this portal.", TALKTYPE_MONSTER_SAY)
		return true
	end
	toShrine(player, shrinesEntrance.ice, Position(32192, 31419, 2))
	toShrine(player, shrinesEntrance.earth, Position(32972, 32227, 7))
	toShrine(player, shrinesEntrance.fire, Position(32911, 32336, 15))
	toShrine(player, shrinesEntrance.energy, Position(33059, 32716, 5))
	return true
end

for b = 1, #shrinesEntrance.ice do
	shrineEntrance:position(shrinesEntrance.ice[b])
end
for c = 1, #shrinesEntrance.earth do
	shrineEntrance:position(shrinesEntrance.earth[c])
end
for d = 1, #shrinesEntrance.fire do
	shrineEntrance:position(shrinesEntrance.fire[d])
end
for e = 1, #shrinesEntrance.energy do
	shrineEntrance:position(shrinesEntrance.energy[e])
end
shrineEntrance:register()
