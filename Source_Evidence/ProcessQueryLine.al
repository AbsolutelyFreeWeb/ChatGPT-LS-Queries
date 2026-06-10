    procedure ProcessQueryLine(MemberContact: Record "LSC Member Contact"; QueryId: Code[10]): Boolean
    var
        DynamicQuery: Record "LSC Dynamic Query";
        DynamicQueryLine: Record "LSC Dynamic Query Line";
        AccountRec: Record "LSC Member Account";
        "Contact Rec": Record "LSC Member Contact";
        FieldRec: Record "Field";
        ParRecRef: RecordRef;
        DataRecRef: RecordRef;
        ParField: FieldRef;
        DataField: FieldRef;
        CurrValue: Text[30];
        Decimal: Decimal;
        DecValue: Decimal;
        DecimalField: Boolean;
        CompareBoolean: Boolean;
    begin
        if not DynamicQuery.Get(DynamicQuery.Type::Campaign, QueryId) then
            exit(false);

        if DynamicQuery."In Parameter" = DynamicQuery."In Parameter"::Account then begin
            AccountRec.Get(MemberContact."Account No.");
            ParRecRef.GetTable(AccountRec);
        end
        else begin
            if MemberContact."Contact No." = '' then
                exit(false);
            "Contact Rec".Get(MemberContact."Account No.", MemberContact."Contact No.");
            ParRecRef.GetTable("Contact Rec");
        end;

        DataRecRef.Open(DynamicQuery."Table ID");
        if DynamicQuery."System Key" <> 0 then
            DataRecRef.CurrentKeyIndex(DynamicQuery."System Key");

        DynamicQueryLine.SetRange(Type, DynamicQuery.Type);
        DynamicQueryLine.SetRange("Query ID", DynamicQuery."Query ID");
        DynamicQueryLine.SetRange("Table Id", DynamicQuery."Table ID");
        if DynamicQueryLine.FindSet then
            repeat
                DataField := DataRecRef.Field(DynamicQueryLine."Field No.");

                if DynamicQueryLine."Filter Type" = DynamicQueryLine."Filter Type"::Filter then begin
                    FieldRec.Get(DynamicQueryLine."Table Id", DynamicQueryLine."Field No.");
                    if FieldRec.Type = FieldRec.Type::Date then
                        DataField.SetFilter(ProcessDateFilter(DynamicQueryLine."Filter Value"))
                    else
                        if UpperCase(DynamicQueryLine."Filter Value") = 'BIRTHDAY' then
                            DataField.SetFilter(GetBirthDay(Today))
                        else
                            DataField.SetFilter(DynamicQueryLine."Filter Value");
                end
                else begin
                    ParField := ParRecRef.Field(DynamicQueryLine."Filter Field No.");
                    DataField.SetRange(ParField.Value);
                end;
            until DynamicQueryLine.Next = 0;

        case DynamicQuery."Result Type" of
            DynamicQuery."Result Type"::Sum:
                begin
                    DecimalField := true;
                    DataField := DataRecRef.Field(DynamicQuery."Result Field No.");

                    if not DataField.CalcSum then begin
                        if DataRecRef.FindSet then
                            repeat
                                DataField := DataRecRef.Field(DynamicQuery."Result Field No.");
                                Decimal := DataField.Value;
                                DecValue := DecValue + Decimal;
                            until DataRecRef.Next = 0;
                        CurrValue := FormatAmount(DecValue);
                    end
                    else begin
                        Decimal := DataField.Value;
                        CurrValue := FormatAmount(Decimal);
                    end;
                end;
            DynamicQuery."Result Type"::Count:
                begin
                    CurrValue := Format(DataRecRef.Count);
                    DecimalField := true;
                end;
            DynamicQuery."Result Type"::Exists:
                CurrValue := Format(DataRecRef.FindFirst);
        end;

        if DecimalField then
            DynamicQuery."Compare Value" := FormatTextAmount(DynamicQuery."Compare Value")
        else begin
            Evaluate(CompareBoolean, DynamicQuery."Compare Value");
            DynamicQuery."Compare Value" := Format(CompareBoolean);
        end;

        case DynamicQuery.Condition of
            DynamicQuery.Condition::"=":
                if CurrValue = DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
            DynamicQuery.Condition::"<":
                if CurrValue < DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
            DynamicQuery.Condition::">":
                if CurrValue > DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
            DynamicQuery.Condition::"<=":
                if CurrValue <= DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
            DynamicQuery.Condition::">=":
                if CurrValue >= DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
            DynamicQuery.Condition::"<>":
                if CurrValue <> DynamicQuery."Compare Value" then
                    exit(true)
                else
                    exit(false);
        end;
    end;
