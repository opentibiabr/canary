#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics as validator


def runtime_with_callback(callback: str) -> str:
    return f'''
local Analytics = {{ config = {{ trackPvP = false }} }}

local function registerPlayerEvents(player)
    player:registerEvent("GameplayAnalyticsHealth")
end

local login = CreatureEvent("GameplayAnalyticsLogin")
function login.onLogin(player)
    if Analytics.isEnabled() then
        registerPlayerEvents(player)
    end
    return true
end
login:register()

local experienceCallback = EventCallback("GameplayAnalyticsExperience")
function experienceCallback.playerOnGainExperience(player, source, experienceValue, rawExperience)
    Analytics.recordExperience(player, experienceValue, rawExperience, source)
    return experienceValue
end
experienceCallback:register()

local function auditedDamageGuards(sourcePlayer, targetPlayer)
    if Analytics.config.trackPvP or not sourcePlayer then
        return true
    end
    if Analytics.config.trackPvP or not targetPlayer then
        return true
    end
    return false
end

local function enableForOnlinePlayers()
    for _, onlinePlayer in ipairs(Game.getPlayers()) do
        registerPlayerEvents(onlinePlayer)
    end
end

{callback}

local analyticsCommand = TalkAction("/analytics")
GameplayAnalyticsStartup = true
GameplayAnalyticsShutdown = true
GameplayAnalyticsLogout = true
GameplayAnalyticsHealth = true
GameplayAnalyticsMana = true
GameplayAnalyticsDeath = true
GameplayAnalyticsKill = true
'''


class GameplayAnalyticsLibraryValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.library = validator.LIBRARY.read_text(encoding="utf-8")

    def test_repository_library_contract(self) -> None:
        validator.validate_library(self.library)

    def test_rejects_store_query_handle_named_result(self) -> None:
        broken = self.library.replace(
            "local queryResult = db.storeQuery",
            "local result = db.storeQuery",
            1,
        ).replace(
            'result.getNumber(queryResult, "id")',
            'result.getNumber(result, "id")',
            1,
        ).replace(
            "result.free(queryResult)",
            "result.free(result)",
            1,
        )

        with self.assertRaisesRegex(AssertionError, "must not shadow"):
            validator.validate_library(broken)

    def test_rejects_spell_mana_double_counting(self) -> None:
        broken = self.library.replace(
            "session.spells[key] = spell",
            "session.spells[key] = spell\n\tAnalytics.recordManaSpent(player, mana)",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "double-count"):
            validator.validate_library(broken)

    def test_rejects_timeout_based_combat_duration(self) -> None:
        broken = self.library.replace(
            "combatEnd = math.min(combatEnd, session.lastCombatAt)",
            "combatEnd = timestamp",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "last combat event"):
            validator.validate_library(broken)

    def test_rejects_missing_empty_session_filter(self) -> None:
        broken = self.library.replace("local function sessionHasData(session)", "local function discardedSessionCheck(session)", 1)
        with self.assertRaisesRegex(AssertionError, "empty sessions"):
            validator.validate_library(broken)


class GameplayAnalyticsRuntimeValidationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.runtime = validator.RUNTIME.read_text(encoding="utf-8")

    def test_repository_runtime_contract(self) -> None:
        validator.validate_runtime(self.runtime)

    def test_requires_drain_health_damage_tracking_callback(self) -> None:
        runtime = runtime_with_callback(
            '''
local drainHealthCallback = EventCallback("GameplayAnalyticsDrainHealth")
function drainHealthCallback.creatureOnDrainHealth(creature, attacker, primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor)
    return primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor
end
drainHealthCallback:register()
'''
        )

        with self.assertRaisesRegex(AssertionError, "drain-health"):
            validator.validate_runtime(runtime)

    def test_accepts_named_drain_health_callback_constructor(self) -> None:
        runtime = runtime_with_callback(
            '''
local drainHealthCallback = EventCallback("GameplayAnalyticsDrainHealth")
function drainHealthCallback.creatureOnDrainHealth(creature, attacker, primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor)
    local sourcePlayer = attacker
    local targetPlayer = nil
    if Analytics.config.trackPvP or not targetPlayer then
        Analytics.recordDamageDealt(sourcePlayer, creature, math.abs(primaryValue), primaryType)
        local secondaryDamage = math.abs(secondaryValue)
        Analytics.recordDamageDealt(sourcePlayer, creature, secondaryDamage, secondaryType)
    end
    return primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor
end
drainHealthCallback:register()
'''
        )

        validator.validate_runtime(runtime)

    def test_rejects_damage_tracking_on_unregistered_callback_variable(self) -> None:
        runtime = runtime_with_callback(
            '''
local drainHealthCallback = EventCallback("GameplayAnalyticsDrainHealth")
function drainHealthCallback.creatureOnDrainHealth(creature, attacker, primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor)
    return primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor
end
drainHealthCallback:register()

local unrelatedCallback = EventCallback("Other")
function unrelatedCallback.creatureOnDrainHealth(creature, attacker, primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor)
    Analytics.recordDamageDealt(attacker, creature, math.abs(primaryValue), primaryType)
    return primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor
end
'''
        )

        with self.assertRaisesRegex(AssertionError, "drain-health"):
            validator.validate_runtime(runtime)

    def test_rejects_session_creation_on_login(self) -> None:
        broken = self.runtime.replace(
            "\tif Analytics.isEnabled() then\n\t\tregisterPlayerEvents(player)\n\tend",
            "\tif Analytics.isEnabled() then\n\t\tregisterPlayerEvents(player)\n\t\tAnalytics.start(player)\n\tend",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "empty analytics session"):
            validator.validate_runtime(broken)

    def test_rejects_secondary_damage_collapsed_into_primary_type(self) -> None:
        broken = self.runtime.replace(
            "Analytics.recordDamageDealt(sourcePlayer, creature, secondaryDamage, secondaryType)",
            "Analytics.recordDamageDealt(sourcePlayer, creature, secondaryDamage, primaryType)",
            1,
        )
        with self.assertRaisesRegex(AssertionError, "secondary damage"):
            validator.validate_runtime(broken)


if __name__ == "__main__":
    unittest.main()
