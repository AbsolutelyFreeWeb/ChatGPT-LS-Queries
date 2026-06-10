table 99009049 "LSC Member Login Card"
{
    Caption = 'Member Login Card';
    DataClassification = CustomerContent;

    fields
    {
        field(2; "Login ID"; Text[50])
        {
            Caption = 'Login ID';
            TableRelation = "LSC Member Login";
            ToolTip = 'Specifies the login ID associated with the card.';
        }
        field(3; "Card No."; Text[100])
        {
            Caption = 'Card No.';
            TableRelation = "LSC Membership Card";
            ToolTip = 'Specifies the card number linked to the member login.';
        }
    }

    keys
    {
        key(Key1; "Login ID", "Card No.")
        {
            Clustered = true;
        }
        key(Key2; "Card No.")
        {
        }
    }
}

