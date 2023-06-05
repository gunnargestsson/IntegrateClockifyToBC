codeunit 70651 "O4N Job Workbench Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        DiscPercentTxt: Label 'Discount Percent ';
        PercentToApplyTxt: Label 'Discount Precentage to apply to Job Planning Lines';

    procedure ApplyDiscount(var JobPlanningLine: Record "Job Planning Line")
    var
        InputDialog: Page "O4N Input Dialog";
        Discount2Apply: Decimal;
    begin
        InputDialog.Caption := PercentToApplyTxt;
        InputDialog.SetFieldCaption(DiscPercentTxt);
        InputDialog.SetFieldVisible(0);
        InputDialog.LookupMode := true;
        if InputDialog.RunModal() <> Action::LookupOK then exit;
        InputDialog.GetAmount(Discount2Apply);

        JobPlanningLine.LockTable();
        if JobPlanningLine.Find('-') then
            repeat
                JobPlanningLine.Validate("Line Discount %", Discount2Apply);
                JobPlanningLine.Modify();
            until JobPlanningLine.Next() = 0;
    end;

    procedure FindJobContractEntryNoDate(JobContractEntryNo: Integer): Date
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        if JobContractEntryNo = 0 then exit(0D);
        JobPlanningLine.SetCurrentKey("Job Contract Entry No.");
        JobPlanningLine.SetRange("Job Contract Entry No.", JobContractEntryNo);
        if JobPlanningLine.FindFirst() then
            exit(JobPlanningLine."Document Date");
    end;

}