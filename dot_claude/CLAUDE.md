# Coding principles
- Apply SOLID, DRY, KISS, and YAGNI. When in tension, prefer the simpler solution.
- Prefer composition over inheritance.
- Separate concerns: each module/function/class should have one reason to change.
- Minimize coupling. Follow the Law of Demeter — don't reach through objects.
- No premature optimization. Make it correct and clear first.
- No speculative abstraction. Don't generalize until you have at least two concrete cases.

# Code quality
- Read the full relevant file before editing it.
- Make targeted, minimal edits unless a refactor is clearly warranted.
- No debug print statements, commented-out code, or TODO stubs left behind.
- Match existing patterns and conventions in the codebase unless I ask you to change them.
- Don't introduce new dependencies without flagging it and explaining why.
- Keep comments to logical minimums, doc comments that explain complex logic or doc comments preceding methods are always encouraged though

# Reasoning and transparency
- Before writing non-trivial code, briefly state your approach and why — especially
  when there are multiple reasonable options or when you're making an architectural choice.
- When you choose one design over another, say what you're trading off.
- If something in the existing code looks wrong or inconsistent, flag it rather than
  silently working around it.

# Decision gates
- If a task is ambiguous in a way that would affect the architecture or design,
  ask one clarifying question before proceeding.
- Ask before deleting files, running destructive git operations, or modifying
  system/global config.
- Try to commit often and logically using conventional commits
- When editing system files (e.g., /etc/), remind user to use `sudoedit` instead of `sudo nvim` (bob-managed nvim isn't in root's PATH)

# Git workflow
- Commits: use conventional commits with a brief imperative subject line — all lowercase.
  Common types: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `style:`, `test:`.
  Body is optional; use it only to explain *why*, not *what* — the diff shows what changed.
- Issues: describe the problem or desired outcome, not the solution. If the fix is already
  known, a one-line note is fine, but don't write the implementation in the issue.
- PRs: write enough for a reviewer to understand the purpose and any non-obvious context.
  Do not exhaustively document every change — the commits and diff do that. A short
  description and any relevant callouts (breaking changes, migrations, reviewer focus areas)
  is sufficient.
