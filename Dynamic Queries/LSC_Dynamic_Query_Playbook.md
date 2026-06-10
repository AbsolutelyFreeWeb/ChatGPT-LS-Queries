# LS Central Dynamic Query Playbook

Version: 1.0
Environment: LS Central 25.2
Purpose: Campaign and Member Segmentation Query Troubleshooting

---

# Overview

This document captures observed behavior of LS Central Dynamic Queries based on source code analysis and live testing.

When query results are unexpected:

1. Verify query correlation (joins).
2. Verify filter type behavior.
3. Verify actual execution results rather than Test Query.
4. Verify implementation in AL source code.

Source code is considered authoritative.

---

# Dynamic Query Execution

Primary procedure:

```al
ProcessQueryLine(MemberContact, QueryId)
```

Observed behavior:

```al
if FilterType = Filter then
    DataField.SetFilter(...)
else
    DataField.SetRange(ParField.Value);
```

Implications:

* Filter Type = Filter receives special handling.
* Filter Type = Field uses SetRange().
* Filter Type = Function does not appear to have dedicated handling.
* Filter Type = DateFormula does not appear to have dedicated handling.

Always verify actual source code in the current version.

---

# Critical Query Correlation Rule

## In Parameter = Account

When:

```text
In Parameter = Account
Table = LSC Member Contact
```

the query MUST include a correlation line linking the Member Contact record to the current Account.

Example:

| Field       | Filter Type | Filter Field |
| ----------- | ----------- | ------------ |
| Account No. | Field       | No.          |

Meaning:

```text
Member Contact.Account No.
=
Account.No.
```

Without this line:

```text
Exists
```

effectively becomes:

```text
Does any record in the entire Member Contact table match?
```

Result:

* Most accounts are returned.
* Filters appear ineffective.
* Query behavior becomes misleading.

---

# Symptoms of Missing Correlation

Example:

| Query Line      |
| --------------- |
| DOB <= 21 years |

Result:

* Every account returned.

Reason:

The query is evaluating the entire Member Contact table rather than contacts belonging to the current account.

---

# Date Filtering

Date fields use:

```al
ProcessDateFilter()
```

before SetFilter() is applied.

---

# Supported Date Inputs

Observed in source code:

## Literal Date

```text
06/06/2005
```

---

## Date Range

```text
01/01/2000..12/31/2000
```

---

## Relative Date Formula

```text
-1D
-30D
-1M
-1Y
-21Y
```

---

## TODAY

```text
TODAY
```

---

# Age Filtering

Recommended pattern:

| Field         | Filter Type | Value  |
| ------------- | ----------- | ------ |
| Account No.   | Field       | No.    |
| Date of Birth | Filter      | ..-21Y |

Meaning:

```text
DOB <= Today - 21 Years
```

---

# DateFormula Filter Type

Observed behavior:

Using:

```text
Filter Type = DateFormula
```

caused runtime errors:

```text
Unable to convert from
Microsoft.Dynamics.Nav.Runtime.NavBigInteger
to System.DateTime
```

Observed on:

* Date fields
* DateTime fields

Current conclusion:

DateFormula filter type may not be implemented correctly in LS Central 25.2 Dynamic Queries.

Recommended workaround:

Use:

```text
Filter Type = Filter
```

with date formulas in the filter value.

Example:

```text
..-21Y
```

---

# Function Filter Type

Observed behavior:

```text
TODAY
```

accepted in the UI but produced runtime errors.

Current conclusion:

Function filter type may not be implemented correctly for date filtering in LS Central 25.2.

Recommended workaround:

Use Filter Type = Filter.

---

# Test Query vs Actual Execution

Observed:

Test Query results differed from actual campaign execution.

Recommendation:

Never rely solely on:

```text
Test Query
```

Always validate by executing the actual campaign selection.

---

# Troubleshooting Workflow

When a query does not behave as expected:

## Step 1

Identify:

```text
In Parameter
```

and

```text
Table
```

---

## Step 2

Verify correlation lines exist.

Typical examples:

```text
Account No. ↔ No.
```

```text
Contact No. ↔ Contact No.
```

---

## Step 3

Review all query lines.

Pay special attention to:

* Field filters
* Date filters
* Field-to-field filters

---

## Step 4

Review source code.

Search for:

```al
SetFilter
SetRange
ProcessDateFilter
FieldRef
RecordRef
```

---

## Step 5

Validate using actual campaign execution.

Do not trust Test Query alone.

---



---

# Future Investigation Topics

* Multiple contacts per account behavior
* Exists vs Count execution differences
* Campaign scheduler execution path
* Dynamic Query performance on large datasets
* Query behavior with FlowFields
* Query behavior with temporary tables

---


