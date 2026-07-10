# Research to task draft gate

`tools/ai-agent/research_to_task.py` converts normalized research into a dry-run `content_bundle` task draft.

The gate is intentionally conservative:

- entities already matched in the Canary content index are excluded and reported as blocking conflicts;
- item entities remain manual because the preview renderer does not generate item definitions;
- only missing quests, NPCs, and monsters become draft components;
- generated tasks always remain `dryRun: true`;
- map work, OTBM, and `items.otb` remain manual and prohibited from automated writes;
- a draft is marked `readyForPipeline` only when at least one supported component exists and no existing Canary entity conflicts were found.

Example:

```bash
python tools/ai-agent/research_to_task.py \
  --normalized artifacts/NORMALIZED_RESEARCH.json \
  --task-output artifacts/TASK_SPEC.draft.json \
  --report-output artifacts/RESEARCH_TO_TASK_REPORT.json
```

Exit codes:

- `0`: conflict-free draft with at least one generated component;
- `1`: no supported component could be generated;
- `2`: existing Canary content conflicts block the draft.

The generated task is a review artifact, not permission to write into an active datapack.
