#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics as validator


class GameplayAnalyticsRuntimeValidationTest(unittest.TestCase):
    def test_requires_health_registration_inside_spawn_callback(self) -> None:
        runtime = '''
local login = CreatureEvent("GameplayAnalyticsLogin")
function login.onLogin(player)
    player:registerEvent("GameplayAnalyticsHealth")
    return true
end
login:register()

local spawnCallback = EventCallback
function spawnCallback.onSpawn(creature, position, startup, artificial)
    return true
end
spawnCallback:register()

local analyticsCommand = TalkAction("/analytics")

GameplayAnalyticsStartup = true
GameplayAnalyticsShutdown = true
GameplayAnalyticsLogout = true
GameplayAnalyticsMana = true
GameplayAnalyticsDeath = true
GameplayAnalyticsKill = true
GameplayAnalyticsExperience = true
'''

        with self.assertRaisesRegex(AssertionError, "spawned monsters"):
            validator.validate_runtime(runtime)

    def test_accepts_health_registration_inside_spawn_callback(self) -> None:
        runtime = '''
local spawnCallback = EventCallback
function spawnCallback.onSpawn(creature, position, startup, artificial)
    if creature:isMonster() then
        creature:registerEvent("GameplayAnalyticsHealth")
    end
    return true
end
spawnCallback:register()

local analyticsCommand = TalkAction("/analytics")
GameplayAnalyticsStartup = true
GameplayAnalyticsShutdown = true
GameplayAnalyticsLogin = true
GameplayAnalyticsLogout = true
GameplayAnalyticsHealth = true
GameplayAnalyticsMana = true
GameplayAnalyticsDeath = true
GameplayAnalyticsKill = true
GameplayAnalyticsExperience = true
'''

        validator.validate_runtime(runtime)

    def test_rejects_health_registration_on_unrelated_callback_variable(self) -> None:
        runtime = '''
local spawnCallback = EventCallback
function spawnCallback.onSpawn(creature, position, startup, artificial)
    return true
end
spawnCallback:register()

local unrelatedCallback = EventCallback
function unrelatedCallback.onSpawn(creature, position, startup, artificial)
    creature:registerEvent("GameplayAnalyticsHealth")
    return true
end

local analyticsCommand = TalkAction("/analytics")
GameplayAnalyticsStartup = true
GameplayAnalyticsShutdown = true
GameplayAnalyticsLogin = true
GameplayAnalyticsLogout = true
GameplayAnalyticsHealth = true
GameplayAnalyticsMana = true
GameplayAnalyticsDeath = true
GameplayAnalyticsKill = true
GameplayAnalyticsExperience = true
'''

        with self.assertRaisesRegex(AssertionError, "spawned monsters"):
            validator.validate_runtime(runtime)


if __name__ == "__main__":
    unittest.main()
