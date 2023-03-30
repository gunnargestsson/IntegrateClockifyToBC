codeunit 65231 "O4NTime Management"
{
    Permissions = tabledata Employee = r;

    trigger OnRun()
    begin
    end;

    var
        PeriodBuf: Record "O4NPeriod Buffer";
        GotSetup: Boolean;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Text003Txt: Label 'Week %1';
        Text004Txt: Label 'Quarter %1/4';
        Text005Txt: Label 'Year %1';
        Text006Txt: Label '%2 to %3';
        Text010Txt: Label '<Week>.<Year4>';
        Text011Txt: Label '<Month Text,3> <Year4>';
        Text012Txt: Label '<Quarter>/<Year4>';
        Text013Txt: Label '<Year4>';

    procedure CreatePeriodFormat(PeriodType: Option Day,Week,Month,Quarter,Year,Period; Date: Date): Text[10]
    begin
        case PeriodType of
            PeriodType::Day:
                exit(Format(Date));
            PeriodType::Week:
                begin
                    if Date2DWY(Date, 2) = 1 then
                        Date := Date + 7 - Date2DWY(Date, 1);
                    exit(Format(Date, 0, Text010Txt));
                end;
            PeriodType::Month:
                exit(Format(Date, 0, Text011Txt));
            PeriodType::Quarter:
                exit(Format(Date, 0, Text012Txt));
            PeriodType::Year:
                exit(Format(Date, 0, Text013Txt));
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
                exit(Text003Txt);
            PeriodType::Quarter:
                exit(Text004Txt);
            PeriodType::Year:
                exit(Text005Txt);
            PeriodType::Undefined:
                exit(Text006Txt);
            else
                exit('%1');
        end;
    end;

    local procedure AddToDateFilterString(var DateFilterString: Text; StartDate: Date; EndDate: Date)
    var
        Customer: Record Customer;
    begin
        if EndDate = 0D then
            Customer.SetRange("Date Filter", StartDate, DMY2Date(31, 12, 9999))
        else
            Customer.SetRange("Date Filter", StartDate, EndDate);
        if DateFilterString = '' then
            DateFilterString := Customer.GetFilter("Date Filter")
        else
            DateFilterString := DateFilterString + '|' + Customer.GetFilter("Date Filter")
    end;

    local procedure CopyPeriodBuf(var Calendar: Record Date)
    begin
        Calendar.Init();
        Calendar."Period Start" := PeriodBuf."Starting Date";
        Calendar."Period Name" := PeriodBuf.Description;
        if PeriodBuf.Next() = 0 then
            Calendar."Period End" := Calendar."Period Start"
        else
            Calendar."Period End" := PeriodBuf."Starting Date" - 1;
    end;

    local procedure GetNoOfDays(FromDate: Date; ToDate: Date): Integer
    begin
        if ToDate = 0D then exit(1);
        exit(1 + (ToDate - FromDate));
    end;

    local procedure GetSetup()
    begin
        GotSetup := true;
    end;

    local procedure SetPeriodBufFilter(var Calendar: Record Date)
    begin
        PeriodBuf.SetFilter("Starting Date", Calendar.GetFilter("Period Start"));
        PeriodBuf.SetFilter(Description, Calendar.GetFilter("Period Name"));
        PeriodBuf."Starting Date" := Calendar."Period Start";
    end;
}
