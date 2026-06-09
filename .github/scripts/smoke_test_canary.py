#!/usr/bin/env python3
import argparse
import glob
import os
import re
import shutil
import signal
import subprocess
import sys
import time
import urllib.request
import uuid
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]


def github_escape(message: str) -> str:
    return message.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def repo_path(path: str) -> Path:
    candidate = Path(path)
    if candidate.is_absolute():
        return candidate
    return REPO_ROOT / candidate


def find_mysql() -> str:
    mysql = shutil.which("mysql")
    if mysql:
        return mysql

    candidates = [
        r"C:\Program Files\MariaDB*\bin\mysql.exe",
        r"C:\Program Files\MySQL\MySQL Server*\bin\mysql.exe",
        "/usr/local/bin/mysql",
        "/opt/homebrew/bin/mysql",
        "/usr/bin/mysql",
    ]
    for pattern in candidates:
        matches = glob.glob(pattern)
        if matches:
            return matches[0]

    raise RuntimeError("mysql client was not found in PATH")


def mysql_args(args: argparse.Namespace, database: str | None = None) -> list[str]:
    command = [
        find_mysql(),
        f"--host={args.db_host}",
        f"--port={args.db_port}",
        f"--user={args.db_user}",
        "--protocol=tcp",
        "--default-character-set=utf8mb4",
    ]
    if database:
        command.append(f"--database={database}")
    return command


def mysql_env(args: argparse.Namespace) -> dict[str, str]:
    env = os.environ.copy()
    if args.db_password:
        env["MYSQL_PWD"] = args.db_password
    return env


def run_mysql(args: argparse.Namespace, query: str | None = None, input_file: Path | None = None, database: str | None = None) -> None:
    command = mysql_args(args, database)
    env = mysql_env(args)
    if query is not None:
        command.extend(["--execute", query])
        result = subprocess.run(command, cwd=REPO_ROOT, text=True, env=env)
        if result.returncode != 0:
            raise RuntimeError(f"mysql query failed with exit code {result.returncode}")
        return

    if input_file is not None:
        with input_file.open("rb") as input_stream:
            result = subprocess.run(command, cwd=REPO_ROOT, stdin=input_stream, env=env)
        if result.returncode != 0:
            raise RuntimeError(f"mysql import failed for '{input_file}' with exit code {result.returncode}")
        return

    raise RuntimeError("run_mysql requires query or input_file")


def wait_mysql(args: argparse.Namespace) -> None:
    deadline = time.time() + 90
    while time.time() < deadline:
        try:
            run_mysql(args, query="SELECT 1;")
            return
        except Exception:
            time.sleep(2)

    raise RuntimeError(f"MySQL did not become reachable at {args.db_host}:{args.db_port}")


def initialize_database(args: argparse.Namespace) -> None:
    if args.skip_database_init:
        print("Skipping database initialization.")
        return

    wait_mysql(args)

    safe_db_name = args.db_name.replace("`", "``")
    run_mysql(
        args,
        query=(
            f"DROP DATABASE IF EXISTS `{safe_db_name}`; "
            f"CREATE DATABASE `{safe_db_name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        ),
    )
    run_mysql(args, database=args.db_name, input_file=REPO_ROOT / "schema.sql")

    test_account = REPO_ROOT / "docker/data/01-test_account.sql"
    test_players = REPO_ROOT / "docker/data/02-test_account_players.sql"
    if test_account.exists() and test_players.exists():
        run_mysql(args, database=args.db_name, input_file=test_account)
        run_mysql(args, database=args.db_name, input_file=test_players)


def lua_string(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def set_lua_value(content: str, name: str, value_literal: str) -> str:
    pattern = re.compile(rf"^{re.escape(name)}\s*=.*$", re.MULTILINE)
    matches = list(pattern.finditer(content))
    if not matches:
        raise RuntimeError(f"Config key '{name}' was not found in config.lua.dist")
    if len(matches) > 1:
        raise RuntimeError(f"Config key '{name}' appeared {len(matches)} times in config.lua.dist")
    return pattern.sub(lambda _: f"{name} = {value_literal}", content, count=1)


def write_smoke_config(args: argparse.Namespace) -> None:
    config = (REPO_ROOT / "config.lua.dist").read_text(encoding="utf-8")

    replacements = {
        "dataPackDirectory": lua_string(args.data_pack),
        "mapName": lua_string(args.map_name),
        "mapDownloadUrl": lua_string(""),
        "toggleDownloadMap": "false",
        "toggleMapCustom": "false",
        "startupDatabaseOptimization": "false",
        "mysqlDatabaseBackup": "false",
        "toggleSaveInterval": "false",
        "forgeInfluencedLimit": "0",
        "forgeFiendishLimit": "0",
        "ip": lua_string("127.0.0.1"),
        "loginProtocolPort": str(args.login_port),
        "gameProtocolPort": str(args.game_port),
        "statusProtocolPort": str(args.status_port),
        "serverName": lua_string("Canary CI Smoke"),
        "houseRentPeriod": lua_string("never"),
        "mysqlHost": lua_string(args.db_host),
        "mysqlUser": lua_string(args.db_user),
        "mysqlPass": lua_string(args.db_password),
        "mysqlDatabase": lua_string(args.db_name),
        "mysqlPort": str(args.db_port),
        "mysqlSock": lua_string(""),
        "metricsEnablePrometheus": "false",
        "metricsEnableOstream": "false",
    }

    for key, value in replacements.items():
        config = set_lua_value(config, key, value)

    (REPO_ROOT / "config.lua").write_text(config, encoding="utf-8", newline="\n")


def prepare_map(args: argparse.Namespace) -> None:
    map_path = REPO_ROOT / args.data_pack / "world" / f"{args.map_name}.otbm"
    map_path.parent.mkdir(parents=True, exist_ok=True)

    if map_path.exists():
        if map_path.stat().st_size <= 0:
            raise RuntimeError(f"Map file '{map_path}' exists but is empty")
        return

    if args.map_cache_path:
        cache_path = repo_path(args.map_cache_path)
        if cache_path.exists():
            if cache_path.stat().st_size <= 0:
                raise RuntimeError(f"Cached map '{cache_path}' exists but is empty")
            shutil.copyfile(cache_path, map_path)
            if map_path.stat().st_size <= 0:
                raise RuntimeError(f"Copied map '{map_path}' is empty")
            return

    if not args.map_download_url:
        raise RuntimeError(f"Map file '{map_path}' is missing and no map download URL was provided")

    download_target = map_path
    if args.map_cache_path:
        download_target = repo_path(args.map_cache_path)
        download_target.parent.mkdir(parents=True, exist_ok=True)

    print(f"Downloading {args.map_name} map from {args.map_download_url}")
    urllib.request.urlretrieve(args.map_download_url, download_target)

    if download_target.stat().st_size <= 0:
        raise RuntimeError(f"Downloaded map '{download_target}' is empty")

    if download_target != map_path:
        shutil.copyfile(download_target, map_path)


def read_logs(paths: list[Path]) -> str:
    parts: list[str] = []
    for path in paths:
        if path.exists():
            parts.append(path.read_text(encoding="utf-8", errors="replace"))
    return "\n".join(parts)


def stop_process(process: subprocess.Popen) -> None:
    if process.poll() is not None:
        return

    if os.name == "nt":
        process.terminate()
    else:
        process.send_signal(signal.SIGTERM)

    try:
        process.wait(timeout=20)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait(timeout=10)


def restore_config(config_path: Path, existed: bool, previous_content: bytes | None) -> None:
    if existed and previous_content is not None:
        config_path.write_bytes(previous_content)
        return

    try:
        config_path.unlink()
    except FileNotFoundError:
        pass


def assert_clean_log(log_text: str, fail_on_warnings: bool) -> None:
    if not log_text.strip():
        raise RuntimeError("Canary produced no runtime log output")

    pattern = r"\b(warn|warning|error|critical|fatal)\b" if fail_on_warnings else r"\b(error|critical|fatal)\b"
    bad_lines = [line for line in log_text.splitlines() if re.search(pattern, line, re.IGNORECASE)]
    if bad_lines:
        message = "\n".join(bad_lines[:40])
        print(f"::error title=Canary runtime log issue::{github_escape(message)}")
        raise RuntimeError("Canary runtime log contains warning/error lines")


def run_smoke(args: argparse.Namespace) -> None:
    binary = repo_path(args.binary_path)
    if not binary.exists():
        raise RuntimeError(f"Binary '{binary}' was not found")

    if os.name != "nt":
        binary.chmod(binary.stat().st_mode | 0o111)

    config_path = REPO_ROOT / "config.lua"
    config_existed = config_path.exists()
    previous_config = config_path.read_bytes() if config_existed else None
    try:
        prepare_map(args)
        initialize_database(args)
        write_smoke_config(args)

        log_dir = REPO_ROOT / "build/runtime-smoke-logs"
        log_dir.mkdir(parents=True, exist_ok=True)
        label = f"{args.data_pack}-{args.map_name}-{uuid.uuid4().hex[:8]}"
        stdout_path = log_dir / f"{label}.stdout.log"
        stderr_path = log_dir / f"{label}.stderr.log"

        print(f"Starting Canary runtime smoke: datapack={args.data_pack} map={args.map_name} binary={binary}")
        with stdout_path.open("wb") as stdout_file, stderr_path.open("wb") as stderr_file:
            process = subprocess.Popen([str(binary)], cwd=REPO_ROOT, stdout=stdout_file, stderr=stderr_file)

        log_paths = [stdout_path, stderr_path]
        try:
            deadline = time.time() + args.startup_timeout_seconds
            online = False
            while time.time() < deadline:
                time.sleep(2)
                if process.poll() is not None:
                    log_text = read_logs(log_paths)
                    print(log_text)
                    raise RuntimeError(f"Canary exited before becoming online with exit code {process.returncode}")

                log_text = read_logs(log_paths)
                saw_online_log = "server online!" in log_text.lower()
                online = saw_online_log
                if online:
                    break

            if not online:
                log_text = read_logs(log_paths)
                print(log_text)
                raise RuntimeError("Canary did not become ready before timeout")

            time.sleep(5)
            if process.poll() is not None:
                log_text = read_logs(log_paths)
                print(log_text)
                raise RuntimeError(
                    f"Canary exited shortly after becoming online with exit code {process.returncode}"
                )
        finally:
            stop_process(process)

        time.sleep(1)
        runtime_log = read_logs(log_paths)
        print(runtime_log)
        assert_clean_log(runtime_log, args.fail_on_warnings)
        print(f"Canary runtime smoke passed for datapack={args.data_pack} map={args.map_name}.")
    finally:
        restore_config(config_path, config_existed, previous_config)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run a short Canary runtime smoke test.")
    parser.add_argument("--binary-path", required=True)
    parser.add_argument("--data-pack", choices=["data-canary", "data-otservbr-global"], default="data-canary")
    parser.add_argument("--map-name", default="")
    parser.add_argument("--map-download-url", default="")
    parser.add_argument("--map-cache-path", default="")
    parser.add_argument("--db-host", default="127.0.0.1")
    parser.add_argument("--db-port", type=int, default=3306)
    parser.add_argument("--db-user", default="root")
    parser.add_argument("--db-password", default="root")
    parser.add_argument("--db-name", default="canary_smoke")
    parser.add_argument("--login-port", type=int, default=7171)
    parser.add_argument("--game-port", type=int, default=7172)
    parser.add_argument("--status-port", type=int, default=7173)
    parser.add_argument("--startup-timeout-seconds", type=int, default=300)
    parser.add_argument("--fail-on-warnings", action=argparse.BooleanOptionalAction, default=True)
    parser.add_argument("--skip-database-init", action="store_true")
    args = parser.parse_args()

    if not args.map_name:
        args.map_name = "canary" if args.data_pack == "data-canary" else "otservbr"

    return args


def main() -> int:
    try:
        run_smoke(parse_args())
        return 0
    except Exception as exc:
        print(f"::error title=Canary runtime smoke failed::{github_escape(str(exc))}")
        print(f"Canary runtime smoke failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
