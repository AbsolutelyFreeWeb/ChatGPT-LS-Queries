table 99009003 "LSC Membership Card"
{
    Caption = 'Membership Card';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Card No."; Text[100])
        {
            Caption = 'Card No.';
            ToolTip = 'Specifies the unique number of the membership card.';
        }
        field(2; Status; Enum "LSC Membership Card Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of the membership card.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnAction_Status(Rec, xRec);
            end;
        }
        field(3; "Linked to Account"; Boolean)
        {
            Caption = 'Linked to Account';
            Editable = false;
            ToolTip = 'Specifies whether the card is linked to a member account.';
        }
        field(5; "Club Code"; Code[10])
        {
            Caption = 'Club Code';
            TableRelation = "LSC Member Club";
            ToolTip = 'Specifies the club code associated with the membership card.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ClubCode(Rec, xRec);
            end;
        }
        field(6; "Scheme Code"; Code[10])
        {
            Caption = 'Scheme Code';
            Editable = false;
            TableRelation = "LSC Member Scheme";
            ToolTip = 'Specifies the scheme code associated with the membership card.';
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF (Status = CONST(Free)) "LSC Member Account"
            ELSE
            IF (Status = CONST(Allocated)) "LSC Member Account"
            ELSE
            IF (Status = CONST(Active)) "LSC Member Account" WHERE("Club Code" = FIELD("Club Code"))
            ELSE
            IF (Status = CONST(Blocked)) "LSC Member Account" WHERE("Club Code" = FIELD("Club Code"));
            ToolTip = 'Specifies the member account number linked to the card.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_AccountNo(Rec, xRec);
            end;
        }
        field(8; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = "LSC Member Contact"."Contact No." WHERE("Account No." = FIELD("Account No."));
            ToolTip = 'Specifies the contact number linked to the membership card.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ContactNo(Rec, xRec);
            end;
        }
        field(20; "First Date Used"; Date)
        {
            Caption = 'First Date Used';
            Editable = false;
            ToolTip = 'Specifies the first date the card was used.';
        }
        field(25; "Last Valid Date"; Date)
        {
            Caption = 'Last Valid Date';
            ToolTip = 'Specifies the last date the card is valid.';
        }
        field(30; "Reason Blocked"; Code[10])
        {
            Caption = 'Reason Blocked';
            TableRelation = "Reason Code";
            ToolTip = 'Specifies the reason why the card is blocked.';

            trigger OnLookup()
            begin
                Logic().Trigger_OnLookup_ReasonBlocked(Rec, xRec);
            end;

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ReasonBlocked(Rec, xRec);
            end;
        }
        field(31; "Date Blocked"; Date)
        {
            Caption = 'Date Blocked';
            Editable = false;
            ToolTip = 'Specifies the date when the card was blocked.';
        }
        field(32; "Blocked by"; Code[50])
        {
            Caption = 'Blocked by';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who blocked the card.';
        }
        field(35; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
            ToolTip = 'Specifies the date when the card was created.';
        }
        field(36; "Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who created the card.';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series used for the card.';
        }
        field(50; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used. Use Retail Images instead.';
            ObsoleteTag = '25.0'; // Pending='18.0'
            ToolTip = 'Obsolete. Not used.';
        }
        field(60; "Allocated to Store"; Code[10])
        {
            Caption = 'Allocated to Store';
            TableRelation = "LSC Store";
            ToolTip = 'Specifies the store to which the card is allocated.';
        }
    }

    keys
    {
        key(Key1; "Card No.")
        {
            Clustered = true;
        }
        key(Key2; "Account No.", "Contact No.", Status)
        {
        }
        key(Key3; "Club Code", "Scheme Code", Status)
        {
        }
    }

    #region Logic

    var
        _logic: Interface "LSC IMembershipCard";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMembershipCard"
    var
        Default: Codeunit "LSC Membership Card";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMembershipCard")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    trigger OnDelete()
    begin
        Logic().Trigger_OnDelete(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        Logic().Trigger_OnInsert(Rec, xRec);
    end;

    trigger OnRename()
    begin
        Logic().Trigger_OnRename(Rec, xRec);
    end;
}

