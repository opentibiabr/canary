#!/usr/bin/env python3
import argparse
import json
import re
import sys
from pathlib import Path


DOC_PATH = Path("docs/lua-api/lua_api.json")
BASELINE_PATH = Path("docs/lua-api/lua_api_quality_baseline.json")
METRIC_KEYS = (
    "param_any",
    "param_argn",
    "param_vararg",
    "return_any",
    "return_plain_table",
)


def iter_functions(data):
    for class_name, methods in data.get("classes", {}).items():
        for method in methods:
            yield f"{class_name}.{method.get('name', '')}", method

    for function in data.get("globals", []):
        yield function.get("name", ""), function


def collect_metrics(data):
    metrics = {key: 0 for key in METRIC_KEYS}
    examples = {key: [] for key in METRIC_KEYS}

    for function_name, function in iter_functions(data):
        for parameter in function.get("params", []):
            if re.search(r":\s*any\b", parameter):
                metrics["param_any"] += 1
                append_example(examples["param_any"], function_name, parameter)
            if re.search(r"\barg\d+\b", parameter):
                metrics["param_argn"] += 1
                append_example(examples["param_argn"], function_name, parameter)
            if parameter.startswith("..."):
                metrics["param_vararg"] += 1
                append_example(examples["param_vararg"], function_name, parameter)

        return_type = function.get("return", "")
        if return_type == "any":
            metrics["return_any"] += 1
            append_example(examples["return_any"], function_name, return_type)
        if return_type == "table":
            metrics["return_plain_table"] += 1
            append_example(examples["return_plain_table"], function_name, return_type)

    return metrics, examples


def append_example(examples, function_name, value):
    if len(examples) < 5:
        examples.append(f"{function_name}: {value}")


def load_json(path):
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Check generated Lua API documentation quality metrics.")
    parser.add_argument(
        "--update-baseline",
        action="store_true",
        help="write the current metrics to docs/lua-api/lua_api_quality_baseline.json",
    )
    args = parser.parse_args()

    current, examples = collect_metrics(load_json(DOC_PATH))
    if args.update_baseline:
        write_json(BASELINE_PATH, current)
        print(f"Updated Lua API quality baseline: {current}")
        return 0

    if not BASELINE_PATH.exists():
        print(f"::error::{BASELINE_PATH} is missing. Run tools/check_lua_api_quality.py --update-baseline and commit it.")
        return 1

    baseline = load_json(BASELINE_PATH)
    failed = False
    for key in METRIC_KEYS:
        value = current[key]
        allowed = baseline.get(key, value)
        if value > allowed:
            print(f"::error::Lua API quality regression: {key} increased from {allowed} to {value}")
            for example in examples[key]:
                print(f"  {example}")
            failed = True

    if failed:
        return 1

    print(f"Lua API quality check passed: {current}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
