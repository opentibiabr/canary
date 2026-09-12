"""Exercise the distributed native helper with independent binary fixtures."""

from __future__ import annotations

import json
import os
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path


def varint(value):
	result = bytearray()
	while value >= 128:
		result.append((value & 127) | 128)
		value >>= 7
	result.append(value)
	return bytes(result)


def message(field, value):
	return varint(field * 8 + 2) + varint(len(value)) + value


def node(kind, props=b"", children=()):
	escaped = bytearray()
	for value in props:
		if value in (253, 254, 255):
			escaped.append(253)
		escaped.append(value)
	return b"\xfe" + bytes([kind]) + escaped + b"".join(children) + b"\xff"


@unittest.skipUnless(os.environ.get("WORLD_TOOL_PATH"), "set WORLD_TOOL_PATH to a compatible native artifact")
class NativeWorldToolFixture(unittest.TestCase):
	def setUp(self):
		self.temp = tempfile.TemporaryDirectory()
		self.addCleanup(self.temp.cleanup)
		self.root = Path(self.temp.name)
		self.exe = os.environ["WORLD_TOOL_PATH"]
		# Appearance flags: bank=1, container=5, take=18. Payloads follow the
		# versioned appearances.proto rather than depending on helper internals.
		appearances = b""
		for item_id, flags in ((100, message(1, b"\x08\x96\x01")), (200, b""), (300, b"\x28\x01"), (400, varint(18*8)+b"\x01")):
			appearances += message(1, b"\x08" + varint(item_id) + message(3, flags))
		(self.root / "appearances.dat").write_bytes(appearances)
		(self.root / "items.xml").write_text('<items><item id="100"/><item id="200"/><item id="300"><attribute key="type" value="container"/></item><item id="400"/></items>', encoding="utf-8")
		book = node(6, struct.pack("<H",400) + b"\x05" + struct.pack("<H",45000))
		container = node(6, struct.pack("<H",300), [book])
		item = node(6, struct.pack("<H",200) + b"\x04" + struct.pack("<H",12107))
		tile = node(5, bytes([100,100,9])+struct.pack("<H",100), [item, container, node(19, struct.pack("<HH",1,17))])
		area = node(4, struct.pack("<HHB",0,0,7), [tile])
		self.map = b"OTBM" + node(0, struct.pack("<IHHII",2,200,200,3,0), [node(2,b"",[area])])
		(self.root / "example.otbm").write_bytes(self.map)
		self.write_json("positions.json", [{"x":100,"y":100,"z":7}])

	def write_json(self, name, value):
		(self.root / name).write_text(json.dumps(value,ensure_ascii=False),encoding="utf-8")

	def command(self, *args):
		return subprocess.run([self.exe,*args],cwd=self.root,capture_output=True,text=True,encoding="utf-8",timeout=30)


class NativeWorldToolTests(NativeWorldToolFixture):
	def test_inspection_sees_ground_attributes_containers_and_all_uids_without_writes(self):
		before = {p.name:p.read_bytes() for p in self.root.iterdir()}
		result=self.command("inspect","--map","example.otbm","--items","items.xml","--positions","positions.json")
		self.assertEqual(result.returncode,0,result.stdout+result.stderr)
		data=json.loads(result.stdout)
		self.assertEqual(data["tilesScanned"],1)
		self.assertEqual(data["itemsScanned"],4)
		items=data["tiles"][0]["items"]
		self.assertEqual(items[0]["part"],"ground")
		self.assertEqual(items[1]["attributes"]["aid"],12107)
		self.assertEqual(items[2]["children"][0]["attributes"]["uid"],45000)
		self.assertEqual(data["uniqueIds"][0]["uid"],45000)
		self.assertEqual(data["uniqueIds"][0]["position"], {"x": 100, "y": 100, "z": 7})
		self.assertEqual(data["tiles"][0]["legacy"]["topDown"], items[2]["key"])
		self.assertEqual(items[1]["selector"], {"itemId": 200, "part": "item", "position": {"x": 100, "y": 100, "z": 7}})
		self.assertEqual(items[2]["children"][0]["selector"], {"itemId": 400})
		self.assertEqual(before,{p.name:p.read_bytes() for p in self.root.iterdir()})

	def test_identifier_census_includes_unselected_items_and_container_paths(self):
		result = self.command("inspect-identifiers", "--map", "example.otbm", "--items", "items.xml")
		self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
		data = json.loads(result.stdout)
		self.assertEqual(data["tilesScanned"], 1)
		self.assertEqual(data["itemsScanned"], 4)
		self.assertEqual(len(data["identifiers"]), 2)
		self.assertEqual(data["identifiers"][0]["aid"], 12107)
		self.assertEqual(data["identifiers"][0]["containers"], [])
		self.assertEqual(data["identifiers"][1]["uid"], 45000)
		self.assertEqual(len(data["identifiers"][1]["containers"]), 1)

	def test_publisher_rejects_missing_offline_confirmation_and_stale_versions(self):
		self.write_json("publication.json", {"schemaVersion": 1, "catalog": "map.world.json", "changes": [{"file": "config.lua", "before": "before.lua", "after": "after.lua"}], "guards": []})
		(self.root / "before.lua").write_text("old", encoding="utf-8")
		(self.root / "after.lua").write_text("new", encoding="utf-8")
		(self.root / "config.lua").write_text("different", encoding="utf-8")
		result = self.command("publish", "publication.json", "--root", str(self.root))
		self.assertNotEqual(result.returncode, 0)
		self.assertIn("confirm-offline", result.stderr)
		result = self.command("publish", "publication.json", "--root", str(self.root), "--confirm-offline")
		self.assertNotEqual(result.returncode, 0)
		self.assertEqual((self.root / "config.lua").read_text(), "different")
		(self.root / "config.lua").write_text("old", encoding="utf-8")
		result = self.command("publish", "publication.json", "--root", str(self.root), "--confirm-offline")
		self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
		self.assertEqual((self.root / "config.lua").read_text(), "new")

	def test_truncated_map_is_rejected(self):
		(self.root / "example.otbm").write_bytes(self.map[:-2])
		result=self.command("inspect","--map","example.otbm","--items","items.xml","--positions","positions.json")
		self.assertEqual(result.returncode,1,result.stdout+result.stderr)
		self.assertFalse(json.loads(result.stdout)["valid"])

	def test_shared_validator_checks_inherited_and_external_uids(self):
		self.write_json("example.world.json",{"schemaVersion":2,"id":"test","map":"example.otbm","items":"items.xml","layers":[{"file":"example.layer.json","enabled":True}]})
		objects=[{"id":"test.sign","kind":"item","source":{"mode":"map","selector":{"position":{"x":100,"y":100,"z":7},"part":"item","itemId":200}},"attributes":{"aid":12107}}, {"id":"test.external","kind":"item","source":{"mode":"create","itemId":200,"placement":{"position":{"x":100,"y":100,"z":7}}},"lifecycle":"fixture","attributes":{"uid":45000}}]
		self.write_json("example.layer.json",{"schemaVersion":2,"id":"test","objects":objects})
		result=self.command("validate","example.world.json")
		self.assertEqual(result.returncode,1,result.stdout+result.stderr)
		self.assertIn("UID",result.stdout)
		objects[1]["attributes"]={"aid":12107}
		self.write_json("example.layer.json",{"schemaVersion":2,"id":"test","objects":objects})
		result=self.command("validate","example.world.json")
		self.assertEqual(result.returncode,0,result.stdout+result.stderr)
		data = json.loads(result.stdout)
		self.assertEqual(data["objects"],2)
		self.assertIn("effective", data)


if __name__ == "__main__":
	unittest.main()
