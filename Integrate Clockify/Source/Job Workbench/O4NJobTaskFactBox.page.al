page 65237 "O4NJob Task Fact Box"
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
            field("Schedule Total Cost"; StrSubstNo('(%1)', Format(Rec."Schedule (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Schedule (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the value of the Schedule (Total Cost) field';
            }
            field("Schedule Total Price"; StrSubstNo('(%1)', Format(Rec."Schedule (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Schedule (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the value of the Schedule (Total Price) field';
            }
            field("Usage Total Cost"; StrSubstNo('(%1)', Format(Rec."Usage (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the value of the Usage (Total Cost) field';
            }
            field("Usage Total Price"; StrSubstNo('(%1)', Format(Rec."Usage (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the value of the Usage (Total Price) field';
            }
            field("Contract Total Cost"; StrSubstNo('(%1)', Format(Rec."Contract (Total Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Total Cost)';
                Editable = false;
                ToolTip = 'Specifies the value of the Contract (Total Cost) field';
            }
            field("Contract Total Price"; StrSubstNo('(%1)', Format(Rec."Contract (Total Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Total Price)';
                Editable = false;
                ToolTip = 'Specifies the value of the Contract (Total Price) field';
            }
            field("Contract Invoiced Price"; StrSubstNo('(%1)', Format(Rec."Contract (Invoiced Price)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Invoiced Price)';
                Editable = false;
                ToolTip = 'Specifies the value of the Contract (Invoiced Price) field';
            }
            field("Contract Invoiced Cost"; StrSubstNo('(%1)', Format(Rec."Contract (Invoiced Cost)", 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract (Invoiced Cost)';
                Editable = false;
                ToolTip = 'Specifies the value of the Contract (Invoiced Cost) field';
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
