page 65226 "O4NJob Workbench"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Job Workbench';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Job;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group("General Filters")
            {
                Caption = 'General Filters';
                field(PeriodTypeField; PeriodType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Period Type';
                    Importance = Promoted;
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies the period type';
                    ValuesAllowed = Day, Week, Month, Quarter, Year, Period;

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                    end;
                }
                field(DateFilterField; DateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date Filter';
                    Importance = Promoted;
                    ToolTip = 'Specifies the date filter';

                    trigger OnValidate()
                    begin
                        TextManagement.MakeDateFilter(DateFilter);

                        Workbench.SetFilter("Date Filter", DateFilter);
                        DateFilter := Workbench.GetFilter("Date Filter");
                        OnAfterModifyFilter();
                    end;
                }
            }
            group("Job Filters")
            {
                Caption = 'Job Filters';
                field(JobNoFilterField; JobNoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job No. Filter';
                    Importance = Additional;
                    TableRelation = Customer;
                    ToolTip = 'Specifies the job no. filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(JobTaskNoFilterField; JobTaskNoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task No. Filter';
                    Importance = Additional;
                    TableRelation = "Job Task"."Job Task No." where("Job No." = field("No."));
                    ToolTip = 'Specifies the job task no. filter';

                    trigger OnValidate()
                    begin
                        Workbench.SetFilter("Job Task No. Filter", JobTaskNoFilter);
                        JobTaskNoFilter := Workbench.GetFilter("Job Task No. Filter");
                    end;
                }
                field(StatusFilterField; StatusFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Status Filter';
                    Importance = Additional;
                    OptionCaption = ' ,Planning,Quote,Order,Completed';
                    ToolTip = 'Specifies the status filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(DescriptionFilterField; DescriptionFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description Filter';
                    Importance = Additional;
                    ToolTip = 'Specifies the description filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(UpcomingInvoiceFilterField; UpcomingInvoiceFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Upcoming Invoice Filter';
                    Importance = Promoted;
                    OptionCaption = ' ,Yes,No';
                    ToolTip = 'Specifies the upcoming invoice filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(PersonResponsibleFilterField; PersonResponsibleFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Person Responsible Filter';
                    Importance = Additional;
                    TableRelation = Resource;
                    ToolTip = 'Specifies the person responsible filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(BilltoCustomerNoFilterField; BilltoCustomerNoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bill-to Customer No. Filter';
                    Importance = Additional;
                    TableRelation = Customer;
                    ToolTip = 'Specifies the bill-to customer no. filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(GlobalDimension1FilterField; GlobalDimension1Filter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Global Dimension 1 Filter';
                    CaptionClass = '1,3,1';
                    Importance = Additional;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    ToolTip = 'Specifies the global dimension 1 filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
                field(GlobalDimension2FilterField; GlobalDimension2Filter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Global Dimension 2 Filter';
                    CaptionClass = '1,3,2';
                    Importance = Additional;
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                    ToolTip = 'Specifies the global dimension 2 filter';

                    trigger OnValidate()
                    begin
                        OnAfterModifyFilter();
                    end;
                }
            }
            group("Line Filters")
            {
                Caption = 'Line Filters';
                Visible = false;
                field(TypeFilterField; TypeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type Filter';
                    Importance = Additional;
                    OptionCaption = ' ,Resource,Item,G/L Account';
                    ToolTip = 'Specifies the type filter';

                    trigger OnValidate()
                    begin
                        SetTypeFilter();
                    end;
                }
                field(NoFilterFIeld; NoFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. Filter';
                    Importance = Additional;
                    ToolTip = 'Specifies the no. filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccList: Page "G/L Account List";
                        ItemList: Page "Item List";
                        ResList: Page "Resource List";
                    begin
                        case TypeFilter of
                            TypeFilter::" ":
                                begin
                                    Text := '';
                                    exit(false);
                                end;
                            TypeFilter::Resource:
                                begin
                                    Res.Reset();
                                    Res."No." := CopyStr(NoFilter, 1, MaxStrLen(Res."No."));
                                    ResList.SetRecord(Res);
                                    ResList.LookupMode := true;
                                    ResList.Editable := false;
                                    if ResList.RunModal() = Action::LookupOK then begin
                                        Text := ResList.GetSelectionFilter();
                                        exit(true);
                                    end else
                                        exit(false);
                                end;
                            TypeFilter::Item:
                                begin
                                    Item.Reset();
                                    Item."No." := CopyStr(NoFilter, 1, MaxStrLen(Item."No."));
                                    ItemList.SetRecord(Item);
                                    ItemList.LookupMode := true;
                                    ItemList.Editable := false;
                                    if ItemList.RunModal() = Action::LookupOK then begin
                                        Text := ItemList.GetSelectionFilter();
                                        exit(true)
                                    end else
                                        exit(false);
                                end;
                            TypeFilter::"G/L Account":
                                begin
                                    GLAcc.Reset();
                                    GLAcc."No." := CopyStr(NoFilter, 1, MaxStrLen(GLAcc."No."));
                                    GLAccList.SetRecord(GLAcc);
                                    GLAccList.LookupMode := true;
                                    GLAccList.Editable := false;
                                    if GLAccList.RunModal() = Action::LookupOK then begin
                                        Text := GLAccList.GetSelectionFilter();
                                        exit(true);
                                    end else
                                        exit(false);
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetNoFilter();
                    end;
                }
                field(WorkTypeCodeFilterField; WorkTypeCodeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Work Type Code Filter';
                    Importance = Additional;
                    TableRelation = "Work Type";
                    ToolTip = 'Specifies the work type code filter';

                    trigger OnValidate()
                    begin
                        SetWorkTypeFilter();
                    end;
                }
            }

            repeater(JobRepeater)
            {
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a short description of the job.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description 2';
                    Visible = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer who pays for the job.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer who pays for the job.';
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bill-to name 2';
                    Visible = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address of the customer to whom you will send the invoice.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional line of the address.';
                    Visible = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the customer who pays for the job.';
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which you set up the job.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the job actually starts.';
                    Visible = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the job is expected to be completed.';
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a current status of the job. You can change the status for the job as it progresses. Final calculations can be made on completed jobs.';
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the person at your company who is responsible for the job.';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(TimeSheetPart; "O4NTime Sheet Factbox")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1200050038; "O4NJob Fact Box")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("No."),
                              "Posting Date Filter" = field("Posting Date Filter"),
                              "Planning Date Filter" = field("Planning Date Filter");
            }
            part(Control1200050118; "Customer Statistics FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1200050117; "Job No. of Prices FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            systempart(Control1200050115; Links)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Control1200050114; Notes)
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("<Action58>")
            {
                Caption = '&Job';
                action(JobCard)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job &Card';
                    Image = Card;
                    RunObject = page "Job Card";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Open the Job &Card';
                }
                action("<Action62>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Job),
                                  "No." = field("No.");
                    Scope = "Repeater";
                    ToolTip = 'View and Edit Job Co&mments';
                }
                action("<Action84>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = page "Default Dimensions";
                    RunPageLink = "Table ID" = const(167),
                                  "No." = field("No.");
                    Scope = "Repeater";
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View and Edit Job Dimensions';
                }
                action("<Action60>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = page "Job Ledger Entries";
                    RunPageLink = "Job No." = field("No.");
                    RunPageView = sorting("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    Scope = "Repeater";
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'Ledger E&ntries';
                }
                action("<Action87>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task Lines';
                    Image = TaskList;
                    RunObject = page "Job Task Lines";
                    RunPageLink = "Job No." = field("No.");
                    Scope = "Repeater";
                    ShortcutKey = 'Shift+Ctrl+T';
                    ToolTip = 'Job Task Lines';
                }
                action("<Action88>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job &Planning Lines';
                    Image = JobLines;
                    RunObject = page "Job Planning Lines";
                    RunPageLink = "Job No." = field("No.");
                    Scope = "Repeater";
                    ToolTip = 'Job &Planning Lines';
                }
                action("<Action61>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    RunObject = page "Job Statistics";
                    RunPageLink = "No." = field("No.");
                    Scope = "Repeater";
                    ShortcutKey = 'F7';
                    ToolTip = 'Statistics';
                }
            }
        }
        area(Processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next Period';
                Image = NextRecord;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    FindPeriod('>=');
                end;
            }
            action("Clear Filters")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Filters';
                Image = ClearFilter;
                ToolTip = 'Clear Filters';

                trigger OnAction()
                begin
                    ClearFilters();
                    OnAfterModifyFilter();
                end;
            }
            group("Self-Service")
            {
                Caption = 'Self-Service';
                Image = HumanResources;
                action("Time Sheets")
                {
                    ApplicationArea = Suite;
                    Caption = 'Time Sheets';
                    Image = Timesheet;
                    RunObject = page "Time Sheet List";
                    ToolTip = 'Time Sheets';
                }
                action("Page Time Sheet List Open")
                {
                    ApplicationArea = Suite;
                    Caption = 'Open';
                    Image = Timesheet;
                    RunObject = page "Time Sheet List";
                    RunPageView = where("Open Exists" = const(true));
                    ToolTip = 'Open';
                }
                action("Page Time Sheet List Submitted")
                {
                    ApplicationArea = Suite;
                    Caption = 'Submitted';
                    Image = Timesheet;
                    RunObject = page "Time Sheet List";
                    RunPageView = where("Submitted Exists" = const(true));
                    ToolTip = 'Submitted';
                }
                action("Page Time Sheet List Rejected")
                {
                    ApplicationArea = Suite;
                    Caption = 'Rejected';
                    Image = Timesheet;
                    RunObject = page "Time Sheet List";
                    RunPageView = where("Rejected Exists" = const(true));
                    ToolTip = 'Rejected';
                }
                action("Page Time Sheet List Approved")
                {
                    ApplicationArea = Suite;
                    Caption = 'Approved';
                    Image = Timesheet;
                    RunObject = page "Time Sheet List";
                    RunPageView = where("Approved Exists" = const(true));
                    ToolTip = 'Approved';
                }
                action("User Tasks")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Tasks';
                    Image = Task;
                    RunObject = page "User Task List";
                    ToolTip = 'User Tasks';
                }
                action(EditTimeSheet)
                {
                    ApplicationArea = All;
                    Caption = 'Edit Time Sheet';
                    Image = PostedTimeSheet;
                    ShortcutKey = 'F9';
                    ToolTip = 'Edit Time Sheet';

                    trigger OnAction()
                    var
                        TimeSheetMgt: Codeunit "O4N TimeSheet Mgt";
                    begin
                        TimeSheetMgt.OpenCurrentTimeSheet();
                    end;
                }
                action(PostTimeSheet)
                {
                    ApplicationArea = All;
                    Caption = 'Post Time Sheet';
                    Image = PostedTimeSheet;
                    ToolTip = 'Post Time Sheet';

                    trigger OnAction()
                    var
                        TimeSheetMgt: Codeunit "O4N TimeSheet Mgt";
                    begin
                        TimeSheetMgt.ApprovePendingTimeSheet();
                        TimeSheetMgt.PostApprovedTimeSheet();
                        TimeSheetMgt.ArchivePostedTimeSheet();
                        TimeSheetMgt.CreateTimeSheet();
                    end;
                }
            }
            group("<Action1200050066>")
            {
                Caption = 'Job';
                action("<Action1200050067>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Task';
                    Image = TaskList;
                    ToolTip = 'Job Task';

                    trigger OnAction()
                    var
                        Workbench2: Record "O4N Job Workbench";
                        TaskWorkbench: Page "O4NJob Task Part";
                    begin
                        Workbench2.Copy(Workbench);
                        if JobNoFilter = '' then
                            Workbench2.SetRange("Job No. Filter", Rec."No.");
                        TaskWorkbench.SetView(Workbench2);
                        TaskWorkbench.Run();
                    end;
                }
                action("<Action1200050111>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Planning Lines';
                    Image = EditLines;
                    ToolTip = 'Executes the Planning Lines action';

                    trigger OnAction()
                    var
                        Workbench2: Record "O4N Job Workbench";
                        PlanningLineWorkbench: Page "O4N Job Planning Part";
                    begin
                        Workbench2.Copy(Workbench);
                        if JobNoFilter = '' then
                            Workbench2.SetRange("Job No. Filter", Rec."No.");
                        PlanningLineWorkbench.SetView(Workbench2);
                        PlanningLineWorkbench.Run();
                    end;
                }
            }

            group("<Action1200050069>")
            {
                Caption = '&Shortcut';
                action("&Job Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Job Journal';
                    Image = Journals;
                    RunObject = page "Job Journal";
                    ToolTip = '&Job Journal';
                }
                action("Sales &Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Quotes';
                    Image = Quote;
                    RunObject = page "Sales Quotes";
                    ToolTip = 'Sales &Quotes';
                }
                action("Sales &Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Orders';
                    Image = Document;
                    RunObject = page "Sales Orders";
                    ToolTip = 'Sales &Orders';
                }
                action("Sales &Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Invoices';
                    Image = Invoice;
                    RunObject = page "Sales Invoice List";
                    ToolTip = 'Sales &Invoices';
                }
                action("Sales Credit &Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Credit &Memos';
                    Image = CreditMemo;
                    RunObject = page "Sales Credit Memos";
                    ToolTip = 'Sales Credit &Memos';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("<Action1200050067>_Promoted"; "<Action1200050067>")
                {
                }
                actionref("<Action60>_Promoted"; "<Action60>")
                {
                }
                actionref("<Action61>_Promoted"; "<Action61>")
                {
                }
            }

            group(Category_Category5)
            {
                Caption = 'Self-Service', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(EditTimeSheet_Promoted; EditTimeSheet)
                {
                }
                actionref(PostTimeSheet_Promoted; PostTimeSheet)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if DateFilter = '' then
            FindPeriod('')
        else
            Workbench.SetFilter("Date Filter", DateFilter);

        OnAfterModifyFilter();
        SetTypeFilter();
        if TypeFilter <> TypeFilter::" " then
            SetNoFilter()
        else
            NoFilter := '';
        if WorkTypeCodeFilter <> '' then
            SetWorkTypeFilter();
    end;

    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Workbench: Record "O4N Job Workbench";
        Res: Record Resource;
        TextManagement: Codeunit "Filter Tokens";
        Text003Err: Label 'Select Type Filter';
        JobCategoryFilter: Option " ",Chargeable,Internal;
        StatusFilter: Option " ",Planning,Quote,"Order",Completed;
        TypeFilter: Option " ",Resource,Item,"G/L Account";
        UpcomingInvoiceFilter: Option " ",Yes,No;
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        BilltoCustomerNoFilter: Text;
        DateFilter: Text;
        DescriptionFilter: Text;
        FAClassCodeFilter: Text;
        FALocationCodeFilter: Text;
        FASubclassCodeFilter: Text;
        FixedAssetNoFilter: Text;
        GlobalDimension1Filter: Text;
        GlobalDimension2Filter: Text;
        JobNoFilter: Text;
        JobStatGrpCodeFilter: Text;
        JobTaskNoFilter: Text;
        MaintenanceCodeFilter: Text;
        NoFilter: Text;
        PersonResponsibleFilter: Text;
        RecurringJobNoFilter: Text;
        StatisticsGroupCodeFilter: Text;
        WorkTypeCodeFilter: Text;

    procedure ClearFilters()
    begin
        JobNoFilter := '';
        JobTaskNoFilter := '';
        StatisticsGroupCodeFilter := '';
        JobStatGrpCodeFilter := '';
        PersonResponsibleFilter := '';
        BilltoCustomerNoFilter := '';
        GlobalDimension1Filter := '';
        GlobalDimension2Filter := '';
        RecurringJobNoFilter := '';
        FixedAssetNoFilter := '';
        MaintenanceCodeFilter := '';
        FAClassCodeFilter := '';
        FASubclassCodeFilter := '';
        FALocationCodeFilter := '';
        NoFilter := '';
        WorkTypeCodeFilter := '';
        JobCategoryFilter := JobCategoryFilter::" ";
        StatusFilter := StatusFilter::" ";
        TypeFilter := TypeFilter::" ";
        DescriptionFilter := '';
    end;

    procedure OnAfterModifyFilter()
    begin
        Workbench.CopyFilter("Date Filter", Rec."Posting Date Filter");
        Workbench.CopyFilter("Date Filter", Rec."Planning Date Filter");

        Workbench.SetFilter("Job No. Filter", JobNoFilter);
        JobNoFilter := Workbench.GetFilter("Job No. Filter");
        Workbench.CopyFilter("Job No. Filter", Rec."No.");

        if StatusFilter = StatusFilter::" " then
            Workbench.SetRange("Status Filter")
        else
            Workbench.SetRange("Status Filter", StatusFilter - 1);
        Workbench.CopyFilter("Status Filter", Rec.Status);

        Workbench.SetFilter("Person Responsible Filter", PersonResponsibleFilter);
        PersonResponsibleFilter := Workbench.GetFilter("Person Responsible Filter");
        Workbench.CopyFilter("Person Responsible Filter", Rec."Person Responsible");

        Workbench.SetFilter("Bill-to Customer No. Filter", BilltoCustomerNoFilter);
        BilltoCustomerNoFilter := Workbench.GetFilter("Bill-to Customer No. Filter");
        Workbench.CopyFilter("Bill-to Customer No. Filter", Rec."Bill-to Customer No.");

        Workbench.SetFilter("Global Dimension 1 Filter", GlobalDimension1Filter);
        GlobalDimension1Filter := Workbench.GetFilter("Global Dimension 1 Filter");
        Workbench.CopyFilter("Global Dimension 1 Filter", Rec."Global Dimension 1 Code");

        Workbench.SetFilter("Global Dimension 2 Filter", GlobalDimension2Filter);
        GlobalDimension2Filter := Workbench.GetFilter("Global Dimension 2 Filter");
        Workbench.CopyFilter("Global Dimension 2 Filter", Rec."Global Dimension 2 Code");

        case UpcomingInvoiceFilter of
            UpcomingInvoiceFilter::" ":
                Workbench.SetRange("Upcoming Invoice Filter");
            UpcomingInvoiceFilter::Yes:
                Workbench.SetRange("Upcoming Invoice Filter", true);
            UpcomingInvoiceFilter::No:
                Workbench.SetRange("Upcoming Invoice Filter", false);
        end;

        SetUpcomingInvoiceFilter();

        if DescriptionFilter = '' then
            Rec.SetRange(Description)
        else
            Rec.SetFilter(Description, '*' + DescriptionFilter + '*');

        CurrPage.Update(false);
    end;

    procedure SetInitialFilter(var WorkbenchFilter: Record "O4N Job Workbench")
    begin
        Workbench.Copy(WorkbenchFilter);
        Workbench.CopyFilter("Date Filter", Rec."Posting Date Filter");
        Workbench.CopyFilter("Date Filter", Rec."Planning Date Filter");
        DateFilter := Workbench.GetFilter("Date Filter");
        JobNoFilter := Workbench.GetFilter("Job No. Filter");
        Workbench.CopyFilter("Job No. Filter", Rec."No.");

        if Workbench.GetFilter("Status Filter") <> '' then
            StatusFilter := Workbench.GetRangeMin("Status Filter") + 1;
        Workbench.CopyFilter("Status Filter", Rec.Status);
        PersonResponsibleFilter := Workbench.GetFilter("Person Responsible Filter");
        Workbench.CopyFilter("Person Responsible Filter", Rec."Person Responsible");
        BilltoCustomerNoFilter := Workbench.GetFilter("Bill-to Customer No. Filter");
        Workbench.CopyFilter("Bill-to Customer No. Filter", Rec."Bill-to Customer No.");
        GlobalDimension1Filter := Workbench.GetFilter("Global Dimension 1 Filter");
        Workbench.CopyFilter("Global Dimension 1 Filter", Rec."Global Dimension 1 Code");
        GlobalDimension2Filter := Workbench.GetFilter("Global Dimension 2 Filter");
        Workbench.CopyFilter("Global Dimension 2 Filter", Rec."Global Dimension 2 Code");
        UpcomingInvoiceFilter := UpcomingInvoiceFilter::" ";
        if Workbench.GetFilter("Upcoming Invoice Filter") <> '' then
            case Workbench.GetRangeMin("Upcoming Invoice Filter") of
                true:
                    UpcomingInvoiceFilter := UpcomingInvoiceFilter::Yes;
                false:
                    UpcomingInvoiceFilter := UpcomingInvoiceFilter::No;
            end;
        SetUpcomingInvoiceFilter();
    end;

    local procedure FindPeriod(SearchText: Text[3])
    var
        Period: Record Date;
        PeriodMgt: Codeunit "O4NTime Management";
    begin
        if DateFilter <> '' then begin
            Period.SetFilter("Period Start", DateFilter);
            if not PeriodMgt.FindDate('+', Period, PeriodType) then
                PeriodMgt.FindDate('+', Period, PeriodType::Day);
            Period.SetRange("Period Start");
        end;
        if PeriodMgt.FindDate(SearchText, Period, PeriodType) then
            Workbench.SetRange("Date Filter", Period."Period Start", Period."Period End");
        DateFilter := Workbench.GetFilter("Date Filter");
        OnAfterModifyFilter();
    end;

    local procedure SetNoFilter()
    begin
        case TypeFilter of
            TypeFilter::" ":
                Error(Text003Err);
            TypeFilter::Resource:
                begin
                    Res.SetFilter("No.", NoFilter);
                    Res.FindFirst();
                    NoFilter := Res.GetFilter("No.");
                end;
            TypeFilter::Item:
                begin
                    Item.SetFilter("No.", NoFilter);
                    Item.FindFirst();
                    NoFilter := Item.GetFilter("No.");
                end;
            TypeFilter::"G/L Account":
                begin
                    GLAcc.SetFilter("No.", NoFilter);
                    GLAcc.FindFirst();
                    NoFilter := GLAcc.GetFilter("No.");
                end;
        end;
    end;

    local procedure SetTypeFilter()
    begin
        if TypeFilter = TypeFilter::" " then
            Workbench.SetRange("Type Filter")
        else
            Workbench.SetRange("Type Filter", TypeFilter - 1);

        Workbench.SetRange("No. Filter");
        NoFilter := '';
        Workbench.SetRange("Work Type Code Filter");
        WorkTypeCodeFilter := '';
    end;

    local procedure SetUpcomingInvoiceFilter()
    var
        ToDate: Date;
    begin
        Rec.FilterGroup(2);
        if Workbench.GetFilter("Upcoming Invoice Filter") = '' then begin
            Rec.SetRange(Status);
            Rec.SetRange("Next Invoice Date");
        end else
            if Workbench.GetRangeMax("Upcoming Invoice Filter") then begin
                if DateFilter <> '' then
                    ToDate := Workbench.GetRangeMax("Date Filter")
                else
                    ToDate := WorkDate();
                Rec.SetRange(Status, Rec.Status::Open);
                Rec.SetFilter("Next Invoice Date", '..%1&<>%2', ToDate, 0D);
            end else begin
                Rec.SetRange(Status, Rec.Status::Open);
                Rec.SetRange("Next Invoice Date", 0D);
            end;
        Rec.FilterGroup(0);
    end;

    local procedure SetWorkTypeFilter()
    begin
        if TypeFilter <> TypeFilter::Resource then begin
            TypeFilter := TypeFilter::Resource;
            Workbench.SetRange("Type Filter", TypeFilter - 1);
            Workbench.SetRange("No. Filter");
            NoFilter := '';
        end;

        Workbench.SetFilter("Work Type Code Filter", WorkTypeCodeFilter);
        WorkTypeCodeFilter := Workbench.GetFilter("Work Type Code Filter");
    end;
}