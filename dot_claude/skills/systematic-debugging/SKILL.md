---
name: systematic-debugging
description: Use when facing any bug, test failure, crash, or unexpected behaviour -- before proposing or applying a fix
---

# Systematic debugging

The failure mode this prevents: pattern-matching a plausible cause, changing
code, and declaring victory without ever confirming the mechanism.

## Order of operations

**1. Reproduce it.**
Get a command that fails reliably. If it's intermittent, say so explicitly and
establish a failure rate. No reproduction means no diagnosis -- stop and say that
rather than guessing.

**2. Read the actual error.**
Full stack trace, full log line, exit code. Not the summary. The real cause is
frequently stated verbatim in output that got skimmed.

**3. Find the mechanism before touching anything.**
Write down the causal chain: input -> the specific line -> wrong output. If you
can't name the line, keep reading. Add instrumentation rather than speculating.

**4. State the hypothesis, then test it.**
A hypothesis predicts something observable. Confirm the prediction _before_
writing the fix. If the prediction fails, the hypothesis was wrong -- go back to 3
instead of adjusting the fix until symptoms disappear.

**5. Fix the cause, not the symptom.**
Fixes that only make the symptom go away -- widened timeouts, added retries,
swallowed exceptions, loosened assertions -- are not fixes unless the mechanism
genuinely is timing or flakiness, and you have shown that.

**6. Verify.**
Run the reproduction from step 1 and show its output. Then check you haven't
broken the neighbours.

## Anti-patterns

| Thought                               | What it actually means                         |
| ------------------------------------- | ---------------------------------------------- |
| "Probably a race, let me add a sleep" | You don't have a mechanism yet                 |
| "Let me just try changing this"       | Shotgun debugging -- stop, go to step 3        |
| "The test is flaky"                   | Unproven until measured                        |
| "That warning is unrelated"           | Verify it, don't assume it                     |
| "Fixed!" (no run)                     | Nothing is fixed until the reproduction passes |

## Reporting

Report the mechanism, the fix, and the verification output. If you never found
the mechanism, say so plainly -- a fix without one is a guess, and I need to know
that it's a guess.
