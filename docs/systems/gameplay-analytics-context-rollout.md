# Gameplay Analytics hunt-context rollout checklist

1. Apply all migrations with `tools/analytics/migrate_gameplay_analytics.sh`.
2. Confirm `/analytics schema` reports version `3/3` and readiness `true`.
3. Set a stable `CANARY_SERVER_VERSION` for the deployed balance build.
4. Start with `huntAreas = {}` and fallback grid areas enabled.
5. Run a short controlled hunt in solo and party modes.
6. Verify `hunt_area`, party min/max/average and shared-experience ratio in `analytics_sessions`.
7. Add stable named rectangles for the most important hunting grounds.
8. Compare named-area totals with fallback-grid totals before building dashboards.
9. Monitor `/analytics status` for context samples, finalized sessions, queue growth and flush failures.
10. Keep exact coordinates and character membership outside Analytics exports.
