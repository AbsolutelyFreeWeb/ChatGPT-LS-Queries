table 99009045 "LSC Member Login"
{
    Caption = 'Member Login';
    DataClassification = CustomerContent;

    fields
    {
        field(2; "Login ID"; Text[50])
        {
            Caption = 'Login ID';
            ToolTip = 'Specifies the login ID for the member.';
        }
        field(5; Password; Text[250])
        {
            Caption = 'Password';
            ToolTip = 'Specifies the password for the member login.';
        }
        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether the member login is blocked.';
        }
        field(110; "Reset Code"; Text[10])
        {
            Caption = 'Reset Code';
            ToolTip = 'Specifies the reset code used for password recovery.';
        }
        field(111; "Reset Code Expires"; DateTime)
        {
            Caption = 'Reset Code Expires';
            ToolTip = 'Specifies the date and time when the reset code expires.';
        }
    }

    keys
    {
        key(Key1; "Login ID")
        {
            Clustered = true;
        }
    }

    #region Logic

    var
        _logic: Interface "LSC IMember Login";
        _logicDefined: Boolean;

    local procedure Logic(): Interface "LSC IMember Login"
    var
        Default: Codeunit "LSC Member Login";
    begin
        if not _logicDefined then
            Define(Default);

        exit(_logic);
    end;

    internal procedure Define(Implementation: Interface "LSC IMember Login")
    begin
        _logicDefined := true;
        _logic := Implementation;
    end;

    #endregion

    trigger OnDelete()
    begin
        Logic().Trigger_OnDelete(Rec);
    end;
}

