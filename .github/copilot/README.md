# Copilot Issue Agent

This repository is configured for GitHub Copilot cloud agent. It does not require an OpenAI API key.

## Manual Usage

Repository administrators with GitHub Copilot access can assign an issue to Copilot from the issue sidebar:

1. Open the issue.
2. Choose `Assignees`.
3. Select `Copilot`.
4. Use `main` as the base branch unless a maintainer wants another branch.
5. Select the `canary-bugfix` agent when available.
6. Add focused instructions for the bug.

For issue #3552, use:

```text
Fix the highscore pagination bug introduced after PR #3222. Keep the change focused and add or update tests if practical.
```

## Slash Command

After `.github/workflows/copilot-issue-fix.yml` is on the default branch, repository administrators can comment this exact command at the start of an issue comment:

```text
/copilot fix
```

Optional extra instructions can be added below the command in the same comment.

The workflow checks that both the actor and triggering actor have repository `admin` permission before attempting to assign Copilot. It uses GitHub credentials only and does not use OpenAI API secrets.

If GitHub does not allow the default Actions token to assign Copilot in this repository, keep using the manual assignment flow above. A maintainer can later add a narrowly scoped GitHub token as `COPILOT_ASSIGN_TOKEN`, but that is optional and should only be done if the slash command is worth the additional credential management.
