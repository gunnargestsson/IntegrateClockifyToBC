codeunit 70650 "O4N TimeSheet Mgt"
{
    var
        DateMissingErr: Label '%1 must be filled in.', Comment = '%1 = data that is missing';
        NotTimeSheetAdminErr: Label 'Time sheet administrator only is allowed to create time sheets.';
        StartingDateLbl: Label 'Starting Date';

    procedure ApprovePendingTimeSheet()
    var
        TimeSheet: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        TimeSheet.SetRange("Open Exists", true);
        TimeSheet.SetFilter("Ending Date", '<=%1', WorkDate());
        if TimeSheet.FindSet() then
            repeat
                TimeSheetMgt.SetTimeSheetNo(TimeSheet."No.", TimeSheetLine);
                if TimeSheetLine.FindSet(true) then
                    repeat
                        TimeSheetApprovalMgt.Submit(TimeSheetLine);
                        TimeSheetApprovalMgt.Approve(TimeSheetLine);
                    until TimeSheetLine.Next() = 0;
            until TimeSheet.Next() = 0;
    end;

    procedure ArchivePostedTimeSheet()
    var
        TimeSheet: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        TimeSheet.SetRange("Open Exists", false);
        TimeSheet.SetFilter("Ending Date", '<%1', WorkDate());
        if TimeSheet.FindSet() then
            repeat
                TimeSheetLine.SetRange("Time Sheet No.", TimeSheet."No.");
                TimeSheetLine.SetRange(Posted);
                if TimeSheetLine.IsEmpty then
                    TimeSheet.Delete(true)
                else begin
                    TimeSheetLine.SetRange(Posted, false);
                    if TimeSheetLine.IsEmpty() then
                        TimeSheetMgt.MoveTimeSheetToArchive(TimeSheet);
                end;
            until TimeSheet.Next() = 0;
    end;

    procedure CreateTimeSheet()
    var
        Resource: Record Resource;
        ResourcesSetup: Record "Resources Setup";
        TimeSheet: Record "Time Sheet Header";
        TimeSheetHeader: Record "Time Sheet Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EndingDate: Date;
        StartingDate: Date;
    begin
        Resource.SetRange(Blocked, false);
        Resource.SetRange("Use Time Sheet", true);
        if Resource.FindSet() then
            repeat
                TimeSheet.SetRange("Owner User ID", Resource."Time Sheet Owner User ID");
                if TimeSheet.FindLast() then
                    while TimeSheet.Count() < 4 do begin
                        ResourcesSetup.Get();
                        ResourcesSetup.TestField("Time Sheet Nos.");
                        StartingDate := TimeSheet."Ending Date" + 1;
                        EndingDate := CalcDate('<CW>', StartingDate);
                        VerifyTimeSheetAdmin(StartingDate);
                        TimeSheetHeader.Init();
                        TimeSheetHeader."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", StartingDate, true);
                        TimeSheetHeader."Starting Date" := StartingDate;
                        TimeSheetHeader."Ending Date" := EndingDate;
                        TimeSheetHeader.Validate("Resource No.", Resource."No.");
                        TimeSheetHeader.Insert(true);
                    end;
            until Resource.Next() = 0;
    end;

    procedure OpenCurrentTimeSheet()
    var
        TimeSheet: Record "Time Sheet Header";
    begin
        TimeSheet.SetRange("Owner User ID", UserId());
        TimeSheet.SetFilter("Starting Date", '<%1', WorkDate());
        if not TimeSheet.FindLast() then exit;
        Page.Run(Page::"Time Sheet Card", TimeSheet);
    end;

    procedure PostApprovedTimeSheet()
    var
        JobJnlBatch: Record "Job Journal Batch";
        JobJnlLine: Record "Job Journal Line";
        JobJnlTemplate: Record "Job Journal Template";
        TimeSheetDetail: Record "Time Sheet Detail";
        TimeSheetHeader: Record "Time Sheet Header";
        TempTimeSheetLine: Record "Time Sheet Line" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextDocNo: Code[20];
        QtyToPost: Decimal;
    begin
        JobJnlTemplate.SetRange("Page ID", Page::"Job Journal");
        JobJnlTemplate.SetRange(Recurring, false);
        JobJnlTemplate.FindFirst();
        JobJnlBatch.SetRange("Journal Template Name", JobJnlTemplate.Name);
#pragma warning disable AA0210
        JobJnlBatch.SetFilter("No. Series", '<>%1', '');
#pragma warning restore AA0210
        JobJnlBatch.FindFirst();
        FillTimeSheetLineBuffer(TempTimeSheetLine);

        if TempTimeSheetLine.FindSet() then begin
            JobJnlLine.LockTable();
            if JobJnlBatch."No. Series" = '' then
                NextDocNo := ''
            else
                NextDocNo := NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series", TempTimeSheetLine."Time Sheet Starting Date", false);

            repeat
                TimeSheetHeader.Get(TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SetRange("Time Sheet No.", TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SetRange("Time Sheet Line No.", TempTimeSheetLine."Line No.");
                TimeSheetDetail.SetFilter(Quantity, '<>0');
                TimeSheetDetail.SetRange(Posted, false);
                if TimeSheetDetail.FindSet() then
                    repeat
                        QtyToPost := TimeSheetDetail.GetMaxQtyToPost();
                        if QtyToPost <> 0 then begin
                            JobJnlLine.Init();
                            JobJnlLine."Journal Template Name" := JobJnlBatch."Journal Template Name";
                            JobJnlLine."Journal Batch Name" := JobJnlBatch.Name;
                            JobJnlLine."Time Sheet No." := TimeSheetDetail."Time Sheet No.";
                            JobJnlLine."Time Sheet Line No." := TimeSheetDetail."Time Sheet Line No.";
                            JobJnlLine."Time Sheet Date" := TimeSheetDetail.Date;
                            JobJnlLine.Validate("Line Type", JobJnlLine."Line Type"::"Both Budget and Billable");
                            JobJnlLine.Validate("Job No.", TimeSheetDetail."Job No.");
                            JobJnlLine."Source Code" := JobJnlTemplate."Source Code";
                            if TimeSheetDetail."Job Task No." <> '' then
                                JobJnlLine.Validate("Job Task No.", TimeSheetDetail."Job Task No.");
                            JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
                            JobJnlLine.Validate("No.", TimeSheetHeader."Resource No.");
                            if TempTimeSheetLine."Work Type Code" <> '' then
                                JobJnlLine.Validate("Work Type Code", TempTimeSheetLine."Work Type Code");
                            JobJnlLine.Validate("Posting Date", TimeSheetDetail.Date);
                            JobJnlLine."Document No." := NextDocNo;
                            NextDocNo := IncStr(NextDocNo);
                            JobJnlLine."Posting No. Series" := JobJnlBatch."Posting No. Series";
                            JobJnlLine.Description := TempTimeSheetLine.Description;
                            JobJnlLine.Validate(Quantity, QtyToPost);
                            JobJnlLine.Validate(Chargeable, TempTimeSheetLine.Chargeable);
                            JobJnlLine."Reason Code" := JobJnlBatch."Reason Code";
                            Codeunit.Run(Codeunit::"Job Jnl.-Post Line", JobJnlLine);
                        end;
                    until TimeSheetDetail.Next() = 0;
            until TempTimeSheetLine.Next() = 0;
        end;
    end;

    local procedure FillTimeSheetLineBuffer(var TempTimeSheetLine: Record "Time Sheet Line" temporary)
    var
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
    begin
        if TimeSheetHeader.FindSet() then
            repeat
                TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
                TimeSheetLine.SetRange(Type, TimeSheetLine.Type::Job);
                TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Approved);
                TimeSheetLine.SetRange(Posted, false);
                if TimeSheetLine.FindSet() then
                    repeat
                        TempTimeSheetLine := TimeSheetLine;
                        TempTimeSheetLine.Insert();
                    until TimeSheetLine.Next() = 0;
            until TimeSheetHeader.Next() = 0;
    end;

    local procedure VerifyTimeSheetAdmin(StartingDate: Date)
    var
        AccountingPeriod: Record "Accounting Period";
        UserSetup: Record "User Setup";
        FirstAccPeriodStartingDate: Date;
        LastAccPeriodStartingDate: Date;
    begin
        if (not UserSetup.Get(UserId()) or not UserSetup."Time Sheet Admin.") and UserSetup.WritePermission() then
            Error('');

        if not UserSetup."Time Sheet Admin." then
            Error(NotTimeSheetAdminErr);

        if StartingDate = 0D then
            Error(DateMissingErr, StartingDateLbl);

        if AccountingPeriod.IsEmpty() then begin
            FirstAccPeriodStartingDate := CalcDate('<-CM>', StartingDate);
            LastAccPeriodStartingDate := CalcDate('<CM>', StartingDate);
        end else begin
            AccountingPeriod.SetFilter("Starting Date", '..%1', StartingDate);
            AccountingPeriod.FindLast();
            FirstAccPeriodStartingDate := AccountingPeriod."Starting Date";

            AccountingPeriod.SetFilter("Starting Date", '..%1', StartingDate);
            AccountingPeriod.FindLast();
            LastAccPeriodStartingDate := AccountingPeriod."Starting Date";

            AccountingPeriod.SetRange("Starting Date", FirstAccPeriodStartingDate, LastAccPeriodStartingDate);
            AccountingPeriod.FindSet();
            repeat
                AccountingPeriod.TestField(Closed, false);
            until AccountingPeriod.Next() = 0;
        end;
    end;
}