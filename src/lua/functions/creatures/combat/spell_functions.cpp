/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/combat/spells.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "lua/functions/creatures/combat/spell_functions.hpp"

int SpellFunctions::luaSpellCreate(lua_State* L) {
	// Spell(words, name or id) to get an existing spell
	// Spell(type) ex: Spell(SPELL_INSTANT) or Spell(SPELL_RUNE) to create a new spell
	if (lua_gettop(L) == 1) {
		g_logger().error("[SpellFunctions::luaSpellCreate] - "
						 "There is no parameter set!");
		lua_pushnil(L);
		return 1;
	}

	SpellType_t spellType = SPELL_UNDEFINED;

	if (isNumber(L, 2)) {
		uint16_t id = getNumber<uint16_t>(L, 2);
		std::shared_ptr<RuneSpell> rune = g_spells().getRuneSpell(id);

		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		spellType = static_cast<SpellType_t>(id);
	} else if (isString(L, 2)) {
		std::string arg = getString(L, 2);
		std::shared_ptr<InstantSpell> instant = g_spells().getInstantSpellByName(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		instant = g_spells().getInstantSpell(arg);
		if (instant) {
			pushUserdata<Spell>(L, instant);
			setMetatable(L, -1, "Spell");
			return 1;
		}
		std::shared_ptr<RuneSpell> rune = g_spells().getRuneSpellByName(arg);
		if (rune) {
			pushUserdata<Spell>(L, rune);
			setMetatable(L, -1, "Spell");
			return 1;
		}

		std::string tmp = asLowerCaseString(arg);
		if (tmp == "instant") {
			spellType = SPELL_INSTANT;
		} else if (tmp == "rune") {
			spellType = SPELL_RUNE;
		}
	}

	if (spellType == SPELL_INSTANT) {
		auto spell = std::make_shared<InstantSpell>(getScriptEnv()->getScriptInterface());
		pushUserdata<Spell>(L, spell);
		setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_INSTANT;
		return 1;
	} else if (spellType == SPELL_RUNE) {
		auto runeSpell = std::make_shared<RuneSpell>(getScriptEnv()->getScriptInterface());
		pushUserdata<Spell>(L, runeSpell);
		setMetatable(L, -1, "Spell");
		runeSpell->spellType = SPELL_RUNE;
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int SpellFunctions::luaSpellOnCastSpell(lua_State* L) {
	// spell:onCastSpell(callback)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			const auto spellBase = getUserdataShared<Spell>(L, 1);
			const auto instant = std::static_pointer_cast<InstantSpell>(spellBase);
			if (!instant->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			instant->setLoadedCallback(true);
			pushBoolean(L, true);
		} else if (spell->spellType == SPELL_RUNE) {
			std::shared_ptr<Spell> spellBase = getUserdataShared<Spell>(L, 1);
			std::shared_ptr<RuneSpell> rune = std::static_pointer_cast<RuneSpell>(spellBase);
			if (!rune->loadCallback()) {
				pushBoolean(L, false);
				return 1;
			}
			rune->setLoadedCallback(true);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellRegister(lua_State* L) {
	// spell:register()
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (spell->spellType == SPELL_INSTANT) {
		const auto spellBase = getUserdataShared<Spell>(L, 1);
		const auto instant = std::static_pointer_cast<InstantSpell>(spellBase);
		if (!instant->isLoadedCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_spells().registerInstantLuaEvent(instant));
	} else if (spell->spellType == SPELL_RUNE) {
		const auto spellBase = getUserdataShared<Spell>(L, 1);
		const auto rune = std::static_pointer_cast<RuneSpell>(spellBase);
		if (rune->getMagicLevel() != 0 || rune->getLevel() != 0) {
			// Change information in the ItemType to get accurate description
			ItemType &iType = Item::items.getItemType(rune->getRuneItemId());
			// If the item is not registered in items.xml then we will register it by rune name
			if (iType.name.empty()) {
				iType.name = rune->getName();
			}
			iType.runeMagLevel = rune->getMagicLevel();
			iType.runeLevel = rune->getLevel();
			iType.charges = rune->getCharges();
		}
		if (!rune->isLoadedCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_spells().registerRuneLuaEvent(rune));
	}
	return 1;
}

int SpellFunctions::luaSpellName(lua_State* L) {

	// spell:name(name)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushString(L, spell->getName());
		} else {
			spell->setName(getString(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellId(lua_State* L) {
	// spell:id(id)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (spell->spellType != SPELL_INSTANT && spell->spellType != SPELL_RUNE) {
			reportErrorFunc("The method: 'spell:id(id)' is only for use of instant spells and rune spells");
			pushBoolean(L, false);
			return 1;
		}
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getId());
		} else {
			spell->setId(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellGroup(lua_State* L) {
	// spell:group(primaryGroup[, secondaryGroup])
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroup());
			lua_pushnumber(L, spell->getSecondaryGroup());
			return 2;
		} else if (lua_gettop(L) == 2) {
			SpellGroup_t group = getNumber<SpellGroup_t>(L, 2);
			if (group) {
				spell->setGroup(group);
				pushBoolean(L, true);
			} else if (isString(L, 2)) {
				group = stringToSpellGroup(getString(L, 2));
				if (group != SPELLGROUP_NONE) {
					spell->setGroup(group);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
									"Unknown group: {}",
									getString(L, 2));
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				g_logger().warn("[SpellFunctions::luaSpellGroup] - "
								"Unknown group: {}",
								getString(L, 2));
				pushBoolean(L, false);
				return 1;
			}
		} else {
			SpellGroup_t primaryGroup = getNumber<SpellGroup_t>(L, 2);
			SpellGroup_t secondaryGroup = getNumber<SpellGroup_t>(L, 2);
			if (primaryGroup && secondaryGroup) {
				spell->setGroup(primaryGroup);
				spell->setSecondaryGroup(secondaryGroup);
				pushBoolean(L, true);
			} else if (isString(L, 2) && isString(L, 3)) {
				primaryGroup = stringToSpellGroup(getString(L, 2));
				if (primaryGroup != SPELLGROUP_NONE) {
					spell->setGroup(primaryGroup);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
									"Unknown primaryGroup: {}",
									getString(L, 2));
					pushBoolean(L, false);
					return 1;
				}
				secondaryGroup = stringToSpellGroup(getString(L, 3));
				if (secondaryGroup != SPELLGROUP_NONE) {
					spell->setSecondaryGroup(secondaryGroup);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
									"Unknown secondaryGroup: {}",
									getString(L, 3));
					pushBoolean(L, false);
					return 1;
				}
				pushBoolean(L, true);
			} else {
				g_logger().warn("[SpellFunctions::luaSpellGroup] - "
								"Unknown primaryGroup: {} or secondaryGroup: {}",
								getString(L, 2), getString(L, 3));
				pushBoolean(L, false);
				return 1;
			}
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellCastSound(lua_State* L) {
	// get: spell:castSound() set: spell:castSound(effect)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, static_cast<uint16_t>(spell->soundCastEffect));
		} else {
			spell->soundCastEffect = static_cast<SoundEffect_t>(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellImpactSound(lua_State* L) {
	// get: spell:impactSound() set: spell:impactSound(effect)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, static_cast<uint16_t>(spell->soundImpactEffect));
		} else {
			spell->soundImpactEffect = static_cast<SoundEffect_t>(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellCooldown(lua_State* L) {
	// spell:cooldown(cooldown)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCooldown());
		} else {
			spell->setCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellGroupCooldown(lua_State* L) {
	// spell:groupCooldown(primaryGroupCd[, secondaryGroupCd])
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroupCooldown());
			lua_pushnumber(L, spell->getSecondaryCooldown());
			return 2;
		} else if (lua_gettop(L) == 2) {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		} else {
			spell->setGroupCooldown(getNumber<uint32_t>(L, 2));
			spell->setSecondaryCooldown(getNumber<uint32_t>(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellLevel(lua_State* L) {
	// spell:level(lvl)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellMagicLevel(lua_State* L) {
	// spell:magicLevel(lvl)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellMana(lua_State* L) {
	// spell:mana(mana)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMana());
		} else {
			spell->setMana(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellManaPercent(lua_State* L) {
	// spell:manaPercent(percent)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getManaPercent());
		} else {
			spell->setManaPercent(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellSoul(lua_State* L) {
	// spell:soul(soul)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getSoulCost());
		} else {
			spell->setSoulCost(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellRange(lua_State* L) {
	// spell:range(range)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRange());
		} else {
			spell->setRange(getNumber<int32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellPremium(lua_State* L) {
	// spell:isPremium(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isPremium());
		} else {
			spell->setPremium(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellEnabled(lua_State* L) {
	// spell:isEnabled(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->isEnabled());
		} else {
			spell->setEnabled(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedTarget(lua_State* L) {
	// spell:needTarget(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedTarget());
		} else {
			spell->setNeedTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedWeapon(lua_State* L) {
	// spell:needWeapon(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedWeapon());
		} else {
			spell->setNeedWeapon(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedLearn(lua_State* L) {
	// spell:needLearn(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedLearn());
		} else {
			spell->setNeedLearn(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellSelfTarget(lua_State* L) {
	// spell:isSelfTarget(bool)
	if (const auto spell = getUserdataShared<Spell>(L, 1)) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getSelfTarget());
		} else {
			spell->setSelfTarget(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellBlocking(lua_State* L) {
	// spell:isBlocking(blockingSolid, blockingCreature)
	if (const auto spell = getUserdataShared<Spell>(L, 1)) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockingSolid());
			pushBoolean(L, spell->getBlockingCreature());
			return 2;
		} else {
			spell->setBlockingSolid(getBoolean(L, 2));
			spell->setBlockingCreature(getBoolean(L, 3));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellAggressive(lua_State* L) {
	// spell:isAggressive(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAggressive());
		} else {
			spell->setAggressive(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellAllowOnSelf(lua_State* L) {
	// spell:allowOnSelf(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAllowOnSelf());
		} else {
			spell->setAllowOnSelf(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellPzLocked(lua_State* L) {
	// spell:isPzLocked(bool)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getLockedPZ());
		} else {
			spell->setLockedPZ(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellVocation(lua_State* L) {
	// spell:vocation(vocation)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_createtable(L, 0, 0);
			auto it = 0;
			for (auto voc : spell->getVocMap()) {
				++it;
				std::string s = std::to_string(it);
				const char* pchar = s.c_str();
				std::string name = g_vocations().getVocation(voc.first)->getVocName();
				setField(L, pchar, name);
			}
			setMetatable(L, -1, "Spell");
		} else {
			int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
			for (int i = 0; i < parameters; ++i) {
				if (getString(L, 2 + i).find(";") != std::string::npos) {
					std::vector<std::string> vocList = explodeString(getString(L, 2 + i), ";");
					int32_t vocationId = g_vocations().getVocationId(vocList[0]);
					if (vocList.size() > 0) {
						if (vocList[1] == "true") {
							spell->addVocMap(vocationId, true);
						} else {
							spell->addVocMap(vocationId, false);
						}
					}
				} else {
					int32_t vocationId = g_vocations().getVocationId(getString(L, 2 + i));
					spell->addVocMap(vocationId, false);
				}
			}
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellWords(lua_State* L) {
	// spell:words(words[, separator = ""])
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushString(L, spell->getWords());
			pushString(L, spell->getSeparator());
			return 2;
		} else {
			std::string sep = "";
			if (lua_gettop(L) == 3) {
				sep = getString(L, 3);
			}
			spell->setWords(getString(L, 2));
			spell->setSeparator(sep);
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellNeedDirection(lua_State* L) {
	// spell:needDirection(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedDirection());
		} else {
			spell->setNeedDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellHasParams(lua_State* L) {
	// spell:hasParams(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasParam());
		} else {
			spell->setHasParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellHasPlayerNameParam(lua_State* L) {
	// spell:hasPlayerNameParam(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getHasPlayerNameParam());
		} else {
			spell->setHasPlayerNameParam(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellNeedCasterTargetOrDirection(lua_State* L) {
	// spell:needCasterTargetOrDirection(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getNeedCasterTargetOrDirection());
		} else {
			spell->setNeedCasterTargetOrDirection(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellIsBlockingWalls(lua_State* L) {
	// spell:blockWalls(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getBlockWalls());
		} else {
			spell->setBlockWalls(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellRuneId(lua_State* L) {
	// spell:runeId(id)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRuneItemId());
		} else {
			spell->setRuneItemId(getNumber<uint16_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellCharges(lua_State* L) {
	// spell:charges(charges)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCharges());
		} else {
			spell->setCharges(getNumber<uint32_t>(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellAllowFarUse(lua_State* L) {
	// spell:allowFarUse(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getAllowFarUse());
		} else {
			spell->setAllowFarUse(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellBlockWalls(lua_State* L) {
	// spell:blockWalls(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckLineOfSight());
		} else {
			spell->setCheckLineOfSight(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellCheckFloor(lua_State* L) {
	// spell:checkFloor(bool)
	const auto spellBase = getUserdataShared<Spell>(L, 1);
	const auto spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			pushBoolean(L, spell->getCheckFloor());
		} else {
			spell->setCheckFloor(getBoolean(L, 2));
			pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Wheel of destiny
int SpellFunctions::luaSpellManaWOD(lua_State* L) {
	// spell:manaWOD(grade, mana)
	const auto spell = getUserdataShared<Spell>(L, 1);
	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::MANA, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellCooldownWOD(lua_State* L) {
	// spell:cooldownWOD(grade, time)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::COOLDOWN, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::COOLDOWN, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellGroupCooldownWOD(lua_State* L) {
	// spell:groupCooldownWOD(grade, time)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::GROUP_COOLDOWN, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::GROUP_COOLDOWN, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellSecondaryGroupCooldownWOD(lua_State* L) {
	// spell:secondaryGroupCooldownWOD(grade, time)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::SECONDARY_GROUP_COOLDOWN, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::SECONDARY_GROUP_COOLDOWN, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseManaLeechWOD(lua_State* L) {
	// spell:increaseManaLeechWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH, grade));
	} else {
		int32_t value = getNumber<int32_t>(L, 3);
		if (value > 0) {
			spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH_CHANCE, grade, 100);
		} else {
			spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH_CHANCE, grade, 0);
		}
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::MANA_LEECH, grade, value);
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaselifeLeechWOD(lua_State* L) {
	// spell:increaselifeLeechWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH, grade));
	} else {
		int32_t value = getNumber<int32_t>(L, 3);
		if (value > 0) {
			spell->setWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH_CHANCE, grade, 100);
		} else {
			spell->setWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH_CHANCE, grade, 0);
		}
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::LIFE_LEECH, grade, value);
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseDamageWOD(lua_State* L) {
	// spell:increaseDamageWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseDamageReductionWOD(lua_State* L) {
	// spell:increaseDamageReductionWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE_REDUCTION, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::DAMAGE_REDUCTION, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseHealWOD(lua_State* L) {
	// spell:increaseHealWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::HEAL, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::HEAL, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseCriticalDamageWOD(lua_State* L) {
	// spell:increaseCriticalDamageWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_DAMAGE, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_DAMAGE, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}

int SpellFunctions::luaSpellIncreaseCriticalChanceWOD(lua_State* L) {
	// spell:increaseCriticalChanceWOD(grade, value)
	const auto spell = getUserdataShared<Spell>(L, 1);
	if (!spell) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	WheelSpellGrade_t grade = getNumber<WheelSpellGrade_t>(L, 2);
	if (lua_gettop(L) == 2) {
		lua_pushnumber(L, spell->getWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_CHANCE, grade));
	} else {
		spell->setWheelOfDestinyBoost(WheelSpellBoost_t::CRITICAL_CHANCE, grade, getNumber<int32_t>(L, 3));
		spell->setWheelOfDestinyUpgraded(true);
		pushBoolean(L, true);
	}
	return 1;
}
