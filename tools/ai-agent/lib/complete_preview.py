from __future__ import annotations

import json


def _lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def _lua_bool(value: bool) -> str:
    return "true" if value else "false"


def render_npc(header: str, component: dict) -> str:
    implementation = component["implementation"]
    dialogue = implementation["dialogue"]
    outfit = implementation["outfit"]
    name = _lua_string(component["name"])
    keywords = []
    for branch in dialogue:
        triggers = ", ".join(_lua_string(value.lower()) for value in branch["keywords"])
        reply = _lua_string(branch["reply"])
        keywords.append(
            "    if table.contains({" + triggers + "}, message:lower()) then\n"
            f"        npcHandler:say({reply}, npc, creature)\n"
            "        return true\n"
            "    end\n"
        )
    return (
        header
        + f"local internalNpcName = {name}\n"
        + "local npcType = Game.createNpcType(internalNpcName)\n"
        + "local npcConfig = {}\n\n"
        + "npcConfig.name = internalNpcName\n"
        + f"npcConfig.description = {_lua_string(implementation['description'])}\n"
        + f"npcConfig.health = {int(implementation['health'])}\n"
        + "npcConfig.maxHealth = npcConfig.health\n"
        + f"npcConfig.walkInterval = {int(implementation['walkInterval'])}\n"
        + f"npcConfig.walkRadius = {int(implementation['walkRadius'])}\n"
        + "npcConfig.outfit = { "
        + ", ".join(f"{key} = {int(value)}" for key, value in outfit.items())
        + " }\n\n"
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
        + "".join(keywords)
        + "    return true\n"
        + "end\n\n"
        + "npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)\n"
        + "npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)\n"
        + "npcType:register(npcConfig)\n"
    )


def render_monster(header: str, component: dict) -> str:
    implementation = component["implementation"]
    flags = implementation["flags"]
    attacks = implementation["attacks"]
    loot = implementation["loot"]
    name = _lua_string(component["name"])
    attack_rows = []
    for attack in attacks:
        fields = []
        for key, value in attack.items():
            rendered = _lua_string(value) if isinstance(value, str) else str(int(value))
            fields.append(f"{key} = {rendered}")
        attack_rows.append("    { " + ", ".join(fields) + " },")
    loot_rows = []
    for entry in loot:
        fields = [f"id = {int(entry['id'])}", f"chance = {int(entry['chance'])}"]
        if "maxCount" in entry:
            fields.append(f"maxCount = {int(entry['maxCount'])}")
        loot_rows.append("    { " + ", ".join(fields) + " },")
    return (
        header
        + f"local mType = Game.createMonsterType({name})\n"
        + "local monster = {}\n\n"
        + f"monster.description = {_lua_string(implementation['description'])}\n"
        + f"monster.experience = {int(implementation['experience'])}\n"
        + "monster.outfit = { "
        + ", ".join(f"{key} = {int(value)}" for key, value in implementation["outfit"].items())
        + " }\n"
        + f"monster.health = {int(implementation['health'])}\n"
        + "monster.maxHealth = monster.health\n"
        + f"monster.race = {_lua_string(implementation['race'])}\n"
        + f"monster.corpse = {int(implementation['corpse'])}\n"
        + f"monster.speed = {int(implementation['speed'])}\n"
        + "monster.manaCost = 0\n"
        + "monster.flags = { "
        + ", ".join(
            f"{key} = {_lua_bool(value) if isinstance(value, bool) else int(value)}" for key, value in flags.items()
        )
        + " }\n"
        + "monster.loot = {\n"
        + "\n".join(loot_rows)
        + "\n}\n"
        + "monster.attacks = {\n"
        + "\n".join(attack_rows)
        + "\n}\n"
        + f"monster.defenses = {{ defense = {int(implementation['defense'])}, armor = {int(implementation['armor'])} }}\n"
        + "monster.elements = {}\n"
        + "monster.immunities = {}\n\n"
        + "mType:register(monster)\n"
    )
