"""Validate a release tag and extract its changelog before starting builds."""

import os
from pathlib import Path
import re


def prepare(tag: str, ref_type: str, pubspec: str, changelog: str):
    if ref_type != "tag":
        raise ValueError("Release workflow must run on a tag, not a branch.")
    match = re.fullmatch(r"v?((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))\+([1-9]\d*)", tag)
    if not match:
        raise ValueError("Expected tag X.Y.Z+BUILD or vX.Y.Z+BUILD, e.g. 0.10.0+60.")
    name, number = match.groups()
    version = f"{name}+{number}"
    configured = re.search(r"^version:\s*([^\s#]+)", pubspec, re.MULTILINE)
    if not configured or configured.group(1) != version:
        raise ValueError(f"pubspec.yaml version must be {version}.")
    section = re.search(
        rf"^##? {re.escape(name)}\s*\n(.*?)(?=^##? |\Z)",
        changelog,
        re.MULTILINE | re.DOTALL,
    )
    if not section or not section.group(1).strip():
        raise ValueError(f"CHANGELOG.md must contain a nonempty section for {name}.")
    return {"APP_VERSION": version, "BUILD_NAME": name, "BUILD_NUMBER": number}, section.group(1).strip() + "\n"


if __name__ == "__main__":
    try:
        outputs, notes = prepare(
            os.environ.get("GITHUB_REF_NAME", ""),
            os.environ.get("GITHUB_REF_TYPE", ""),
            Path("pubspec.yaml").read_text(encoding="utf-8"),
            Path("CHANGELOG.md").read_text(encoding="utf-8"),
        )
    except ValueError as error:
        raise SystemExit(str(error)) from error
    Path("release-notes.md").write_text(notes, encoding="utf-8")
    with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
        for key, value in outputs.items():
            print(f"{key}={value}", file=output)
    print(f"Preparing MoeKey {outputs['APP_VERSION']}")
