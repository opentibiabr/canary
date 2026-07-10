You are repairing a failed CI run in the Canary C++ server repository.

Read `ci-failure.log` first. Inspect the repository and identify the smallest safe change that fixes the actual CI failure.

Rules:
- Modify only files necessary to fix the failure.
- Do not modify anything under `.github/workflows/`, repository security policy, branch protection, secrets, dependency credentials, or release/signing configuration.
- Do not disable, skip, weaken, or delete tests, linters, compiler warnings, security checks, or required CI jobs.
- Do not change gameplay behavior unless the failure is directly caused by the current PR's intended gameplay change and the correction is clearly required for compilation or correctness.
- Prefer fixing code over changing toolchain configuration.
- Preserve project formatting and coding conventions.
- Do not commit or push; the workflow handles that.
- If the failure is caused by transient infrastructure, unavailable external services, runner capacity, network download failure, or credentials, make no source changes and explain that in the final response.
- If a safe deterministic fix cannot be made, make no changes and explain what human decision is needed.

After editing, run the narrowest practical local check available for the changed files. Summarize the root cause, files changed, and checks run.
