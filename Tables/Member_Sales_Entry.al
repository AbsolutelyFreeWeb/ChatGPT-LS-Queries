table 99009034 "LSC Member Sales Entry"
{
    Caption = 'Member Sales Entry';
    DrillDownPageID = "LSC Member Sales Entry";
    LookupPageID = "LSC Member Sales Entry";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'POS Transaction,Sales Invoice,,Credit Memo';
            OptionMembers = "POS Transaction","Sales Invoice",,"Credit Memo";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Member Account No."; Code[20])
        {
            Caption = 'Member Account No.';
            TableRelation = "LSC Member Account"."No.";
        }
        field(6; "Member Contact No."; Code[20])
        {
            Caption = 'Member Contact No.';
            TableRelation = "LSC Member Contact"."Contact No." WHERE("Account No." = FIELD("Member Account No."));
        }
        field(7; "Member Card No."; Text[100])
        {
            Caption = 'Member Card No.';
            TableRelation = "LSC Membership Card";
        }
        field(8; "Member Club"; Code[10])
        {
            Caption = 'Member Club';
            TableRelation = "LSC Member Club".Code;
        }
        field(9; "Member Scheme"; Code[10])
        {
            Caption = 'Member Scheme';
            TableRelation = "LSC Member Scheme".Code;
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
        }
        field(13; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
        }
        field(14; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            AutoFormatType = 2;
        }
        field(15; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            AutoFormatType = 2;
        }
        field(16; "Points Type"; Option)
        {
            Caption = 'Points Type';
            OptionCaption = 'Award Points,Other Points';
            OptionMembers = "Award Points","Other Points";
        }
        field(17; Points; Decimal)
        {
            Caption = 'Points';
        }
        field(18; Date; Date)
        {
            Caption = 'Date';
        }
        field(19; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(21; "Item Variant Code"; Code[10])
        {
            Caption = 'Item Variant Code';
        }
        field(25; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(30; "Retail Product Code"; Code[20])
        {
            Caption = 'Retail Product Code';
            TableRelation = "LSC Retail Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(40; "Store No."; Code[10])
        {
            Caption = 'Store No.';
            TableRelation = "LSC Store";
        }
        field(41; "POS Terminal No."; Code[10])
        {
            Caption = 'POS Terminal No.';
            TableRelation = "LSC POS Terminal"."No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(42; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            TableRelation = "LSC Transaction Header"."Transaction No." WHERE("Store No." = FIELD("Store No."),
                                                                          "POS Terminal No." = FIELD("POS Terminal No."));
        }
        field(50; "Trans. Sales Entry"; Integer)
        {
            CalcFormula = Count("LSC Trans. Sales Entry" WHERE("Store No." = FIELD("Store No."),
                                                            "POS Terminal No." = FIELD("POS Terminal No."),
                                                            "Transaction No." = FIELD("Transaction No."),
                                                            "Line No." = FIELD("Line No.")));
            Caption = 'Trans. Sales Entry';
            FieldClass = FlowField;
        }
        field(51; Transaction; Integer)
        {
            CalcFormula = Count("LSC Transaction Header" WHERE("Store No." = FIELD("Store No."),
                                                            "POS Terminal No." = FIELD("POS Terminal No."),
                                                            "Transaction No." = FIELD("Transaction No.")));
            Caption = 'Transaction';
            FieldClass = FlowField;
        }
        field(60; "Store Name Int"; Text[100])
        {
        }
        field(1002; "Replication Counter"; Integer)
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
        key(Key1; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Member Account No.", Date, "Item Category Code", "Retail Product Code")
        {
            SumIndexFields = Quantity, "Gross Amount", "Discount Amount";
        }
        key(Key3; "Member Club", "Member Scheme", Date, "Item Category Code", "Retail Product Code")
        {
            SumIndexFields = Quantity, "Gross Amount", "Discount Amount";
        }
        key(Key4; "Store No.", "POS Terminal No.", "Transaction No.")
        {
        }
        key(Key5; "Replication Counter")
        {
        }
        key(Key6; "Member Account No.", "Member Contact No.", Date)
        {
            SumIndexFields = Quantity, "Gross Amount", "Net Amount";
        }
        key(Key7; Date)
        {
        }
        key(Key8; "Member Card No.")
        {
        }
    }


    #region Logic

    var
        _logic: Interface "LSC IMember Sales Entry";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMember Sales Entry"
    var
        Default: Codeunit "LSC Member Sales Entry";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMember Sales Entry")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    trigger OnInsert()
    begin
        Logic.Trigger_OnInsert(Rec, xRec);
    end;

    trigger OnModify()
    begin
        Logic.Trigger_OnModify(Rec, xRec);
    end;

    trigger OnRename()
    begin
        Logic.Trigger_OnRename(Rec)
    end;

    internal procedure NextEntryNo(): Integer
    begin
        exit(Logic.NextEntryNo());
    end;
}

