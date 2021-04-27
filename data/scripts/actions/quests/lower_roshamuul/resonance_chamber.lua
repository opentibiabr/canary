local config = {
	item = 22535,
	storage = 34380,
	position = {
		Position(33637, 32516, 5), -- Top Left
		Position(33664, 32537, 5), -- botton Right
		Position(33650, 32527, 5)  -- Center
	},
	raid = {
		[1] = {"silencer", math.random(8,15) },
		[2] = {"silencer", math.random(11,18) },
		[3] = {"silencer", math.random(8,15) },
		[4] = {"sight of surrender", math.random(3,8) }
	},
	globalEventTime = 30 * 60 * 1000, -- [30min] waiting time to get started again
	timeBetweenraid = 1  * 60 * 1000, -- [1min] Waiting time between each raid
	cleanraid = true -- Clean zone after globalEventTime
}

local function raids(monster)
        local randX,randY,randZ = 0,0,0
        randX = math.random(config.position[1].x, config.position[2].x)
        randY = math.random(config.position[1].y, config.position[2].y)
        randZ = math.random(config.position[1].z, config.position[2].z)

		local pos = Position(randX, randY, randZ)
		local tile = Tile(pos)
		if not tile then return false end

        if tile:isWalkable(true, false, false, false, true) then
			Game.createMonster(monster, Position(randX, randY, randZ))
        else
			raids(monster)
        end
end

local function cleanRaid()
	local mostersraid= Game.getSpectators(config.position[3], false, false, 13, 13, 11, 11)
    for i = 1, #mostersraid do
		if mostersraid[i]:isMonster() then
			mostersraid[i]:remove()
		end
	end
end

local lowerRoshamuulChamber = Action()
function lowerRoshamuulChamber.onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	local max,time,monster = 0,0,""

    if item.itemid ~= config.item then
        return true
    end
    local spectators,hasPlayer,hasMonsters = Game.getSpectators(config.position[3], false, false, 13, 13, 11, 11),false,false
    for i = 1, #spectators do
        if spectators[i]:isPlayer() then
			if spectators[i]:getName() == player:getName() then
				hasPlayer = true
			end
		elseif spectators[i]:isMonster() then
			hasMonsters = true
		end
	end
	if not hasPlayer then
		player:sendCancelMessage('Use on Silencer Plateau is located in the south-eastern part of Roshamuul')
		return true
	end
	if hasMonsters then
		player:sendCancelMessage('You need kill all monsters')
		return true
	end

	if Game.getStorageValue(config.storage) <= 0 then
		if math.random(0,10000) < 7000 then
			player:say("PRRRR...*crackle*", TALKTYPE_MONSTER_SAY)
			item:remove(1)
			return true
		else
			player:say("PRRRROOOOOAAAAAHHHH!!!", TALKTYPE_MONSTER_SAY)
		end

		local raid = config.raid
		for y, x in pairs(raid) do
			local i = 1
			while i <= #x  do
				time = time + config.timeBetweenraid
				for j = 1, x[i+1] do
					Game.setStorageValue(config.storage,x[i+1])
					addEvent(raids,time,x[i])
				end
				i = i + 2
			end
		end

		addEvent(Game.setStorageValue, config.globalEventTime, config.storage, 0)
		if config.cleanraid then
			addEvent(cleanRaid, config.globalEventTime)
		end
		item:remove(1)
	else
		player:sendCancelMessage('You need to wait')
	end
end

lowerRoshamuulChamber:id(22535)
lowerRoshamuulChamber:register()
