   procedure ProcessDateFilter(FilterIn: Text[250]): Text[250]
    var
        Date: Date;
        DateFormula: DateFormula;
        FirstPart: Text[250];
        LastPart: Text[250];
        Pos: Integer;
        SplitFound: Boolean;
    begin
        FilterIn := UpperCase(FilterIn);
        Pos := StrPos(FilterIn, '.');
        if Pos <> 0 then
            if CopyStr(FilterIn, Pos + 1, 1) = '.' then begin
                if Pos > 1 then
                    FirstPart := CopyStr(FilterIn, 1, Pos - 1);
                if StrLen(FilterIn) > (Pos + 1) then
                    LastPart := CopyStr(FilterIn, Pos + 2);
                SplitFound := true;
            end;

        if SplitFound then begin
            if FirstPart <> '' then
                if not Evaluate(Date, FirstPart) then begin
                    if FirstPart = 'TODAY' then
                        FirstPart := Format(Today)
                    else begin
                        Evaluate(DateFormula, FirstPart);
                        Date := CalcDate(DateFormula, Today);
                        FirstPart := Format(Date);
                    end;
                end
                else
                    FirstPart := Format(Date);

            if LastPart <> '' then
                if not Evaluate(Date, LastPart) then begin
                    if LastPart = 'TODAY' then
                        LastPart := Format(Today)
                    else begin
                        Evaluate(DateFormula, LastPart);
                        Date := CalcDate(DateFormula, Today);
                        LastPart := Format(Date);
                    end;
                end
                else
                    LastPart := Format(Date);
            exit(FirstPart + '..' + LastPart);
        end;

        FirstPart := FilterIn;

        if FirstPart <> '' then
            if not Evaluate(Date, FirstPart) then begin
                if FirstPart = 'TODAY' then
                    FirstPart := Format(Today)
                else begin
                    Evaluate(DateFormula, FirstPart);
                    Date := CalcDate(DateFormula, Today);
                    FirstPart := Format(Date);
                end;
            end
            else
                FirstPart := Format(Date);

        exit(FirstPart);
    end;