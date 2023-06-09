page 70655 "O4NJob Task Fact Box"
{
    Caption = 'Job Task Lines';
    DataCaptionFields = "Job No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = CardPart;
    SaveValues = true;
    SourceTable = "Job Task";

    layout
    {
        area(Content)
        {
            field("Schedule Total Cost"; StrSubstNo(PlaceHolderTok, Format(Rec."Schedule (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Schedule (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the schedule (total cost)';
            }
            field("Schedule Total Price"; StrSubstNo(PlaceHolderTok, Format(Rec."Schedule (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Schedule (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the schedule (total price)';
            }
            field("Usage Total Cost"; StrSubstNo(PlaceHolderTok, Format(Rec."Usage (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the usage (total cost)';
            }
            field("Usage Total Price"; StrSubstNo(PlaceHolderTok, Format(Rec."Usage (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the usage (total price)';
            }
            field("Contract Total Cost"; StrSubstNo(PlaceHolderTok, Format(Rec."Contract (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the contract (total cost)';
            }
            field("Contract Total Price"; StrSubstNo(PlaceHolderTok, Format(Rec."Contract (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the contract (total price)';
            }
            field("Contract Invoiced Price"; StrSubstNo(PlaceHolderTok, Format(Rec."Contract (Invoiced Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Invoiced Price)';
                Editable = false;
                ToolTip = 'Specifies the contract (invoiced price)';
            }
            field("Contract Invoiced Cost"; StrSubstNo(PlaceHolderTok, Format(Rec."Contract (Invoiced Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Invoiced Cost)';
                Editable = false;
                ToolTip = 'Specifies the contract (invoiced cost)';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRec();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRec();
    end;

    var
        PlaceHolderTok: Label '(%1)', Locked = true;

    procedure OpenCard()
    var
        JT: Record "Job Task";
    begin
        JT := Rec;
        Page.Run(Page::"Job Task Card", JT);
    end;

    procedure OpenDimensions()
    var
        JobTaskDim: Record "Job Task Dimension";
    begin
        JobTaskDim.FilterGroup(2);
        JobTaskDim.SetRange("Job No.", Rec."Job No.");
        JobTaskDim.SetRange("Job Task No.", Rec."Job Task No.");
        JobTaskDim.FilterGroup(0);
        Page.Run(Page::"Job Task Dimensions", JobTaskDim);
    end;

    procedure OpenLedgerEntries()
    var
        JobLedgerEntries: Record "Job Ledger Entry";
    begin
        JobLedgerEntries.SetRange("Job No.", Rec."Job No.");
        JobLedgerEntries.SetRange("Job Task No.", Rec."Job Task No.");
        Page.Run(Page::"Job Ledger Entries", JobLedgerEntries);
    end;

    procedure OpenPlanningLines()
    var
        JobPlanningLines: Record "Job Planning Line";
    begin
        JobPlanningLines.SetRange("Job No.", Rec."Job No.");
        JobPlanningLines.SetRange("Job Task No.", Rec."Job Task No.");
        Page.Run(Page::"Job Planning Lines", JobPlanningLines);
    end;

    procedure OpenStatistics()
    var
        JT: Record "Job Task";
    begin
        JT := Rec;
        Page.Run(Page::"Job Task Statistics", JT);
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        Rec.CalcFields(
          "Schedule (Total Cost)",
          "Schedule (Total Price)",
          "Usage (Total Cost)",
          "Usage (Total Price)",
          "Contract (Total Cost)",
          "Contract (Total Price)",
          "Contract (Invoiced Price)",
          "Contract (Invoiced Cost)");
    end;
}