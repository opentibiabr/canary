#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/account_quests.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/custom/account_quest_system.lua"
QUEST_DOORS = ROOT / "data/scripts/actions/doors/quest_door.lua"
INTEGRATION_ROOTS = (
    ROOT / "data/scripts",
    ROOT / "data-otservbr-global/scripts",
)
QUEST_ID = re.compile(r"^[a-z0-9][a-z0-9_.-]*$")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def configured_quest_ids(text: str) -> set[str]:
    ids = set(re.findall(r'^\s*\["([^"]+)"\]\s*=\s*\{', text, flags=re.MULTILINE))
    require(ids, "account quest configuration contains no quests")
    invalid = sorted(value for value in ids if not QUEST_ID.fullmatch(value))
    require(not invalid, f"invalid configured quest ids: {', '.join(invalid)}")
    return ids


def integrated_quest_ids() -> set[str]:
    ids: set[str] = set()
    patterns = (
        re.compile(r'local\s+[A-Za-z_]*[Qq]uestId\s*=\s*"([^"]+)"'),
        re.compile(r'addAccountQuestDoor\([^,]+,\s*"([^"]+)"'),
        re.compile(r'(?:has|unlock|claim|canClaim)AccountQuest(?:Access|Reward)\s*\([^,)]*,?\s*"([^"]+)"'),
    )
    for root in INTEGRATION_ROOTS:
        for path in root.rglob("*.lua"):
            text = path.read_text(encoding="utf-8")
            for pattern in patterns:
                ids.update(pattern.findall(text))
    return ids


def function_body(text: str, function_name: str, next_function_name: str) -> str:
    start_marker = f"function AccountQuest.{function_name}"
    end_marker = f"function AccountQuest.{next_function_name}"
    start = text.find(start_marker)
    end = text.find(end_marker, start + len(start_marker))
    require(start >= 0 and end > start, f"cannot isolate AccountQuest.{function_name}")
    return text[start:end]


def validate_runtime(text: str) -> None:
    require('type(loaded.quests) ~= "table"' in text, "invalid quests configuration must fail closed")
    require("loaded.enabled = false" in text, "invalid quests configuration must disable the system")
    require("local function countRegisteredQuests()" in text, "registered quest counter is missing")
    require("#AccountQuest.config.quests" not in text, "string-keyed quest table must not use the length operator")
    require("countRegisteredQuests()" in text, "startup log must use the registered quest counter")

    sequence = (
        ("hasAccess", "unlockAccess"),
        ("unlockAccess", "canClaimReward"),
        ("canClaimReward", "claimReward"),
        ("claimReward", "resetCharacterProgress"),
    )
    for current, following in sequence:
        body = function_body(text, current, following)
        require(
            "local definition, normalizedId = getQuestDefinition(questId)" in body,
            f"AccountQuest.{current} must resolve a registered quest definition",
        )
        require("not definition" in body, f"AccountQuest.{current} must reject unregistered quest ids")

    require('selfReset:groupType("normal")' in text, "self-service command must use the normal group")
    require('questReset:groupType("god")' in text, "administrative reset command must remain god-only")


def validate_door_integration(text: str) -> None:
    require("local accountQuestUnlockDoors = {}" in text, "completion-only unlock mapping is missing")
    require(
        'addAccountQuestDoor(secretService.Mission07, "secret-service", true)' in text,
        "Secret Service must unlock account access only at its final mission gate",
    )
    require(
        re.search(r'addAccountQuestDoor\(theApeCity\.[^,]+,\s*"the-ape-city",\s*true\)', text) is None,
        "The Ape City early doors must not unlock completed-quest access",
    )
    require(
        "if hasCharacterAccess and accountQuestId then" not in text,
        "ordinary quest doors must not unlock an entire account quest",
    )
    require(
        "if hasCharacterAccess and completionQuestId then" in text,
        "only explicit completion gates may unlock account quest access",
    )


def main() -> int:
    try:
        config_text = read(CONFIG)
        runtime_text = read(RUNTIME)
        door_text = read(QUEST_DOORS)
        configured = configured_quest_ids(config_text)
        integrated = integrated_quest_ids()
        unknown = sorted(integrated - configured)
        require(not unknown, f"integrations reference unregistered quests: {', '.join(unknown)}")
        validate_runtime(runtime_text)
        validate_door_integration(door_text)
    except AssertionError as error:
        print(f"account quest validation failed: {error}", file=sys.stderr)
        return 1

    print(
        f"account quest validation passed: {len(configured)} configured quests, "
        f"{len(integrated)} integrated quest ids"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
