# Task Spec Format

Tasks live in `.tasks/ready/` as individual markdown files.
Filename: `ID-short-slug.md` where ID is the unique integer assigned at creation (e.g., `7-user-auth.md`).

The ID is permanent — it stays with the task as it moves between directories.
New IDs are only created when splitting a task into subtasks or merging tasks.

## Template

```markdown
---
id: 7
title: Short descriptive title
tags: [feature]
priority: high
created: YYYY-MM-DD
depends_on: []
split_from: null
branch: ""
---

## Summary

One paragraph. What this feature does and why. A developer should understand
the scope by reading only this section.

## Detailed Description

Full specification. Behavior, edge cases, business rules.
Use subsections if complex.

### Sub-behavior (if needed)

Details.

## Approach

Recommended implementation path. Informed by research.
Include relevant files to modify/create.
Note any library choices or patterns to follow.

### Files

- `path/to/file.rb` - what to change
- `path/to/new_file.rb` - create this

## UI/UX

_Skip this section if no UI changes._

ASCII mockup inline:
```
+------------------+
| Header           |
+------------------+
| Content here     |
+------------------+
```

For image mockups: `See .tasks/assets/ID-mockup-name.png`

Note responsive behavior if applicable.

## Testing Strategy

How the implementing agent proves this works.

### Unit Tests
- What to test, expected behavior

### Integration Tests
- Controller/API tests with Given/When/Then

### System Tests (if needed)
- End-to-end flows

### Manual Verification (if needed)
- Steps for human click-testing
- When to use: visual correctness, complex interactions, things automated tests can't capture

## Acceptance Criteria

Checklist of done conditions:
- [ ] Criterion 1
- [ ] Criterion 2

## Session Log

_Agents append context here as they work. This persists across sessions._

Entries should include:
- Discoveries that affect implementation
- Decisions made and why
- Blockers encountered and how they were resolved
- Any deviation from the original spec and the reason
```

## Guidelines

- **Summary must stand alone.** Reader should understand scope from summary only.
- **Testing strategy is mandatory.** Every task must tell the agent how to verify.
- **Be specific in tests.** Not "test that it works" but "POST /users with valid params returns 201 and creates record."
- **Size check.** If acceptance criteria exceed 10 items, the task is too big. Split it.
- **IDs are permanent.** The integer ID assigned at creation stays with the task forever. It does not change when moving between directories. New IDs are only generated when splitting or merging.
- **Dependencies.** Use `depends_on: [7]` in frontmatter. List task IDs (integers).
- **Split tracking.** When a task is split, each subtask gets a new ID and records `split_from: PARENT_ID`. When tasks are merged, the new task records `merged_from: [ID, ID]`.
- **Branch.** If work has started, record the branch name in `branch:` frontmatter.
- **Session log.** Agents must append important context as they work — this is how knowledge persists across sessions.
