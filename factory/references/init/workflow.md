# Init Workflow

Check that a project is ready for factory agents to work in. This is a one-time bootstrap.

## What agents need to work

Agents need to know how to do basic things without guessing. This information should live
in the project's `CLAUDE.md`.

### Required in CLAUDE.md

Check for each of these. If missing, ask the user and add them:

- [ ] **How to run tests** — the command, how to run a single file, how to run a single test
- [ ] **How to start the dev server** — the command, any setup steps (db, seeds, env vars)
- [ ] **How to lint** — the command, fix mode flag
- [ ] **How to build** (if applicable) — the command

### Optional but recommended

Suggest these to the user if not present:

- [ ] **Code conventions** — suggest putting these in `.claude/rules/` if the project has style preferences beyond what a linter catches
- [ ] **Architecture notes** — key directories, where things live, patterns used
- [ ] **External dependencies** — services the app depends on, how to run them locally

## Process

1. Read the project's `CLAUDE.md` (create if it doesn't exist)
2. Check each required item
3. For anything missing, explore the project to propose an answer (check package.json, Makefile, bin/, etc.)
4. Present findings to the user: what's already covered, what's missing, proposed additions
5. Apply changes the user approves
6. Initialize `.tasks/` directories if they don't exist:
   - Create directories: `mkdir -p .tasks/{inbox,ready,in-progress,done,drafts,assets}`
   - Initialize the task ID counter: `echo 0 > .tasks/.counter`
   - Add `.keep` files so git tracks empty directories: `for dir in .tasks/{inbox,ready,in-progress,done,drafts,assets}; do touch "$dir/.keep"; done`
   - Commit the `.tasks/` directory structure (including `.counter`)
