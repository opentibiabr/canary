local primeirotp = {
	configaid = 57539, -- action id teleport
	localfireum = {x = 33830, y = 31628, z = 9}, -- local do fire um
	localfiredois = {x = 33832, y = 31628, z = 9}, -- local do fire dois
	localfiretres = {x = 33834, y = 31628, z = 9}, -- local do fire tres
	fireon = 7527, -- id do fire on
	fireoff = 1485, -- id do fire off
}

local segundotp = {
	configaid = 57540, -- action id teleport
	localfireum = {x = 33830, y = 31628, z = 9}, -- local do fire um
	localfiredois = {x = 33832, y = 31628, z = 9}, -- local do fire dois
	localfiretres = {x = 33834, y = 31628, z = 9}, -- local do fire tres
	fireon = 7527, -- id do fire on
	fireoff = 1485, -- id do fire off
}

local terceirotp = {
	configaid = 57541, -- action id teleport
	localfireum = {x = 33830, y = 31628, z = 9}, -- local do fire um
	localfiredois = {x = 33832, y = 31628, z = 9}, -- local do fire dois
	localfiretres = {x = 33834, y = 31628, z = 9}, -- local do fire tres
	fireon = 7527, -- id do fire on
	fireoff = 1485, -- id do fire off
}

local quartotp = {
	configaid = 57542, -- action id teleport
	localfireum = {x = 33830, y = 31628, z = 9}, -- local do fire um
	localfiredois = {x = 33832, y = 31628, z = 9}, -- local do fire dois
	localfiretres = {x = 33834, y = 31628, z = 9}, -- local do fire tres
	fireon = 7527, -- id do fire on
	fireoff = 1485, -- id do fire off
}


local errotp = {x = 33822, y = 31645, z = 9} -- errou
local finaltp = {x = 33826, y = 31620, z = 9} -- deu certo

local firetp = MoveEvent()

function firetp.onStepIn(creature, item, position, fromPosition)


	local player = creature:getPlayer()
	if not player then
		return true
	end


	local firstfasefireum = Tile(primeirotp.localfireum):getItemById(primeirotp.fireoff)
	local firstfasefiredois = Tile(primeirotp.localfiredois):getItemById(primeirotp.fireoff)
	local firstfasefiretres = Tile(primeirotp.localfiretres):getItemById(primeirotp.fireoff)

	if item.actionid == primeirotp.configaid then
		if firstfasefireum and firstfasefiredois and firstfasefiretres then
			player:teleportTo(finaltp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(errotp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	
	
	
	local secondfasefireum = Tile(segundotp.localfireum):getItemById(segundotp.fireon)
	local secondfasefiredois = Tile(segundotp.localfiredois):getItemById(segundotp.fireoff)
	local secondfasefiretres = Tile(segundotp.localfiretres):getItemById(segundotp.fireoff)

	if item.actionid == segundotp.configaid then
		if secondfasefireum and secondfasefiredois and secondfasefiretres then
			player:teleportTo(finaltp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(errotp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	
	
	
	local thirdfasefireum = Tile(terceirotp.localfireum):getItemById(terceirotp.fireon)
	local thirdfasefiredois = Tile(terceirotp.localfiredois):getItemById(terceirotp.fireon)
	local thirdfasefiretres = Tile(terceirotp.localfiretres):getItemById(terceirotp.fireoff)

	if item.actionid == terceirotp.configaid then
		if thirdfasefireum and thirdfasefiredois and thirdfasefiretres then
			player:teleportTo(finaltp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(errotp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	
	
	
	local fourthfasefireum = Tile(quartotp.localfireum):getItemById(quartotp.fireon)
	local fourthfasefiredois = Tile(quartotp.localfiredois):getItemById(quartotp.fireon)
	local fourthfasefiretres = Tile(quartotp.localfiretres):getItemById(quartotp.fireon)

	if item.actionid == quartotp.configaid then
		if fourthfasefireum and fourthfasefiredois and fourthfasefiretres then
			player:teleportTo(finaltp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(errotp)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	
	
	

	return true
end

firetp:aid(57539, 57540, 57541, 57542)
firetp:register()



