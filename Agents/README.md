# Working on FlowState

This folder coordinates implementation agents. It contains the complete shared checklist, not separate competing task lists per agent.

- [TASKS.md](TASKS.md): authoritative completion status and phase exit gates.
- [COMPLETION_LOG.md](COMPLETION_LOG.md): evidence and handoffs.
- [Project rules](../AGENTS.md): persistent requirements for every agent.
- [Implementation plan](../outputs/IMPLEMENTATION_PLAN.md): architecture, behavior contracts and dependency diagram.
- [Authentication setup](../docs/AUTHENTICATION.md): Supabase inputs and pending account decisions.

## Implementation cycle

1. Read the rules and full checklist; select an unfinished task whose dependencies are satisfied. State the task and inspect existing implementation before editing.
2. Check `graphify-out/graph.json` and freshness against the files relevant to the change. Build a missing graph or refresh a stale one using the installed Graphify skill. Query relevant requirements and dependencies; confirm findings in actual files.
3. Implement a reviewable increment within the existing native architecture. If missing inputs or evidence block it, stop and ask the user; leave the task unchecked with its blocker.
4. Run verification appropriate to the change and its acceptance gate. UI shells, mock success and provider configuration alone do not prove live authentication works.
5. Update Graphify after the implementation, including changed code, documentation, migrations and configuration. Refresh graph/report/HTML and verify a relevant query against the changed scope.
6. Record evidence in the completion log, then mark the satisfied checklist item `[x]`. If only part of an item passed, keep `[ ]` and add the exact partial status. Do not create another copy of checklist state.

## Graphify operations

Use the Graphify skill installed in this environment at `/Users/senukadeneth/.codex/skills/graphify/SKILL.md`. Its instructions are the source of truth for the extraction pipeline. On another workstation discover the installed skill instead of relying on this machine's path.

Skill invocations (agent workflow, **not shell commands**):

```text
/graphify .
/graphify . --update
```

From the project root, query an existing graph with the installed CLI:

```sh
graphify query "What modules and requirements are affected by authentication?" --graph graphify-out/graph.json
```

Check the installed CLI's help before using additional flags. Its code-only incremental command does not refresh semantic relationships for edited plans/documents; use the skill's full incremental pipeline for those changes. Keep generated outputs and provenance under `graphify-out/`. Record the changed input files and an actual successful query; modification timestamps alone do not prove completeness.

Exclude `.env*`, private keys, credentials, tokens, user databases/history, activity/browser data, `.build/`, `.swiftpm/`, `DerivedData/`, `work/`, user-specific Xcode data and Graphify-generated outputs from source extraction. Include `.env.example` only while it contains placeholders/public field names. Review included files before semantic extraction.

**Current state (2 October 2026):** Graphify is installed; `graphify-out/graph.json` does not exist in this renamed project. Building and verifying the initial graph remains an unchecked setup task before the next application implementation. No graph refresh or new application implementation is claimed by this planning/rules update.

## Evidence format

For each finished task record date, checklist item, changed files, acceptance checks and outcomes, pre-implementation Graphify query, post-implementation refresh/query and any limitations. Existing completion marks are imported from the prior plan; refer to the original verification rather than inventing historic graph checks.
