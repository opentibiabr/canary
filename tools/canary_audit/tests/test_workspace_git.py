from __future__ import annotations

import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.canary_audit.workspace import (
	GIT_COMMAND_TIMEOUT_SECONDS,
	WorkspaceError,
	_git_file_names,
	discover_files,
	git_dirty,
	git_revision,
	relative_outputs,
	safe_relative_directory,
	safe_relative_path,
)


class WorkspaceGitTests(unittest.TestCase):
	def test_invalid_utf8_from_git_falls_back_to_workspace_walk(self) -> None:
		with tempfile.TemporaryDirectory() as temporary:
			root = Path(temporary)
			(root / "from-walk.lua").write_text("return true", encoding="utf-8")
			result = subprocess.CompletedProcess(
				args=["git", "ls-files"],
				returncode=0,
				stdout=b"invalid-\xff.lua\0",
			)

			with patch("tools.canary_audit.workspace.subprocess.run", return_value=result):
				files = discover_files(root, frozenset(), prefer_git=True)

			self.assertEqual([item.path for item in files], ["from-walk.lua"])

	def test_git_commands_use_bounded_timeouts(self) -> None:
		results = (
			subprocess.CompletedProcess(args=[], returncode=0, stdout=b"tracked.lua\0"),
			subprocess.CompletedProcess(args=[], returncode=0, stdout="revision\n"),
			subprocess.CompletedProcess(args=[], returncode=0, stdout=""),
		)
		with patch("tools.canary_audit.workspace.subprocess.run", side_effect=results) as run:
			self.assertEqual(_git_file_names(Path.cwd()), ["tracked.lua"])
			self.assertEqual(git_revision(Path.cwd()), "revision")
			self.assertFalse(git_dirty(Path.cwd()))

		self.assertEqual(len(run.call_args_list), 3)
		for call in run.call_args_list:
			self.assertEqual(call.kwargs["timeout"], GIT_COMMAND_TIMEOUT_SECONDS)

	def test_git_command_timeouts_return_unavailable_metadata(self) -> None:
		timeout = subprocess.TimeoutExpired(cmd="git", timeout=GIT_COMMAND_TIMEOUT_SECONDS)
		with patch("tools.canary_audit.workspace.subprocess.run", side_effect=timeout):
			self.assertIsNone(_git_file_names(Path.cwd()))
			self.assertIsNone(git_revision(Path.cwd()))
			self.assertIsNone(git_dirty(Path.cwd()))


class WorkspacePathNormalizationTests(unittest.TestCase):
	def test_safe_relative_path_rejects_non_utf8_names(self) -> None:
		with self.assertRaisesRegex(WorkspaceError, "valid UTF-8"):
			safe_relative_path("invalid-\udcff.lua")

	def test_relative_directory_accepts_trailing_separators(self) -> None:
		self.assertEqual(safe_relative_directory("artifacts/audit///"), "artifacts/audit")
		self.assertEqual(
			relative_outputs("artifacts/audit/", ("report.json", "summary.txt")),
			("artifacts/audit/report.json", "artifacts/audit/summary.txt"),
		)

	def test_relative_directory_still_rejects_unsafe_paths(self) -> None:
		for value in ("", "/", "../", "/absolute/", "artifacts//audit/", "artifacts\\audit\\"):
			with self.subTest(value=value), self.assertRaises(WorkspaceError):
				safe_relative_directory(value)


if __name__ == "__main__":
	unittest.main()
