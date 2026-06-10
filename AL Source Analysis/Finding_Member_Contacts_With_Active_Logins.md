# Finding

## Summary

Building a campaign for "all Member Contacts with an active login" cannot be done
with a native Dynamic Query, because the relationship spans four tables:

```
Member Contact -> Membership Card -> Member Login Card -> Member Login
```

Dynamic Queries (ProcessQueryLine) open a single target table and correlate its
fields only to the Account/Contact In Parameter record. No single table in this
chain holds both a field correlatable to the Contact AND the login status, so the
join cannot be expressed in one query.

Workaround: denormalize the chain result onto a maintained boolean
("Has Active Login") on the Membership Card, then segment with a single-table
Exists query.

"Active login" is defined here as a linked "LSC Member Login" with Blocked = false.

## Version

LS Central: 25.2

## Source

Procedure: ProcessQueryLine (single-query evaluation), ProcessQuery (campaign
composition of And / Or / "(" / ")" / Query operators)

Table: LSC Membership Card (99009003), LSC Member Login Card (99009049),
LSC Member Login (99009045), LSC Member Contact (99009002)

Codeunit: Campaign Dynamic Query evaluation

## Evidence

```al
// ProcessQueryLine opens ONE table...
DataRecRef.Open(DynamicQuery."Table ID");

// ...and correlation lines link that table only to the Account/Contact parameter:
if DynamicQueryLine."Filter Type" = DynamicQueryLine."Filter Type"::Filter then
    DataField.SetFilter(...)
else begin
    ParField := ParRecRef.Field(DynamicQueryLine."Filter Field No.");
    DataField.SetRange(ParField.Value);
end;
```

Correlatability of each table in the chain:

- Membership Card: has Account No. (f7) + Contact No. (f8) -> correlatable to Contact,
  but no login reference field.
- Member Login Card: has Card No. (f3, Key2) + Login ID (f2) -> the join key, but NO
  Account No./Contact No. to correlate against the parameter.
- Member Login: has Blocked (f100), but nothing correlatable to a Contact.

No single table provides both a correlation field and the login status. Therefore
the join is not expressible in a single Dynamic Query.

## Observed Behavior

Confirmed (source): a Dynamic Query targeting any one of these tables can either
correlate to the contact OR see the login status, never both. An Exists query on
Membership Card alone reports "contact has a card", not "contact has an active login".

## Query Composition (And / Or / "(" / ")" / Query) does NOT rescue this

Confirmed against ProcessQuery. The operators compose query RESULT SETS per contact;
they do not thread a join key from one query into the next.

Evidence - every Query token is evaluated by the same single-query procedure, and the
only arguments ever passed are the contact and a Query ID:

```al
if ProcessQueryLine(MemberContact, TmpCampaignQueryLine."Query ID") then
    InsertLine(MemberContact, Campaign);   // OR / seed: union over full population
...
if ProcessQueryLine(MemberContact, TmpCampaignQueryLine."Query ID") then begin
    TmpCampaignLine."And Found" := true;   // AND: intersect existing working set
    TmpCampaignLine.Modify;
end;
```

Mechanics:

- OR  -> next Query iterates the full eligible population (Account/Contact, Club Code
  filtered) and InsertLines matches = set UNION into the working set.
- AND -> next Query iterates only the current working set, marks survivors, deletes the
  rest = set INTERSECTION over contacts.
- No intermediate Card No. (or any key) is passed between queries.

Why this does not help here:

A query needing login status must target Member Login / Member Login Card, which have
no Account No./Contact No. field, so ProcessQueryLine writes no correlation and its
Exists evaluates the whole table GLOBALLY - the same truth value for every contact.
"Active login exists" is therefore a CONSTANT predicate. ANDing it into
"contact has a card" yields "contact has a card"; ORing it pollutes the set. No
arrangement of operators makes a constituent query contact-specific past the card hop.

Granularity note: when In Parameter = Account, ProcessQuery evaluates against the
account's Main Contact (or a synthetic blank contact), not per real contact. Use
In Parameter = Contact for a per-contact card/login check (family/company accounts).

## Impact

Any segmentation that depends on a relationship more than one hop from the
Account/Contact (login state, card-of-card, etc.) cannot be done natively and needs
denormalization or an external selection routine.

## Workaround

1. Add Boolean field "Has Active Login" to LSC Membership Card (table extension).
2. Maintain it via event subscribers (see MemberActiveLogin.al):
   - Member Login Card OnAfterInsert / OnAfterDelete -> recompute that Card No.
   - Member Login OnAfterModify (Blocked change) / OnAfterDelete -> recompute its cards.
   - RebuildAll() once after deployment to backfill existing data.
3. Campaign Dynamic Query:
   - In Parameter = Contact   (NOT Account: a card is tied to a specific Contact No.;
     Account would over-select every contact on family/company accounts)
   - Table = LSC Membership Card (99009003)
   - Result Type = Exists, Condition = "=", Compare Value = true

   Query lines:

   | Field            | Filter Type | Filter Field / Value                 |
   |------------------|-------------|--------------------------------------|
   | Account No. (f7) | Field       | No. -> Contact "Account No." (f1)    |
   | Contact No. (f8) | Field       | Contact No. -> Contact "Contact No." (f5) |
   | Has Active Login | Filter      | Yes                                  |

   The two Field lines are the mandatory correlation. Without them, Exists evaluates
   the entire Membership Card table.

### Validation required (per methodology)

- Boolean filter: the flag value goes through DataField.SetFilter(Filter Value).
  Confirm "Yes" filters correctly; if not, try "1" / "true" or make the flag an Option.
- Validate with ACTUAL campaign execution, not Test Query.

### Alternative (no customization)

For a one-off list rather than an auto-maintained campaign, a processing-only report
or codeunit can walk the chain directly and write the contacts into the campaign
member selection, bypassing Dynamic Queries entirely.

## Status
Confirmed (limitation: single-query AND multi-query composition, per ProcessQueryLine + ProcessQuery)
Suspected (boolean-filter behavior of the workaround flag — pending live validation)
