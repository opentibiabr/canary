"""JSON Schema loading and strict instance validation."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator, FormatChecker


SCHEMA_DIRECTORY = Path(__file__).with_name("schemas")


class SchemaError(ValueError):
	pass


def load_schema(name: str) -> dict[str, Any]:
	if Path(name).name != name or not name.endswith(".schema.json"):
		raise SchemaError(f"invalid schema name: {name!r}")
	path = SCHEMA_DIRECTORY / name
	try:
		return json.loads(path.read_text(encoding="utf-8"))
	except (OSError, UnicodeError, json.JSONDecodeError) as error:
		raise SchemaError(f"cannot load schema {name}: {error}") from error


def validate_instance(name: str, instance: Any) -> None:
	schema = load_schema(name)
	try:
		Draft202012Validator.check_schema(schema)
	except Exception as error:
		raise SchemaError(f"invalid schema {name}: {error}") from error
	validator = Draft202012Validator(schema, format_checker=FormatChecker())
	errors = sorted(validator.iter_errors(instance), key=lambda error: list(error.absolute_path))
	if errors:
		error = errors[0]
		location = ".".join(str(part) for part in error.absolute_path) or "<root>"
		raise SchemaError(f"{name} rejected {location}: {error.message}")


def validate_all_schemas() -> None:
	for path in sorted(SCHEMA_DIRECTORY.glob("*.schema.json")):
		schema = load_schema(path.name)
		try:
			Draft202012Validator.check_schema(schema)
		except Exception as error:
			raise SchemaError(f"invalid schema {path.name}: {error}") from error


def load_and_validate_json(path: Path, schema_name: str) -> Any:
	try:
		instance = json.loads(path.read_text(encoding="utf-8"))
	except (OSError, UnicodeError, json.JSONDecodeError) as error:
		raise SchemaError(f"cannot read JSON {path}: {error}") from error
	validate_instance(schema_name, instance)
	return instance


def stable_json(instance: Any) -> str:
	return json.dumps(instance, ensure_ascii=False, indent=2, sort_keys=True) + "\n"
