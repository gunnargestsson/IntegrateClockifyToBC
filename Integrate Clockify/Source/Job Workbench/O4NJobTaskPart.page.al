page 70652 "O4NJob Task Part"
{
    Caption = 'Job Task Lines';
    DataCaptionFields = "Job No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Job Task";
    UsageCategory = None;

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
                    ToolTip = 'Specifies the number of the related job.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the related job task.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.';
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:';
                }
                field("WIP-Total"; Rec."WIP-Total")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the job tasks you want to group together when calculating Work In Process (WIP) and Recognition.';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an interval or a list of job task numbers.';
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the job posting group of the task.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
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
                    RunObject = page "Job Task Card";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'Job &Task Card';
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
                    ToolTip = 'Job Task Ledger E&ntries';
                }
                action("<Action20>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task &Planning Lines';
                    Image = Planning;
                    RunObject = page "Job Planning Lines";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ToolTip = 'Job Task &Planning Lines';
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
                    ToolTip = 'Job Task &Statistics';
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
                    ToolTip = 'Dimensions';
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
                    ToolTip = 'Edit Planning Lines';

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
                    ToolTip = 'Create Sales Invoice';

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
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action18>_Promoted"; "<Action18>")
                {
                }
                actionref("<Action5>_Promoted"; "<Action5>")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        JobNoOnFormat();
        JobTaskNoOnFormat();
    end;

    var
        Job: Record Customer;
        "Job No.Emphasize": Boolean;
        "Job Task No.Emphasize": Boolean;
        DescriptionIndent: Integer;

    procedure GetCurrentLine(var JobTaskLine: Record "Job Task")
    begin
        JobTaskLine := Rec;
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

    local procedure JobNoOnFormat()
    begin
        "Job No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure JobTaskNoOnFormat()
    begin
        "Job Task No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;
}