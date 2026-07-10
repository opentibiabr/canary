#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "lib"))

from complete_preview import render_monster as render_complete_monster
from complete_preview import render_npc as render_complete_npc
from io_utils import atomic_write_json, dumps_json, read_json
from path_policy import require_safe_write

HEADER = "-- Generated preview — not active game content\n-- Manual review and datapack integration required\n"


def _safe_stem(name: str) -> str:
    stem = re.sub(r"[^a-z0-9_-]+", "_", name.lower()).strip("_")
    if not stem:
        raise ValueError("name does not produce a safe filename")
    return stem


def _lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def _quest_preview(task_id: str, component: dict) -> str:
    deps = ", ".join(_lua_string(value) for value in component.get("dependsOn", []))
    return (
        HEADER
        + "local quest = {\n"
        + f"    taskId = {_lua_string(task_id)},\n"
        + f"    componentId = {_lua_string(component['id'])},\n"
        + f"    name = {_lua_string(component['name'])},\n"
        + f"    dependsOn = {{{deps}}},\n"
        + "    dryRun = true,\n"
        + "}\n\n"
        + "-- TODO: replace numeric placeholders with Storage namespace constants after review.\n"
        + "-- TODO: register Action/MoveEvent/CreatureEvent handlers required by the approved design.\n"
        + "return quest\n"
    )


def _npc_preview(task_id: str, component: dict) -> str:
    implementation = component.get("implementation", {})
    if implementation.get("complete") is True:
        return render_complete_npc(HEADER, component)
    name = _lua_string(component["name"])
    return (
        HEADER
        + f"local internalNpcName = {name}\n"
        + "local npcType = Game.createNpcType(internalNpcName)\n"
        + "local npcConfig = {}\n\n"
        + "npcConfig.name = internalNpcName\n"
        + "npcConfig.description = internalNpcName\n"
        + "npcConfig.health = 100\n"
        + "npcConfig.maxHealth = npcConfig.health\n"
        + "npcConfig.walkInterval = 2000\n"
        + "npcConfig.walkRadius = 2\n"
        + "npcConfig.outfit = { lookType = 128, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0 }\n\n"
        + "local keywordHandler = KeywordHandler:new()\n"
        + "local npcHandler = NpcHandler:new(keywordHandler)\n\n"
        + "npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end\n"
        + "npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end\n"
        + "npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end\n"
        + "npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end\n"
        + "npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end\n"
        + "npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end\n\n"
        + "local function creatureSayCallback(npc, creature, type, message)\n"
        + "    if not npcHandler:checkInteraction(npc, creature) then return false end\n"
        + "    -- TODO: implement reviewed quest dialogue and Storage transitions.\n"
        + "    return true\n"
        + "end\n\n"
        + "npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)\n"
        + "npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)\n"
        + "npcType:register(npcConfig)\n"
    )


def _monster_preview(task_id: str, component: dict) -> str:
    implementation = component.get("implementation", {})
    if implementation.get("complete") is True:
        return render_complete_monster(HEADER, component)
    name = _lua_string(component["name"])
    description = _lua_string("a " + component["name"].lower())
    return (
        HEADER
        + f"local mType = Game.createMonsterType({name})\n"
        + "local monster = {}\n\n"
        + f"monster.description = {description}\n"
        + "monster.experience = 0 -- TODO: balance after review\n"
        + "monster.outfit = { lookType = 34, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0 }\n"
        + "monster.health = 1000 -- TODO\n"
        + "monster.maxHealth = 1000 -- TODO\n"
        + "monster.race = \"blood\"\n"
        + "monster.corpse = 0 -- TODO: choose an existing corpse item\n"
        + "monster.speed = 100\n"
        + "monster.manaCost = 0\n"
        + "monster.flags = { summonable = false, attackable = true, hostile = true, convinceable = false, pushable = false, rewardBoss = true, illusionable = false, canPushItems = true, canPushCreatures = true, staticAttackChance = 80, targetDistance = 1, runHealth = 0, healthHidden = false, isBlockable = false }\n"
        + "monster.loot = {} -- TODO: verify items and chances against approved design\n"
        + "monster.attacks = { { name = \"melee\", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 } }\n"
        + "monster.defenses = { defense = 20, armor = 20 }\n"
        + "monster.elements = {}\n"
        + "monster.immunities = {}\n\n"
        + "mType:register(monster)\n"
    )


def _generic_preview(task_id: str, component: dict) -> str:
    deps = ", ".join(_lua_string(value) for value in component.get("dependsOn", []))
    return HEADER + "return {\n" + f"    taskId = {_lua_string(task_id)},\n" + f"    componentId = {_lua_string(component.get('id', task_id))},\n" + f"    type = {_lua_string(component['type'])},\n" + f"    name = {_lua_string(component['name'])},\n" + f"    dependsOn = {{{deps}}},\n" + "    dryRun = true,\n}\n"


def _write_preview(base: Path, output_root: Path, task_id: str, component: dict) -> Path:
    component_type = component["type"]
    extension = ".xml" if component_type == "raid" else ".lua"
    path = base / component_type / f"{_safe_stem(component['name'])}{extension}"
    require_safe_write(path, output_root=output_root)
    path.parent.mkdir(parents=True, exist_ok=True)
    if component_type == "quest":
        body = _quest_preview(task_id, component)
    elif component_type == "npc":
        body = _npc_preview(task_id, component)
    elif component_type == "monster":
        body = _monster_preview(task_id, component)
    elif extension == ".xml":
        body = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- Generated preview — not active game content -->\n<raid name="preview" interval2="0" margin="0" repeat="false" />\n'
    else:
        body = _generic_preview(task_id, component)
    path.write_text(body, encoding="utf-8")
    return path


def render(task, plan, outdir):
    output_root = Path(outdir)
    base = output_root / task["taskId"]
    require_safe_write(base, output_root=output_root)
    base.mkdir(parents=True, exist_ok=True)
    files = []
    task_type = task["type"]
    if task_type == "content_bundle":
        for component in task["contentBundle"]["components"]:
            files.append(_write_preview(base, output_root, task["taskId"], component))
    elif task_type in {"quest", "npc", "spell", "raid", "monster"}:
        files.append(_write_preview(base, output_root, task["taskId"], {"id": task["taskId"], "type": task_type, "name": task["name"], "dependsOn": []}))
    else:
        path = base / "MANUAL_IMPLEMENTATION_REQUIRED.md"
        require_safe_write(path, output_root=output_root)
        path.write_text("# Manual implementation required\n\nGenerated preview — not active game content.\n", encoding="utf-8")
        files.append(path)
    manifest_path = base / "MANIFEST.json"
    require_safe_write(manifest_path, output_root=output_root)
    manifest = {
        "taskId": task["taskId"],
        "taskType": task_type,
        "dryRun": True,
        "format": "canary-preview-v1",
        "plannedFiles": plan.get("newFiles", []),
        "files": [{"path": str(path.relative_to(output_root)).replace("\\", "/"), "sha256": hashlib.sha256(path.read_bytes()).hexdigest()} for path in sorted(files)],
    }
    atomic_write_json(manifest_path, manifest)
    return manifest


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", required=True)
    parser.add_argument("--plan", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()
    manifest = render(read_json(args.task), read_json(args.plan), args.output_dir)
    print(dumps_json(manifest), end="")


if __name__ == "__main__":
    raise SystemExit(main())
