    procedure ProcessQuery(Campaign: Record "LSC Member Campaign")
    var
        TmpCampaignQueryLine: Record "LSC Member Campaign Query Line" temporary;
        CampaignQueryLine: Record "LSC Member Campaign Query Line";
        CampaignLine: Record "LSC Member Campaign Line";
        DynamicQuery: Record "LSC Dynamic Query";
        MemberAccount: Record "LSC Member Account";
        MemberContact: Record "LSC Member Contact";
        CurrSeq: Integer;
        LineNoFrom: Integer;
        LineNoTo: Integer;
        NoOfLines: Integer;
        NextIsOr: Boolean;
    begin
        TmpCampaignQueryLine.Reset;
        TmpCampaignQueryLine.DeleteAll;

        TmpCampaignLine.Reset;
        TmpCampaignLine.DeleteAll;

        MemberAccount.SetRange("Club Code", Campaign."Club Code");
        MemberContact.SetRange("Club Code", Campaign."Club Code");

        MemberCampMgtPublic.OnAfterSetFilters(MemberAccount, MemberContact, Campaign);

        CampaignQueryLine.SetRange("Campaign No.", Campaign."No.");
        if CampaignQueryLine.FindSet then
            repeat
                TmpCampaignQueryLine := CampaignQueryLine;
                TmpCampaignQueryLine.Insert;
            until CampaignQueryLine.Next = 0;

        TmpCampaignQueryLine.SetRange(Sequence, 0);
        CurrSeq := 0;

        if TmpCampaignQueryLine.FindSet then
            repeat
                CurrSeq := CurrSeq + 1;
                TmpCampaignQueryLine.SetRange("Line Type", TmpCampaignQueryLine."Line Type"::")");
                if TmpCampaignQueryLine.FindFirst then begin
                    LineNoTo := TmpCampaignQueryLine."Line No.";
                    TmpCampaignQueryLine.SetRange("Line Type", TmpCampaignQueryLine."Line Type"::"(");
                    TmpCampaignQueryLine.Next(-1);
                    LineNoFrom := TmpCampaignQueryLine."Line No.";
                    TmpCampaignQueryLine.SetRange("Line Type");
                end
                else begin
                    TmpCampaignQueryLine.SetRange("Line Type");
                    TmpCampaignQueryLine.FindFirst;
                    LineNoFrom := TmpCampaignQueryLine."Line No.";
                    TmpCampaignQueryLine.FindLast;
                    LineNoTo := TmpCampaignQueryLine."Line No.";
                end;
                TmpCampaignQueryLine.SetRange("Line No.", LineNoFrom, LineNoTo);
                TmpCampaignQueryLine.ModifyAll(Sequence, CurrSeq);
                TmpCampaignQueryLine.SetRange("Line No.");
            until not TmpCampaignQueryLine.FindFirst;

        TmpCampaignQueryLine.Reset;
        TmpCampaignQueryLine.SetRange(Sequence);
        TmpCampaignQueryLine.SetCurrentKey(Sequence);

        NextIsOr := true;
        TmpCampaignQueryLine.SetRange("Line Type", TmpCampaignQueryLine."Line Type"::"OR", TmpCampaignQueryLine."Line Type"::Query);
        if TmpCampaignQueryLine.FindSet then
            repeat
                if TmpCampaignQueryLine."Line Type" <> TmpCampaignQueryLine."Line Type"::Query then begin
                    if TmpCampaignQueryLine."Line Type" = TmpCampaignQueryLine."Line Type"::"OR" then
                        NextIsOr := true
                    else begin
                        TmpCampaignLine.Reset;
                        TmpCampaignLine.ModifyAll("And Found", false);
                        NextIsOr := false;
                    end;
                end
                else begin
                    DynamicQuery.Get(DynamicQuery.Type::Campaign, TmpCampaignQueryLine."Query ID");
                    if NextIsOr then begin
                        if DynamicQuery."In Parameter" = DynamicQuery."In Parameter"::Account then begin
                            if MemberAccount.FindSet then
                                repeat
                                    MemberAccount.CalcFields("Main Contact");
                                    if MemberAccount."Main Contact" = '' then begin
                                        Clear(MemberContact);
                                        MemberContact."Account No." := MemberAccount."No.";
                                    end
                                    else
                                        MemberContact.Get(MemberAccount."No.", MemberAccount."Main Contact");

                                    if ProcessQueryLine(MemberContact, TmpCampaignQueryLine."Query ID") then
                                        InsertLine(MemberContact, Campaign);
                                until MemberAccount.Next = 0;
                        end
                        else begin
                            if MemberContact.FindSet then
                                repeat
                                    if ProcessQueryLine(MemberContact, TmpCampaignQueryLine."Query ID") then
                                        InsertLine(MemberContact, Campaign);
                                until MemberContact.Next = 0;
                        end;
                        TmpCampaignLine.Reset;
                    end
                    else begin
                        if TmpCampaignLine.FindSet then
                            repeat
                                if TmpCampaignLine."Contact No." <> '' then
                                    MemberContact.Get(TmpCampaignLine."Account No.", TmpCampaignLine."Contact No.")
                                else begin
                                    MemberAccount.Get(TmpCampaignLine."Account No.");
                                    Clear(MemberContact);
                                    MemberContact."Account No." := MemberAccount."No.";
                                    MemberContact."Contact No." := MemberAccount."Main Contact";
                                end;
                                if ProcessQueryLine(MemberContact, TmpCampaignQueryLine."Query ID") then begin
                                    TmpCampaignLine."And Found" := true;
                                    TmpCampaignLine.Modify;
                                end;
                            until TmpCampaignLine.Next = 0;

                        TmpCampaignLine.SetRange("And Found", false);
                        TmpCampaignLine.DeleteAll;
                    end;
                    TmpCampaignLine.Reset
                end;
            until TmpCampaignQueryLine.Next = 0;

        NoOfLines := 0;
        TmpCampaignLine.Reset;
        if TmpCampaignLine.FindSet then
            repeat
                CampaignLine := TmpCampaignLine;
                CampaignLine.Insert;
                NoOfLines := NoOfLines + 1;
            until TmpCampaignLine.Next = 0;

        TmpCampaignLine.DeleteAll;
        if NoOfLines = 0 then
            Message(Text009)
        else
            if NoOfLines = 1 then
                Message(Text010)
            else
                Message(Text011, NoOfLines);
    end;
