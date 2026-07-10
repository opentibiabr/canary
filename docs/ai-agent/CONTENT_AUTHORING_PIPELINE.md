# AI content authoring pipeline

Flow:

`Task Spec -> Validation -> ID Allocation -> Planning -> Rendering -> Plan Validation -> Risk Report -> Human Review`

The pipeline accepts a deterministic JSON task spec, validates core semantic rules, allocates identifiers against `ID_REGISTRY.json` plus `ID_RESERVATIONS.json`, writes a dry-run plan, renders preview files under `artifacts/generated-content/<taskId>/`, validates safety constraints, and emits a summary for human review.

All generated content is preview-only. OTBM files, `items.otb`, active datapacks, and production configuration files are forbidden write targets.
