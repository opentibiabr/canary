"""Known consumer adapters; data extraction remains structural and static."""

from __future__ import annotations

import copy
from pathlib import Path

from .bundle import read_json, sha
from .lua_ast import Reader, evaluate, json_value


REWARD_FIELDS = {"storage", "useKV", "questName", "container", "keyAction", "isKey", "weight", "timerStorage", "time", "reward", "randomReward"}
BEHAVIORS = {
	"quest.reward": "quest_reward",
	"world.player_teleport": "player_teleport",
	"world.tile_mechanism": "tile_mechanism",
}


def adapt_consumers(root: Path, pack: Path, consumers: list[dict], selected_tables: set[str]) -> tuple[list[dict], dict[str, bytes]]:
	contracts = read_json(Path(__file__).with_name("consumer_adapters.json"))["files"]
	results, outputs = [], {}
	cache = {}
	for consumer in consumers:
		if consumer["table"] not in selected_tables:
			continue
		name = consumer["file"]
		if name not in cache:
			path = root / name
			local = path.relative_to(pack).as_posix() if path.is_relative_to(pack) else name
			contract = contracts.get(local)
			content = path.read_bytes()
			normalized = content.decode("utf-8").replace("\r\n", "\n").replace("\r", "\n")
			fingerprint = sha(normalized.encode("utf-8"))
			status = "blocked"
			if contract and fingerprint == contract["afterSha256"]:
				status = "preserved" if contract["kind"] == "compatibility" else "adapted"
			elif contract and fingerprint == contract.get("beforeSha256"):
				lines = content.decode("utf-8").splitlines(keepends=True)
				newline = "\r\n" if b"\r\n" in content else "\n"
				for patch in reversed(contract["patches"]):
					start = patch["startLine"]
					old = patch["before"]
					if [line.rstrip("\r\n") for line in lines[start:start + len(old)]] != old:
						raise ValueError(f"Consumer patch precondition changed: {name}")
					lines[start:start + len(old)] = [line + newline for line in patch["after"]]
				updated = "".join(lines)
				if sha(updated.replace("\r\n", "\n").encode("utf-8")) != contract["afterSha256"]:
					raise ValueError(f"Consumer patch did not produce the recognized adapter: {name}")
				outputs[name] = updated.encode("utf-8")
				status = "adapted"
			cache[name] = status
		results.append(dict(consumer, status=cache[name]))
	return results, outputs


def consumer_constants(pack: Path) -> dict:
	path = pack / "scripts/actions/system/quest_reward_common.lua"
	if not path.is_file():
		return {}
	result = {}
	for assignment in Reader(path.read_text(encoding="utf-8")).assignments():
		if assignment.name in {"AttributeTable", "achievementTable"}:
			if assignment.name in result:
				raise ValueError(f"Repeated consumer configuration: {assignment.name}")
			result[assignment.name] = json_value(evaluate(assignment.value))
	return result


def reward_parameters(value: dict, key: str, constants: dict) -> dict:
	parameters = {name: copy.deepcopy(value[name]) for name in REWARD_FIELDS if name in value}
	for name in ("reward", "randomReward"):
		if name not in parameters:
			continue
		values = parameters[name]
		if name == "reward" and values == [{}] and parameters.get("randomReward"):
			# The consumer fills its single empty slot before reading rewards.
			parameters[name] = []
			continue
		if not isinstance(values, list) or not values:
			raise ValueError(f"Expected a non-empty {name} list")
		converted = []
		for entry in values:
			if not isinstance(entry, list) or len(entry) != 2 or any(type(number) is not int or number < 1 for number in entry):
				raise ValueError(f"Expected static itemId/count pairs in {name}")
			converted.append(dict(zip(("itemId", "count"), entry)))
		parameters[name] = converted
	attribute = constants.get("AttributeTable", {}).get(key)
	if attribute is not None:
		if set(attribute) != {"text"} or not isinstance(attribute["text"], str):
			raise ValueError("Unknown reward attributes in the legacy consumer")
		parameters["rewardText"] = attribute["text"]
	achievement = constants.get("achievementTable", {}).get(key)
	if achievement is not None:
		parameters["achievement"] = achievement
	if not parameters.get("useKV") and type(parameters.get("storage")) is not int:
		raise ValueError("A storage reward requires a static completion storage")
	if parameters.get("useKV") and not isinstance(parameters.get("questName"), str):
		raise ValueError("A key/value reward requires a quest namespace")
	return parameters


def behavior_files(root: Path, pack: Path, catalog: dict, behavior_ids: set[str]) -> dict[str, bytes]:
	"""Include implementations and descriptors in the same reviewable bundle."""
	templates = Path(__file__).resolve().parents[2] / "data-otservbr-global"
	outputs = {}
	for identity in sorted(behavior_ids):
		name = BEHAVIORS[identity]
		reference = f"behaviors/{name}.behavior.json"
		if reference not in catalog.setdefault("behaviorCatalog", []):
			catalog["behaviorCatalog"].append(reference)
		paths = [f"world/{reference}", f"scripts/world_behaviors/{name}.lua"]
		if identity == "quest.reward":
			paths.append("lib/core/world_quest_reward.lua")
		for name in paths:
			source = templates / name
			destination = pack / name
			content = source.read_text(encoding="utf-8")
			if destination.exists() and destination.read_text(encoding="utf-8") != content:
				raise ValueError(f"The destination behavior is customized; review it before migration: {destination}")
			outputs[destination.relative_to(root).as_posix()] = content.encode("utf-8")
	return outputs
