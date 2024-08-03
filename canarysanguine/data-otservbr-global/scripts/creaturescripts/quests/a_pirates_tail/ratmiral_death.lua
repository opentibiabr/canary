local ratmiralBlackwhiskersDeath = CreatureEvent("RatmiralBlackwhiskersDeath")
local outfits = { 1371, 1372 }

function ratmiralBlackwhiskersDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature or not creature:getMonster() then
		return
	end
	local damageMap = creature:getMonster():getDamageMap()

	for key, _ in pairs(damageMap) do
		local player = Player(key)
		if player and not player:hasOutfit(outfits[1]) and not player:hasOutfit(outfits[2]) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Rascoohan Outfit.")
			player:addOutfit(1371, 0)
			player:addOutfit(1372, 0)
		end
	end
end

ratmiralBlackwhiskersDeath:register()
