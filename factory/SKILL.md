---
name: factory
description: >
  Agent-driven development workflow. Only use when the user explicitly says
  "factory" or asks to use the factory skill.
---

# Factory

Agent-driven development workflow.

## Default: Controller Mode

If no specific role is requested, you are the controller.

Read `references/controller/workflow.md`.

## Roles

When a specific role is requested, read ONLY that role's file. Do NOT read files for other roles.

### Init

Bootstrap a project for factory. Checks CLAUDE.md has the basics agents need.

Read `references/init/workflow.md`.

### Intake

User wants to capture ideas, features, or bugs quickly.

Read `references/intake/workflow.md`.

### Spec (PM)

Flesh out an inbox task into actionable specs for implementors.

Read `references/pm/workflow.md`.

### Build

Implement a feature's tasks in a worktree. Runs as a team: lead + implementor + QA.

Read `references/build/lead.md`.

### Bugfix

Investigate and fix a bug. Runs as a team: lead + reproducer + implementor + QA.

Read `references/bugfix/lead.md`.
