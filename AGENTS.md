# FlowState agent rules

These rules apply to all implementation work in this project.

- At the start of each task, read `Agents/TASKS.md`, `Agents/README.md`, the relevant implementation-plan sections and existing architecture decisions.
- Follow the full checklist and its dependencies. Select an unfinished item, state its scope, and preserve prior work and completion marks. Do not silently drop features or replace the full checklist with a smaller one.
- Before every implementation, check and query Graphify for affected modules, file relationships and requirements; read the actual referenced source files. If the graph is missing or stale, use the Graphify skill to build or refresh it first.
- After every implementation, update Graphify for changed code, documents, schema and configuration; refresh its report and visualization, verify a relevant query, and record the evidence. A code-only update does not cover changed planning documents.
- Mark the corresponding checklist item `[x]` only after its entire scope, acceptance criteria, appropriate verification and Graphify refresh succeed. Record changed files, verification, graph evidence and date in `Agents/COMPLETION_LOG.md`.
- Leave partial, deferred and blocked items `[ ]` with a clear status note. Do not mark a whole phase complete because its scaffold exists. Keep completion state solely in `Agents/TASKS.md`.
- If a required input, provider setup, tool failure or unknown reference behavior blocks the selected work, stop and ask the user before continuing dependent work. Do not infer answers to pending decisions.
- Preserve the native SwiftUI/AppKit architecture, single timer coordinator, isolated persistence and real-time audio constraints. Authentication and cloud sync are separate concerns.
- Never commit or index credentials, tokens, private keys, real user history, browser/activity data, or local environment files. Follow `docs/AUTHENTICATION.md` for public configuration and provider setup.

Detailed always-applied equivalents are in `.cursor/rules/`. User instructions take precedence.
