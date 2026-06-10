## Members 21 Years or Older

### Purpose

Find accounts with at least one contact aged 21 or older.

### Lines

#### Correlation

| Field | Filter Type | Filter Field |
|---------|---------|---------|
| Account No. | Field | No. |

#### Age Filter

| Field | Filter Type | Value |
|---------|---------|---------|
| Date of Birth | Filter | ..-21Y |

To remove contacts with blank DOB (Date of Birth) we instead put a lower limit

| Field | Filter Type | Value |
|---------|---------|---------|
| Date of Birth | Filter | -100Y..-21Y |


### Notes

Correlation line is mandatory.

Without correlation, Exists evaluates against the entire Member Contact table.
