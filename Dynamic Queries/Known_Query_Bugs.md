# Known Query Bugs

## DQ-001

### Title

DateFormula Filter Type Runtime Failure

### Version

25.2

### Symptoms

Runtime error:

Unable to convert from Microsoft.Dynamics.Nav.Runtime.NavBigInteger to System.DateTime

### Reproduction

Use:

Filter Type = DateFormula

on Date field.

### Workaround

Use:

Filter Type = Filter

with date formula in filter value.

Example:

..-21Y

### Status

Confirmed


