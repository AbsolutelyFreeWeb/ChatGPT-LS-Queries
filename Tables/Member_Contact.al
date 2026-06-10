table 99009002 "LSC Member Contact"
{
    Caption = 'Member Contact';
    DrillDownPageID = "LSC Member Contacts";
    LookupPageID = "LSC Member Contacts";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            NotBlank = true;
            TableRelation = "LSC Member Account";
            ToolTip = 'Specifies the member account number associated with this contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_AccountNo(Rec, xRec);
            end;
        }
        field(2; "Club Code"; Code[10])
        {
            Caption = 'Club Code';
            Editable = false;
            TableRelation = "LSC Member Club";
            ToolTip = 'Specifies the club code for the member contact.';
        }
        field(3; "Scheme Code"; Code[10])
        {
            Caption = 'Scheme Code';
            Editable = false;
            TableRelation = "LSC Member Scheme";
            ToolTip = 'Specifies the scheme code for the member contact.';
        }
        field(5; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            ToolTip = 'Specifies the unique contact number for the member.';

            trigger OnLookup()
            begin
                Logic().Trigger_OnLookup_ContactNo(Rec, xRec);
            end;

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_ContactNo(Rec, xRec);
            end;
        }
        field(6; "Main Contact"; Boolean)
        {
            Caption = 'Main Contact';
            ToolTip = 'Specifies whether this contact is the main contact for the account.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_MainContact(Rec, xRec);
            end;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the member contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_Name(Rec, xRec);
            end;
        }
        field(11; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            ToolTip = 'Specifies an alternate name for searching the contact.';
        }
        field(12; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies an additional name for the contact.';
        }
        field(13; Address; Text[100])
        {
            Caption = 'Address';
            ToolTip = 'Specifies the address of the member contact.';
        }
        field(14; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            ToolTip = 'Specifies additional address information for the contact.';
        }
        field(15; City; Text[30])
        {
            Caption = 'City';
            Description = 'Stored data should not exceed 30 chars';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
            ToolTip = 'Specifies the city of the member contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_City(Rec, xRec, CurrFieldNo);
            end;
        }
        field(16; "House/Apartment No."; Text[30])
        {
            Caption = 'House/Apartment No.';
            ToolTip = 'Specifies the house or apartment number of the contact.';
        }
        field(17; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'Stored data should not exceed 20 chars';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the postal code of the member contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_PostCode(Rec, xRec, CurrFieldNo);
            end;
        }
        field(18; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            ToolTip = 'Specifies the email address of the member contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_Email(Rec, xRec);
            end;
        }
        field(19; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
            ToolTip = 'Specifies the home page URL of the member contact.';
        }
        field(20; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            ToolTip = 'Specifies the phone number of the member contact.';
        }
        field(21; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
            ToolTip = 'Specifies the mobile phone number of the member contact.';
        }
        field(23; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
            ToolTip = 'Specifies the territory code for the member contact.';
        }
        field(25; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
            ObsoleteState = Removed;
            ObsoleteReason = 'Never used.';
            ObsoleteTag = '25.0'; // Pending='18.0'
            ToolTip = 'Obsolete. Not used.';
        }
        field(26; County; Text[30])
        {
            Caption = 'County';
            ToolTip = 'Specifies the county of the member contact.';
        }
        field(27; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the country or region code of the member contact.';
        }
        field(28; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            ToolTip = 'Specifies the language code for the member contact.';
        }
        field(30; Gender; Option)
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Not used. Use new field due to conversion to Enum. Use Contact Gender instead.';
            ObsoleteTag = '24.1';
            Caption = 'Gender (Obsolete)';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
            ToolTip = 'Obsolete. Use Contact Gender instead.';
        }
        field(31; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            ToolTip = 'Specifies the date of birth of the member contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_DateOfBirth(Rec, xRec);
            end;
        }
        field(32; Birthday; Code[4])
        {
            Caption = 'Birthday';
            Editable = false;
            ToolTip = 'Specifies the birthday of the member contact.';
        }
        field(33; "Contact Gender"; enum "LSC Gender")
        {
            Caption = 'Gender';
            ToolTip = 'Specifies the gender of the member contact.';
        }
        field(35; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionCaption = ' ,Single,Married,Divorced,Widowed';
            OptionMembers = " ",Single,Married,Divorced,Widowed;
            ToolTip = 'Specifies the marital status of the member contact.';
        }
        field(36; "Guest Type"; Code[20])
        {
            Caption = 'Guest Type';
            TableRelation = "LSC Guest Type";
            ToolTip = 'Specifies the guest type of the member/client.';
        }
        field(50; "Expired Points"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry".Points WHERE("Account No." = FIELD("Account No."),
                                                                 "Contact No." = FIELD("Contact No."),
                                                                 "Entry Type" = CONST(Expire),
                                                                 Date = FIELD("Date Filter")));
            Caption = 'Expired Points';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total number of expired points for the contact.';
        }
        field(51; "Issued Award Points"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry".Points WHERE("Account No." = FIELD("Account No."),
                                                                 "Contact No." = FIELD("Contact No."),
                                                                 "Entry Type" = FILTER(Sales | "Positive Adjmt." | "Transfer To"),
                                                                 "Point Type" = CONST("Award Points"),
                                                                 Date = FIELD("Date Filter")));
            Caption = 'Issued Award Points';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total number of issued award points for the contact.';
        }
        field(52; "Issued Other Points"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry".Points WHERE("Account No." = FIELD("Account No."),
                                                                 "Contact No." = FIELD("Contact No."),
                                                                 "Entry Type" = FILTER(Sales | "Positive Adjmt." | "Transfer To"),
                                                                 "Point Type" = CONST("Other Points"),
                                                                 Date = FIELD("Date Filter")));
            Caption = 'Issued Other Points';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total number of issued other points for the contact.';
        }
        field(53; "Total Issued Points"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry".Points WHERE("Account No." = FIELD("Account No."),
                                                                 "Contact No." = FIELD("Contact No."),
                                                                 "Entry Type" = FILTER(Sales | "Positive Adjmt." | "Transfer To"),
                                                                 Date = FIELD("Date Filter")));
            Caption = 'Total Issued Points';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total number of issued points for the contact.';
        }
        field(54; "Used Points"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry".Points WHERE("Account No." = FIELD("Account No."),
                                                                 "Contact No." = FIELD("Contact No."),
                                                                 "Entry Type" = FILTER(Redemption | "Negative Adjmt" | "Transfer From"),
                                                                 Date = FIELD("Date Filter")));
            Caption = 'Used Points';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total number of used points for the contact.';
        }
        field(56; "Expiration Period"; Date)
        {
            Caption = 'Expiration Period';
            FieldClass = FlowFilter;
            ToolTip = 'Specifies the expiration period for filtering points.';
        }
        field(57; "Expiration in Period"; Decimal)
        {
            CalcFormula = Sum("LSC Member Point Entry"."Remaining Points" WHERE("Account No." = FIELD("Account No."),
                                                                             "Contact No." = FIELD("Contact No."),
                                                                             Open = CONST(true),
                                                                             "Expiration Date" = FIELD("Expiration Period")));
            Caption = 'Expiration in Period';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of points expiring in the selected period for the contact.';
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
            CalcFormula = Sum("LSC Member Point Entry"."Remaining Points" WHERE("Account No." = FIELD("Account No."),
                                                                             "Contact No." = FIELD("Contact No."),
                                                                             Open = CONST(true)));
            Caption = 'Balance';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the current balance of points for the contact.';
        }
        field(63; "Total Sales"; Decimal)
        {
            CalcFormula = - Sum("LSC Member Sales Entry"."Gross Amount" WHERE("Member Account No." = FIELD("Account No."),
                                                                          "Member Contact No." = FIELD("Contact No."),
                                                                          Date = FIELD("Date Filter")));
            Caption = 'Total Sales';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the total sales amount for the contact.';
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
            ToolTip = 'Specifies whether the contact is blocked.';

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
            ToolTip = 'Specifies the reason why the contact is blocked.';
        }
        field(102; "Date Blocked"; Date)
        {
            Caption = 'Date Blocked';
            Editable = false;
            ToolTip = 'Specifies the date when the contact was blocked.';
        }
        field(103; "Blocked by"; Code[50])
        {
            Caption = 'Blocked by';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who blocked the contact.';
        }
        field(105; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            ToolTip = 'Specifies the date when the contact was created.';
        }
        field(106; "Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who created the contact.';
        }
        field(140; Image; Media)
        {
            Caption = 'Image';
            ObsoleteState = Removed;
            ObsoleteReason = 'Not used. Use Retail Images instead.';
            ObsoleteTag = '25.0'; // Pending='18.0'
            ToolTip = 'Obsolete. Not used.';
        }
        field(150; "Privacy Blocked"; Boolean)
        {
            Caption = 'Privacy Blocked';
            ToolTip = 'Specifies whether the contact is privacy blocked.';
        }
        field(200; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series used for the contact.';
        }
        field(300; "External ID"; Text[50])
        {
            Caption = 'External ID';
            ToolTip = 'Specifies the external identifier for the contact.';
        }
        field(301; "External System"; Text[50])
        {
            Caption = 'External System';
            ToolTip = 'Specifies the external system associated with the contact.';
        }
        field(450; "Member Card Temporary"; Text[100])
        {
            Caption = 'Member Card Temporary';
            ToolTip = 'Specifies a temporary member card number for the contact.';
        }
        field(5054; "First Name"; Text[30])
        {
            Caption = 'First Name';
            ToolTip = 'Specifies the first name of the contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_FirstName(Rec, xRec);
            end;
        }
        field(5055; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
            ToolTip = 'Specifies the middle name of the contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_MiddleName(Rec, xRec);
            end;
        }
        field(5056; Surname; Text[30])
        {
            Caption = 'Surname';
            ToolTip = 'Specifies the surname of the contact.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_Surname(Rec, xRec);
            end;
        }
        field(5101; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
            ToolTip = 'Specifies the salutation code for the contact.';
        }
        field(5102; "Search E-Mail"; Code[80])
        {
            Caption = 'Search E-Mail';
            ToolTip = 'Specifies an alternate email address for searching the contact.';
        }
        field(5103; "Send Receipt by E-mail"; Enum "LSC Send Receipt by Email")
        {
            Caption = 'Send Receipt by E-mail';
            ToolTip = 'Specifies if the user wants to receive the receipt by email for ScanPayGo orders. Selecting the empty option will assign the value set in the Member Management Setup.';
        }
        field(5110; "City Search Internal"; Text[100])
        {
            //Internal fields used for searching in MEMBERCONTACT POS Command
            Caption = 'City Search Internal';
            ToolTip = 'Internal field used for searching by city.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_CitySearchInternal(Rec, xRec, CurrFieldNo);
            end;
        }
        field(5111; "Post Code Search Internal"; Text[100])
        {
            //Internal fields used for searching in MEMBERCONTACT POS Command
            Caption = 'Post Code Search Internal';
            ToolTip = 'Internal field used for searching by post code.';

            trigger OnValidate()
            begin
                Logic().Trigger_OnValidate_PostCodeSearchInternal(Rec, xRec, CurrFieldNo);
            end;
        }
        field(5112; "Default Token"; Integer)
        {
            Caption = 'Default Token';
            ToolTip = 'Specifies the default token for the contact.';
        }
    }

    keys
    {
        key(Key1; "Account No.", "Contact No.")
        {
            Clustered = true;
        }
        key(Key2; "Club Code", "Scheme Code")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; "Search E-Mail")
        {
        }
        key(Key5; "Contact No.")
        {
        }
        key(key6; "Phone No.")
        {
        }
        key(key7; "Mobile Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Account No.", "Contact No.", Name)
        {
        }
    }

    #region Logic

    var
        _logic: Interface "LSC IMember Contact";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMember Contact"
    var
        Default: Codeunit "LSC Member Contact";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMember Contact")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    #region Triggers

    trigger OnDelete()
    begin
        Logic().Trigger_OnDelete(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        Logic().Trigger_OnInsert(Rec, xRec);
    end;

    trigger OnModify()
    begin
        Logic().Trigger_OnModify(Rec, xRec);
    end;

    trigger OnRename()
    begin
        Logic().Trigger_OnRename(Rec, xRec);
    end;

    #endregion

    #region public methods

    procedure ValidatePostCodeCity(var Rec: Record "LSC Member Contact"; CombinedKey: Code[55]): Boolean
    begin
        exit(Logic().ValidatePostCodeCity(Rec, CombinedKey));
    end;

    procedure NameBreakdown(SkipFirstNameCheck: Boolean)
    begin
        Logic().NameBreakdown(Rec, SkipFirstNameCheck);
    end;

    procedure BlockMemberContact(Rec: Record "LSC Member Contact")
    begin
        Logic().BlockMemberContact(Rec);
    end;

    #endregion

    #region Internal methods    
    internal procedure AssignCard()
    begin
        Logic().AssignCard(Rec);
    end;

    procedure UpdateAttributes()
    begin
        Logic().UpdateAttributes(Rec);
    end;

    procedure DeleteLinkedTables()
    begin
        Logic().DeleteLinkedTables(Rec);
    end;

    internal procedure MemberContactLookup(MemberCardNo: Text)
    begin
        Logic().MemberContactLookup(Rec, MemberCardNo);
    end;

    internal procedure InsertRelatedMemberShipCardComments(CardNo: Text[100]; var LSCCommentTmp: Record "LSC Comment" temporary; OriginalRecID: RecordId; var RelatedLineNo: Integer)
    begin
        Logic().InsertRelatedMemberShipCardComments(Rec, CardNo, LSCCommentTmp, OriginalRecID, RelatedLineNo);
    end;

    internal procedure InsertRelatedMemberContactComments(MemberContact: Record "LSC Member Contact"; var LSCCommentTemp: Record "LSC Comment" temporary; OriginalRecID: RecordId; var RelatedLineNo: Integer)
    begin
        Logic().InsertRelatedMemberContactComments(Rec, MemberContact, LSCCommentTemp, OriginalRecID, RelatedLineNo);
    end;

    internal procedure CountRelatedMemberShipCardComments(CardNo: Text[100]; OriginalRecID: RecordId): Integer
    begin
        exit(Logic().CountRelatedMemberShipCardComments(Rec, CardNo, OriginalRecID));
    end;

    internal procedure CountRelatedMemberContactComments(MemberContact: Record "LSC Member Contact"; OriginalRecID: RecordId): Integer
    begin
        exit(Logic().CountRelatedMemberContactComments(Rec, MemberContact, OriginalRecID));
    end;

    internal procedure MemberShipCardCommentsExist(CardNo: Text[100]): Boolean
    begin
        exit(Logic().MemberShipCardCommentsExist(Rec, CardNo));
    end;

    internal procedure MemberContactCommentsExist(MemberContact: Record "LSC Member Contact"): Boolean
    begin
        exit(Logic().MemberContactCommentsExist(Rec, MemberContact));
    end;

    internal procedure OnBeforeSetCommentPanelHeading(LinkedTableRecordID: RecordId; var EntityID: Text; var IsHandled: Boolean; var PanelName: Text)
    begin
        Logic().OnBeforeSetCommentPanelHeading(Rec, LinkedTableRecordID, EntityID, IsHandled, PanelName);
    end;

    #endregion

    #region Page Actions

    #endregion

    #region Integration Events

    [IntegrationEvent(false, false)]
    internal procedure OnBeforeCalculatedName(var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    internal procedure OnBeforeNameBrakedown(var IsHandled: Boolean)
    begin
    end;

    #endregion    
}