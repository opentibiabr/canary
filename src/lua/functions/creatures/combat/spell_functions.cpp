/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/combat/spell_functions.hpp"

#include "creatures/combat/spells.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "items/item.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void SpellFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Spell", "", SpellFunctions::luaSpellCreate);
	Lua::registerMetaMethod(L, "Spell", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Spell", "onCastSpell", SpellFunctions::luaSpellOnCastSpell);
	Lua::registerMethod(L, "Spell", "register", SpellFunctions::luaSpellRegister);
	Lua::registerMethod(L, "Spell", "name", SpellFunctions::luaSpellName);
	Lua::registerMethod(L, "Spell", "id", SpellFunctions::luaSpellId);
	Lua::registerMethod(L, "Spell", "group", SpellFunctions::luaSpellGroup);
	Lua::registerMethod(L, "Spell", "cooldown", SpellFunctions::luaSpellCooldown);
	Lua::registerMethod(L, "Spell", "groupCooldown", SpellFunctions::luaSpellGroupCooldown);
	Lua::registerMethod(L, "Spell", "level", SpellFunctions::luaSpellLevel);
	Lua::registerMethod(L, "Spell", "magicLevel", SpellFunctions::luaSpellMagicLevel);
	Lua::registerMethod(L, "Spell", "mana", SpellFunctions::luaSpellMana);
	Lua::registerMethod(L, "Spell", "manaPercent", SpellFunctions::luaSpellManaPercent);
	Lua::registerMethod(L, "Spell", "soul", SpellFunctions::luaSpellSoul);
	Lua::registerMethod(L, "Spell", "range", SpellFunctions::luaSpellRange);
	Lua::registerMethod(L, "Spell", "isPremium", SpellFunctions::luaSpellPremium);
	Lua::registerMethod(L, "Spell", "isEnabled", SpellFunctions::luaSpellEnabled);
	Lua::registerMethod(L, "Spell", "needTarget", SpellFunctions::luaSpellNeedTarget);
	Lua::registerMethod(L, "Spell", "needWeapon", SpellFunctions::luaSpellNeedWeapon);
	Lua::registerMethod(L, "Spell", "needLearn", SpellFunctions::luaSpellNeedLearn);
	Lua::registerMethod(L, "Spell", "allowOnSelf", SpellFunctions::luaSpellAllowOnSelf);
	Lua::registerMethod(L, "Spell", "setPzLocked", SpellFunctions::luaSpellPzLocked);
	Lua::registerMethod(L, "Spell", "isSelfTarget", SpellFunctions::luaSpellSelfTarget);
	Lua::registerMethod(L, "Spell", "isBlocking", SpellFunctions::luaSpellBlocking);
	Lua::registerMethod(L, "Spell", "isAggressive", SpellFunctions::luaSpellAggressive);
	Lua::registerMethod(L, "Spell", "vocation", SpellFunctions::luaSpellVocation);

	Lua::registerMethod(L, "Spell", "castSound", SpellFunctions::luaSpellCastSound);
	Lua::registerMethod(L, "Spell", "impactSound", SpellFunctions::luaSpellImpactSound);

	// Only for InstantSpell.
	Lua::registerMethod(L, "Spell", "words", SpellFunctions::luaSpellWords);
	Lua::registerMethod(L, "Spell", "needDirection", SpellFunctions::luaSpellNeedDirection);
	Lua::registerMethod(L, "Spell", "hasParams", SpellFunctions::luaSpellHasParams);
	Lua::registerMethod(L, "Spell", "hasPlayerNameParam", SpellFunctions::luaSpellHasPlayerNameParam);
	Lua::registerMethod(L, "Spell", "needCasterTargetOrDirection", SpellFunctions::luaSpellNeedCasterTargetOrDirection);
	Lua::registerMethod(L, "Spell", "isBlockingWalls", SpellFunctions::luaSpellIsBlockingWalls);

	// Only for RuneSpells.
	Lua::registerMethod(L, "Spell", "runeId", SpellFunctions::luaSpellRuneId);
	Lua::registerMethod(L, "Spell", "charges", SpellFunctions::luaSpellCharges);
	Lua::registerMethod(L, "Spell", "allowFarUse", SpellFunctions::luaSpellAllowFarUse);
	Lua::registerMethod(L, "Spell", "blockWalls", SpellFunctions::luaSpellBlockWalls);
	Lua::registerMethod(L, "Spell", "checkFloor", SpellFunctions::luaSpellCheckFloor);
}

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

	if (Lua::isNumber(L, 2)) {
		uint16_t id = Lua::getNumber<uint16_t>(L, 2);
		const auto &rune = g_spells().getRuneSpell(id);

		if (rune) {
			Lua::pushUserdata<Spell>(L, rune);
			Lua::setMetatable(L, -1, "Spell");
			return 1;
		}

		spellType = static_cast<SpellType_t>(id);
	} else if (Lua::isString(L, 2)) {
		const std::string arg = Lua::getString(L, 2);
		auto instant = g_spells().getInstantSpellByName(arg);
		if (instant) {
			Lua::pushUserdata<Spell>(L, instant);
			Lua::setMetatable(L, -1, "Spell");
			return 1;
		}
		instant = g_spells().getInstantSpell(arg);
		if (instant) {
			Lua::pushUserdata<Spell>(L, instant);
			Lua::setMetatable(L, -1, "Spell");
			return 1;
		}
		const auto &rune = g_spells().getRuneSpellByName(arg);
		if (rune) {
			Lua::pushUserdata<Spell>(L, rune);
			Lua::setMetatable(L, -1, "Spell");
			return 1;
		}

		const std::string tmp = asLowerCaseString(arg);
		if (tmp == "instant") {
			spellType = SPELL_INSTANT;
		} else if (tmp == "rune") {
			spellType = SPELL_RUNE;
		}
	}

	if (spellType == SPELL_INSTANT) {
		const auto &spell = std::make_shared<InstantSpell>();
		Lua::pushUserdata<Spell>(L, spell);
		Lua::setMetatable(L, -1, "Spell");
		spell->spellType = SPELL_INSTANT;
		return 1;
	} else if (spellType == SPELL_RUNE) {
		const auto &runeSpell = std::make_shared<RuneSpell>();
		Lua::pushUserdata<Spell>(L, runeSpell);
		Lua::setMetatable(L, -1, "Spell");
		runeSpell->spellType = SPELL_RUNE;
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int SpellFunctions::luaSpellOnCastSpell(lua_State* L) {
	// spell:onCastSpell(callback)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (spell->spellType == SPELL_INSTANT) {
			const auto &instant = std::static_pointer_cast<InstantSpell>(spell);
			if (!instant->loadScriptId()) {
				Lua::pushBoolean(L, false);
				return 1;
			}
			Lua::pushBoolean(L, true);
		} else if (spell->spellType == SPELL_RUNE) {
			const auto &rune = std::static_pointer_cast<RuneSpell>(spell);
			if (!rune->loadRuneSpellScriptId()) {
				Lua::pushBoolean(L, false);
				return 1;
			}
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellRegister(lua_State* L) {
	// spell:register()
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (!spell) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_SPELL_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (spell->spellType == SPELL_INSTANT) {
		const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
		const auto &instant = std::static_pointer_cast<InstantSpell>(spellBase);
		if (!instant->isLoadedScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, g_spells().registerInstantLuaEvent(instant));
	} else if (spell->spellType == SPELL_RUNE) {
		const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
		const auto &rune = std::static_pointer_cast<RuneSpell>(spellBase);
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
		if (!rune->isRuneSpellLoadedScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, g_spells().registerRuneLuaEvent(rune));
	}
	return 1;
}

int SpellFunctions::luaSpellName(lua_State* L) {

	// spell:name(name)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushString(L, spell->getName());
		} else {
			spell->setName(Lua::getString(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellId(lua_State* L) {
	// spell:id(id)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (spell->spellType != SPELL_INSTANT && spell->spellType != SPELL_RUNE) {
			Lua::reportErrorFunc("The method: 'spell:id(id)' is only for use of instant spells and rune spells");
			Lua::pushBoolean(L, false);
			return 1;
		}
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getSpellId());
		} else {
			spell->setSpellId(Lua::getNumber<uint16_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellGroup(lua_State* L) {
	// spell:group(primaryGroup[, secondaryGroup])
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroup());
			lua_pushnumber(L, spell->getSecondaryGroup());
			return 2;
		} else if (lua_gettop(L) == 2) {
			auto group = Lua::getNumber<SpellGroup_t>(L, 2);
			if (group) {
				spell->setGroup(group);
				Lua::pushBoolean(L, true);
			} else if (Lua::isString(L, 2)) {
				group = stringToSpellGroup(Lua::getString(L, 2));
				if (group != SPELLGROUP_NONE) {
					spell->setGroup(group);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
					                "Unknown group: {}",
					                Lua::getString(L, 2));
					Lua::pushBoolean(L, false);
					return 1;
				}
				Lua::pushBoolean(L, true);
			} else {
				g_logger().warn("[SpellFunctions::luaSpellGroup] - "
				                "Unknown group: {}",
				                Lua::getString(L, 2));
				Lua::pushBoolean(L, false);
				return 1;
			}
		} else {
			auto primaryGroup = Lua::getNumber<SpellGroup_t>(L, 2);
			auto secondaryGroup = Lua::getNumber<SpellGroup_t>(L, 2);
			if (primaryGroup && secondaryGroup) {
				spell->setGroup(primaryGroup);
				spell->setSecondaryGroup(secondaryGroup);
				Lua::pushBoolean(L, true);
			} else if (Lua::isString(L, 2) && Lua::isString(L, 3)) {
				primaryGroup = stringToSpellGroup(Lua::getString(L, 2));
				if (primaryGroup != SPELLGROUP_NONE) {
					spell->setGroup(primaryGroup);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
					                "Unknown primaryGroup: {}",
					                Lua::getString(L, 2));
					Lua::pushBoolean(L, false);
					return 1;
				}
				secondaryGroup = stringToSpellGroup(Lua::getString(L, 3));
				if (secondaryGroup != SPELLGROUP_NONE) {
					spell->setSecondaryGroup(secondaryGroup);
				} else {
					g_logger().warn("[SpellFunctions::luaSpellGroup] - "
					                "Unknown secondaryGroup: {}",
					                Lua::getString(L, 3));
					Lua::pushBoolean(L, false);
					return 1;
				}
				Lua::pushBoolean(L, true);
			} else {
				g_logger().warn("[SpellFunctions::luaSpellGroup] - "
				                "Unknown primaryGroup: {} or secondaryGroup: {}",
				                Lua::getString(L, 2), Lua::getString(L, 3));
				Lua::pushBoolean(L, false);
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
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, static_cast<uint16_t>(spell->soundCastEffect));
		} else {
			spell->soundCastEffect = static_cast<SoundEffect_t>(Lua::getNumber<uint16_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellImpactSound(lua_State* L) {
	// get: spell:impactSound() set: spell:impactSound(effect)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, static_cast<uint16_t>(spell->soundImpactEffect));
		} else {
			spell->soundImpactEffect = static_cast<SoundEffect_t>(Lua::getNumber<uint16_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellCooldown(lua_State* L) {
	// spell:cooldown(cooldown)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCooldown());
		} else {
			spell->setCooldown(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellGroupCooldown(lua_State* L) {
	// spell:groupCooldown(primaryGroupCd[, secondaryGroupCd])
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getGroupCooldown());
			lua_pushnumber(L, spell->getSecondaryCooldown());
			return 2;
		} else if (lua_gettop(L) == 2) {
			spell->setGroupCooldown(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		} else {
			spell->setGroupCooldown(Lua::getNumber<uint32_t>(L, 2));
			spell->setSecondaryCooldown(Lua::getNumber<uint32_t>(L, 3));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellLevel(lua_State* L) {
	// spell:level(lvl)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getLevel());
		} else {
			spell->setLevel(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellMagicLevel(lua_State* L) {
	// spell:magicLevel(lvl)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMagicLevel());
		} else {
			spell->setMagicLevel(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellMana(lua_State* L) {
	// spell:mana(mana)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getMana());
		} else {
			spell->setMana(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellManaPercent(lua_State* L) {
	// spell:manaPercent(percent)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getManaPercent());
		} else {
			spell->setManaPercent(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellSoul(lua_State* L) {
	// spell:soul(soul)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getSoulCost());
		} else {
			spell->setSoulCost(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellRange(lua_State* L) {
	// spell:range(range)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRange());
		} else {
			spell->setRange(Lua::getNumber<int32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellPremium(lua_State* L) {
	// spell:isPremium(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->isPremium());
		} else {
			spell->setPremium(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellEnabled(lua_State* L) {
	// spell:isEnabled(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->isEnabled());
		} else {
			spell->setEnabled(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedTarget(lua_State* L) {
	// spell:needTarget(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getNeedTarget());
		} else {
			spell->setNeedTarget(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedWeapon(lua_State* L) {
	// spell:needWeapon(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getNeedWeapon());
		} else {
			spell->setNeedWeapon(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellNeedLearn(lua_State* L) {
	// spell:needLearn(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getNeedLearn());
		} else {
			spell->setNeedLearn(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellSelfTarget(lua_State* L) {
	// spell:isSelfTarget(bool)
	if (const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell")) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getSelfTarget());
		} else {
			spell->setSelfTarget(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellBlocking(lua_State* L) {
	// spell:isBlocking(blockingSolid, blockingCreature)
	if (const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell")) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getBlockingSolid());
			Lua::pushBoolean(L, spell->getBlockingCreature());
			return 2;
		} else {
			spell->setBlockingSolid(Lua::getBoolean(L, 2));
			spell->setBlockingCreature(Lua::getBoolean(L, 3));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellAggressive(lua_State* L) {
	// spell:isAggressive(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getAggressive());
		} else {
			spell->setAggressive(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellAllowOnSelf(lua_State* L) {
	// spell:allowOnSelf(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getAllowOnSelf());
		} else {
			spell->setAllowOnSelf(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellPzLocked(lua_State* L) {
	// spell:isPzLocked(bool)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getLockedPZ());
		} else {
			spell->setLockedPZ(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpellFunctions::luaSpellVocation(lua_State* L) {
	// spell:vocation(vocation)
	const auto &spell = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	if (spell) {
		if (lua_gettop(L) == 1) {
			lua_createtable(L, 0, 0);
			auto it = 0;
			for (const auto &voc : spell->getVocMap()) {
				++it;
				std::string s = std::to_string(it);
				const char* pchar = s.c_str();
				std::string name = g_vocations().getVocation(voc.first)->getVocName();
				Lua::setField(L, pchar, name);
			}
			Lua::setMetatable(L, -1, "Spell");
		} else {
			const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
			for (int i = 0; i < parameters; ++i) {
				if (Lua::getString(L, 2 + i).find(';') != std::string::npos) {
					std::vector<std::string> vocList = explodeString(Lua::getString(L, 2 + i), ";");
					const int32_t vocationId = g_vocations().getVocationId(vocList[0]);
					if (!vocList.empty()) {
						if (vocList[1] == "true") {
							spell->addVocMap(vocationId, true);
						} else {
							spell->addVocMap(vocationId, false);
						}
					}
				} else {
					const int32_t vocationId = g_vocations().getVocationId(Lua::getString(L, 2 + i));
					spell->addVocMap(vocationId, false);
				}
			}
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellWords(lua_State* L) {
	// spell:words(words[, separator = ""])
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushString(L, spell->getWords());
			Lua::pushString(L, spell->getSeparator());
			return 2;
		} else {
			std::string sep;
			if (lua_gettop(L) == 3) {
				sep = Lua::getString(L, 3);
			}
			spell->setWords(Lua::getString(L, 2));
			spell->setSeparator(sep);
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellNeedDirection(lua_State* L) {
	// spell:needDirection(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getNeedDirection());
		} else {
			spell->setNeedDirection(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellHasParams(lua_State* L) {
	// spell:hasParams(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getHasParam());
		} else {
			spell->setHasParam(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellHasPlayerNameParam(lua_State* L) {
	// spell:hasPlayerNameParam(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getHasPlayerNameParam());
		} else {
			spell->setHasPlayerNameParam(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellNeedCasterTargetOrDirection(lua_State* L) {
	// spell:needCasterTargetOrDirection(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getNeedCasterTargetOrDirection());
		} else {
			spell->setNeedCasterTargetOrDirection(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for InstantSpells
int SpellFunctions::luaSpellIsBlockingWalls(lua_State* L) {
	// spell:blockWalls(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<InstantSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_INSTANT, it means that this actually is no InstantSpell, so we return nil
		if (spell->spellType != SPELL_INSTANT) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getBlockWalls());
		} else {
			spell->setBlockWalls(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellRuneId(lua_State* L) {
	// spell:runeId(id)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getRuneItemId());
		} else {
			spell->setRuneItemId(Lua::getNumber<uint16_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellCharges(lua_State* L) {
	// spell:charges(charges)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			lua_pushnumber(L, spell->getCharges());
		} else {
			spell->setCharges(Lua::getNumber<uint32_t>(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellAllowFarUse(lua_State* L) {
	// spell:allowFarUse(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getAllowFarUse());
		} else {
			spell->setAllowFarUse(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellBlockWalls(lua_State* L) {
	// spell:blockWalls(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getCheckLineOfSight());
		} else {
			spell->setCheckLineOfSight(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// only for RuneSpells
int SpellFunctions::luaSpellCheckFloor(lua_State* L) {
	// spell:checkFloor(bool)
	const auto &spellBase = Lua::getUserdataShared<Spell>(L, 1, "Spell");
	const auto &spell = std::static_pointer_cast<RuneSpell>(spellBase);
	if (spell) {
		// if spell != SPELL_RUNE, it means that this actually is no RuneSpell, so we return nil
		if (spell->spellType != SPELL_RUNE) {
			lua_pushnil(L);
			return 1;
		}

		if (lua_gettop(L) == 1) {
			Lua::pushBoolean(L, spell->getCheckFloor());
		} else {
			spell->setCheckFloor(Lua::getBoolean(L, 2));
			Lua::pushBoolean(L, true);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}
