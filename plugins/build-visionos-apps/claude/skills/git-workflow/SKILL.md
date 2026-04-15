---
name: git-workflow
description: Git workflow and versioning practices for visionOS projects. Atomic commits, never mix formatting with behaviour changes, commit at every green build point. Keep .xcodeproj and .entitlements changes in dedicated commits. Branch naming follows feature/scene-type/description convention.
---

# Git Workflow

## Quick Start

Use this skill when committing, branching, or organizing version control for a
visionOS project.

Use it when:
- you are ready to commit after a successful simulator verification
- you need to decide how to structure commits for a change
- .xcodeproj, .entitlements, or Info.plist files were modified
- you are creating a branch for a new feature or fix
- you need to keep formatting changes separate from behaviour changes

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/commit-conventions.md`](references/commit-conventions.md) | When writing commit messages or deciding commit boundaries. |
| [`references/branch-naming.md`](references/branch-naming.md) | When creating a new branch for a feature or fix. |
| [`references/xcodeproj-management.md`](references/xcodeproj-management.md) | When .xcodeproj changes need to be isolated in their own commit. |
| [`references/entitlements.md`](references/entitlements.md) | When .entitlements or Info.plist changes need dedicated commits. |

## Workflow

1. One logical change per commit.
2. Never mix formatting or whitespace changes with behaviour changes.
3. Commit at every green build point (simulator passes).
4. Keep .xcodeproj changes in dedicated commits.
5. Keep .entitlements and Info.plist changes in dedicated commits.
6. Write commit messages that reference the scene model or component being
   changed.
7. Branch naming: `feature/scene-type/description`
   (e.g., `feature/immersive/hand-tracking-setup`).

## When To Switch Skills

- Switch to `incremental-build` when you need to implement the next slice
  before committing.
- Switch to `debugging-triage` when a build fails after a commit and you need
  to investigate.
- Switch to `adr-spatial` when a commit involves a significant architectural
  decision that should be recorded.

## Guardrails

- Do not mix .xcodeproj changes with source code changes in the same commit.
- Do not mix .entitlements or Info.plist changes with feature code in the same
  commit.
- Do not combine formatting and behaviour changes in the same commit.
- Do not commit code that has not been verified on the simulator.
- Do not use generic commit messages - always reference the scene model,
  component, or system being changed.
- Do not force-push to shared branches.
