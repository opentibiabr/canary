#!/usr/bin/env python3
from __future__ import annotations

import unittest

import validate_gameplay_analytics as validator


def runtime_with_callback(callback: str) -> str:
    return f'''
{callback}

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


class GameplayAnalyticsRuntimeValidationTest(unittest.TestCase):
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
    if creature and attacker then
        Analytics.recordDamageDealt(attacker, creature, math.abs(primaryValue), primaryType)
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


if __name__ == "__main__":
    unittest.main()
