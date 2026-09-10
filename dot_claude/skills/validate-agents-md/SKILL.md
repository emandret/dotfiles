---
name: validate-agents-md
description: Use when reviewing, auditing, or validating an existing AGENTS.md file for quality, accuracy, and drift risk
---

# Validate AGENTS.md

## Overview

Audit an AGENTS.md file against quality principles. Find what's wrong, what's drifted, what's redundant, and what's missing.

## When to Use

- Reviewing an existing AGENTS.md for quality
- After a codebase has changed and AGENTS.md may be stale
- Before approving a PR that modifies AGENTS.md

## Validation Checklist

### 1. Section coverage

The 7 expected sections are:

| Section                  | Purpose                                                                                                                                                               |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Architecture**         | High-level system design -- how components fit together. Diagrams (e.g. mermaid) welcome. Explains the flow from entry point through to output.                       |
| **Development commands** | Copy-pasteable commands to build, test, run, and validate the project. The "how do I work on this" cheat sheet.                                                       |
| **Code structure**       | Directory tree showing where things live and what each directory/file group does. A map of the repo.                                                                  |
| **Key files**            | The most important files an agent (or human) should read first to understand the codebase. Paths with one-line descriptions.                                          |
| **Key conventions**      | Naming patterns, commit message formats, coding style rules, file naming schemes -- the "how we do things here" that isn't captured by a linter.                      |
| **Testing**              | How to run tests, what testing approach is used, what coverage looks like. If there's no automated suite, say so and describe what exists instead.                    |
| **Agent behaviour**      | Guidance specifically for AI agents -- what to do when adding features, what side effects to watch for, what files to update together, what not to touch. Guardrails. |

At least 4 of 7 must be present. More is better as long as each section earns its place. Sections can be merged (e.g. "Development" covering both commands and testing) or renamed (e.g. "Constraints" instead of "Agent behaviour") -- what matters is the content is covered, not the exact heading names.

Flag: sections that mix unrelated concerns (e.g. branch naming inside code conventions, "never do X" scattered across multiple sections instead of consolidated).

### 2. Drift risk -- duplicated content

For each factual claim, ask: "is this duplicating a source file?"

Common offenders:

- **Enumerated lists** of make targets, linters, pre-commit hooks, env vars -- these belong in their source files (Makefile, .golangci.yaml, .pre-commit-config.yaml, config.go). AGENTS.md should point to the file, not repeat the list.
- **Directory trees** -- acceptable if README doesn't have one, redundant if it does.
- **Specific symbol names** (function names, variable names, file names) -- high drift risk. Prefer "package-level test hooks in `internal/foo/`" over "`testHookBarExists` in `internal/foo/bar.go`".

**Test**: for each list or specific name, ask "if this changes in the code, will someone update AGENTS.md?" If the answer is no, remove it and point to the source.

### 3. Drift risk -- factual errors

Verify claims against the actual codebase:

- Do referenced files/directories actually exist?
- Are described patterns actually used where stated?
- Is the scope correct? (e.g. "Ginkgo in driver/ only" -- is it really only there?)

**Test**: grep/glob for each file path, symbol name, or pattern mentioned. Flag anything that doesn't match reality.

### 4. Inferability

For each item, ask: "could an agent discover this by reading the code?"

**Remove if inferable:**

- Logging library (visible in any import)
- Test framework (visible in test files)
- Build flags (visible in Makefile/Dockerfile)
- Standard patterns (table-driven tests, error wrapping conventions)

**Keep if NOT inferable:**

- Branch/commit/PR naming conventions
- Which branch to target
- External dependencies not in this repo (helm charts, deployment repos)
- "Don't do X" constraints (no kubectl, no real hardware commands)
- Non-obvious patterns that break convention (e.g. functional options instead of direct assignment)
- Internal module dependencies with special GOPRIVATE requirements

### 5. Missing content

Things agents can't infer that are commonly missing:

- Default branch name
- Branch naming convention
- Commit message format
- PR title format
- External repos that relate to this one (charts, deployment, shared libraries)
- Hard constraints (no internet, no live cluster access, no destructive commands)

### 6. README overlap

AGENTS.md should reference README.md for background rather than duplicating it. Check for:

- Architecture descriptions that exist in both files
- Directory structures that exist in both files
- Component descriptions that exist in both files

If both have it, AGENTS.md should either remove it or add agent-specific context the README lacks.

## Output Format

Present findings as:

```
## Section coverage
- X of 7 sections covered: [list]
- Missing: [list]

## Drift risks
- [file:line] what's wrong and why

## Factual errors
- [file:line] claim vs reality

## Redundant (remove or replace with pointer)
- [file:line] what it duplicates

## Missing
- what's missing and why an agent needs it
```

## Common Mistakes

- Validating only structure without checking facts against the codebase
- Suggesting removal of non-inferable content (conventions, constraints)
- Not checking README for overlap
- Being rigid about section names instead of checking content coverage
