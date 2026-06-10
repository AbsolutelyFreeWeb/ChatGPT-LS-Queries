table 99009001 "LSC Member Account"
{
    Caption = 'Member Account';
    DrillDownPageID = "LSC Member Accounts";
    LookupPageID = "LSC Member Accounts";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the unique number for the member account.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_No(Rec, xRec);
            end;
        }
        field(2; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Unassigned,Active,Closed';
            OptionMembers = Unassigned,Active,Closed;
            ToolTip = 'Specifies the status of the member account.';
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Private,Family,Company';
            OptionMembers = Private,Family,Company;
            ToolTip = 'Specifies the type of the member account.';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the member account.';
        }
        field(10; "Main Contact"; Code[20])
        {
            CalcFormula = Lookup("LSC Member Contact"."Contact No." WHERE("Account No." = FIELD("No."),
                                                                       "Main Contact" = CONST(true)));
            Caption = 'Main Contact';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the contact number of the main contact for this account.';
        }
        field(11; "Main Contact Name"; Text[100])
        {
            CalcFormula = Lookup("LSC Member Contact".Name WHERE("Account No." = FIELD("No."),
                                                              "Main Contact" = CONST(true)));
            Caption = 'Main Contact Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the name of the main contact for this account.';
        }
        field(13; "Linked To Customer No."; Code[20])
        {
            Caption = 'Linked To Customer No.';
            TableRelation = Customer;
            ToolTip = 'Specifies the customer number linked to this member account.';
        }
        field(16; "Date Activated"; Date)
        {
            Caption = 'Date Activated';
            Editable = false;
            ToolTip = 'Specifies the date when the account was activated.';
        }
        field(17; "Activated By"; Code[50])
        {
            Caption = 'Activated By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who activated the account.';
        }
        field(20; "Club Code"; Code[10])
        {
            Caption = 'Club Code';
            TableRelation = "LSC Member Club";
            ToolTip = 'Specifies the club code associated with this account.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ClubCode(Rec, xRec, CurrFieldNo);
            end;
        }
        field(21; "Scheme Code"; Code[10])
        {
            Caption = 'Scheme Code';
            TableRelation = "LSC Member Scheme" WHERE("Club Code" = FIELD("Club Code"));
            ToolTip = 'Specifies the scheme code associated with this account.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_SchemeCode(Rec, xRec);
            end;
        }
        field(30; "Price Group"; Code[10])
        {
            Caption = 'Price Group';
            TableRelation = "Customer Price Group";
            ToolTip = 'Specifies the price group for the member account.';
        }
        field(31; "Cust. Disc. Group"; Code[20])
        {
            Caption = 'Cust. Disc. Group';
            TableRelation = "Customer Discount Group";
            ToolTip = 'Specifies the customer discount group for the member account.';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series used for the account.';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            ToolTip = 'Specifies the language code for the member account.';
        }
        field(50; "Expired Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of expired points for the account.';
        }
        field(51; "Issued Award Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of issued award points for the account.';
        }
        field(52; "Issued Other Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of issued other points for the account.';
        }
        field(53; "Total Issued Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of issued points for the account.';
        }
        field(54; "Used Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of used points for the account.';
        }
        field(55; "Transferred Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the total number of transferred points for the account.';
        }
        field(56; "Expiration Period"; Date)
        {
            Caption = 'Expiration Period';
            FieldClass = FlowFilter;
            ToolTip = 'Specifies the expiration period for filtering points.';
        }
        field(57; "Expiration in Period"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the number of points expiring in the selected period.';
        }
        field(58; "Expiration Period Type"; Option)
        {
            Caption = 'Expiration Period Type';
            OptionCaption = 'Current Week,Next Week,Current Month,Next Month';
            OptionMembers = "Current Week","Next Week","Current Month","Next Month";
            ToolTip = 'Specifies the type of expiration period for filtering points.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ExpirationPeriodType(Rec, xRec);
            end;
        }
        field(59; Balance; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the current balance of points for the account.';
        }
        field(60; BalanceInt; Decimal)
        {
            Caption = 'BalanceInt';
            DecimalPlaces = 0 : 0;
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the current balance of points (internal use).';
        }
        field(61; "No. of Contacts"; Integer)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the number of contacts linked to the account.';
        }
        field(62; "Unprocessed Points"; Decimal)
        {
            ObsoleteReason = 'Not used anymore. Use CalculateMemberPoints procedure instead.';
            ObsoleteState = Pending;
            ObsoleteTag = '27.0';
            Editable = false;
            ToolTip = 'Specifies the number of unprocessed points for the account.';
        }
        field(63; "Total Sales"; Decimal)
        {
            CalcFormula = - Sum("LSC Member Sales Entry"."Gross Amount" WHERE("Member Account No." = FIELD("No."),
                                                                          Date = FIELD("Date Filter")));
            Caption = 'Total Sales';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total sales amount for the account.';
        }
        field(64; "Sales Current Year"; Decimal)
        {
            Caption = 'Sales Current Year';
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the total sales amount for the current year.';
        }
        field(65; "Last Sales Date"; Date)
        {
            Caption = 'Last Sales Date';
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the date of the last sale for the account.';
        }
        field(66; UnprocessedPointsInt; Decimal)
        {
            Caption = 'UnprocessedPointsInt';
            DecimalPlaces = 0 : 0;
            Description = 'Only applicable in WS';
        }
        field(70; "Disc. Tracking Amount"; Decimal)
        {
            CalcFormula = Sum("LSC Discount Tracking Entry"."Discount Amount" WHERE("Account No." = FIELD("No."),
                                                                                 Date = FIELD("Date Filter"),
                                                                                 "Tracking No." = FIELD("Tracking No. Filter")));
            Caption = 'Disc. Tracking Amount';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total discount tracking amount for the account.';
        }
        field(75; "Tracking No. Filter"; Code[10])
        {
            Caption = 'Tracking No. Filter';
            FieldClass = FlowFilter;
            TableRelation = "LSC Discount Tracking Header";
            ToolTip = 'Specifies the tracking number for filtering discount entries.';
        }
        field(80; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
            ToolTip = 'Specifies the date filter for calculations.';
        }
        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether the account is blocked.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_Blocked(Rec, xRec);
            end;
        }
        field(101; "Reason Blocked"; Code[10])
        {
            Caption = 'Reason Blocked';
            Editable = false;
            TableRelation = "Reason Code";
            ToolTip = 'Specifies the reason why the account is blocked.';
        }
        field(102; "Date Blocked"; Date)
        {
            Caption = 'Date Blocked';
            Editable = false;
            ToolTip = 'Specifies the date when the account was blocked.';
        }
        field(103; "Blocked By"; Code[50])
        {
            Caption = 'Blocked By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who blocked the account.';
        }
        field(105; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            ToolTip = 'Specifies the date when the account was created.';
        }
        field(106; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who created the account.';
        }
        field(110; "Last Upgraded/Downgraded"; Date)
        {
            CalcFormula = Lookup("LSC Member Account Upgr. Entry".Date WHERE("Account No." = FIELD("No."),
                                                                            Active = CONST(true)));
            Caption = 'Last Upgraded/Downgraded';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the date when the account was last upgraded or downgraded.';
        }
        field(111; "Next Check for Update"; Date)
        {
            CalcFormula = Lookup("LSC Member Account Upgr. Entry"."Next Check Date" WHERE("Account No." = FIELD("No."),
                                                                                         Active = CONST(true)));
            Caption = 'Next Check for Update';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the next date when the account will be checked for upgrade or downgrade.';
        }
        field(150; "Privacy Blocked"; Boolean)
        {
            Caption = 'Privacy Blocked';
            ToolTip = 'Specifies whether the account is privacy blocked.';
        }
        field(1000; TotalRemainingPointsInt; Decimal)
        {
            Caption = 'TotalRemainingPointsInt';
            DecimalPlaces = 0 : 0;
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the total remaining points (internal use).';
        }
        field(1001; TotalSalesInt; Decimal)
        {
            Caption = 'TotalSalesInt';
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the total sales amount (internal use).';
        }
        field(1002; ExpirationinPeriodInt; Decimal)
        {
            Caption = 'ExpirationinPeriodInt';
            DecimalPlaces = 0 : 0;
            Description = 'Only applicable in WS';
            ToolTip = 'Specifies the number of points expiring in the selected period (internal use).';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Club Code")
        {
        }
        key(Key3; "Scheme Code")
        {
        }
    }

    #region Logic

    var
        _logic: Interface "LSC IMember Account";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMember Account"
    var
        Default: Codeunit "LSC Member Account";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMember Account")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    trigger OnDelete()
    begin
        Logic().Trigger_OnDelete(Rec);
    end;

    trigger OnInsert()
    begin
        Logic().Trigger_OnInsert(Rec, xRec);
    end;

    trigger OnModify()
    begin
        Logic().Trigger_OnModify(Rec);
    end;

    trigger OnRename()
    begin
        Logic().Trigger_OnRename(Rec);
    end;

    procedure AssistEdit(testNoSeries: Boolean)
    begin
        Logic().AssistEdit(Rec, testNoSeries);
    end;

    procedure DeleteLinkedTables()
    begin
        Logic().DeleteLinkedTables(Rec);
    end;

    procedure PointsBalance(): Decimal
    begin
        exit(Logic.PointsBalance(Rec));
    end;

    procedure TotalRemainingPoints(): Decimal
    begin
        exit(Logic().TotalRemainingPoints(Rec));
    end;

    procedure BlockMemberAccount()
    begin
        Logic().BlockMemberAccount(Rec);
    end;

    procedure CalculateMemberPoints(var Points: array[6] of Decimal)
    begin
        Logic.CalculateMemberPoints(Rec, Points);
    end;

    procedure CalculateExpirationInPeriodPoints(): Decimal
    begin
        exit(Logic.CalculateExpirationInPeriodPoints(Rec));
    end;

    procedure CalculateUnprocessedPoints(): Decimal
    begin
        exit(Logic.CalculateUnprocessedPoints(Rec));
    end;
}

