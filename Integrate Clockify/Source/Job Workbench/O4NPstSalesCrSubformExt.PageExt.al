pageextension 65215 "O4NPstSalesCrSubformExt" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addbefore(Description)
        {
            field(TimeSheetDate; JobWorkbenchMgt.FindJobContractEntryNoDate(Rec."Job Contract Entry No."))
            {
                ApplicationArea = All;
                Caption = 'Time Sheet Date';
                Editable = false;
                ToolTip = 'Specifies the date of the time sheet entry that resulted in this sales line';
            }
        }
    }

    actions
    {
    }
    var
        JobWorkbenchMgt: Codeunit "O4N Job Workbench Mgt.";
}
