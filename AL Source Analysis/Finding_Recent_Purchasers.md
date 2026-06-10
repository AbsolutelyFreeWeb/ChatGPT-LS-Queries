# Finding

## Summary

A campaign for "members (accounts OR contacts) who purchased something in the last
week, optionally of a specific product" CAN be built with a native single-table
Dynamic Query.

Unlike the active-login case (see Finding_Member_Contacts_With_Active_Logins.md),
no multi-hop join is required: "LSC Member Sales Entry" carries BOTH the
correlation fields (Member Account No., Member Contact No.) AND every attribute we
filter on (Date, Item No., etc.) in the same table. It is a one-hop correlation,
so ProcessQueryLine can express it directly.

Target table : LSC Member Sales Entry (99009034)
Result Type  : Exists
Condition    : "="
Compare Value: Yes

Grain is chosen via In Parameter:
- In Parameter = Account -> "this account bought" (every contact on the account
  inherits the same truth value; over-selects on family/company accounts).
- In Parameter = Contact -> "this specific person bought" (correct grain for
  family/company accounts). Every sales entry carries both an account and a
  contact, so neither grain misses purchases; Contact is simply the finer cut.

## Version

LS Central: 25.2

## Source

Procedure: ProcessQueryLine (single-query evaluation), ProcessDateFilter (date
filter normalization)

Table: LSC Member Sales Entry (99009034); In Parameter records LSC Member Account
(99009001) / LSC Member Contact (99009002)

Codeunit: Campaign Dynamic Query evaluation

## Evidence

ProcessQueryLine opens one target table and, for each query line, either applies a
literal filter (Filter Type = Filter) or correlates a target field to a field on
the In Parameter record (Filter Type = Field):

```al
DataRecRef.Open(DynamicQuery."Table ID");
...
if DynamicQueryLine."Filter Type" = DynamicQueryLine."Filter Type"::Filter then begin
    if FieldRec.Type = FieldRec.Type::Date then
        DataField.SetFilter(ProcessDateFilter(DynamicQueryLine."Filter Value"))
    else
        DataField.SetFilter(DynamicQueryLine."Filter Value");
end
else begin
    ParField := ParRecRef.Field(DynamicQueryLine."Filter Field No.");
    DataField.SetRange(ParField.Value);   // correlation: target field = parameter field
end;
```

Relevant fields on LSC Member Sales Entry (confirmed from table source):

```
f5  Member Account No.   Code[20]   -> correlate to Account."No." / Contact."Account No."
f6  Member Contact No.   Code[20]   -> correlate to Contact."Contact No."
f18 Date                 Date       -> rolling window via ProcessDateFilter
f20 Item No.             Code[20]   -> product (specific SKU)
f21 Item Variant Code    Code[10]   -> product variant
f25 Item Category Code   Code[20]   -> product category
f30 Retail Product Code  Code[20]   -> retail product group
f2  Source Type          Option     'POS Transaction,Sales Invoice,,Credit Memo'
f10 Quantity             Decimal
f13 Gross Amount         Decimal
```

Supporting keys (performance):

```
Key2: Member Account No., Date, Item Category Code, Retail Product Code  (SIFT)
Key6: Member Account No., Member Contact No., Date                       (SIFT)
```

Sign convention (sales stored as negatives):

The Total Sales FlowFields on both Member Account (f63) and Member Contact (f63)
compute the amount as a NEGATED sum:

```al
CalcFormula = - Sum("LSC Member Sales Entry"."Gross Amount" WHERE(...));
```

The leading minus implies Gross Amount (and, per production observation, Quantity)
is stored NEGATIVE for normal sales and POSITIVE for returns/credits. This inverts
the intuitive purchase guard.

## Observed Behavior

A single Exists query on Member Sales Entry, correlated to the parameter record and
filtered on Date (and optionally a product field), correctly returns members with a
qualifying purchase in the window. Dropping the Field-type correlation lines makes
Exists evaluate the entire Member Sales Entry table globally (same failure mode as
the missing-correlation case in the playbook / Investigation_Log).

## Query Definition

### Variant A - In Parameter = Account

| Field (Member Sales Entry) | Filter Type | Filter Field / Value          |
|----------------------------|-------------|-------------------------------|
| Member Account No. (f5)    | Field       | No.  (Account f1)             |
| Date (f18)                 | Filter      | -7D..TODAY                    |
| Item No. (f20)             | Filter      | <item>  (optional, e.g. 1000) |

### Variant B - In Parameter = Contact

| Field (Member Sales Entry) | Filter Type | Filter Field / Value           |
|----------------------------|-------------|--------------------------------|
| Member Account No. (f5)    | Field       | Account No.  (Contact f1)      |
| Member Contact No. (f6)    | Field       | Contact No.  (Contact f5)      |
| Date (f18)                 | Filter      | -7D..TODAY                     |
| Item No. (f20)             | Filter      | <item>  (optional, e.g. 1000)  |

The Field-type lines are the MANDATORY correlation. The product line is Filter
Type = Filter (literal compared against the row), supporting one item (1000),
several (1000|2000), or a range (1000..1999). To target a broader product grain,
swap Item No. for Item Category Code (f25) or Retail Product Code (f30).

### Date filter

-7D..TODAY is a rolling 7-day window. Traced through ProcessDateFilter: "-7D"
evaluates as a DateFormula -> CalcDate(-7D, Today); "TODAY" -> Format(Today);
producing "<date>..<today>". This is the Filter Type = Filter workaround (DQ-001);
do NOT use Filter Type = DateFormula. For the prior CALENDAR week rather than a
rolling 7 days, use a different value (e.g. -CW..-CW or an explicit range).

### Genuine purchases vs returns

Because sales are stored negative, the guard is INVERTED from intuition:

- Purchases only : Quantity (f10) Filter = <0   (or Gross Amount (f13) Filter = <0)
- Returns only   : Quantity (f10) Filter = >0
- Either         : omit the guard

Alternatively constrain Source Type (f2): Filter = POS Transaction|Sales Invoice
excludes Credit Memo, but does NOT exclude negative-quantity return LINES inside a
POS transaction, so the Quantity/amount sign guard is the more reliable filter.

## Impact

Recent-purchaser segmentation - including by product - is achievable natively with
no customization, in contrast to login/card-of-card segmentation. This is the
single-hop counter-example to the multi-hop limitation finding.

## Workaround

None required (native query). For a one-off list instead of a maintained campaign,
a processing-only report or codeunit can walk the table directly.

## Status
Confirmed (single-table query is expressible; field numbers, correlation mechanics,
and ProcessDateFilter behavior verified against table + procedure source)
Confirmed (sales-negative sign convention - corroborated by the negated Total Sales
CalcFormula in source and by production observation of Quantity)
Suspected (exact boolean rendering of Compare Value "Yes" for Exists, and whether
Source Type alone vs Quantity sign best isolates purchases - pending live
validation, NOT Test Query)