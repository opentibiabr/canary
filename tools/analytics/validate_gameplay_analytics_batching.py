#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
CONFIG = ROOT / "data-otservbr-global/scripts/config/gameplay_analytics.lua"
BATCHING = ROOT / "data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua"
RUNTIME = ROOT / "data-otservbr-global/scripts/systems/gameplay_analytics.lua"
DOCS = ROOT / "docs/systems/gameplay-analytics-persistence.md"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(path: Path) -> str:
    require(path.is_file(), f"missing file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def validate_config(text: str) -> None:
    require(
        re.search(r"^\s*detailBatchSize\s*=\s*[1-9][0-9]*\s*,?\s*$", text, flags=re.MULTILINE) is not None,
        "detailBatchSize must have a positive default",
    )


def validate_batching(text: str) -> None:
    require("Analytics.batchingInstalled" in text, "batching layer must be idempotent")
    require("function Analytics.flush()" in text, "batching layer must own the active flush path")
    require("table.concat(batch, \",\")" in text, "detail rows must be joined into multi-row inserts")
    require("detailBatchSize()" in text, "detail batch size must be enforced")
    require("clampInteger(Analytics.config.detailBatchSize, 1, 1000, 250)" in text, "detail batch size must be bounded")
    require("for first = 1, #rows, batchSize do" in text, "detail rows must be chunked")
    require(text.count("runDetailBatches(") >= 6, "all five detail categories must use the batch helper")
    for table in (
        "analytics_session_monsters",
        "analytics_session_spells",
        "analytics_session_damage_types",
        "analytics_session_supplies",
        "analytics_session_loot",
    ):
        require(table in text, f"missing batched persistence for {table}")
    for metric in ("detailBatchQueries", "detailRowsPersisted", "largestDetailBatch"):
        require(metric in text, f"missing batching metric: {metric}")
    require("Analytics.enqueue(session)" in text, "failed batched sessions must be requeued")
    require("ON DUPLICATE KEY UPDATE" in text, "batched persistence must remain idempotent")


def validate_runtime(text: str) -> None:
    core = 'dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")'
    batching = 'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")'
    reliability = 'dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")'
    core_index = text.find(core)
    batching_index = text.find(batching)
    reliability_index = text.find(reliability)
    require(core_index >= 0 and batching_index >= 0 and reliability_index >= 0, "runtime lacks an analytics persistence layer")
    require(core_index < batching_index < reliability_index, "load order must be core, batching, reliability")
    for metric in ("detailBatchSize", "detailBatchQueries", "detailRowsPersisted"):
        require(metric in text, f"admin status does not expose {metric}")


def validate_docs(text: str) -> None:
    require("detailBatchSize" in text, "batching documentation lacks configuration")
    require("multi-row" in text.lower(), "batching documentation lacks multi-row behaviour")
    require("largestDetailBatch" in text, "batching documentation lacks health metrics")
    require("max_allowed_packet" in text, "batching documentation lacks packet-size guidance")


def main() -> int:
    try:
        validate_config(read(CONFIG))
        validate_batching(read(BATCHING))
        validate_runtime(read(RUNTIME))
        validate_docs(read(DOCS))
    except AssertionError as error:
        print(f"gameplay analytics batching validation failed: {error}", file=sys.stderr)
        return 1

    print("gameplay analytics batching validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
