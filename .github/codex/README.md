# Codex Issue Bot

This repository includes an admin-gated Codex workflow at `.github/workflows/codex-issue-fix.yml`.

## Setup

Create a GitHub environment named `codex-issue-bot` and store `OPENAI_API_KEY` as an environment secret there. Configure the environment with required reviewers from repository administrators if you want an additional manual approval gate before the key can be used.

The workflow also works with a repository secret named `OPENAI_API_KEY`, but an environment secret with required reviewers is safer.

## Usage

Repository administrators can run the workflow manually from GitHub Actions with an issue number.

Repository administrators can also comment this exact command at the start of an issue comment:

```text
/codex fix
```

The comment trigger only works for repository administrators. Users without `admin` permission can trigger the cheap authorization job, but the Codex job is skipped and the OpenAI key is not exposed to that run.

## Security Controls

- The workflow never runs on `pull_request` or `issues.opened`.
- The OpenAI key is only referenced in the Codex job after an explicit repository permission check returns `admin`.
- The Codex job uses the `codex-issue-bot` environment, so GitHub environment protection rules can add a second approval layer.
- The Codex Action runs with `safety-strategy: drop-sudo` and `sandbox: workspace-write`.
- The prompt treats issue text and comments as untrusted input.
- The publish step blocks generated changes under `.github/**`.
- Generated PRs are drafts by default.
- Branches are created as `codex/issue-<number>-<run>`.

Cost control still depends on the OpenAI project budget. Use a dedicated API key for this bot and set a low monthly budget and usage alerts in the OpenAI dashboard.
