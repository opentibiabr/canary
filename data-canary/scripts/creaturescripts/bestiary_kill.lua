local bestiaryOnKill = CreatureEvent("BestiaryOnKill")

function bestiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		if participant and participant:isPlayer() then
			participant:addBestiaryKill(creature:getName())
		end
	end

	return true
end

bestiaryOnKill:register()

local loginBestiaryPlayer = CreatureEvent("loginBestiaryPlayer")

function loginBestiaryPlayer.onLogin(player)
	player:registerEvent("BestiaryOnKill")
	return true
end

loginBestiaryPlayer:register()
