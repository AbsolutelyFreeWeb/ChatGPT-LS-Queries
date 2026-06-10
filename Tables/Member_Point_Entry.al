table 99009005 "LSC Member Point Entry"
{
    Caption = 'Member Point Entry';
    DrillDownPageID = "LSC Member Point Entries";
    LookupPageID = "LSC Member Point Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Source Type"; Enum "LSC Member Point Source Type")
        {
            Caption = 'Source Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = "LSC Member Account"."No.";
        }
        field(6; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = "LSC Member Contact"."Contact No." WHERE("Account No." = FIELD("Account No."));
        }
        field(7; "Card No."; Text[100])
        {
            Caption = 'Card No.';
            TableRelation = "LSC Membership Card";
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Sales,Redemption,Expire,Positive Adjmt.,Negative Adjmt,Transfer From,Transfer To';
            OptionMembers = Sales,Redemption,Expire,"Positive Adjmt.","Negative Adjmt","Transfer From","Transfer To";
        }
        field(10; "Point Type"; Option)
        {
            Caption = 'Point Type';
            OptionCaption = 'Award Points,Other Points';
            OptionMembers = "Award Points","Other Points";
        }
        field(11; Points; Decimal)
        {
            Caption = 'Points';
            DecimalPlaces = 0 : 1;
        }
        field(12; "Point Value"; Decimal)
        {
            Caption = 'Point Value';
        }
        field(13; "Posting Value"; Decimal)
        {
            Caption = 'Posting Value';
        }
        field(14; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(15; "Remaining Points"; Decimal)
        {
            Caption = 'Remaining Points';
            DecimalPlaces = 0 : 1;
        }
        field(16; "Closed by Entry"; Integer)
        {
            Caption = 'Closed by Entry';
            TableRelation = "LSC Member Point Entry"."Entry No.";
        }
        field(17; "Closed by Points"; Decimal)
        {
            Caption = 'Closed by Points';
            DecimalPlaces = 0 : 1;
        }
        field(20; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(30; "Member Club"; Code[10])
        {
            Caption = 'Member Club';
            TableRelation = "LSC Member Club".Code;
        }
        field(31; "Member Scheme"; Code[10])
        {
            Caption = 'Member Scheme';
            TableRelation = "LSC Member Scheme".Code;
        }
        field(35; "Store No."; Code[10])
        {
            Caption = 'Store No.';
            TableRelation = "LSC Store"."No.";
        }
        field(36; "POS Terminal No."; Code[10])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "LSC POS Terminal"."No." WHERE("Store No." = FIELD("Store No."));
        }
        field(37; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(40; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(50; "Posted to G/L"; Boolean)
        {
            Caption = 'Posted to G/L';
        }
        field(1100; "Replication Counter"; Integer)
        {
            Caption = 'Replication Counter';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ReplicationCounter(Rec, xRec);
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Account No.", "Entry Type", "Point Type", Date)
        {
            SumIndexFields = Points;
        }
        key(Key3; "Account No.", "Closed by Entry", Date)
        {
            SumIndexFields = Points;
        }
        key(Key4; "Member Club", "Entry Type", "Point Type", Date)
        {
            SumIndexFields = Points;
        }
        key(Key5; "Member Scheme", "Entry Type", "Point Type", Date)
        {
            SumIndexFields = Points;
        }
        key(Key6; "Closed by Entry", Date)
        {
        }
        key(Key7; "Account No.", Open, "Expiration Date")
        {
            SumIndexFields = "Remaining Points";
        }
        key(Key8; "Member Club", Open, "Expiration Date")
        {
            SumIndexFields = "Remaining Points";
        }
        key(Key9; "Member Scheme", Open, "Expiration Date")
        {
            SumIndexFields = "Remaining Points";
        }
        key(Key10; "Expiration Date", Open)
        {
        }
        key(Key11; "Card No.", Date)
        {
        }
        key(Key12; "Replication Counter")
        {
        }
        key(Key13; "Store No.", "POS Terminal No.", "Transaction No.")
        {
            SumIndexFields = Points;
        }
    }

    #region Logic

    var

        _logic: Interface "LSC IMember Point Entry";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMember Point Entry"
    var
        Default: Codeunit "LSC Member Point Entry";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMember Point Entry")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    trigger OnInsert()
    begin
        Logic().Trigger_OnInsert(Rec, xRec);
    end;

    trigger OnModify()
    begin
        Logic().Trigger_OnModify(Rec, xRec);
    end;
}

