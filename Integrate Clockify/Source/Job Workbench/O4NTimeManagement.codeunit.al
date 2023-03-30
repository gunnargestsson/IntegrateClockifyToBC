codeunit 65231 "O4NTime Management"
{
    Permissions = tabledata Employee = r;

    trigger OnRun()
    begin
    end;

    var
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        WeekTxt: Label 'Week %1', Comment = '%1 = week no.';
        QuarterTxt: Label 'Quarter %1/4', Comment = '%1 = quarter no.';
        YearTxt: Label 'Year %1', Comment = '%1 = year no.';
        PeriodTxt: Label '%2 to %3', Comment = 'period, %2 = start date, %3 = end date';
        WeekYearFormatTok: Label '<Week>.<Year4>', Locked = true;
        MonthYearFormatTok: Label '<Month Text,3> <Year4>', Locked = true;
        QuarterYearFormatTok: Label '<Quarter>/<Year4>', Locked = true;
        YearFormatTok: Label '<Year4>', Locked = true;

    procedure CreatePeriodFormat(PeriodType: Option Day,Week,Month,Quarter,Year,Period; Date: Date): Text[10]
    begin
        case PeriodType of
            PeriodType::Day:
                exit(Format(Date));
            PeriodType::Week:
                begin
                    if Date2DWY(Date, 2) = 1 then
                        Date := Date + 7 - Date2DWY(Date, 1);
                    exit(Format(Date, 0, WeekYearFormatTok));
                end;
            PeriodType::Month:
                exit(Format(Date, 0, MonthYearFormatTok));
            PeriodType::Quarter:
                exit(Format(Date, 0, QuarterYearFormatTok));
            PeriodType::Year:
                exit(Format(Date, 0, YearFormatTok));
            PeriodType::Period:
                exit(Format(Date));
        end;
    end;

    procedure DateNotAllowed(PostingDate: Date): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
    begin
        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then
            if UserId() <> '' then
                if UserSetup.Get(UserId()) then begin
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            GLSetup.Get();
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
        end;
        if AllowPostingTo = 0D then
            AllowPostingTo := 99991231D;
        exit((PostingDate < AllowPostingFrom) or (PostingDate > AllowPostingTo));
    end;

    procedure FindDate(SearchString: Text[3]; var Calendar: Record Date; PeriodType: Option Day,Week,Month,Quarter,Year,Period): Boolean
    var
        Found: Boolean;
    begin
        Calendar.SetRange("Period Type", PeriodType);
        Calendar."Period Type" := PeriodType;
        if Calendar."Period Start" = 0D then
            Calendar."Period Start" := WorkDate();
        if SearchString in ['', '=><'] then
            SearchString := '=<>';
        Found := Calendar.Find(SearchString);
        if Found then
            Calendar."Period End" := NormalDate(Calendar."Period End");
        exit(Found);
    end;

    procedure GetFirstDateFilterDate(DateFilter: Text): Date
    var
        Period: Record Date;
        TextManagement: Codeunit "Filter Tokens";
    begin
        TextManagement.MakeDateFilter(DateFilter);
        if DateFilter = '' then
            exit(WorkDate());

        Period.SetRange("Period Type", Period."Period Type"::Date);
        Period.SetFilter("Period Start", DateFilter);
        Period.FindFirst();
        exit(Period."Period Start");
    end;

    procedure GetFirstPeriodDate(DateFilter: Text): Date
    begin
        exit(GetFirstDateFilterDate(DateFilter));
    end;

    procedure GetLastDateFilterDate(DateFilter: Text): Date
    var
        Period: Record Date;
        TextManagement: Codeunit "Filter Tokens";
    begin
        TextManagement.MakeDateFilter(DateFilter);
        if DateFilter = '' then
            exit(WorkDate());

        Period.SetRange("Period Type", Period."Period Type"::Date);
        Period.SetFilter("Period Start", DateFilter);
        Period.FindLast();
        exit(Period."Period Start");
    end;

    procedure GetLastPeriodDate(DateFilter: Text): Date
    begin
        exit(GetLastDateFilterDate(DateFilter));
    end;

    procedure NextDate(NextStep: Integer; var Calendar: Record Date; PeriodType: Option Day,Week,Month,Quarter,Year,Period): Integer
    begin
        Calendar.SetRange("Period Type", PeriodType);
        Calendar."Period Type" := PeriodType;
        NextStep := Calendar.Next(NextStep);
        if NextStep <> 0 then
            Calendar."Period End" := NormalDate(Calendar."Period End");
        exit(NextStep);
    end;

    procedure PeriodNamePrefix(PeriodType: Option Day,Week,Month,Quarter,Year,Period,Undefined): Text[30]
    begin
        case PeriodType of
            PeriodType::Week:
                exit(WeekTxt);
            PeriodType::Quarter:
                exit(QuarterTxt);
            PeriodType::Year:
                exit(YearTxt);
            PeriodType::Undefined:
                exit(PeriodTxt);
            else
                exit('%1');
        end;
    end;

}
