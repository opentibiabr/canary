function Monster:handleCobraOnSpawn()
	if Game.getStorageValue(Global.Storage.CobraFlask) >= os.time() then
		monster:setHealth(monster:getMaxHealth() * 0.75)
		monster:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
	else
		Game.setStorageValue(Global.Storage.CobraFlask, -1)
	end
end
