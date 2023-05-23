local grandCommanderSoerenDeath = CreatureEvent("GrandCommanderSoerenDeath")
function grandCommanderSoerenDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer:isPlayer() and killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCommanderSoeren) < 1 then
		killer:setStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCommanderSoeren, 1)
		if killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.PreceptorLazare) == 1 then
			killer:setStorageValue(Storage.TheSecretLibrary.LowerBastionAccess, 1) -- Access to quest door
		end
	end
end
grandCommanderSoerenDeath:register()

local preceptorLazareDeath = CreatureEvent("PreceptorLazareDeath")
function preceptorLazareDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer:isPlayer() and killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.PreceptorLazare) < 1 then
		killer:setStorageValue(Storage.TheSecretLibrary.MiniBosses.PreceptorLazare, 1)
		if killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCommanderSoeren) == 1 then
			killer:setStorageValue(Storage.TheSecretLibrary.LowerBastionAccess, 1) -- Access to quest door
		end
	end
end
preceptorLazareDeath:register()

local grandChaplainGaunderDeath = CreatureEvent("GrandChaplainGaunderDeath")
function grandChaplainGaunderDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer:isPlayer() and killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandChaplainGaunder) < 1 then
		killer:setStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandChaplainGaunder, 1)
		if killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCanonDominus) == 1 then
			killer:setStorageValue(Storage.TheSecretLibrary.UndergroundBastionAccess, 1) -- Access to quest door
		end
	end
end
grandChaplainGaunderDeath:register()

local grandCanonDominusDeath = CreatureEvent("GrandCanonDominusDeath")
function grandCanonDominusDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer:isPlayer() and killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCanonDominus) < 1 then
		killer:setStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandCanonDominus, 1)
		if killer:getStorageValue(Storage.TheSecretLibrary.MiniBosses.GrandChaplainGaunder) == 1 then
			killer:setStorageValue(Storage.TheSecretLibrary.UndergroundBastionAccess, 1) -- Access to quest door
		end
	end
end
grandCanonDominusDeath:register()

local dazedLeafGolemDeath = CreatureEvent("DazedLeafGolemDeath")
function dazedLeafGolemDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer:isPlayer() and killer:getStorageValue(Storage.TheSecretLibrary.OberonAccess) < 1 then
		killer:setStorageValue(Storage.TheSecretLibrary.OberonAccess, 1) -- Access to teleport
	end
end
dazedLeafGolemDeath:register()
