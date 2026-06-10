## 2026-06-09

Issue:
Member Campaign age filter returned all accounts.

Root Cause:
Missing Account No. correlation line.

Evidence:
ProcessQueryLine uses Exists against Member Contact table.

Resolution:
Added:

Account No.
Filter Type = Field
Filter Field No. = No.

Status:
Resolved