local configs = {
	-- Override examples
	--- durationOverride = 30,
	--- cooldownOverride = 60,
	--- tickTypeOverride = ConcoctionTickType.Experience,

	[Concoction.Ids.StaminaExtension] = {
		amount = 60, -- minutes
		callback = function(player, config)
			player:setStamina(player:getStamina() + config.amount)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been granted " .. config.amount .. " minutes of stamina.")
		end,
	},
	[Concoction.Ids.KooldownAid] = {
		callback = function(player)
			player:clearSpellCooldowns()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your spells are no longer on cooldown.")
		end,
	},
	[Concoction.Ids.StrikeEnhancement] = { condition = { CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 5 } },
	[Concoction.Ids.CharmUpgrade] = { condition = { CONDITION_PARAM_CHARM_CHANCE_MODIFIER, 5 } },
	[Concoction.Ids.WealthDuplex] = { rate = 100 },
	[Concoction.Ids.BestiaryBetterment] = { multiplier = 2.0 },
	[Concoction.Ids.FireResilience] = { condition = { CONDITION_PARAM_ABSORB_FIREPERCENT, 8 } },
	[Concoction.Ids.IceResilience] = { condition = { CONDITION_PARAM_ABSORB_ICEPERCENT, 8 } },
	[Concoction.Ids.EarthResilience] = { condition = { CONDITION_PARAM_ABSORB_EARTHPERCENT, 8 } },
	[Concoction.Ids.EnergyResilience] = { condition = { CONDITION_PARAM_ABSORB_ENERGYPERCENT, 8 } },
	[Concoction.Ids.HolyResilience] = { condition = { CONDITION_PARAM_ABSORB_HOLYPERCENT, 8 } },
	[Concoction.Ids.DeathResilience] = { condition = { CONDITION_PARAM_ABSORB_DEATHPERCENT, 8 } },
	[Concoction.Ids.PhysicalResilience] = { condition = { CONDITION_PARAM_ABSORB_PHYSICALPERCENT, 8 } },
	[Concoction.Ids.FireAmplification] = { condition = { CONDITION_PARAM_INCREASE_FIREPERCENT, 8 } },
	[Concoction.Ids.IceAmplification] = { condition = { CONDITION_PARAM_INCREASE_ICEPERCENT, 8 } },
	[Concoction.Ids.EarthAmplification] = { condition = { CONDITION_PARAM_INCREASE_EARTHPERCENT, 8 } },
	[Concoction.Ids.EnergyAmplification] = { condition = { CONDITION_PARAM_INCREASE_ENERGYPERCENT, 8 } },
	[Concoction.Ids.HolyAmplification] = { condition = { CONDITION_PARAM_INCREASE_HOLYPERCENT, 8 } },
	[Concoction.Ids.DeathAmplification] = { condition = { CONDITION_PARAM_INCREASE_DEATHPERCENT, 8 } },
	[Concoction.Ids.PhysicalAmplification] = { condition = { CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 8 } },
}

for concoctionKey, concoctionId in pairs(Concoction.Ids) do
	Concoction.new({
		id = concoctionId,
		timeLeftStorage = Storage.TibiaDrome[concoctionKey].TimeLeft,
		lastActivatedAtStorage = Storage.TibiaDrome[concoctionKey].LastActivatedAt,
		config = configs[concoctionId] or {},
	}):register()
end

local concoctionsOnLogin = CreatureEvent("ConcoctionsOnLogin")

function concoctionsOnLogin.onLogin(player)
	Concoction.initAll(player, true)
	return true
end

concoctionsOnLogin:register()
