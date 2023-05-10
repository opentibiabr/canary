if Wheel == nil then
	Wheel = {
		enabled = true,
		minLevelToUse = 50,
		minLevelToStartCountPoints = 50,
		pointsPerLevel = 1,
		-- This value seems to be hardcoded on the client, only can be changed when editing the client (Default TRUE)
		onlyPremiumPlayersCanUse = true,
		-- This value seems to be hardcoded on the client, only can be changed when editing the client (Default TRUE)
		onlyPromotedPlayersCanUse = true,
		-- Spells used on 'Focus spells' bonus
		focusSpells = {
			mage = {"Eternal Winter", "Hell's Core", "Rage of the Skies", "Wrath of Nature"}
		},
		-- Can get up to +37 from this value (From ...01 to ...37)
		slotsPointsSelected = Global.Storage.WheelOfDestinySlotsPointsSelected,
		enum = {
			bytes = {
				client = {
					PROTOCOL_OPEN_WINDOW = 0x61,
					PROTOCOL_SAVE_WINDOW = 0x62
				}
			},
			slots = {
				SLOT_GREEN_200 = 1,
				SLOT_GREEN_TOP_150 = 2,
				SLOT_GREEN_TOP_100 = 3,

				SLOT_RED_TOP_100 = 4,
				SLOT_RED_TOP_150 = 5,
				SLOT_RED_200 = 6,

				SLOT_GREEN_BOTTOM_150 = 7,
				SLOT_GREEN_MIDDLE_100 = 8,
				SLOT_GREEN_TOP_75 = 9,

				SLOT_RED_TOP_75 = 10,
				SLOT_RED_MIDDLE_100 = 11,
				SLOT_RED_BOTTOM_150 = 12,

				SLOT_GREEN_BOTTOM_100 = 13,
				SLOT_GREEN_BOTTOM_75 = 14,
				SLOT_GREEN_50 = 15,

				SLOT_RED_50 = 16,
				SLOT_RED_BOTTOM_75 = 17,
				SLOT_RED_BOTTOM_100 = 18,

				SLOT_BLUE_TOP_100 = 19,
				SLOT_BLUE_TOP_75 = 20,
				SLOT_BLUE_50 = 21,

				SLOT_PURPLE_50 = 22,
				SLOT_PURPLE_TOP_75 = 23,
				SLOT_PURPLE_TOP_100 = 24,

				SLOT_BLUE_TOP_150 = 25,
				SLOT_BLUE_MIDDLE_100 = 26,
				SLOT_BLUE_BOTTOM_75 = 27,

				SLOT_PURPLE_BOTTOM_75 = 28,
				SLOT_PURPLE_MIDDLE_100 = 29,
				SLOT_PURPLE_TOP_150 = 30,

				SLOT_BLUE_200 = 31,
				SLOT_BLUE_BOTTOM_150 = 32,
				SLOT_BLUE_BOTTOM_100 = 33,

				SLOT_PURPLE_BOTTOM_100 = 34,
				SLOT_PURPLE_BOTTOM_150 = 35,
				SLOT_PURPLE_200 = 36,

				SLOT_FIRST = 1, -- SLOT_GREEN_200
				SLOT_LAST = 36, -- SLOT_PURPLE_200
			},
			vocation = {
				VOCATION_INVALID = 0,
				VOCATION_KNIGHT = 1,
				VOCATION_PALADIN = 2,
				VOCATION_SORCERER = 3,
				VOCATION_DRUID = 4
			},
			stage = {
				STAGE_NONE = 0,
				STAGE_ONE = 1,
				STAGE_TWO = 2,
				STAGE_THREE = 3
			},
			stagePoints = {
				STAGE_POINTS_ONE = 250,
				STAGE_POINTS_TWO = 500,
				STAGE_POINTS_THREE = 1000
			},
			combatType = {
				COMBAT_TYPE_INDEX_PHYSICAL = 0,
				COMBAT_TYPE_INDEX_ENERGY = 1,
				COMBAT_TYPE_INDEX_EARTH = 2,
				COMBAT_TYPE_INDEX_FIRE = 3,
				COMBAT_TYPE_INDEX_UNDEFINED = 4,
				COMBAT_TYPE_INDEX_LIFEDRAIN = 5,
				COMBAT_TYPE_INDEX_MANADRAIN = 6,
				COMBAT_TYPE_INDEX_HEALING = 7,
				COMBAT_TYPE_INDEX_DROWN = 8,
				COMBAT_TYPE_INDEX_ICE = 9,
				COMBAT_TYPE_INDEX_HOLY = 10,
				COMBAT_TYPE_INDEX_DEATH = 11
			}
		},
		bonus = {
			revelation = {
				stats = {
					[1] = {
						damage = 4,
						healing = 4
					},
					[2] = {
						damage = 9,
						healing = 9
					},
					[3] = {
						damage = 20,
						healing = 20
					}
				}
			},
			spells = {
				Druid = {
					[1] = {
						name = "Strong Ice Wave",
						grade = {
							[1] = {
								leech = {
									mana = 3 -- 3%
								}
							},
							[2] = {
								increase = {
									damage = 30 -- 30%
								}
							}
						}
					},
					[2] = {
						name = "Mass Healing",
						grade = {
							[1] = {
								increase = {
									heal = 10 -- 10%
								}
							},
							[2] = {
								increase = {
									area = true -- true
								}
							}
						}
					},
					[3] = {
						name = "Nature's Embrace",
						grade = {
							[1] = {
								increase = {
									heal = 10 -- 10%
								}
							},
							[2] = {
								decrease = {
									coolDown = 10 -- 10s
								}
							}
						}
					},
					[4] = {
						name = "Terra Wave",
						grade = {
							[1] = {
								increase = {
									damage = 25 -- 25%
								}
							},
							[2] = {
								leech = {
									life = 5 -- 5%
								}
							}
						}
					},
					[5] = {
						name = "Heal Friend",
						grade = {
							[1] = {
								decrease = {
									manaCost = 10 -- 10 mana
								}
							},
							[2] = {
								increase = {
									heal = 10 -- 10%
								}
							}
						}
					}
				},
				Knight = {
					[1] = {
						name = "Front Sweep",
						grade = {
							[1] = {
								leech = {
									life = 5 -- 5%
								}
							},
							[2] = {
								increase = {
									damage = 30 -- 30%
								}
							}
						}
					},
					[2] = {
						name = "Groundshaker",
						grade = {
							[1] = {
								increase = {
									damage = 25 -- 25%
								}
							},
							[2] = {
								decrease = {
									coolDown = 2 -- 2s
								}
							}
						}
					},
					[3] = {
						name = "Chivalrous Challenge",
						grade = {
							[1] = {
								decrease = {
									manaCost = 20 -- 20 mana
								}
							},
							[2] = {
								increase = {
									aditionalTarget = 1 -- 1 target
								}
							}
						}
					},
					[4] = {
						name = "Intense Wound Cleansing",
						grade = {
							[1] = {
								increase = {
									heal = 10 -- 10%
								}
							},
							[2] = {
								decrease = {
									coolDown = 300 -- 300s
								}
							}
						}
					},
					[5] = {
						name = "Fierce Berserk",
						grade = {
							[1] = {
								decrease = {
									manaCost = 30 -- 30 mana
								}
							},
							[2] = {
								increase = {
									damage = 25 -- 25%
								}
							}
						}
					}
				},
				Paladin = {
					[1] = {
						name = "Sharpshooter",
						grade = {
							[1] = {
								decrease = {
									secondaryGroupCooldown = 8 -- 8s
								}
							},
							[2] = {
								decrease = {
									coolDown = 6 -- 6s
								}
							}
						}
					},
					[2] = {
						name = "Strong Ethereal Spear",
						grade = {
							[1] = {
								decrease = {
									coolDown = 2 -- 2s
								}
							},
							[2] = {
								increase = {
									damage = 25 -- 25%
								}
							}
						}
					},
					[3] = {
						name = "Divine Dazzle",
						grade = {
							[1] = {
								increase = {
									aditionalTarget = 1 -- 1 target
								}
							},
							[2] = {
								increase = {
									duration = 4 -- 4s
								},
								decrease = {
									coolDown = 4 -- 4s
								}
							}
						}
					},
					[4] = {
						name = "Swift Foot",
						grade = {
							[1] = {
								decrease = {
									secondaryGroupCooldown = 8 -- 8s
								}
							},
							[2] = {
								decrease = {
									coolDown = 6 -- 6s
								}
							}
						}
					},
					[5] = {
						name = "Divine Caldera",
						grade = {
							[1] = {
								decrease = {
									manaCost = 20 -- 20 mana
								}
							},
							[2] = {
								increase = {
									damage = 25 -- 25%
								}
							}
						}
					}
				},
				Sorcerer = {
					[1] = {
						name = "Magic Shield",
						grade = {
							[1] = {
								-- On spell LUA
							},
							[2] = {
								decrease = {
									coolDown = 6 -- 6s
								}
							}
						}
					},
					[2] = {
						name = "Sap Strength",
						grade = {
							[1] = {
								increase = {
									area = true -- true
								}
							},
							[2] = {
								increase = {
									damageReduction = 10 -- 10%
								}
							}
						}
					},
					[3] = {
						name = "Energy Wave",
						grade = {
							[1] = {
								increase = {
									damage = 25 -- 25%
								}
							},
							[2] = {
								increase = {
									area = true -- true
								}
							}
						}
					},
					[4] = {
						name = "Great Fire Wave",
						grade = {
							[1] = {
								increase = {
									criticalDamage = 15, -- 15%
									criticalChance = 10 -- 10%
								}
							},
							[2] = {
								increase = {
									damage = 25 -- 25%
								}
							}
						}
					},
					[5] = {
						name = "Any_Focus_Mage_Spell",
						grade = {
							[1] = {
								increase = {
									damage = 25 -- 25%
								}
							},
							[2] = {
								decrease = {
									coolDown = 4, -- 4s
									secondaryGroupCooldown = 4 -- 4s
								}
							}
						}
					}
				}
			}
		},
		data = {
			player = {}
		}
	}
end

Wheel.registerSpellTable = function(spellData, name, grade)
	if name == "Any_Focus_Mage_Spell" then
		for _, spellName in ipairs(Wheel.focusSpells.mage) do
			Wheel.registerSpellTable(spellData, spellName, grade)
		end
		return
	end

	local spell = Spell(name)
	if spell then
		-- Increase area
		if spellData.increase ~= nil then
			if spellData.increase.damage ~= nil then
				spell:increaseDamageWOD(grade, spellData.increase.damage)
			end
			if spellData.increase.damageReduction ~= nil then
				spell:increaseDamageReductionWOD(grade, spellData.increase.damageReduction)
			end
			if spellData.increase.heal ~= nil then
				spell:increaseHealWOD(grade, spellData.increase.heal)
			end
			if spellData.increase.criticalDamage ~= nil then
				spell:increaseCriticalDamageWOD(grade, spellData.increase.criticalDamage)
			end
			if spellData.increase.criticalChance ~= nil then
				spell:increaseCriticalChanceWOD(grade, spellData.increase.criticalChance)
			end
		end
		-- Decrease area
		if spellData.decrease ~= nil then
			if spellData.decrease.coolDown ~= nil then
				spell:cooldownWOD(grade, spellData.decrease.coolDown * 1000)
			end
			if spellData.decrease.manaCost ~= nil then
				spell:manaWOD(grade, spellData.decrease.manaCost)
			end
			if spellData.decrease.groupCooldown ~= nil then
				spell:groupCooldownWOD(grade, spellData.decrease.groupCooldown * 1000)
			end
			if spellData.decrease.secondaryGroupCooldown ~= nil then
				spell:secondaryGroupCooldownWOD(grade, spellData.decrease.secondaryGroupCooldown * 1000)
			end
		end
		-- Leech area
		if spellData.leech ~= nil then
			if spellData.leech.mana ~= nil then
				spell:increaseManaLeechWOD(grade, spellData.leech.mana * 100)
			end
			if spellData.leech.life ~= nil then
				spell:increaselifeLeechWOD(grade, spellData.leech.life * 100)
			end
		end
	else
		Spdlog.warn("[Wheel.canUseOwnWheel] Spell with name '" .. spellData.name .. "' could not be found and was ignored")
	end
end

Wheel.initializeGlobalData = function(reload)
	if not Wheel.enabled then
		if not reload then
			Spdlog.info("Loading wheel of destiny... [Disabled by admin]")
		end
		return false
	end

	-- Initialize spells for druid
	for _, data in ipairs(Wheel.bonus.spells.Druid) do
		for grade, spellData in ipairs(data.grade) do
			Wheel.registerSpellTable(spellData, data.name, grade)
		end
	end
	-- Initialize spells for knight
	for _, data in ipairs(Wheel.bonus.spells.Knight) do
		for grade, spellData in ipairs(data.grade) do
			Wheel.registerSpellTable(spellData, data.name, grade)
		end
	end
	-- Initialize spells for paladin
	for _, data in ipairs(Wheel.bonus.spells.Paladin) do
		for grade, spellData in ipairs(data.grade) do
			Wheel.registerSpellTable(spellData, data.name, grade)
		end
	end
	-- Initialize spells for sorcerer
	for _, data in ipairs(Wheel.bonus.spells.Sorcerer) do
		for grade, spellData in ipairs(data.grade) do
			Wheel.registerSpellTable(spellData, data.name, grade)
		end
	end

	if not reload then
		Spdlog.info("Loading wheel of destiny... [Success]")
	else
		Spdlog.info("Reloading wheel of destiny... [Success]")
	end
	return true
end

Wheel.getPlayerVocationEnum = function(player)
	if not player then
		Spdlog.error("[Wheel.getPlayerVocationEnum] 'player' cannot be null")
		return Wheel.enum.vocation.VOCATION_INVALID
	end

	if player:getVocation():getClientId() == 1 or player:getVocation():getClientId() == 11 then
		return Wheel.enum.vocation.VOCATION_KNIGHT -- Knight
	elseif player:getVocation():getClientId() == 2 or player:getVocation():getClientId() == 12 then
		return Wheel.enum.vocation.VOCATION_PALADIN -- Paladin
	elseif player:getVocation():getClientId() == 3 or player:getVocation():getClientId() == 13 then
		return Wheel.enum.vocation.VOCATION_SORCERER -- Sorcerer
	elseif player:getVocation():getClientId() == 4 or player:getVocation():getClientId() == 14 then
		return Wheel.enum.vocation.VOCATION_DRUID -- Druid
	end

	return Wheel.enum.vocation.VOCATION_INVALID
end

Wheel.canUseOwnWheel = function(player)
	if not player then
		Spdlog.error("[Wheel.canUseOwnWheel] 'player' cannot be null")
		return false
	end

	if not Wheel.enabled then
		return false
	end

	-- Vocation check
	if Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_INVALID then
		if DEV_MODE then
			Spdlog.error("Not have valid vocation to open wheel")
		end
		return false
	end

	-- Level check
	if player:getLevel() <= Wheel.minLevelToUse then
		if DEV_MODE then
			Spdlog.error("Not have level to open wheel")
		end
		return false
	end

	if Wheel.onlyPremiumPlayersCanUse and not player:isPremium() then
		if DEV_MODE then
			Spdlog.error("Not is premium account")
		end
		return false
	end

	if Wheel.onlyPromotedPlayersCanUse and player:getVocation():getId() <= 4 then
		if DEV_MODE then
			Spdlog.error("Not have promotion to open wheel")
		end
		return false
	end

	if DEV_MODE then
		Spdlog.info("Opened wheel")
	end
	return true
end

Wheel.initializePlayerData = function(player)
	if not player then
		Spdlog.error("[Wheel.initializePlayerData] 'player' cannot be null")
		return false
	end

	if not Wheel.enabled then
		return true
	end

	if Wheel.data.player[player:getGuid()] ~= nil then
		Wheel.registerPlayerBonusData(player)
		return true
	end

	-- Creating blank table
	Wheel.data.player[player:getGuid()] = {}

	-- Load slots data
	if not Wheel.loadPlayerSlotsData(player) then
		return false
	end

	-- Clear player data
	if not Wheel.resetPlayerBonusData(player) then
		return false
	end

	-- Load bonus data
	if not Wheel.loadPlayerBonusData(player) then
		return false
	end

	-- Register player bonus data
	if not Wheel.registerPlayerBonusData(player) then
		return false
	end

	return true
end

Wheel.registerPlayerBonusData = function(player)
	if not player then
		Spdlog.error("[Wheel.registerPlayerBonusData] 'player' cannot be null")
		return false
	end

	if not Wheel.enabled then
		if player:getHealth() > player:getMaxHealth() then
			player:setHealth(player:getMaxHealth())
		end
		if player:getMana() > player:getMaxMana() then
			player:setMana(player:getMaxMana())
		end
		return true
	end

	-- Get data value
	local data = Wheel.data.player[player:getGuid()]
	if data == nil then
		Spdlog.error("[Wheel.registerPlayerBonusData] data is invalid")
		return false
	end

	local bonus = data.bonus

	-- Reset stages and spell data
	player:upgradeSpellsWORD()

	-- Stats
	player:statsHealthWOD(bonus.stats.health)
	player:statsManaWOD(bonus.stats.mana)
	player:statsCapacityWOD(bonus.stats.capacity * 100)
	player:statsMitigationWOD(bonus.mitigation * 100)
	player:statsDamageWOD(bonus.stats.damage)
	player:statsHealingWOD(bonus.stats.healing)

	-- Resistance
	player:resistanceWOD()
	for element, values in ipairs(bonus.resistance) do
		player:resistanceWOD(element, values)
	end

	-- Skills
	player:skillsMeleeWOD(bonus.skills.melee)
	player:skillsDistanceWOD(bonus.skills.distance)
	player:skillsMagicWOD(bonus.skills.magic)

	-- Leech
	player:leechWOD(Wheel.enum.combatType.COMBAT_TYPE_INDEX_LIFEDRAIN, bonus.leech.lifeLeech * 100)
	player:leechWOD(Wheel.enum.combatType.COMBAT_TYPE_INDEX_MANADRAIN, bonus.leech.manaLeech * 100)

	-- Instant
	player:instantSkillWOD("Battle Instinct", bonus.instant.battleInstinct)
	player:instantSkillWOD("Battle Healing", bonus.instant.battleHealing)
	player:instantSkillWOD("Positional Tatics", bonus.instant.positionalTatics)
	player:instantSkillWOD("Ballistic Mastery", bonus.instant.ballisticMastery)
	player:instantSkillWOD("Healing Link", bonus.instant.healingLink)
	player:instantSkillWOD("Runic Mastery", bonus.instant.runicMastery)
	player:instantSkillWOD("Focus Mastery", bonus.instant.focusMastery)

	-- Stages (Revelation)
	if bonus.stages.combatMastery > 0 then
		for i = 1, bonus.stages.combatMastery do
			player:instantSkillWOD("Combat Mastery", true)
		end
	else
		player:instantSkillWOD("Combat Mastery", false)
	end
	if bonus.stages.giftOfLife > 0 then
		for i = 1, bonus.stages.giftOfLife do
			player:instantSkillWOD("Gift of Life", true)
		end
	else
		player:instantSkillWOD("Gift of Life", false)
	end
	if bonus.stages.blessingOfTheGrove > 0 then
		for i = 1, bonus.stages.blessingOfTheGrove do
			player:instantSkillWOD("Blessing of the Grove", true)
		end
	else
		player:instantSkillWOD("Blessing of the Grove", false)
	end
	if bonus.stages.divineEmpowerment > 0 then
		for i = 1, bonus.stages.divineEmpowerment do
			player:instantSkillWOD("Divine Empowerment", true)
		end
	else
		player:instantSkillWOD("Divine Empowerment", false)
	end
	if bonus.stages.drainBody > 0 then
		for i = 1, bonus.stages.drainBody do
			player:instantSkillWOD("Drain Body", true)
		end
	else
		player:instantSkillWOD("Drain Body", false)
	end
	if bonus.stages.beamMastery > 0 then
		for i = 1, bonus.stages.beamMastery do
			player:instantSkillWOD("Beam Mastery", true)
		end
	else
		player:instantSkillWOD("Beam Mastery", false)
	end
	if bonus.stages.twinBurst > 0 then
		for i = 1, bonus.stages.twinBurst do
			player:instantSkillWOD("Twin Burst", true)
		end
	else
		player:instantSkillWOD("Twin Burst", false)
	end
	if bonus.stages.executionersThrow > 0 then
		for i = 1, bonus.stages.executionersThrow do
			player:instantSkillWOD("Executioner's Thow", true)
		end
	else
		player:instantSkillWOD("Executioner's Thow", false)
	end

	-- Avatar
	if bonus.avatar.light > 0 then
		for i = 1, bonus.avatar.light do
			player:instantSkillWOD("Avatar of Light", true)
		end
	else
		player:instantSkillWOD("Avatar of Light", false)
	end
	if bonus.avatar.nature > 0 then
		for i = 1, bonus.avatar.nature do
			player:instantSkillWOD("Avatar of Nature", true)
		end
	else
		player:instantSkillWOD("Avatar of Nature", false)
	end
	if bonus.avatar.steel > 0 then
		for i = 1, bonus.avatar.steel do
			player:instantSkillWOD("Avatar of Steel", true)
		end
	else
		player:instantSkillWOD("Avatar of Steel", false)
	end
	if bonus.avatar.storm > 0 then
		for i = 1, bonus.avatar.storm do
			player:instantSkillWOD("Avatar of Storm", true)
		end
	else
		player:instantSkillWOD("Avatar of Storm", false)
	end

	for _, spell in ipairs(bonus.spells) do
		player:upgradeSpellsWORD(spell, true)
	end

	if player:getHealth() > player:getMaxHealth() then
		player:setHealth(player:getMaxHealth())
	end
	if player:getMana() > player:getMaxMana() then
		player:addMana(-(player:getMana() - player:getMaxMana()))
	end

	player:onThinkWheelOfDestiny(false) -- Not forcing the reload
	player:reloadData()
	return true
end

Wheel.loadPlayerSlotsData = function(player)
	if not player then
		Spdlog.error("[Wheel.loadPlayerSlotsData] 'player' cannot be null")
		return false
	end

	-- Adding default values on slots table
	if not Wheel.resetPlayerSlotsData(player) then
		return false
	end

	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		local value = player:getStorageValue(Wheel.slotsPointsSelected + i)
		if value > 0 then
			Wheel.data.player[player:getGuid()].slots[i] = value
		end
	end

	return true
end

Wheel.savePlayerSlotData = function(player, slot)
	if not player then
		Spdlog.error("[Wheel.savePlayerSlotsData] 'player' cannot be null")
		return false
	end

	local key = Wheel.slotsPointsSelected + slot
	local value = math.max(0, Wheel.data.player[player:getGuid()].slots[slot])
	player:setStorageValue(key, value, true)
	return true
end

Wheel.savePlayerAllSlotsData = function(player)
	if not player then
		Spdlog.error("[Wheel.savePlayerSlotsData] 'player' cannot be null")
		return false
	end

	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		if not Wheel.savePlayerSlotData(player, i) then
			return false
		end
	end

	return true
end

Wheel.resetPlayerSlotsData = function(player)
	if not player then
		Spdlog.error("[Wheel.resetPlayerSlotsData] 'player' cannot be null")
		return false
	end

	Wheel.data.player[player:getGuid()].slots = {}
	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		Wheel.data.player[player:getGuid()].slots[i] = 0
	end

	return true
end

Wheel.resetPlayerBonusData = function(player)
	if not player then
		Spdlog.error("[Wheel.resetPlayerBonusData] 'player' cannot be null")
		return false
	end

	Wheel.data.player[player:getGuid()].bonus = {
		stats = { -- Raw value. Example: 1 == 1
			health = 0,
			mana = 0,
			capacity = 0,
			damage = 0,
			healing = 0
		},
		resistance = { -- value * 100. Example: 1% == 100
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_PHYSICAL] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_EARTH] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_FIRE] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_UNDEFINED] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_LIFEDRAIN] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_MANADRAIN] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_HEALING] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_DROWN] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_ICE] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = 0,
			[Wheel.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = 0
		},
		skills = { -- Raw value. Example: 1 == 1
			melee = 0,
			distance = 0,
			magic = 0
		},
		leech = { -- value * 100. Example: 1% == 100
			manaLeech = 0,
			lifeLeech = 0
		},
		instant = {
			battleInstinct = false, -- Knight
			battleHealing = false, -- Knight
			positionalTatics = false, -- Paladin
			ballisticMastery = false, -- Paladin
			healingLink = false, -- Druid
			runicMastery = false, -- Druid/sorcerer
			focusMastery = false -- Sorcerer
		},
		stages = {
			combatMastery = 0, -- Knight
			giftOfLife = 0, -- Knight/Paladin/Druid/Sorcerer
			divineEmpowerment = 0, -- Paladin
			blessingOfTheGrove = 0, -- Druid
			drainBody = 0, -- Sorcerer
			beamMastery = 0, -- Sorcerer
			twinBurst = 0, -- Druid
			executionersThrow = 0 -- Knight
		},
		avatar = {
			light = 0, -- Paladin
			nature = 0, -- Druid
			steel = 0, -- Knight
			storm = 0 -- Sorcerer
		},
		mitigation = 0,
		spells = {} -- Array of strings containing boosted spells
	}

	return true
end

Wheel.loadDedicationAndConvictionPerks = function(player, guid)
	local vocationEnum = Wheel.getPlayerVocationEnum(player)
	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		local points = Wheel.getPlayerPointsOnSlot(player, i)
		if points > 0 then
			local internalData = nil
			if vocationEnum == Wheel.enum.vocation.VOCATION_KNIGHT then
				internalData = Wheel.bonus.knight[i]
			elseif vocationEnum == Wheel.enum.vocation.VOCATION_PALADIN then
				internalData = Wheel.bonus.paladin[i]
			elseif vocationEnum == Wheel.enum.vocation.VOCATION_DRUID then
				internalData = Wheel.bonus.druid[i]
			elseif vocationEnum == Wheel.enum.vocation.VOCATION_SORCERER then
				internalData = Wheel.bonus.sorcerer[i]
			end

			if internalData == nil then
				Spdlog.warn("[Wheel.loadPlayerBonusData] 'internalData' cannot be null on i = " .. i .. " for vocation = " .. vocationEnum)
			else
				internalData.get(player, points, Wheel.data.player[guid].bonus)
			end
		end
	end
	return true
end

Wheel.loadRevelationPerks = function(player, guid)
	-- Stats (Damage and Healing)
	local greenStage = Wheel.getPlayerSliceStage(player, "green")
	if greenStage ~= Wheel.enum.stage.STAGE_NONE then
		Wheel.data.player[guid].bonus.stats.damage = Wheel.data.player[guid].bonus.stats.damage + Wheel.bonus.revelation.stats[greenStage].damage
		Wheel.data.player[guid].bonus.stats.healing = Wheel.data.player[guid].bonus.stats.healing + Wheel.bonus.revelation.stats[greenStage].healing
		Wheel.data.player[guid].bonus.stages.giftOfLife = greenStage
	end
	local redStage = Wheel.getPlayerSliceStage(player, "red")
	if redStage ~= Wheel.enum.stage.STAGE_NONE then
		Wheel.data.player[guid].bonus.stats.damage = Wheel.data.player[guid].bonus.stats.damage + Wheel.bonus.revelation.stats[redStage].damage
		Wheel.data.player[guid].bonus.stats.healing = Wheel.data.player[guid].bonus.stats.healing + Wheel.bonus.revelation.stats[redStage].healing
		if Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_DRUID then
			Wheel.data.player[guid].bonus.stages.blessingOfTheGrove = redStage
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_KNIGHT then
			Wheel.data.player[guid].bonus.stages.executionersThrow = redStage
			for i = 1, redStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Executioner's Throw")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_SORCERER then
			Wheel.data.player[guid].bonus.stages.beamMastery = redStage
			for i = 1, redStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Great Death Beam")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_PALADIN then
			for i = 1, redStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Divine Grenade")
			end
		end
	end
	local purpleStage = Wheel.getPlayerSliceStage(player, "purple")
	if purpleStage ~= Wheel.enum.stage.STAGE_NONE then
		Wheel.data.player[guid].bonus.stats.damage = Wheel.data.player[guid].bonus.stats.damage + Wheel.bonus.revelation.stats[purpleStage].damage
		Wheel.data.player[guid].bonus.stats.healing = Wheel.data.player[guid].bonus.stats.healing + Wheel.bonus.revelation.stats[purpleStage].healing
		if Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_KNIGHT then
			Wheel.data.player[guid].bonus.avatar.steel = purpleStage
			for i = 1, purpleStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Avatar of Steel")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_PALADIN then
			Wheel.data.player[guid].bonus.avatar.light = purpleStage
			for i = 1, purpleStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Avatar of Light")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_DRUID then
			Wheel.data.player[guid].bonus.avatar.nature = purpleStage
			for i = 1, purpleStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Avatar of Nature")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_SORCERER then
			Wheel.data.player[guid].bonus.avatar.storm = purpleStage
			for i = 1, purpleStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Avatar of Storm")
			end
		end
	end
	local blueStage = Wheel.getPlayerSliceStage(player, "blue")
	if blueStage ~= Wheel.enum.stage.STAGE_NONE then
		Wheel.data.player[guid].bonus.stats.damage = Wheel.data.player[guid].bonus.stats.damage + Wheel.bonus.revelation.stats[blueStage].damage
		Wheel.data.player[guid].bonus.stats.healing = Wheel.data.player[guid].bonus.stats.healing + Wheel.bonus.revelation.stats[blueStage].healing
		if Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_KNIGHT then
			Wheel.data.player[guid].bonus.stages.combatMastery = blueStage
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_SORCERER then
			Wheel.data.player[guid].bonus.stages.drainBody = blueStage
			for i = 1, blueStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Drain_Body_Spells")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_PALADIN then
			Wheel.data.player[guid].bonus.stages.divineEmpowerment = blueStage
			for i = 1, blueStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Divine Empowerment")
			end
		elseif Wheel.getPlayerVocationEnum(player) == Wheel.enum.vocation.VOCATION_DRUID then
			Wheel.data.player[guid].bonus.stages.twinBurst = blueStage
			for i = 1, blueStage do
				table.insert(Wheel.data.player[guid].bonus.spells, "Twin Burst")
				table.insert(Wheel.data.player[guid].bonus.spells, "Terra Burst")
				table.insert(Wheel.data.player[guid].bonus.spells, "Ice Burst")
			end
		end
	end
	return true
end

Wheel.loadPlayerBonusData = function(player)
	if not player then
		Spdlog.error("[Wheel.loadPlayerBonusData] 'player' cannot be null")
		return false
	end

	-- Check if the player can use the wheel, otherwise we dont need to do unnecessary loops and checks
	if not Wheel.canUseOwnWheel(player) then
		return true
	end

	local guid = player:getGuid()
	Wheel.loadDedicationAndConvictionPerks(player, guid)
	Wheel.loadRevelationPerks(player, guid)
	return true
end

Wheel.getUnnusedPoints = function(player)
	if not player then
		Spdlog.error("[Wheel.getUnnusedPoints] 'player' cannot be null")
		return 0
	end

	local totalPoints = Wheel.getPoints(player)
	if totalPoints == 0 then
		return 0
	end

	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		totalPoints = totalPoints - Wheel.getPlayerPointsOnSlot(player, i)
	end

	return totalPoints
end

Wheel.getPoints = function(player)
	if not player then
		Spdlog.error("[Wheel.getPoints] 'player' cannot be null")
		return 0
	end

	return (math.max(0, player:getLevel() - Wheel.minLevelToStartCountPoints)) * Wheel.pointsPerLevel
end

Wheel.getPlayerPointsOnSlot = function(player, slot)
	if not player then
		Spdlog.error("[Wheel.getPoints] 'player' cannot be null")
		return 0
	end

	return math.max(0, Wheel.data.player[player:getGuid()].slots[slot])
end

Wheel.canSelectSlotFullOrPartial = function(player, slot)
	if not player then
		Spdlog.error("[Wheel.canSelectSlotFullOrPartial] 'player' cannot be null")
		return false
	end

	if Wheel.getPlayerPointsOnSlot(player, slot) == Wheel.getMaxPointsPerSlot(slot) then
		return true
	end

	return false
end

Wheel.canPlayerSelectPointOnSlot = function(player, slot, recursive)
	if not player then
		Spdlog.error("[Wheel.canPlayerSelectPointOnSlot] 'player' cannot be null")
		return false
	end

	local playerPoints = Wheel.getPoints(player)
	-- Green quadrant
	if slot == Wheel.enum.slots.SLOT_GREEN_200 then
		if playerPoints < 375 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_150) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_TOP_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_TOP_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_MIDDLE_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_TOP_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_75) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_GREEN_50 then
		return recursive and (Wheel.getPlayerPointsOnSlot(player, slot) == Wheel.getMaxPointsPerSlot(slot)) or true
	end

	-- Red quadrant
	if slot == Wheel.enum.slots.SLOT_RED_200 then
		if playerPoints < 375 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_150) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_TOP_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_BOTTOM_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_TOP_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_MIDDLE_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_BOTTOM_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_TOP_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_75) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_BOTTOM_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_TOP_75) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_RED_50 then
		return recursive and (Wheel.getPlayerPointsOnSlot(player, slot) == Wheel.getMaxPointsPerSlot(slot)) or true
	end

	-- Purple quadrant
	if slot == Wheel.enum.slots.SLOT_PURPLE_200 then
		if playerPoints < 375 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_150) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_TOP_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_TOP_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_TOP_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_RED_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_PURPLE_50 then
		return recursive and (Wheel.getPlayerPointsOnSlot(player, slot) == Wheel.getMaxPointsPerSlot(slot)) or true
	end

	-- Blue quadrant
	if slot == Wheel.enum.slots.SLOT_BLUE_200 then
		if playerPoints < 375 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_150) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_TOP_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_150 then
		if playerPoints < 225 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_TOP_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_MIDDLE_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_100 then
		if playerPoints < 125 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_150) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_TOP_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_GREEN_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_75 then
		if playerPoints < 50 then
			return false
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_50) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_TOP_75) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_MIDDLE_100) then
			return true
		end
		if Wheel.canSelectSlotFullOrPartial(player, Wheel.enum.slots.SLOT_BLUE_BOTTOM_100) then
			return true
		end
	elseif slot == Wheel.enum.slots.SLOT_BLUE_50 then
		return recursive and (Wheel.getPlayerPointsOnSlot(player, slot) == Wheel.getMaxPointsPerSlot(slot)) or true
	end

	return false
end

Wheel.getMaxPointsPerSlot = function(slot)
	if slot == Wheel.enum.slots.SLOT_BLUE_50 or 
		slot == Wheel.enum.slots.SLOT_RED_50 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_50 or 
		slot == Wheel.enum.slots.SLOT_GREEN_50 then
			return 50
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_75 then
			return 75
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_GREEN_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_GREEN_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_RED_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_100 then
			return 100
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_150 then
			return 150
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_200 or 
		slot == Wheel.enum.slots.SLOT_RED_200 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_200 or 
		slot == Wheel.enum.slots.SLOT_BLUE_200 then
			return 200
	end

	Spdlog.error("[Wheel.getMaxPointsPerSlot] Unknown 'slot' = " .. slot)
	return -1
end

Wheel.setSlotPoints = function(player, slot, points)
	if not player then
		Spdlog.error("[Wheel.setSlotPoints] 'player' cannot be null")
		return false
	end

	if not Wheel.canUseOwnWheel(player) then
		return false
	end

	if points > 0 and not(Wheel.canPlayerSelectPointOnSlot(player, slot, false)) then
		return false
	end

	-- Reseting old points
	Wheel.data.player[player:getGuid()].slots[slot] = 0

	local unnusedPoints = Wheel.getUnnusedPoints(player)
	if points > unnusedPoints then
		return false
	end

	-- Saving points
	Wheel.data.player[player:getGuid()].slots[slot] = points
	return true
end

Wheel.getSlotPrioritaryOrder = function(slot)
	if slot == Wheel.enum.slots.SLOT_BLUE_50 or 
		slot == Wheel.enum.slots.SLOT_RED_50 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_50 or 
		slot == Wheel.enum.slots.SLOT_GREEN_50 then
			return 0
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_75 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_75 then
			return 1
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_GREEN_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_GREEN_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_RED_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_MIDDLE_100 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_100 then
			return 2
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_GREEN_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_RED_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_RED_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150 or 
		slot == Wheel.enum.slots.SLOT_BLUE_TOP_150 or 
		slot == Wheel.enum.slots.SLOT_BLUE_BOTTOM_150 then
			return 3
	end

	if slot == Wheel.enum.slots.SLOT_GREEN_200 or 
		slot == Wheel.enum.slots.SLOT_RED_200 or 
		slot == Wheel.enum.slots.SLOT_PURPLE_200 or 
		slot == Wheel.enum.slots.SLOT_BLUE_200 then
			return 4
	end

	Spdlog.error("[Wheel.getSlotPrioritaryOrder] Unknown 'slot' = " .. slot)
	return -1
end

Wheel.getPlayerSpellAdditionalArea = function(player, spell)
	if not player then
		Spdlog.error("[Wheel.getPlayerSpellAdditionalArea] 'player' cannot be null")
		return false
	elseif not Wheel.enabled then
		return false
	end

	local stage = player:upgradeSpellsWORD(spell)
	if stage == 0 then
		return false
	end

	local spellsTable = {}
	local vocationEnum = Wheel.getPlayerVocationEnum(player)
	if vocationEnum == Wheel.enum.vocation.VOCATION_KNIGHT then
		spellsTable = Wheel.bonus.spells.Knight
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_PALADIN then
		spellsTable = Wheel.bonus.spells.Paladin
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_DRUID then
		spellsTable = Wheel.bonus.spells.Druid
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_SORCERER then
		spellsTable = Wheel.bonus.spells.Sorcerer
	else
		return false
	end

	for _, spellTable in ipairs(spellsTable) do
		if spellTable.name == spell then
			for spellStage, spellData in ipairs(spellTable.grade) do
				if stage >= spellStage and spellData.increase ~= nil and spellData.increase.area == true then
					return true
				end
			end
		end
	end
	return false
end

Wheel.getPlayerSpellAdditionalTarget = function(player, spell)
	if not player then
		Spdlog.error("[Wheel.getPlayerSpellAdditionalTarget] 'player' cannot be null")
		return 0
	elseif not Wheel.enabled then
		return 0
	end

	local stage = player:upgradeSpellsWORD(spell)
	if stage == 0 then
		return 0
	end

	local spellsTable = {}
	local vocationEnum = Wheel.getPlayerVocationEnum(player)
	if vocationEnum == Wheel.enum.vocation.VOCATION_KNIGHT then
		spellsTable = Wheel.bonus.spells.Knight
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_PALADIN then
		spellsTable = Wheel.bonus.spells.Paladin
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_DRUID then
		spellsTable = Wheel.bonus.spells.Druid
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_SORCERER then
		spellsTable = Wheel.bonus.spells.Sorcerer
	else
		return 0
	end

	for _, spellTable in ipairs(spellsTable) do
		if spellTable.name == spell and spellTable.grade[stage] ~= nil then
			if spellTable.grade[stage].increase ~= nil then
				if spellTable.grade[stage].increase.aditionalTarget ~= nil then
					return spellTable.grade[stage].increase.aditionalTarget
				end
			end
		end
	end

	return 0
end

Wheel.getPlayerSpellAdditionalDuration = function(player, spell)
	if not player then
		Spdlog.error("[Wheel.getPlayerSpellAdditionalDuration] 'player' cannot be null")
		return 0
	elseif not Wheel.enabled then
		return 0
	end

	local stage = player:upgradeSpellsWORD(spell)
	if stage == 0 then
		return 0
	end

	local spellsTable = {}
	local vocationEnum = Wheel.getPlayerVocationEnum(player)
	if vocationEnum == Wheel.enum.vocation.VOCATION_KNIGHT then
		spellsTable = Wheel.bonus.spells.Knight
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_PALADIN then
		spellsTable = Wheel.bonus.spells.Paladin
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_DRUID then
		spellsTable = Wheel.bonus.spells.Druid
	elseif vocationEnum == Wheel.enum.vocation.VOCATION_SORCERER then
		spellsTable = Wheel.bonus.spells.Sorcerer
	else
		return 0
	end

	for _, spellTable in ipairs(spellsTable) do
		if spellTable.name == spell and spellTable.grade[stage] ~= nil then
			if spellTable.grade[stage].increase ~= nil then
				if spellTable.grade[stage].increase.duration ~= nil then
					return spellTable.grade[stage].increase.duration
				end
			end
		end
	end

	return 0
end

Wheel.getPlayerSliceStage = function(player, color)
	if not player then
		Spdlog.error("[Wheel.getPlayerSliceStage] 'player' cannot be null")
		return Wheel.enum.stage.STAGE_NONE
	end

	local slots = nil
	if color == "green" then
		slots = {
			Wheel.enum.slots.SLOT_GREEN_50,
			Wheel.enum.slots.SLOT_GREEN_TOP_75,
			Wheel.enum.slots.SLOT_GREEN_BOTTOM_75,
			Wheel.enum.slots.SLOT_GREEN_TOP_100,
			Wheel.enum.slots.SLOT_GREEN_MIDDLE_100,
			Wheel.enum.slots.SLOT_GREEN_BOTTOM_100,
			Wheel.enum.slots.SLOT_GREEN_TOP_150,
			Wheel.enum.slots.SLOT_GREEN_BOTTOM_150,
			Wheel.enum.slots.SLOT_GREEN_200
		}
	elseif color == "red" then
		slots = {
			Wheel.enum.slots.SLOT_RED_50,
			Wheel.enum.slots.SLOT_RED_TOP_75,
			Wheel.enum.slots.SLOT_RED_BOTTOM_75,
			Wheel.enum.slots.SLOT_RED_TOP_100,
			Wheel.enum.slots.SLOT_RED_MIDDLE_100,
			Wheel.enum.slots.SLOT_RED_BOTTOM_100,
			Wheel.enum.slots.SLOT_RED_TOP_150,
			Wheel.enum.slots.SLOT_RED_BOTTOM_150,
			Wheel.enum.slots.SLOT_RED_200
		}
	elseif color == "purple" then
		slots = {
			Wheel.enum.slots.SLOT_PURPLE_50,
			Wheel.enum.slots.SLOT_PURPLE_TOP_75,
			Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75,
			Wheel.enum.slots.SLOT_PURPLE_TOP_100,
			Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100,
			Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100,
			Wheel.enum.slots.SLOT_PURPLE_TOP_150,
			Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150,
			Wheel.enum.slots.SLOT_PURPLE_200
		}
	elseif color == "blue" then
		slots = {
			Wheel.enum.slots.SLOT_BLUE_50,
			Wheel.enum.slots.SLOT_BLUE_TOP_75,
			Wheel.enum.slots.SLOT_BLUE_BOTTOM_75,
			Wheel.enum.slots.SLOT_BLUE_TOP_100,
			Wheel.enum.slots.SLOT_BLUE_MIDDLE_100,
			Wheel.enum.slots.SLOT_BLUE_BOTTOM_100,
			Wheel.enum.slots.SLOT_BLUE_TOP_150,
			Wheel.enum.slots.SLOT_BLUE_BOTTOM_150,
			Wheel.enum.slots.SLOT_BLUE_200
		}
	else
		Spdlog.error("[Wheel.getPlayerSliceStage] 'color' does not match any check and was ignored")
		return Wheel.enum.stage.STAGE_NONE
	end

	local totalPoints = 0
	for _, slot in ipairs(slots) do
		totalPoints = totalPoints + Wheel.getPlayerPointsOnSlot(player, slot)
	end

	if totalPoints >= Wheel.enum.stagePoints.STAGE_POINTS_THREE then
		return Wheel.enum.stage.STAGE_THREE
	elseif totalPoints >= Wheel.enum.stagePoints.STAGE_POINTS_TWO then
		return Wheel.enum.stage.STAGE_TWO
	elseif totalPoints >= Wheel.enum.stagePoints.STAGE_POINTS_ONE then
		return Wheel.enum.stage.STAGE_ONE
	end

	return Wheel.enum.stage.STAGE_NONE
end

-- Unused function
Wheel.handleDeathPointsLoss = function(player)
	if not player then
		Spdlog.error("[Wheel.handleDeathPointsLoss] 'player' cannot be null")
		return Wheel.enum.stage.STAGE_NONE
	end

	local extraPoints = Wheel.getUnnusedPoints(player)
	if extraPoints >= 0 then
		return true
	end

	local loopBack = false
	extraPoints = math.abs(extraPoints)
	local sliceStage = {color = "", stage = Wheel.enum.stage.STAGE_NONE, priority = -1, slot = -1}
	for _, color in ipairs({ "blue", "purple", "red", "green" }) do
		local stage = Wheel.getPlayerSliceStage(player, color)
		if stage > sliceStage.stage then
			sliceStage.color = color
			sliceStage.stage = stage
		end
	end

	if sliceStage.stage > Wheel.enum.stage.STAGE_NONE then
		local slots = nil
		if sliceStage.color == "green" then
			slots = {
				Wheel.enum.slots.SLOT_GREEN_50,
				Wheel.enum.slots.SLOT_GREEN_TOP_75,
				Wheel.enum.slots.SLOT_GREEN_BOTTOM_75,
				Wheel.enum.slots.SLOT_GREEN_TOP_100,
				Wheel.enum.slots.SLOT_GREEN_MIDDLE_100,
				Wheel.enum.slots.SLOT_GREEN_BOTTOM_100,
				Wheel.enum.slots.SLOT_GREEN_TOP_150,
				Wheel.enum.slots.SLOT_GREEN_BOTTOM_150,
				Wheel.enum.slots.SLOT_GREEN_200
			}
		elseif sliceStage.color == "red" then
			slots = {
				Wheel.enum.slots.SLOT_RED_50,
				Wheel.enum.slots.SLOT_RED_TOP_75,
				Wheel.enum.slots.SLOT_RED_BOTTOM_75,
				Wheel.enum.slots.SLOT_RED_TOP_100,
				Wheel.enum.slots.SLOT_RED_MIDDLE_100,
				Wheel.enum.slots.SLOT_RED_BOTTOM_100,
				Wheel.enum.slots.SLOT_RED_TOP_150,
				Wheel.enum.slots.SLOT_RED_BOTTOM_150,
				Wheel.enum.slots.SLOT_RED_200
			}
		elseif sliceStage.color == "purple" then
			slots = {
				Wheel.enum.slots.SLOT_PURPLE_50,
				Wheel.enum.slots.SLOT_PURPLE_TOP_75,
				Wheel.enum.slots.SLOT_PURPLE_BOTTOM_75,
				Wheel.enum.slots.SLOT_PURPLE_TOP_100,
				Wheel.enum.slots.SLOT_PURPLE_MIDDLE_100,
				Wheel.enum.slots.SLOT_PURPLE_BOTTOM_100,
				Wheel.enum.slots.SLOT_PURPLE_TOP_150,
				Wheel.enum.slots.SLOT_PURPLE_BOTTOM_150,
				Wheel.enum.slots.SLOT_PURPLE_200
			}
		elseif sliceStage.color == "blue" then
			slots = {
				Wheel.enum.slots.SLOT_BLUE_50,
				Wheel.enum.slots.SLOT_BLUE_TOP_75,
				Wheel.enum.slots.SLOT_BLUE_BOTTOM_75,
				Wheel.enum.slots.SLOT_BLUE_TOP_100,
				Wheel.enum.slots.SLOT_BLUE_MIDDLE_100,
				Wheel.enum.slots.SLOT_BLUE_BOTTOM_100,
				Wheel.enum.slots.SLOT_BLUE_TOP_150,
				Wheel.enum.slots.SLOT_BLUE_BOTTOM_150,
				Wheel.enum.slots.SLOT_BLUE_200
			}
		else
			Spdlog.error("[Wheel.getPlayerSliceStage] 'color' does not match any check and was ignored")
			return Wheel.enum.stage.STAGE_NONE
		end

		for _, slot in ipairs(slots) do
			local priority = Wheel.getSlotPrioritaryOrder(slot)
			if priority > sliceStage.priority then
				sliceStage.slot = slot
				sliceStage.priority = priority
			end
		end

		if sliceStage.slot ~= -1 then
			local points = Wheel.getPlayerPointsOnSlot(player, sliceStage.slot)
			if points ~= 0 then
				Spdlog.warn("Death handler: Player '" .. player:getName() .. "' died and had '" .. extraPoints .. "' as unnused slot points.")
				if extraPoints > points then
					loopBack = true
					extraPoints = points
				else
					extraPoints = points - extraPoints
				end

				-- Clean old data
				Wheel.resetPlayerBonusData(player)

				-- Set the new slot points
				Spdlog.warn("Death handler: Slot '" .. sliceStage.slot .. "' points on the '" .. sliceStage.color .. "' slice has been reduced from '" .. points .. "' to '" .. extraPoints .. "'.")
				Wheel.setSlotPoints(player, sliceStage.slot, extraPoints)

				-- Load bonus data
				if not Wheel.loadPlayerBonusData(player) then
					return false
				end

				-- Save data on database
				Wheel.savePlayerAllSlotsData(player)

				if not loopBack then
					-- Register player bonus data
					Wheel.registerPlayerBonusData(player)
				end
			end
		end
	end

	if loopBack then
		Wheel.handleDeathPointsLoss(player)
	end
end
