codeunit 65211 "O4N Job Workbench Mgt."
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
}