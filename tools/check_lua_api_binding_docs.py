#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


DOC_PATH = Path("docs/lua-api/lua_api.json")
WEAK_PARAM_PATTERNS = (
    re.compile(r":\s*any\b"),
    re.compile(r"\barg\d+\b"),
)

@dataclass(frozen=True)
class Binding:
    path: Path
    line: int
    kind: str
    name: str
    handler: str


def run_git(args):
    completed = subprocess.run(["git", *args], check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return completed.stdout


def resolve_base_ref(explicit_base):
    candidates = []
    if explicit_base:
        candidates.append(explicit_base)
    github_base_ref = os.environ.get("GITHUB_BASE_REF")
    if github_base_ref:
        candidates.extend([f"origin/{github_base_ref}", github_base_ref])
    candidates.extend(["origin/main", "main"])

    for candidate in candidates:
        try:
            return run_git(["merge-base", "HEAD", candidate]).strip()
        except subprocess.CalledProcessError:
            continue

    raise RuntimeError("could not resolve a base ref for Lua API binding documentation check")


def parse_added_bindings(base_ref):
    bindings = []
    for path, line_number, source in iter_added_cpp_lines(base_ref):
        binding = parse_registration_line(path, line_number, source)
        if binding:
            bindings.append(binding)
    return bindings


def iter_added_cpp_lines(base_ref):
    diff = run_git(["diff", "--unified=0", "--diff-filter=AM", f"{base_ref}...HEAD", "--", "src/lua"])
    current_path = None
    new_line = None

    for line in diff.splitlines():
        if line.startswith("+++ b/"):
            current_path = Path(line[6:])
            continue
        if line.startswith("@@"):
            new_line = parse_hunk_start(line)
            continue
        if not is_cpp_source_path(current_path):
            continue
        if is_added_source_line(line):
            yield current_path, new_line or 0, line[1:]
            new_line = next_line_number(new_line)
            continue
        if is_context_source_line(line):
            new_line = next_line_number(new_line)


def parse_hunk_start(line):
    match = re.search(r"\+(\d+)", line)
    return int(match.group(1)) if match else None


def is_cpp_source_path(path):
    return path is not None and path.suffix == ".cpp"


def is_added_source_line(line):
    return line.startswith("+") and not line.startswith("+++")


def is_context_source_line(line):
    return not line.startswith("-")


def next_line_number(line_number):
    return None if line_number is None else line_number + 1


def split_call_arguments(line, call_name):
    open_index = find_call_open_index(line, call_name)
    if open_index < 0:
        return None

    args = []
    current = []
    depth = 0
    in_string = False
    escape = False

    for char in line[open_index + 1 :]:
        if in_string:
            in_string, escape = consume_string_character(current, char, escape)
            continue

        if char == '"':
            in_string = True
            current.append(char)
            continue

        if char in "([{":
            depth += 1
            current.append(char)
            continue

        if is_call_close(char, depth):
            append_current_argument(args, current)
            return args

        if char in ")]}":
            depth -= 1
            current.append(char)
            continue

        if char == "," and depth == 0:
            append_current_argument(args, current)
            continue

        current.append(char)

    return None


def find_call_open_index(line, call_name):
    call_index = line.find(call_name)
    if call_index < 0:
        return -1
    return line.find("(", call_index + len(call_name))


def consume_string_character(current, char, escape):
    current.append(char)
    if escape:
        return True, False
    if char == "\\":
        return True, True
    if char == '"':
        return False, False
    return True, False


def append_current_argument(args, current):
    args.append("".join(current).strip())
    current.clear()


def is_call_close(char, depth):
    return char in ")]}" and depth == 0


def string_literal_value(value):
    value = value.strip()
    if len(value) < 2 or value[0] != '"' or value[-1] != '"':
        return None
    return value[1:-1]


def handler_name(value):
    return value.strip().rstrip(";")


def parse_registration_line(path, line_number, line):
    for parser in (parse_method_registration, parse_global_registration, parse_class_registration):
        binding = parser(path, line_number, line)
        if binding:
            return binding
    return None


def parse_method_registration(path, line_number, line):
    args = split_call_arguments(line, "Lua::registerMethod")
    if args and len(args) >= 4:
        class_name = string_literal_value(args[1])
        method_name = string_literal_value(args[2])
        if class_name and method_name:
            return Binding(path, line_number, "method", f"{class_name}:{method_name}", handler_name(args[3]))
    return None


def parse_global_registration(path, line_number, line):
    args = split_call_arguments(line, "Lua::registerGlobalMethod")
    if args and len(args) >= 2:
        name = string_literal_value(args[0])
        if name:
            return Binding(path, line_number, "global", name, handler_name(args[1]))
    return None


def parse_class_registration(path, line_number, line):
    for call_name in ("Lua::registerSharedClass", "Lua::registerClass"):
        args = split_call_arguments(line, call_name)
        if args and len(args) >= 4:
            class_name = string_literal_value(args[1])
            handler = handler_name(args[3])
            if class_name and handler != "nullptr":
                return Binding(path, line_number, "class", class_name, handler)

    return None


def load_docs():
    with DOC_PATH.open("r", encoding="utf-8") as file:
        return json.load(file)


def find_doc_entry(data, binding):
    if binding.kind == "method":
        class_name, method_name = binding.name.split(":", 1)
        for method in data.get("classes", {}).get(class_name, []):
            if method.get("name") == method_name:
                return method
        return None
    if binding.kind == "global":
        for function in data.get("globals", []):
            if function.get("name") == binding.name:
                return function
        return None
    if binding.kind == "class":
        return {
            "params": [],
            "return": "",
            "overloads": data.get("classOverloads", {}).get(binding.name, []),
        }
    return None


def weak_reasons(entry):
    reasons = []
    for parameter in entry.get("params", []):
        if parameter.startswith("..."):
            reasons.append(f"parameter uses vararg placeholder: {parameter}")
        for pattern in WEAK_PARAM_PATTERNS:
            if pattern.search(parameter):
                reasons.append(f"weak parameter: {parameter}")
                break

    return_type = entry.get("return", "")
    if return_type in {"any", "table"}:
        reasons.append(f"weak return type: {return_type}")
    if "boolean|" in return_type or "|boolean" in return_type:
        reasons.append(f"broad boolean union return: {return_type}")
    if entry.get("overloads") == [] and entry.get("return", "") == "" and entry.get("params") == []:
        reasons.append("callable class has no documented overload")
    return reasons


def has_lua_docblock(binding):
    if not binding.path.exists():
        return False

    text = binding.path.read_text(encoding="utf-8", errors="replace")
    registration_index = find_registration_index(text, binding)
    handler_index = find_handler_index(text, binding.handler)
    return has_docblock_before(text, registration_index) or has_docblock_before(text, handler_index)


def find_registration_index(text, binding):
    escaped_name = re.escape(binding.name.split(":", 1)[-1] if binding.kind == "method" else binding.name)
    escaped_handler = re.escape(binding.handler)
    pattern = re.compile(rf'Lua::register[A-Za-z]*\s*\([^;]*"{escaped_name}"[^;]*{escaped_handler}', re.DOTALL)
    match = pattern.search(text)
    return match.start() if match else -1


def find_handler_index(text, handler):
    if not handler:
        return -1
    pattern = re.compile(rf"\b(?:int|void|bool)\s+{re.escape(handler)}\s*\(")
    match = pattern.search(text)
    return match.start() if match else -1


def has_docblock_before(text, index):
    if index < 0:
        return False
    block_end = text.rfind("*/", 0, index)
    if block_end < 0:
        return False
    block_start = text.rfind("/***", 0, block_end)
    if block_start < 0:
        return False
    between = text[block_end + 2 : index]
    if between.strip():
        return False
    block = text[block_start:block_end]
    return any(tag in block for tag in ("@function", "@param", "@return", "@class", "@overload"))


def main():
    parser = argparse.ArgumentParser(description="Require explicit Lua API docblocks for new weak Lua bindings.")
    parser.add_argument("--base", help="base ref or commit to compare against")
    args = parser.parse_args()

    try:
        base_ref = resolve_base_ref(args.base)
        bindings = parse_added_bindings(base_ref)
        docs = load_docs()
    except (OSError, RuntimeError, subprocess.CalledProcessError, json.JSONDecodeError) as error:
        print(f"::error::failed to run Lua API binding documentation check: {error}")
        return 1

    failed = False
    for binding in bindings:
        entry = find_doc_entry(docs, binding)
        if entry is None:
            print(f"::error file={binding.path},line={binding.line}::Lua API binding {binding.name} is missing from docs/lua-api/lua_api.json")
            failed = True
            continue

        reasons = weak_reasons(entry)
        if reasons and not has_lua_docblock(binding):
            print(f"::error file={binding.path},line={binding.line}::Lua API binding {binding.name} has a weak generated signature and needs an explicit /*** */ docblock")
            for reason in reasons:
                print(f"  - {reason}")
            failed = True

    if failed:
        return 1

    print(f"Lua API binding documentation check passed: {len(bindings)} new binding registration(s) inspected")
    return 0


if __name__ == "__main__":
    sys.exit(main())
