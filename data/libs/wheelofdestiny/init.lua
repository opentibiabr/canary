if not(WheelOfDestinySystem) then
    WheelOfDestinySystem = {
        config = {
            enabled = true,
            minLevelToUse = 50, -- This value seems to be hardcoded on the client, only can be changed when editing the client (Default 50)
            minLevelToStartCountPoints = 50,
            pointsPerLevel = 1,
            onlyPremiumPlayersCanUse = false, -- This value seems to be hardcoded on the client, only can be changed when editing the client (Default TRUE)
            onlyPromotedPlayersCanUse = false, -- This value seems to be hardcoded on the client, only can be changed when editing the client (Default TRUE)
            focusSpells = { -- Spells used on 'Focus spells' bonus
                mage = {"Eternal Winter", "Hell's Core", "Rage of the Skies", "Wrath of Nature"}
            },
        },
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
            storages = {
                slotsPointsSelected = 43201 -- Can get up to +37 from this value (From ...01 to ...37)
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

dofile('data/libs/wheelofdestiny/protocol.lua')
dofile('data/libs/wheelofdestiny/knight.lua')
dofile('data/libs/wheelofdestiny/druid.lua')
dofile('data/libs/wheelofdestiny/paladin.lua')
dofile('data/libs/wheelofdestiny/sorcerer.lua')

WheelOfDestinySystem.registerSpellTable = function(spellData, name, grade)
    if (name == "Any_Focus_Mage_Spell") then
        for _, spellName in ipairs(WheelOfDestinySystem.config.focusSpells.mage) do
            WheelOfDestinySystem.registerSpellTable(spellData, spellName, grade)
        end
        return
    end

    local spell = Spell(name)
    if spell then
        -- Increase area
        if (spellData.increase ~= nil) then
            if (spellData.increase.damage ~= nil) then
                spell:increaseDamageWOD(grade, spellData.increase.damage)
            end
            if (spellData.increase.damageReduction ~= nil) then
                spell:increaseDamageReductionWOD(grade, spellData.increase.damageReduction)
            end
            if (spellData.increase.heal ~= nil) then
                spell:increaseHealWOD(grade, spellData.increase.heal)
            end
            if (spellData.increase.criticalDamage ~= nil) then
                spell:increaseCriticalDamageWOD(grade, spellData.increase.criticalDamage)
            end
            if (spellData.increase.criticalChance ~= nil) then
                spell:increaseCriticalChanceWOD(grade, spellData.increase.criticalChance)
            end
        end
        -- Decrease area
        if (spellData.decrease ~= nil) then
            if (spellData.decrease.coolDown ~= nil) then
                spell:cooldownWOD(grade, spellData.decrease.coolDown * 1000)
            end
            if (spellData.decrease.manaCost ~= nil) then
                spell:manaWOD(grade, spellData.decrease.manaCost)
            end
            if (spellData.decrease.groupCooldown ~= nil) then
                spell:groupCooldownWOD(grade, spellData.decrease.groupCooldown * 1000)
            end
            if (spellData.decrease.secondaryGroupCooldown ~= nil) then
                spell:secondaryGroupCooldownWOD(grade, spellData.decrease.secondaryGroupCooldown * 1000)
            end
        end
        -- Leech area
        if (spellData.leech ~= nil) then
            if (spellData.leech.mana ~= nil) then
                spell:increaseManaLeechWOD(grade, spellData.leech.mana * 100)
            end
            if (spellData.leech.life ~= nil) then
                spell:increaselifeLeechWOD(grade, spellData.leech.life * 100)
            end
        end
    else
        print("[WheelOfDestinySystem.canUseOwnWheel]", "Spell with name '" .. spellData.name .. "' could not be found and was ignored")
    end
end

WheelOfDestinySystem.initializeGlobalData = function(reload)
    if not(WheelOfDestinySystem.config.enabled) then
        if not(reload) then
           Spdlog.info("Loading wheel of destiny...", "[Disabled by admin]")
        end
        return false
    end

    -- Initialize spells for druid
    for _, data in ipairs(WheelOfDestinySystem.bonus.spells.Druid) do
        for grade, spellData in ipairs(data.grade) do
            WheelOfDestinySystem.registerSpellTable(spellData, data.name, grade)
        end
    end
    -- Initialize spells for knight
    for _, data in ipairs(WheelOfDestinySystem.bonus.spells.Knight) do
        for grade, spellData in ipairs(data.grade) do
            WheelOfDestinySystem.registerSpellTable(spellData, data.name, grade)
        end
    end
    -- Initialize spells for paladin
    for _, data in ipairs(WheelOfDestinySystem.bonus.spells.Paladin) do
        for grade, spellData in ipairs(data.grade) do
            WheelOfDestinySystem.registerSpellTable(spellData, data.name, grade)
        end
    end
    -- Initialize spells for sorcerer
    for _, data in ipairs(WheelOfDestinySystem.bonus.spells.Sorcerer) do
        for grade, spellData in ipairs(data.grade) do
            WheelOfDestinySystem.registerSpellTable(spellData, data.name, grade)
        end
    end

    if not(reload) then
        Spdlog.info("Loading wheel of destiny... [Success]")
    else
        Spdlog.info("Reloading wheel of destiny... [Success]")
    end
    return true
end

WheelOfDestinySystem.getPlayerVocationEnum = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerVocationEnum]", "'player' cannot be null")
        return WheelOfDestinySystem.enum.vocation.VOCATION_INVALID
    end

    if (player:getVocation():getClientId() == 1 or player:getVocation():getClientId() == 11) then
        return WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT -- Knight
    elseif (player:getVocation():getClientId() == 2 or player:getVocation():getClientId() == 12) then
        return WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN -- Paladin
    elseif (player:getVocation():getClientId() == 3 or player:getVocation():getClientId() == 13) then
        return WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER -- Sorcerer
    elseif (player:getVocation():getClientId() == 4 or player:getVocation():getClientId() == 14) then
        return WheelOfDestinySystem.enum.vocation.VOCATION_DRUID -- Druid
    end

    return WheelOfDestinySystem.enum.vocation.VOCATION_INVALID
end

WheelOfDestinySystem.canUseOwnWheel = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.canUseOwnWheel]", "'player' cannot be null")
        return false
    end

    if not(WheelOfDestinySystem.config.enabled) then
        return false
    end

    -- Vocation check
    if (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_INVALID) then
        return false
    end

    -- Level check
    if (player:getLevel() <= WheelOfDestinySystem.config.minLevelToUse) then
        return false
    end

    if (WheelOfDestinySystem.config.onlyPremiumPlayersCanUse and not(player:isPremium())) then
        return false
    end

    if (WheelOfDestinySystem.config.onlyPromotedPlayersCanUse and player:getStorageValue(STORAGEVALUE_PROMOTION) ~= 1) then
        return false
    end

    return true
end

WheelOfDestinySystem.initializePlayerData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.initializePlayerData]", "'player' cannot be null")
        return false
    end

    if not(WheelOfDestinySystem.config.enabled) then
        return true
    end

    if (WheelOfDestinySystem.data.player[player:getGuid()] ~= nil) then
        WheelOfDestinySystem.registerPlayerBonusData(player)
        return true
    end

    -- Creating blank table
    WheelOfDestinySystem.data.player[player:getGuid()] = {}

    -- Load slots data
    WheelOfDestinySystem.loadPlayerSlotsData(player)

    -- Clear player data
    WheelOfDestinySystem.resetPlayerBonusData(player)

    -- Load bonus data
    WheelOfDestinySystem.loadPlayerBonusData(player)

    -- Register player bonus data
    WheelOfDestinySystem.registerPlayerBonusData(player)

    return true
end

WheelOfDestinySystem.registerPlayerBonusData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.registerPlayerBonusData]", "'player' cannot be null")
        return false
    end

    if not(WheelOfDestinySystem.config.enabled) then
        if (player:getHealth() > player:getMaxHealth()) then
            player:setHealth(player:getMaxHealth())
        end
        if (player:getMana() > player:getMaxMana()) then
            player:setMana(player:getMaxMana())
        end
        return false
    end

    -- Get data value
    local data = WheelOfDestinySystem.data.player[player:getGuid()].bonus

    -- Reset stages and spell data
    player:upgradeSpellsWORD()

    -- Stats
    player:statsHealthWOD(data.stats.health)
    player:statsManaWOD(data.stats.mana)
    player:statsCapacityWOD(data.stats.capacity * 100)
    player:statsMitigationWOD(data.mitigation * 100)
    player:statsDamageWOD(data.stats.damage)
    player:statsHealingWOD(data.stats.healing)

    -- Resistance
    player:resistanceWOD()
    for element, values in ipairs(data.resistance) do
        player:resistanceWOD(element, values)
    end

    -- Skills
    player:skillsMeleeWOD(data.skills.melee)
    player:skillsDistanceWOD(data.skills.distance)
    player:skillsMagicWOD(data.skills.magic)

    -- Leech
    player:leechWOD(WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_LIFEDRAIN, data.leech.lifeLeech * 100)
    player:leechWOD(WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_MANADRAIN, data.leech.manaLeech * 100)

    -- Instant
    player:instantSkillWOD("Battle Instinct", data.instant.battleInstinct)
    player:instantSkillWOD("Battle Healing", data.instant.battleHealing)
    player:instantSkillWOD("Positional Tatics", data.instant.positionalTatics)
    player:instantSkillWOD("Ballistic Mastery", data.instant.ballisticMastery)
    player:instantSkillWOD("Healing Link", data.instant.healingLink)
    player:instantSkillWOD("Runic Mastery", data.instant.runicMastery)
    player:instantSkillWOD("Focus Mastery", data.instant.focusMastery)

    -- Stages (Revelation)
    if (data.stages.combatMastery > 0) then
        for i = 1, data.stages.combatMastery do
            player:instantSkillWOD("Combat Mastery", true)
        end
    else
        player:instantSkillWOD("Combat Mastery", false)
    end
    if (data.stages.giftOfLife > 0) then
        for i = 1, data.stages.giftOfLife do
            player:instantSkillWOD("Gift of Life", true)
        end
    else
        player:instantSkillWOD("Gift of Life", false)
    end
    if (data.stages.blessingOfTheGrove > 0) then
        for i = 1, data.stages.blessingOfTheGrove do
            player:instantSkillWOD("Blessing of the Grove", true)
        end
    else
        player:instantSkillWOD("Blessing of the Grove", false)
    end
    if (data.stages.divineEmpowerment > 0) then
        for i = 1, data.stages.divineEmpowerment do
            player:instantSkillWOD("Divine Empowerment", true)
        end
    else
        player:instantSkillWOD("Divine Empowerment", false)
    end
    if (data.stages.drainBody > 0) then
        for i = 1, data.stages.drainBody do
            player:instantSkillWOD("Drain Body", true)
        end
    else
        player:instantSkillWOD("Drain Body", false)
    end
    if (data.stages.beamMastery > 0) then
        for i = 1, data.stages.beamMastery do
            player:instantSkillWOD("Beam Mastery", true)
        end
    else
        player:instantSkillWOD("Beam Mastery", false)
    end
    if (data.stages.twinBurst > 0) then
        for i = 1, data.stages.twinBurst do
            player:instantSkillWOD("Twin Burst", true)
        end
    else
        player:instantSkillWOD("Twin Burst", false)
    end
    if (data.stages.executionersThrow > 0) then
        for i = 1, data.stages.executionersThrow do
            player:instantSkillWOD("Executioner's Thow", true)
        end
    else
        player:instantSkillWOD("Executioner's Thow", false)
    end

    -- Avatar
    if (data.avatar.light > 0) then
        for i = 1, data.avatar.light do
            player:instantSkillWOD("Avatar of Light", true)
        end
    else
        player:instantSkillWOD("Avatar of Light", false)
    end
    if (data.avatar.nature > 0) then
        for i = 1, data.avatar.nature do
            player:instantSkillWOD("Avatar of Nature", true)
        end
    else
        player:instantSkillWOD("Avatar of Nature", false)
    end
    if (data.avatar.steel > 0) then
        for i = 1, data.avatar.steel do
            player:instantSkillWOD("Avatar of Steel", true)
        end
    else
        player:instantSkillWOD("Avatar of Steel", false)
    end
    if (data.avatar.storm > 0) then
        for i = 1, data.avatar.storm do
            player:instantSkillWOD("Avatar of Storm", true)
        end
    else
        player:instantSkillWOD("Avatar of Storm", false)
    end

    for _, spell in ipairs(data.spells) do
        player:upgradeSpellsWORD(spell, true)
    end

    if (player:getHealth() > player:getMaxHealth()) then
        player:setHealth(player:getMaxHealth())
    end
    if (player:getMana() > player:getMaxMana()) then
        player:addMana(-(player:getMana() - player:getMaxMana()))
    end

    player:onThinkWheelOfDestiny(false) -- Not forcing the reload
    player:reloadData()
    return true
end

WheelOfDestinySystem.loadPlayerSlotsData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.loadPlayerSlotsData]", "'player' cannot be null")
        return false
    end

    -- Adding default values on slots table
    WheelOfDestinySystem.resetPlayerSlotsData(player)

    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        local value = player:getStorageValue(WheelOfDestinySystem.enum.storages.slotsPointsSelected + i)
        if (value > 0) then
            WheelOfDestinySystem.data.player[player:getGuid()].slots[i] = value
        end
    end

    return true
end

WheelOfDestinySystem.savePlayerSlotData = function(player, slot)
    if not(player) then
        print("[WheelOfDestinySystem.savePlayerSlotsData]", "'player' cannot be null")
        return false
    end

    local key = WheelOfDestinySystem.enum.storages.slotsPointsSelected + slot
    local value = math.max(0, WheelOfDestinySystem.data.player[player:getGuid()].slots[slot])
    player:setStorageValue(key, value, true)

    return true
end

WheelOfDestinySystem.savePlayerAllSlotsData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.savePlayerSlotsData]", "'player' cannot be null")
        return false
    end

    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        WheelOfDestinySystem.savePlayerSlotData(player, i)
    end

    return true
end

WheelOfDestinySystem.resetPlayerSlotsData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.resetPlayerSlotsData]", "'player' cannot be null")
        return false
    end

    WheelOfDestinySystem.data.player[player:getGuid()].slots = {}
    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        WheelOfDestinySystem.data.player[player:getGuid()].slots[i] = 0
    end

    return true
end

WheelOfDestinySystem.resetPlayerBonusData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.resetPlayerBonusData]", "'player' cannot be null")
        return false
    end

    WheelOfDestinySystem.data.player[player:getGuid()].bonus = {
        stats = { -- Raw value. Example: 1 == 1
            health = 0,
            mana = 0,
            capacity = 0,
            damage = 0,
            healing = 0
        },
        resistance = { -- value * 100. Example: 1% == 100
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_PHYSICAL] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ENERGY] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_EARTH] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_FIRE] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_UNDEFINED] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_LIFEDRAIN] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_MANADRAIN] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HEALING] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DROWN] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_ICE] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_HOLY] = 0,
            [WheelOfDestinySystem.enum.combatType.COMBAT_TYPE_INDEX_DEATH] = 0
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

WheelOfDestinySystem.loadPlayerBonusData = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.loadPlayerBonusData]", "'player' cannot be null")
        return false
    end

    -- Check if the player can use the wheel, otherwise we dont need to do unnecessary loops and checks
    if not(WheelOfDestinySystem.canUseOwnWheel(player)) then
        return true
    end

    local guid = player:getGuid()
    -- Load bonus values (Dedication Perks and Conviction Perks)
    local vocationEnum = WheelOfDestinySystem.getPlayerVocationEnum(player)
    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        local points = WheelOfDestinySystem.getPlayerPointsOnSlot(player, i)
        if (points > 0) then
            local internalData = nil
            if (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
                internalData = WheelOfDestinySystem.bonus.knight[i]
            elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
                internalData = WheelOfDestinySystem.bonus.paladin[i]
            elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
                internalData = WheelOfDestinySystem.bonus.druid[i]
            elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
                internalData = WheelOfDestinySystem.bonus.sorcerer[i]
            end

            if (internalData == nil) then
                print("[WheelOfDestinySystem.loadPlayerBonusData]", "'internalData' cannot be null on i = " .. i .. " for vocation = " .. vocationEnum)
            else
                internalData.get(player, points, WheelOfDestinySystem.data.player[guid].bonus)
            end
        end
    end
    -- Load bonus values (Revelation Perks)
    -- Stats (Damage and Healing)
    local greenStage = WheelOfDestinySystem.getPlayerSliceStage(player, "green")
    if (greenStage ~= WheelOfDestinySystem.enum.stage.STAGE_NONE) then
        WheelOfDestinySystem.data.player[guid].bonus.stats.damage = WheelOfDestinySystem.data.player[guid].bonus.stats.damage + WheelOfDestinySystem.bonus.revelation.stats[greenStage].damage
        WheelOfDestinySystem.data.player[guid].bonus.stats.healing = WheelOfDestinySystem.data.player[guid].bonus.stats.healing + WheelOfDestinySystem.bonus.revelation.stats[greenStage].healing
        WheelOfDestinySystem.data.player[guid].bonus.stages.giftOfLife = greenStage
    end
    local redStage = WheelOfDestinySystem.getPlayerSliceStage(player, "red")
    if (redStage ~= WheelOfDestinySystem.enum.stage.STAGE_NONE) then
        WheelOfDestinySystem.data.player[guid].bonus.stats.damage = WheelOfDestinySystem.data.player[guid].bonus.stats.damage + WheelOfDestinySystem.bonus.revelation.stats[redStage].damage
        WheelOfDestinySystem.data.player[guid].bonus.stats.healing = WheelOfDestinySystem.data.player[guid].bonus.stats.healing + WheelOfDestinySystem.bonus.revelation.stats[redStage].healing
        if (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.blessingOfTheGrove = redStage
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.executionersThrow = redStage
            for i = 1, redStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Executioner's Throw")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.beamMastery = redStage
            for i = 1, redStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Great Death Beam")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
            for i = 1, redStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Divine Grenade")
            end
        end
    end
    local purpleStage = WheelOfDestinySystem.getPlayerSliceStage(player, "purple")
    if (purpleStage ~= WheelOfDestinySystem.enum.stage.STAGE_NONE) then
        WheelOfDestinySystem.data.player[guid].bonus.stats.damage = WheelOfDestinySystem.data.player[guid].bonus.stats.damage + WheelOfDestinySystem.bonus.revelation.stats[purpleStage].damage
        WheelOfDestinySystem.data.player[guid].bonus.stats.healing = WheelOfDestinySystem.data.player[guid].bonus.stats.healing + WheelOfDestinySystem.bonus.revelation.stats[purpleStage].healing
        if (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
            WheelOfDestinySystem.data.player[guid].bonus.avatar.steel = purpleStage
            for i = 1, purpleStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Avatar of Steel")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
            WheelOfDestinySystem.data.player[guid].bonus.avatar.light = purpleStage
            for i = 1, purpleStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Avatar of Light")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
            WheelOfDestinySystem.data.player[guid].bonus.avatar.nature = purpleStage
            for i = 1, purpleStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Avatar of Nature")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
            WheelOfDestinySystem.data.player[guid].bonus.avatar.storm = purpleStage
            for i = 1, purpleStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Avatar of Storm")
            end
        end
    end
    local blueStage = WheelOfDestinySystem.getPlayerSliceStage(player, "blue")
    if (blueStage ~= WheelOfDestinySystem.enum.stage.STAGE_NONE) then
        WheelOfDestinySystem.data.player[guid].bonus.stats.damage = WheelOfDestinySystem.data.player[guid].bonus.stats.damage + WheelOfDestinySystem.bonus.revelation.stats[blueStage].damage
        WheelOfDestinySystem.data.player[guid].bonus.stats.healing = WheelOfDestinySystem.data.player[guid].bonus.stats.healing + WheelOfDestinySystem.bonus.revelation.stats[blueStage].healing
        if (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.combatMastery = blueStage
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.drainBody = blueStage
            for i = 1, blueStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Drain_Body_Spells")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.divineEmpowerment = blueStage
            for i = 1, blueStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Divine Empowerment")
            end
        elseif (WheelOfDestinySystem.getPlayerVocationEnum(player) == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
            WheelOfDestinySystem.data.player[guid].bonus.stages.twinBurst = blueStage
            for i = 1, blueStage do
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Twin Burst")
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Terra Burst")
                table.insert(WheelOfDestinySystem.data.player[guid].bonus.spells, "Ice Burst")
            end
        end
    end

    return true
end

WheelOfDestinySystem.getUnnusedPoints = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.getUnnusedPoints]", "'player' cannot be null")
        return 0
    end

    local totalPoints = WheelOfDestinySystem.getPoints(player)
    if (totalPoints == 0) then
        return 0
    end

    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        totalPoints = totalPoints - WheelOfDestinySystem.getPlayerPointsOnSlot(player, i)
    end

    return totalPoints
end

WheelOfDestinySystem.getPoints = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.getPoints]", "'player' cannot be null")
        return 0
    end

    return (math.max(0, player:getLevel() - WheelOfDestinySystem.config.minLevelToStartCountPoints)) * WheelOfDestinySystem.config.pointsPerLevel
end

WheelOfDestinySystem.getPlayerPointsOnSlot = function(player, slot)
    if not(player) then
        print("[WheelOfDestinySystem.getPoints]", "'player' cannot be null")
        return 0
    end

    return math.max(0, WheelOfDestinySystem.data.player[player:getGuid()].slots[slot])
end

WheelOfDestinySystem.canSelectSlotFullOrPartial = function(player, slot)
    if not(player) then
        print("[WheelOfDestinySystem.canSelectSlotFullOrPartial]", "'player' cannot be null")
        return false
    end

    if (WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot) == WheelOfDestinySystem.getMaxPointsPerSlot(slot)) then
        return true
    end

    return false
end

WheelOfDestinySystem.canPlayerSelectPointOnSlot = function(player, slot, recursive)
    if not(player) then
        print("[WheelOfDestinySystem.canPlayerSelectPointOnSlot]", "'player' cannot be null")
        return false
    end

    local playerPoints = WheelOfDestinySystem.getPoints(player)

    -- Green quadrant
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_200) then
        if (playerPoints < 375) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_50) then
        return recursive and (WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot) == WheelOfDestinySystem.getMaxPointsPerSlot(slot)) or true
    end

    -- Red quadrant
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_200) then
        if (playerPoints < 375) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_RED_50) then
        return recursive and (WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot) == WheelOfDestinySystem.getMaxPointsPerSlot(slot)) or true
    end

    -- Purple quadrant
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200) then
        if (playerPoints < 375) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50) then
        return recursive and (WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot) == WheelOfDestinySystem.getMaxPointsPerSlot(slot)) or true
    end

    -- Blue quadrant
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_200) then
        if (playerPoints < 375) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150) then
        if (playerPoints < 225) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100) then
        if (playerPoints < 125) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75) then
        if (playerPoints < 50) then
            return false
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_50)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100)) then
            return true
        end
        if (WheelOfDestinySystem.canSelectSlotFullOrPartial(player, WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100)) then
            return true
        end
    elseif (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_50) then
        return recursive and (WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot) == WheelOfDestinySystem.getMaxPointsPerSlot(slot)) or true
    end

    return false
end

WheelOfDestinySystem.getMaxPointsPerSlot = function(slot)
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_50) then
            return 50
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75) then
            return 75
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100) then
            return 100
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150) then
            return 150
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_200) then
            return 200
    end

    print("[WheelOfDestinySystem.getMaxPointsPerSlot]", "Unknown 'slot' = " .. slot)
    return -1
end

WheelOfDestinySystem.setSlotPoints = function(player, slot, points)
    if not(player) then
        print("[WheelOfDestinySystem.setSlotPoints]", "'player' cannot be null")
        return false
    end

    if not(WheelOfDestinySystem.canUseOwnWheel(player)) then
        return false
    end

    if (points > 0 and not(WheelOfDestinySystem.canPlayerSelectPointOnSlot(player, slot, false))) then
        return false
    end

    -- Reseting old points
    WheelOfDestinySystem.data.player[player:getGuid()].slots[slot] = 0

    local unnusedPoints = WheelOfDestinySystem.getUnnusedPoints(player)
    if (points > unnusedPoints) then
        return false
    end

    -- Saving points
    WheelOfDestinySystem.data.player[player:getGuid()].slots[slot] = points
    return true
end

WheelOfDestinySystem.getSlotPrioritaryOrder = function(slot)
    if (slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_50) then
            return 0
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75) then
            return 1
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100) then
            return 2
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150) then
            return 3
    end

    if (slot == WheelOfDestinySystem.enum.slots.SLOT_GREEN_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_RED_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200 or 
        slot == WheelOfDestinySystem.enum.slots.SLOT_BLUE_200) then
            return 4
    end

    print("[WheelOfDestinySystem.getSlotPrioritaryOrder]", "Unknown 'slot' = " .. slot)
    return -1
end

WheelOfDestinySystem.getPlayerSpellAdditionalArea = function(player, spell)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerSpellAdditionalArea]", "'player' cannot be null")
        return false
    elseif not(WheelOfDestinySystem.config.enabled) then
        return false
    end
    local stage = player:upgradeSpellsWORD(spell)
    if (stage == 0) then
        return false
    end

    local spellsTable = {}
    local vocationEnum = WheelOfDestinySystem.getPlayerVocationEnum(player)
    if (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Knight
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Paladin
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Druid
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Sorcerer
    else
        return false
    end
    for _, spellTable in ipairs(spellsTable) do
        if (spellTable.name == spell) then
            for spellStage, spellData in ipairs(spellTable.grade) do
                if (stage >= spellStage and spellData.increase ~= nil and spellData.increase.area == true) then
                    return true
                end
            end
        end
    end
    return false
end

WheelOfDestinySystem.getPlayerSpellAdditionalTarget = function(player, spell)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerSpellAdditionalTarget]", "'player' cannot be null")
        return 0
    elseif not(WheelOfDestinySystem.config.enabled) then
        return 0
    end
    local stage = player:upgradeSpellsWORD(spell)
    if (stage == 0) then
        return 0
    end

    local spellsTable = {}
    local vocationEnum = WheelOfDestinySystem.getPlayerVocationEnum(player)
    if (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Knight
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Paladin
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Druid
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Sorcerer
    else
        return 0
    end
    for _, spellTable in ipairs(spellsTable) do
        if (spellTable.name == spell and spellTable.grade[stage] ~= nil) then
            if (spellTable.grade[stage].increase ~= nil) then
                if (spellTable.grade[stage].increase.aditionalTarget ~= nil) then
                    return spellTable.grade[stage].increase.aditionalTarget
                end
            end
        end
    end
    return 0
end

WheelOfDestinySystem.getPlayerSpellAdditionalDuration = function(player, spell)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerSpellAdditionalDuration]", "'player' cannot be null")
        return 0
    elseif not(WheelOfDestinySystem.config.enabled) then
        return 0
    end
    local stage = player:upgradeSpellsWORD(spell)
    if (stage == 0) then
        return 0
    end

    local spellsTable = {}
    local vocationEnum = WheelOfDestinySystem.getPlayerVocationEnum(player)
    if (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_KNIGHT) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Knight
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_PALADIN) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Paladin
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_DRUID) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Druid
    elseif (vocationEnum == WheelOfDestinySystem.enum.vocation.VOCATION_SORCERER) then
        spellsTable = WheelOfDestinySystem.bonus.spells.Sorcerer
    else
        return 0
    end
    for _, spellTable in ipairs(spellsTable) do
        if (spellTable.name == spell and spellTable.grade[stage] ~= nil) then
            if (spellTable.grade[stage].increase ~= nil) then
                if (spellTable.grade[stage].increase.duration ~= nil) then
                    return spellTable.grade[stage].increase.duration
                end
            end
        end
    end
    return 0
end

WheelOfDestinySystem.getPlayerSliceStage = function(player, color)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerSliceStage]", "'player' cannot be null")
        return WheelOfDestinySystem.enum.stage.STAGE_NONE
    end

    local slots = nil
    if (color == "green") then
        slots = {
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_50,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150,
            WheelOfDestinySystem.enum.slots.SLOT_GREEN_200
        }
    elseif (color == "red") then
        slots = {
            WheelOfDestinySystem.enum.slots.SLOT_RED_50,
            WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75,
            WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75,
            WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100,
            WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100,
            WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100,
            WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150,
            WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150,
            WheelOfDestinySystem.enum.slots.SLOT_RED_200
        }
    elseif (color == "purple") then
        slots = {
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150,
            WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200
        }
    elseif (color == "blue") then
        slots = {
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_50,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150,
            WheelOfDestinySystem.enum.slots.SLOT_BLUE_200
        }
    else
        print("[WheelOfDestinySystem.getPlayerSliceStage]", "'color' does not match any check and was ignored")
        return WheelOfDestinySystem.enum.stage.STAGE_NONE
    end

    local totalPoints = 0
    for _, slot in ipairs(slots) do
        totalPoints = totalPoints + WheelOfDestinySystem.getPlayerPointsOnSlot(player, slot)
    end

    if (totalPoints >= WheelOfDestinySystem.enum.stagePoints.STAGE_POINTS_THREE) then
        return WheelOfDestinySystem.enum.stage.STAGE_THREE
    elseif (totalPoints >= WheelOfDestinySystem.enum.stagePoints.STAGE_POINTS_TWO) then
        return WheelOfDestinySystem.enum.stage.STAGE_TWO
    elseif (totalPoints >= WheelOfDestinySystem.enum.stagePoints.STAGE_POINTS_ONE) then
        return WheelOfDestinySystem.enum.stage.STAGE_ONE
    end

    return WheelOfDestinySystem.enum.stage.STAGE_NONE
end

WheelOfDestinySystem.handleDeathPointsLoss = function(player)
    if not(player) then
        print("[WheelOfDestinySystem.getPlayerSliceStage]", "'player' cannot be null")
        return WheelOfDestinySystem.enum.stage.STAGE_NONE
    end

    local extraPoints = WheelOfDestinySystem.getUnnusedPoints(player)
    if (extraPoints >= 0) then
        return true
    end

    local loopBack = false
    extraPoints = math.abs(extraPoints)
    local sliceStage = {color = "", stage = WheelOfDestinySystem.enum.stage.STAGE_NONE, priority = -1, slot = -1}
    for _, color in ipairs({ "blue", "purple", "red", "green" }) do
        local stage = WheelOfDestinySystem.getPlayerSliceStage(player, color)
        if (stage > sliceStage.stage) then
            sliceStage.color = color
            sliceStage.stage = stage
        end
    end

    if (sliceStage.stage > WheelOfDestinySystem.enum.stage.STAGE_NONE) then
        local slots = nil
        if (sliceStage.color == "green") then
            slots = {
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_50,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_75,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_75,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_100,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_MIDDLE_100,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_100,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_TOP_150,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_BOTTOM_150,
                WheelOfDestinySystem.enum.slots.SLOT_GREEN_200
            }
        elseif (sliceStage.color == "red") then
            slots = {
                WheelOfDestinySystem.enum.slots.SLOT_RED_50,
                WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_75,
                WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_75,
                WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_100,
                WheelOfDestinySystem.enum.slots.SLOT_RED_MIDDLE_100,
                WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_100,
                WheelOfDestinySystem.enum.slots.SLOT_RED_TOP_150,
                WheelOfDestinySystem.enum.slots.SLOT_RED_BOTTOM_150,
                WheelOfDestinySystem.enum.slots.SLOT_RED_200
            }
        elseif (sliceStage.color == "purple") then
            slots = {
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_50,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_75,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_75,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_100,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_MIDDLE_100,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_100,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_TOP_150,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_BOTTOM_150,
                WheelOfDestinySystem.enum.slots.SLOT_PURPLE_200
            }
        elseif (sliceStage.color == "blue") then
            slots = {
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_50,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_75,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_75,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_100,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_MIDDLE_100,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_100,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_TOP_150,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_BOTTOM_150,
                WheelOfDestinySystem.enum.slots.SLOT_BLUE_200
            }
        else
            print("[WheelOfDestinySystem.getPlayerSliceStage]", "'color' does not match any check and was ignored")
            return WheelOfDestinySystem.enum.stage.STAGE_NONE
        end

        for _, slot in ipairs(slots) do
            local priority = WheelOfDestinySystem.getSlotPrioritaryOrder(slot)
            if (priority > sliceStage.priority) then
                sliceStage.slot = slot
                sliceStage.priority = priority
            end
        end

        if (sliceStage.slot ~= -1) then
            local points = WheelOfDestinySystem.getPlayerPointsOnSlot(player, sliceStage.slot)
            if (points ~= 0) then
                print("Death handler:", "Player '" .. player:getName() .. "' died and had '" .. extraPoints .. "' as unnused slot points.")
                if (extraPoints > points) then
                    loopBack = true
                    extraPoints = points
                else
                    extraPoints = points - extraPoints
                end

                -- Clean old data
                WheelOfDestinySystem.resetPlayerBonusData(player)

                -- Set the new slot points
                print("Death handler:", "Slot '" .. sliceStage.slot .. "' points on the '" .. sliceStage.color .. "' slice has been reduced from '" .. points .. "' to '" .. extraPoints .. "'.")
                WheelOfDestinySystem.setSlotPoints(player, sliceStage.slot, extraPoints)

                -- Load bonus data
                WheelOfDestinySystem.loadPlayerBonusData(player)

                -- Save data on database
                WheelOfDestinySystem.savePlayerAllSlotsData(player)

                if not(loopBack) then
                    -- Register player bonus data
                    WheelOfDestinySystem.registerPlayerBonusData(player)
                end
            end
        end
    end

    if (loopBack) then
        WheelOfDestinySystem.handleDeathPointsLoss(player)
    end
end