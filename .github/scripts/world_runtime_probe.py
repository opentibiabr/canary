"""Generate read-only Lua acceptance checks for a validated v2 World catalog.

This is a test oracle for published instances, not a project/map validator.
The server must validate the catalog before any probe callback can run.
"""

import json
from pathlib import Path


def lua_literal(value):
    if isinstance(value, str):
        escaped = []
        for character in value:
            if character in {'"', "\\"}:
                escaped.append("\\" + character)
            elif ord(character) < 32 or ord(character) == 127:
                escaped.append("\\" + str(ord(character)).zfill(3))
            else:
                escaped.append(character)
        return '"' + "".join(escaped) + '"'
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return json.dumps(value, allow_nan=False)
    if value is None:
        return "nil"
    if isinstance(value, dict):
        return "{" + ",".join("[" + lua_literal(key) + "]=" + lua_literal(entry) for key, entry in value.items()) + "}"
    if isinstance(value, list):
        return "{" + ",".join(map(lua_literal, value)) + "}"
    raise TypeError(type(value))


def build_probe(project: Path, mode: str) -> tuple[str, str]:
    catalog = json.loads(project.read_text(encoding="utf-8"))
    if catalog["schemaVersion"] != 2:
        raise ValueError("The runtime acceptance probe requires a v2 catalog")
    objects = {}
    for entry in catalog["layers"]:
        if not entry.get("enabled", True):
            continue
        layer = json.loads((project.parent / entry["file"]).read_text(encoding="utf-8"))
        if layer["schemaVersion"] != 2:
            raise ValueError("The runtime acceptance probe requires v2 layers")
        for obj in layer["objects"]:
            if obj["id"] in objects:
                raise ValueError("Repeated probe identity: " + obj["id"])
            objects[obj["id"]] = obj

    positions = {}

    def position(identity, ancestors=()):
        if identity in ancestors:
            raise ValueError("Cyclic probe placement: " + identity)
        if identity not in positions:
            obj = objects[identity]
            if obj["kind"] == "anchor":
                positions[identity] = obj["position"]
            else:
                source = obj["source"]
                location = source["selector"] if source["mode"] == "map" else source["placement"]
                positions[identity] = location.get("position") or position(location["container"], (*ancestors, identity))
        return positions[identity]

    checks = []
    for identity, obj in objects.items():
        expected = {"id": identity, "position": position(identity)}
        if obj["kind"] == "item":
            source = obj["source"]
            expected["initial"] = source["selector"]["itemId"] if source["mode"] == "map" else source["itemId"]
            expected["attributes"] = obj.get("attributes", {})
            location = source["selector"] if source["mode"] == "map" else source["placement"]
            if "container" in location:
                expected["container"] = location["container"]
            if source["mode"] != "map":
                expected["created"] = True
            for component in obj.get("components", []):
                if component["type"] == "teleport":
                    destination = component["destination"]
                    target = position(destination["object"])
                    offset = destination.get("offset", {})
                    expected["destination"] = {axis: target[axis] + offset.get(axis, 0) for axis in ("x", "y", "z")}
        checks.append("\t\tverify(" + lua_literal(expected) + ")")

    marker = f"World runtime probe passed: {len(checks)} declarations ({mode})"
    # Separate functions keep large catalogs below LuaJIT's per-prototype limit.
    batches = ["\tfunction()\n" + "\n".join(checks[start:start + 128]) + "\n\tend" for start in range(0, len(checks), 128)]
    source = "local legacy = " + lua_literal(mode == "legacy") + "\n" + r'''
local function samePosition(actual, expected)
	return actual and actual.x == expected.x and actual.y == expected.y and actual.z == expected.z
end

local function verify(expected)
	local object = World.get(expected.id)
	if legacy then
		assert(object == nil, expected.id .. ": unexpectedly active in legacy mode")
		return
	end
	assert(object, expected.id .. ": declaration missing")
	assert(samePosition(object:getPosition(), expected.position), expected.id .. ": position mismatch")
	local item = object:getItem()
	if not expected.initial then
		assert(item == nil, expected.id .. ": anchor has a gameplay item")
		return
	end
	assert(item, expected.id .. ": live item missing")
	assert(object:getInitialItemId() == expected.initial, expected.id .. ": initial item ID mismatch")
	assert(samePosition(item:getPosition(), expected.position), expected.id .. ": item position mismatch")
	if expected.created then
		assert(item:getId() == expected.initial, expected.id .. ": created type mismatch")
	end
	local token = object:token()
	local resolved = token and World.resolve(token)
	local fromItem = World.fromItem(item)
	assert(resolved and resolved:getItem() == item, expected.id .. ": token did not resolve the same instance")
	assert(fromItem and fromItem:getItem() == item, expected.id .. ": reverse binding missing")
	for key, value in pairs(expected.attributes) do
		if key == "custom" then
			for customKey, customValue in pairs(value) do
				assert(item:getCustomAttribute(customKey) == customValue, expected.id .. ": custom attribute " .. customKey)
			end
		else
			local attribute = key == "plural" and "pluralname" or key
			assert(item:getAttribute(attribute) == value, expected.id .. ": attribute " .. key)
		end
	end
	if expected.container then
		local parent = World.get(expected.container)
		assert(parent and item:getParent() == parent:getItem(), expected.id .. ": container mismatch")
	end
	if expected.destination then
		assert(samePosition(item:getDestination(), expected.destination), expected.id .. ": native teleport destination mismatch")
	end
end

local batches = {
''' + ",\n".join(batches) + "\n}\n" + r'''
local startup = GlobalEvent("WorldRuntimeAcceptanceProbe")
function startup.onStartup()
	addEvent(function()
		for _, batch in ipairs(batches) do
			batch()
		end
''' + "\t\tlogger.info(" + lua_literal(marker) + ")\n" + r'''
	end, 1000)
	return true
end
startup:register()
'''
    return source, marker
