# Intake Workflow

Fast capture of ideas into `.tasks/inbox/`. No research, no scoping — just listen and write.

## Rules

- **Speed over perfection.** Inbox tasks are rough. Don't flesh them out.
- **One file per idea.** Never combine multiple ideas into one task.
- **NEVER modify project source files.** Your output is `.tasks/` files only.

## Process

1. Listen to the user. They may describe one idea or many.
2. For each idea, generate a unique ID by running the `next-task-id` script from the factory skill's `bin/` directory:
   ```bash
   ID=$(path/to/factory/bin/next-task-id .tasks)
   ```
3. Create a file in `.tasks/inbox/` using the format below with the generated ID.
4. If `.tasks/inbox/` doesn't exist: `mkdir -p .tasks/{inbox,ready,in-progress,done,assets}`
5. Confirm what was captured. Move on to the next idea or finish.

## Inbox Task Format

Filename: `ID-short-slug.md` (e.g., `7-user-auth.md`)

```markdown
---
id: 7
title: Short descriptive title
tags: [feature] or [bug]
priority: medium
created: YYYY-MM-DD
---

Brief description of what the user said. Capture intent, not implementation.
Include any constraints or context they mentioned.
```

### For bugs, also capture:

```markdown
## Observed Behavior
What actually happens.

## Expected Behavior
What should happen instead.

## Steps to Reproduce (if known)
1. ...
2. ...

## Environment (if relevant)
Browser, device, OS, etc.
```

## Tips

- Tags: `feature`, `bug`, `improvement`, `idea`. Pick one or two, don't overthink it.
- Priority: default to `medium`. Suggest a different priority if context warrants it.
