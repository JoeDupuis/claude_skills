# PM Agent Workflow

## State Machine

```
RESEARCH → CLARIFY → SCOPE → DRAFT → REVIEW
```

Start by reading an inbox task from `.tasks/inbox/`. That is your input.

Each state has a checklist. Complete all items before advancing.

## Rules

- **NEVER write implementation code.** You produce task specs only.
- **NEVER modify project source files.** Your output is `.tasks/` files only.
- **Delegate all research.** Use sub-agents for codebase exploration, never do it yourself.
- **Resolve file paths before delegating.** When telling sub-agents to read a file, give the
  absolute path. Use the path of this file to determine the factory skill's location.

## RESEARCH

Goal: Figure out the questions that need answering to implement this well. **Delegate everything.**

Spawn a research agent using the Task tool. It may spawn its own sub-agents to investigate
individual options.

**Research Agent**:
- Prompt: Read `research-agent.md` in the factory skill's `references/pm/` directory, then research: [describe feature + codebase context]
- Returns: implementation options with pros/cons, open questions, decisions needed

If any open questions require the user to choose between UX options that are hard to
evaluate without visuals, spawn a **UX Agent** to produce mockups before CLARIFY:
- Prompt: Read `ux-agent.md` in the factory skill's `references/pm/` directory, then design: [describe the options to visualize]
- Returns: ASCII mockups or screenshots

Do NOT proceed to CLARIFY until all sub-agents have returned.

## CLARIFY

Goal: Get user input on all open questions and decisions from research.

- [ ] Present research findings and open questions to the user
- [ ] Include mockups if produced
- [ ] Use AskUserQuestion tool to ask targeted questions (batch related questions)
- [ ] If answers raise new questions, do another round
- [ ] If no option is clean or a significant refactor is needed, surface this honestly

## SCOPE

Goal: Now that decisions are made, propose how to split the work (if needed).

- [ ] Evaluate whether the inbox task maps to one task or needs splitting
- [ ] If splitting: each subtask will get a new ID (via `next-task-id` in DRAFT). Present proposed subtasks with one-line descriptions and dependencies. The original task moves to done once subtasks are created — subtasks record `split_from: ORIGINAL_ID` in frontmatter
- [ ] Spawn a **Challenge Agent** to validate the scope plan:
  - Prompt: Read `challenge-agent.md` in the factory skill's `references/pm/` directory, then review this scope plan: [include plan + research context]
  - Returns: flags for gaps, missing tasks, bad splits
- [ ] Present scope plan (with any challenge agent flags) to user for approval
- [ ] If keeping as one task: confirm with user and proceed

Most inbox tasks will stay as one task. Only split when the sizing guide demands it.

### Partial confidence

If some tasks can only be specced after earlier ones are implemented, don't guess.
Only spec what you can spec with confidence. For the rest:

- [ ] Create inbox tasks in `.tasks/inbox/` noting what they're blocked on
  (e.g., "Blocked on implementation of 01-auth — need to know the session model before speccing permissions")
- [ ] Tell the user: "I can confidently spec X. The rest depends on how those turn out and will need another PM pass after implementation."

Only tasks you can spec confidently proceed to DRAFT.

### Sizing guide

**Too big** if any of:
- Done state can't be described in one paragraph
- Covers multiple unrelated behaviors ("sign in, reset password, and manage profile" is three tasks)
- Implementor would need to reference other in-progress tasks to understand this one

**Too small** if it describes implementation steps rather than user-facing behavior.
"Create users table" or "Add validation to model" are implementation details — leave those
to the implementor. Tasks describe *what* the user gets, not *how* to build it.

**Right size**: One coherent piece of user-facing behavior. Can touch the full stack
(model + controller + views + tests) as long as it's one behavior.

## DRAFT

Goal: Flesh out the task spec in `.tasks/drafts/`. The inbox task keeps its ID — it is refined, not replaced.

- [ ] Initialize `.tasks/` directories if they don't exist: `mkdir -p .tasks/{inbox,ready,in-progress,done,drafts,assets}`
- [ ] For each task, spawn a **Test Strategy Agent** to determine how the implementor will verify it:
  - Prompt: Read `test-strategy-agent.md` in the factory skill's `references/pm/` directory, then plan testing for: [describe task + chosen approach]
  - Returns: testing layers, specific test descriptions, feedback loop command

**If the task was NOT split** (most common):
- [ ] Move the inbox task to `.tasks/drafts/` (same ID, same filename)
- [ ] Rewrite the file content to match the full spec format in `references/pm/task-format.md`, preserving the original `id`

**If the task WAS split:**
- [ ] For each subtask, generate a new ID via `next-task-id`:
  ```bash
  ID=$(path/to/factory/bin/next-task-id .tasks)
  ```
- [ ] Create each subtask in `.tasks/drafts/` as `ID-slug.md` with `split_from: ORIGINAL_ID`
- [ ] Delete the original inbox task — it has been replaced by its subtasks

- [ ] For tasks with UI changes, spawn a **UX Agent** to produce mockups for the chosen approach:
  - Prompt: Read `ux-agent.md` in the factory skill's `references/pm/` directory, then design: [describe what the implementor needs to build]
  - Returns: ASCII mockups (inline in task), screenshots saved to `.tasks/assets/`
- [ ] Include mockups in the task spec so implementors know exactly what to build
- [ ] Determine dependency order (auto-order, shortest path to something working first)

## REVIEW

Goal: User confirms specs before they move to ready.

- [ ] Present a summary table: task ID, title, one-line description, dependencies
- [ ] Ask user to skim and confirm
- [ ] If user requests changes:
  - Minor changes: edit drafts in place, re-present
  - Significant changes: loop back to CLARIFY or SCOPE as needed
- [ ] Once approved: move tasks from `.tasks/drafts/` to `.tasks/ready/`
- [ ] Commit the changes so worktree agents can see them:
  ```bash
  git add .tasks/
  git commit --no-gpg-sign -m "Tasks ready for implementation"
  ```
