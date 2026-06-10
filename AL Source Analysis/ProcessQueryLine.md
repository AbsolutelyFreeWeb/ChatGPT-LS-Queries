# ProcessQueryLine

## Location

Campaign Dynamic Query evaluation.

## Purpose

Evaluates whether a record satisfies a Dynamic Query.

## Important Findings

### Filter Type Handling

Observed:

```al
if FilterType = Filter then
    SetFilter(...)
else
    SetRange(...)
```

Implications:

Filter handled specially.
Field handled via SetRange.
Function appears unimplemented.
DateFormula appears unimplemented.
Correlation Requirement

When:

In Parameter = Account

and

Table = Member Contact

a correlation line must exist:

Member Contact.Account No.

Account.No.

Without correlation:

Exists queries become global table searches.

Test Query

Observed behavior differs from actual execution.

Always validate using actual campaign execution.

### Dateformula broken

DateFormula filter type appears broken in LS Central 25.2.

Source: ProcessQueryLine()

Only Filter type is explicitly handled.

```al
if DynamicQueryLine."Filter Type" = DynamicQueryLine."Filter Type"::Filter then
    ...
else
    DataField.SetRange(ParField.Value);
```

Observed Runtime Error

Unable to convert from
Microsoft.Dynamics.Nav.Runtime.NavBigInteger
to System.DateTime

Workaround

Use Filter Type = Filter and Filter Value = ..-21Y




