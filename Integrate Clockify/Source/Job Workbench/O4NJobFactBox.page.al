page 65234 "O4NJob Fact Box"
{
    Caption = 'Job Fact Box';
    Editable = false;
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(Content)
        {
            field("StrSubstNo('(%1)',LedgerEntriesCount)"; StrSubstNo('(%1)', LedgerEntriesCount()))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger E&ntries';
                Editable = false;
                ToolTip = 'Specifies the value of the Ledger E&ntries field';

                trigger OnDrillDown()
                begin
                    LedgerEntriesLookup();
                end;
            }
            field("StrSubstNo('(%1)',Format(CL[8],0,'<Integer Thousand><Sign>'))"; StrSubstNo('(%1)', Format(CL[8], 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Used Cost (LCY)';
                Editable = false;
                ToolTip = 'Specifies the value of the Used Cost (LCY) field';
            }
            field("StrSubstNo('(%1)',Format(CL[12],0,'<Integer Thousand><Sign>'))"; StrSubstNo('(%1)', Format(CL[12], 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract Cost (LCY)';
                Editable = false;
                ToolTip = 'Specifies the value of the Contract Cost (LCY) field';
            }
            field("StrSubstNo('(%1)',Format(CL[16],0,'<Integer Thousand><Sign>'))"; StrSubstNo('(%1)', Format(CL[16], 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoiced Cost (LCY)';
                Editable = false;
                ToolTip = 'Specifies the value of the Invoiced Cost (LCY) field';
            }
            field("StrSubstNo('(%1)',Format(PL[16],0,'<Integer Thousand><Sign>'))"; StrSubstNo('(%1)', Format(PL[16], 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoiced Price (LCY)';
                ToolTip = 'Specifies the value of the Invoiced Price (LCY) field';
            }
            field("StrSubstNo('(%1)',Format(PL[16]-CL[16],0,'<Integer Thousand><Sign>'))"; StrSubstNo('(%1)', Format(PL[16] - CL[16], 0, '<Integer Thousand><Sign>')))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoiced Profit (LCY)';
                ToolTip = 'Specifies the value of the Invoiced Profit (LCY) field';
            }
            group("Planning Lines in Period")
            {
                Caption = 'Planning Lines in Period';
                field("StrSubstNo('(%1)',PlanningLineCount[1])"; StrSubstNo('(%1)', PlanningLineCount[1]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines';
                    ToolTip = 'Specifies the value of the No. of Lines field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[2])"; StrSubstNo('(%1)', PlanningLineCount[2]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines not Transferred';
                    ToolTip = 'Specifies the value of the No. of Lines not Transferred field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[3])"; StrSubstNo('(%1)', PlanningLineCount[3]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines Transferred';
                    ToolTip = 'Specifies the value of the No. of Lines Transferred field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[4])"; StrSubstNo('(%1)', PlanningLineCount[4]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines not Invoiced';
                    ToolTip = 'Specifies the value of the No. of Lines not Invoiced field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[5])"; StrSubstNo('(%1)', PlanningLineCount[5]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines Invoiced';
                    ToolTip = 'Specifies the value of the No. of Lines Invoiced field';
                }
            }
            group("Other Planning Lines")
            {
                Caption = 'Other Planning Lines';
                field("StrSubstNo('(%1)',PlanningLineCount[6])"; StrSubstNo('(%1)', PlanningLineCount[6]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines';
                    ToolTip = 'Specifies the value of the No. of Lines field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[7])"; StrSubstNo('(%1)', PlanningLineCount[7]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines not Transferred';
                    ToolTip = 'Specifies the value of the No. of Lines not Transferred field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[8])"; StrSubstNo('(%1)', PlanningLineCount[8]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines Transferred';
                    ToolTip = 'Specifies the value of the No. of Lines Transferred field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[9])"; StrSubstNo('(%1)', PlanningLineCount[9]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines not Invoiced';
                    ToolTip = 'Specifies the value of the No. of Lines not Invoiced field';
                }
                field("StrSubstNo('(%1)',PlanningLineCount[10])"; StrSubstNo('(%1)', PlanningLineCount[10]))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Lines Invoiced';
                    ToolTip = 'Specifies the value of the No. of Lines Invoiced field';
                }
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
        Job: Record Job;
        JobPlanningLines: Record "Job Planning Line";
        JobCalcStatistics: Codeunit "Job Calculate Statistics";
        CL: array[16] of Decimal;
        PL: array[16] of Decimal;
        PlanningLineCount: array[10] of Integer;

    procedure CommentsExists(): Boolean
    begin
        Rec.CalcFields(Comment);
        exit(Rec.Comment);
    end;

    procedure CopyFilters(var Job: Record Job)
    begin
        Job.Reset();
        Job.Copy(Rec);
    end;

    procedure GetCurrentLine(var Job: Record Job)
    begin
        Job := Rec;
    end;

    procedure LedgerEntriesCount(): Integer
    var
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        JobLedgerEntry.SetRange("Job No.", Rec."No.");
        exit(JobLedgerEntry.Count());
    end;

    procedure LedgerEntriesLookup()
    var
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        JobLedgerEntry.SetRange("Job No.", Rec."No.");
        Page.Run(Page::"Job Ledger Entries", JobLedgerEntry);
    end;

    procedure OpenCard()
    begin
        Job := Rec;
        Page.Run(Page::"Job Card", Job);
    end;

    procedure OpenComment()
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.FilterGroup(2);
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Job);
        CommentLine.SetRange("No.", Rec."No.");
        CommentLine.FilterGroup(0);
        Page.Run(Page::"Comment Sheet", CommentLine);
    end;

    procedure OpenDimensions()
    var
        DefDim: Record "Default Dimension";
    begin
        DefDim.FilterGroup(2);
        DefDim.SetRange("Table ID", Database::Customer);
        DefDim.SetRange("No.", Rec."No.");
        DefDim.FilterGroup(0);
        Page.Run(Page::"Default Dimensions", DefDim);
    end;

    procedure OpenStatistics()
    begin
        Job := Rec;
        Page.Run(Page::"Job Statistics", Job);
    end;

    procedure SetSelectionFilter(var Job: Record Job)
    begin
        Job.Reset();
        CurrPage.SetSelectionFilter(Job);
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        Clear(JobCalcStatistics);
        JobCalcStatistics.JobCalculateCommonFilters(Rec);
        JobCalcStatistics.CalculateAmounts();
        JobCalcStatistics.GetLCYCostAmounts(CL);
        JobCalcStatistics.GetLCYPriceAmounts(PL);
        JobPlanningLines.Reset();
        JobPlanningLines.SetCurrentKey("Job No.", "Contract Line");
        JobPlanningLines.SetRange("Job No.", Rec."No.");

        PlanningLineCount[6] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Contract Line", true);
        JobPlanningLines.SetFilter("Qty. to Transfer to Invoice", '<>%1', 0);
        PlanningLineCount[7] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Transfer to Invoice", 0);
        PlanningLineCount[8] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Transfer to Invoice");
        JobPlanningLines.SetFilter("Qty. to Invoice", '<>%1', 0);
        PlanningLineCount[9] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Invoice", 0);
        PlanningLineCount[10] := JobPlanningLines.Count();

        Job.Copy(Rec);
        Job.FilterGroup(4);
        Job.CopyFilter("Planning Date Filter", JobPlanningLines."Planning Date");
        Job.FilterGroup(0);

        JobPlanningLines.SetRange("Qty. Invoiced");
        PlanningLineCount[1] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Contract Line", true);
        JobPlanningLines.SetFilter("Qty. to Transfer to Invoice", '<>%1', 0);
        PlanningLineCount[2] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Transfer to Invoice", 0);
        PlanningLineCount[3] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Transfer to Invoice");
        JobPlanningLines.SetFilter("Qty. to Invoice", '<>%1', 0);
        PlanningLineCount[4] := JobPlanningLines.Count();
        JobPlanningLines.SetRange("Qty. to Invoice", 0);
        PlanningLineCount[5] := JobPlanningLines.Count();

        PlanningLineCount[6] := PlanningLineCount[6] - PlanningLineCount[1];
        PlanningLineCount[7] := PlanningLineCount[7] - PlanningLineCount[2];
        PlanningLineCount[8] := PlanningLineCount[8] - PlanningLineCount[3];
        PlanningLineCount[9] := PlanningLineCount[9] - PlanningLineCount[4];
        PlanningLineCount[10] := PlanningLineCount[10] - PlanningLineCount[5];
    end;
}
