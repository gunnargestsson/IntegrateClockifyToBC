page 65227 "O4NJob Task Part"
{
    Caption = 'Job Task Lines';
    DataCaptionFields = "Job No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Job Task";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowCaption = false;
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job No. field';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job Task No. field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job Task Type field';
                }
                field("WIP-Total"; Rec."WIP-Total")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the WIP-Total field';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Totaling field';
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job Posting Group field';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field';
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(Control1200050001; "O4NJob Task Fact Box")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Job No." = field("Job No."),
                              "Job Task No." = field("Job Task No."),
                              "Posting Date Filter" = field("Posting Date Filter"),
                              "Planning Date Filter" = field("Planning Date Filter");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("<Action56>")
            {
                Caption = '&Job Task';
                action("<Action18>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job &Task Card';
                    Image = JobJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Job Task Card";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'Executes the Job &Task Card action';
                }
                action("<Action6>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = page "Job Ledger Entries";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    RunPageView = sorting("Job No.", "Job Task No.");
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Job Task Ledger E&ntries action';
                }
                action("<Action20>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task &Planning Lines';
                    Image = Planning;
                    RunObject = page "Job Planning Lines";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ToolTip = 'Executes the Job Task &Planning Lines action';
                }
                action("<Action16>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task &Statistics';
                    Image = Statistics;
                    RunObject = page "Job Task Statistics";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ShortcutKey = 'F7';
                    ToolTip = 'Executes the Job Task &Statistics action';
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("<Action66>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = page "Job Task Dimensions";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action';
                }
            }
            group("<Action46>")
            {
                Caption = 'W&IP';
                action("<Action48>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    ToolTip = 'Executes the Calculate WIP action';

                    trigger OnAction()
                    var
                        Job: Record Customer;
                    begin
                        Rec.TestField("Job No.");
                        Job.Get(Rec."Job No.");
                        Job.SetRange("No.", Job."No.");
                        Report.RunModal(Report::"Job Calculate WIP", true, false, Job);
                    end;
                }
                action("<Action49>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;
                    ToolTip = 'Executes the Post WIP to G/L action';

                    trigger OnAction()
                    var
                        Job: Record Customer;
                    begin
                        Rec.TestField("Job No.");
                        Job.Get(Rec."Job No.");
                        Job.SetRange("No.", Job."No.");
                        Report.RunModal(Report::"Job Post WIP to G/L", true, false, Job);
                    end;
                }
                action("<Action10>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'WIP Entries';
                    Image = WIPEntries;
                    RunObject = page "Job WIP Entries";
                    RunPageLink = "Job No." = field("Job No.");
                    RunPageView = sorting("Job No.", "Job Posting Group", "WIP Posting Date");
                    ToolTip = 'Executes the WIP Entries action';
                }
                action("<Action14>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'WIP G/L Entries';
                    Image = WIPLedger;
                    RunObject = page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = field("Job No.");
                    RunPageView = sorting("Job No.");
                    ToolTip = 'Executes the WIP G/L Entries action';
                }
            }
        }
        area(Processing)
        {
            group("<Action4>")
            {
                Caption = 'F&unctions';
                action("<Action5>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit Planning Lines';
                    Ellipsis = true;
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Edit Planning Lines action';

                    trigger OnAction()
                    var
                        JT: Record "Job Task";
                    begin
                        Rec.TestField("Job Task Type", Rec."Job Task Type"::Posting);
                        Rec.TestField("Job No.");
                        Job.Get(Rec."Job No.");
                        Rec.TestField("Job Task No.");
                        JT.Get(Rec."Job No.", Rec."Job Task No.");
                        JT.FilterGroup := 2;
                        JT.SetRange("Job No.", Rec."Job No.");
                        JT.SetRange("Job Task Type", JT."Job Task Type"::Posting);
                        JT.FilterGroup := 0;
                        Page.RunModal(Page::"Job Planning Lines", JT);
                    end;
                }
                action("<Action15>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;
                    ToolTip = 'Executes the Create Sales Invoice action';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JT: Record "Job Task";
                    begin
                        Rec.TestField("Job No.");
                        Job.Get(Rec."Job No.");
                        if Job.Blocked = Job.Blocked::All then
                            Job.TestBlocked();

                        JT := Rec;
                        JT.SetRange("Job No.", Job."No.");
                        Report.RunModal(Report::"Job Create Sales Invoice", true, false, JT);
                    end;
                }
                action("<Action17>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Split Planning Lines';
                    Ellipsis = true;
                    Image = Splitlines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Split Planning Lines action';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JT: Record "Job Task";
                    begin
                        Rec.TestField("Job No.");
                        Rec.TestField("Job Task No.");
                        JT := Rec;
                        Job.Get(Rec."Job No.");
                        if Job.Blocked = Job.Blocked::All then
                            Job.TestBlocked();
                        JT.SetRange("Job No.", Job."No.");
                        JT.SetRange("Job Task No.", Rec."Job Task No.");

                        Report.RunModal(Report::"Job Split Planning Line", true, false, JT);
                    end;
                }
                action("<Action22>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change &Dates';
                    Ellipsis = true;
                    Image = ChangeDates;
                    ToolTip = 'Executes the Change &Dates action';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JT: Record "Job Task";
                    begin
                        Rec.TestField("Job No.");
                        Job.Get(Rec."Job No.");
                        if Job.Blocked = Job.Blocked::All then
                            Job.TestBlocked();
                        JT.SetRange("Job No.", Job."No.");
                        JT.SetRange("Job Task No.", Rec."Job Task No.");
                        Report.RunModal(Report::"Change Job Dates", true, false, JT);
                    end;
                }
                action("<Action7>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Indent Job Tasks';
                    Image = Job;
                    RunObject = codeunit "Job Task-Indent";
                    ToolTip = 'Executes the Indent Job Tasks action';
                }
            }
        }
        area(Reporting)
        {
            action("<Action1903776506>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Actual to Budget';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Actual To Budget";
                ToolTip = 'Executes the Job Actual to Budget action';
            }
            action("<Action1901542506>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Analysis";
                ToolTip = 'Executes the Job Analysis action';
            }
            action("<Action1902943106>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job - Planning Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job - Planning Lines";
                ToolTip = 'Executes the Job - Planning Lines action';
            }
            action("<Action1903186006>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job - Suggested Billing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Suggested Billing";
                ToolTip = 'Executes the Job - Suggested Billing action';
            }
            action("<Action1905285006>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Jobs - Transaction Detail';
                Image = "Report";
                Promoted = false;
                RunObject = report "Job - Transaction Detail";
                ToolTip = 'Executes the Jobs - Transaction Detail action';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        JobNoOnFormat();
        JobTaskNoOnFormat();
        DescriptionOnFormat();
    end;

    var
        Job: Record Customer;
        DescriptionEmphasize: Boolean;
        "Job No.Emphasize": Boolean;
        "Job Task No.Emphasize": Boolean;
        DescriptionIndent: Integer;

    procedure GetCurrentLine(var JobTaskLine: Record "Job Task")
    begin
        JobTaskLine := Rec;
    end;

    procedure SetSelectionFilter(var JobTaskLine: Record "Job Task")
    begin
        JobTaskLine.Reset();
        CurrPage.SetSelectionFilter(JobTaskLine);
    end;

    procedure SetView(var Workbench: Record "O4N Job Workbench")
    begin
        Workbench.CopyFilter("Job No. Filter", Rec."Job No.");
        Workbench.CopyFilter("Job Task No. Filter", Rec."Job Task No.");
        Workbench.CopyFilter("Global Dimension 1 Filter", Rec."Global Dimension 1 Code");
        Workbench.CopyFilter("Global Dimension 2 Filter", Rec."Global Dimension 2 Code");
        Workbench.CopyFilter("Date Filter", Rec."Posting Date Filter");
        Workbench.CopyFilter("Date Filter", Rec."Planning Date Filter");
    end;

    local procedure CopyFilters(var JobTaskLine: Record "Job Task")
    begin
        JobTaskLine.Reset();
        JobTaskLine.Copy(Rec);
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Rec.Indentation;
        DescriptionEmphasize := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure JobNoOnFormat()
    begin
        "Job No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure JobTaskNoOnFormat()
    begin
        "Job Task No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure OpenCard()
    var
        JT: Record "Job Task";
    begin
        JT := Rec;
        Page.Run(Page::"Job Task Card", JT);
    end;

    local procedure OpenDimensions()
    var
        JobTaskDim: Record "Job Task Dimension";
    begin
        JobTaskDim.FilterGroup(2);
        JobTaskDim.SetRange("Job No.", Rec."Job No.");
        JobTaskDim.SetRange("Job Task No.", Rec."Job Task No.");
        JobTaskDim.FilterGroup(0);
        Page.Run(Page::"Job Task Dimensions", JobTaskDim);
    end;

    local procedure OpenLedgerEntries()
    var
        JobLedgerEntries: Record "Job Ledger Entry";
    begin
        JobLedgerEntries.SetRange("Job No.", Rec."Job No.");
        JobLedgerEntries.SetRange("Job Task No.", Rec."Job Task No.");
        Page.Run(Page::"Job Ledger Entries", JobLedgerEntries);
    end;

    local procedure OpenPlanningLines()
    var
        JobPlanningLines: Record "Job Planning Line";
    begin
        JobPlanningLines.SetRange("Job No.", Rec."Job No.");
        JobPlanningLines.SetRange("Job Task No.", Rec."Job Task No.");
        Page.Run(Page::"Job Planning Lines", JobPlanningLines);
    end;

    local procedure OpenStatistics()
    var
        JT: Record "Job Task";
    begin
        JT := Rec;
        Page.Run(Page::"Job Task Statistics", JT);
    end;
}
