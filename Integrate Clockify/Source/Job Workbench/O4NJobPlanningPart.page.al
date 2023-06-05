page 70650 "O4N Job Planning Part"
{
    AutoSplitKey = true;
    Caption = 'Job Planning Lines';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Filter,Line';
    SaveValues = true;
    SourceTable = "Job Planning Line";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job No. field';
                    Visible = "Job No.Visible";
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job Task No. field';
                    Visible = "Job Task No.Visible";
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line Type field';
                }
                field("Usage Link"; Rec."Usage Link")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Usage Link field';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UsageLinkOnAfterValidate();
                    end;
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Planning DateEditable";
                    ToolTip = 'Specifies the value of the Planning Date field';

                    trigger OnValidate()
                    begin
                        PlanningDateOnAfterValidate();
                    end;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Planned Delivery Date field';
                }
                field("Currency Date"; Rec."Currency Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Currency DateEditable";
                    ToolTip = 'Specifies the value of the Currency Date field';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Document No.Editable";
                    ToolTip = 'Specifies the value of the Document No. field';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line No. field';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = TypeEditable;
                    ToolTip = 'Specifies the value of the Type field';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "No.Editable";
                    ToolTip = 'Specifies the value of the No. field';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                    end;
                }
                field(LongDescriptionField; LongDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = DescriptionEditable;
                    ToolTip = 'Specifies the value of the Description field';

                    trigger OnValidate()
                    begin
                        Rec.Description := CopyStr(LongDescription, 1, MaxStrLen(Rec.Description));
                        Rec."Description 2" := CopyStr(LongDescription, 1 + MaxStrLen(Rec.Description), MaxStrLen(Rec."Description 2"));
                    end;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Variant CodeEditable";
                    ToolTip = 'Specifies the value of the Variant Code field';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Location CodeEditable";
                    ToolTip = 'Specifies the value of the Location Code field';

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate();
                    end;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Work Type CodeEditable";
                    ToolTip = 'Specifies the value of the Work Type Code field';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Unit of Measure CodeEditable";
                    ToolTip = 'Specifies the value of the Unit of Measure Code field';

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida();
                    end;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Reserve field';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity field';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate();
                    end;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Reserved Quantity field';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Quantity (Base) field';
                    Visible = false;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Qty. field';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Direct Unit Cost (LCY) field';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Unit CostEditable";
                    ToolTip = 'Specifies the value of the Unit Cost field';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Unit Cost (LCY) field';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Total Cost field';
                }
                field("Remaining Total Cost"; Rec."Remaining Total Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Total Cost field';
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Total Cost (LCY) field';
                }
                field("Remaining Total Cost (LCY)"; Rec."Remaining Total Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Total Cost (LCY) field';
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Unit PriceEditable";
                    ToolTip = 'Specifies the value of the Unit Price field';
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Unit Price (LCY) field';
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Line AmountEditable";
                    ToolTip = 'Specifies the value of the Line Amount field';
                }
                field("Remaining Line Amount"; Rec."Remaining Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Line Amount field';
                    Visible = false;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field';
                    Visible = false;
                }
                field("Remaining Line Amount (LCY)"; Rec."Remaining Line Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Remaining Line Amount (LCY) field';
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Line Discount AmountEditable";
                    ToolTip = 'Specifies the value of the Line Discount Amount field';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Line Discount %Editable";
                    ToolTip = 'Specifies the value of the Line Discount % field';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Total Price field';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Total Price (LCY) field';
                    Visible = false;
                }
                field("Qty. Posted"; Rec."Qty. Posted")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. Posted field';
                    Visible = false;
                }
                field("Qty. to Transfer to Journal"; Rec."Qty. to Transfer to Journal")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. to Transfer to Journal field';
                }
                field("Posted Total Cost"; Rec."Posted Total Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Posted Total Cost field';
                    Visible = false;
                }
                field("Posted Total Cost (LCY)"; Rec."Posted Total Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Posted Total Cost (LCY) field';
                    Visible = false;
                }
                field("Posted Line Amount"; Rec."Posted Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Posted Line Amount field';
                    Visible = false;
                }
                field("Posted Line Amount (LCY)"; Rec."Posted Line Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Posted Line Amount (LCY) field';
                    Visible = false;
                }
                field("Qty. Transferred to Invoice"; Rec."Qty. Transferred to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. Transferred to Invoice field';
                }
                field("Qty. to Transfer to Invoice"; Rec."Qty. to Transfer to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. to Transfer to Invoice field';
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. Invoiced field';
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Qty. to Invoice field';
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Invoiced Amount (LCY) field';
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Invoiced Cost Amount (LCY) field';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the User ID field';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Serial No. field';
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Lot No. field';
                    Visible = false;
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Job Contract Entry No. field';
                }
                field("Ledger Entry Type"; Rec."Ledger Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Ledger Entry Type field';
                    Visible = false;
                }
                field("Ledger Entry No."; Rec."Ledger Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Ledger Entry No. field';
                    Visible = false;
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the System-Created Entry field';
                    Visible = false;
                }
                field(Overdue; Rec.Overdue())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Overdue field';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000001; Links)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Control1000000002; Notes)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("Job Planning &Line")
            {
                Caption = 'Job Planning &Line';
                Image = Line;
                action("Linked Job Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Linked Job Ledger E&ntries';
                    Image = JobLedger;
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Linked Job Ledger E&ntries action';

                    trigger OnAction()
                    var
                        JobLedgerEntry: Record "Job Ledger Entry";
                        JobUsageLink: Record "Job Usage Link";
                    begin
                        JobUsageLink.SetRange("Job No.", Rec."Job No.");
                        JobUsageLink.SetRange("Job Task No.", Rec."Job Task No.");
                        JobUsageLink.SetRange("Line No.", Rec."Line No.");

                        if JobUsageLink.FindSet() then
                            repeat
                                JobLedgerEntry.Get(JobUsageLink."Entry No.");
                                JobLedgerEntry.Mark := true;
                            until JobUsageLink.Next() = 0;

                        JobLedgerEntry.MarkedOnly(true);
                        Page.Run(Page::"Job Ledger Entries", JobLedgerEntry);
                    end;
                }
                action("&Reservation Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'Executes the &Reservation Entries action';

                    trigger OnAction()
                    begin
                        Rec.ShowReservationEntries(true);
                    end;
                }
                separator(Separator1000000082)
                {
                }
                action("Order &Promising")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;
                    ToolTip = 'Executes the Order &Promising action';

                    trigger OnAction()
                    begin
                        Rec.ShowOrderPromisingLine();
                    end;
                }
                action("<Action1200050006>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    ToolTip = 'Executes the Ledger E&ntries action';

                    trigger OnAction()
                    begin
                        LedgerEntriesLookup();
                    end;
                }
                action("<Action1200050001>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Card action';

                    trigger OnAction()
                    begin
                        OpenCard();
                    end;
                }
                action("<Action1200050004>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'Executes the Comments action';

                    trigger OnAction()
                    begin
                        OpenComment();
                    end;
                }
                action("<Action1200050005>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    ToolTip = 'Executes the Statistics action';

                    trigger OnAction()
                    begin
                        OpenStatistics();
                    end;
                }
            }
        }
        area(Processing)
        {
            group("<Action1200050003>")
            {
                Caption = '&Filter';
                action("Line Type Action")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Line Type';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Line Type action';

                    trigger OnAction()
                    begin
                        SetLineTypeFilter(LineType + 1);
                    end;
                }
                action("<Action1200050010>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Not Transferred';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Not Transferred action';

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Qty. to Transfer to Invoice", '<>%1', 0);
                    end;
                }
                action("<Action1200050011>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Not Invoiced';
                    Image = FilterLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Not Invoiced action';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Qty. Invoiced", 0);
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remove';
                    Image = RemoveFilterLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Remove action';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Qty. to Invoice");
                        Rec.SetRange("Qty. to Transfer to Invoice");
                        SetLineTypeFilter(0);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action("&Open Job Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Open Job Journal';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = page "Job Journal";
                    RunPageLink = "Job No." = field("Job No."),
                                  "Job Task No." = field("Job Task No.");
                    ToolTip = 'Executes the &Open Job Journal action';
                }
                separator(Separator1000000076)
                {
                }
                action("Create &Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Create &Sales Invoice action';

                    trigger OnAction()
                    begin
                        CreateSalesInvoice(false);
                    end;
                }
                action("Create Sales &Credit Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales &Credit Memo';
                    Ellipsis = true;
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Create Sales &Credit Memo action';

                    trigger OnAction()
                    begin
                        CreateSalesInvoice(true);
                    end;
                }
                action("Sales &Invoices / Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Invoices / Credit Memos';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Sales &Invoices / Credit Memos action';

                    trigger OnAction()
                    begin
                        JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
                    end;
                }
                separator(Separator1000000072)
                {
                }
                action("Reserve Action")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;
                    ToolTip = 'Executes the &Reserve action';

                    trigger OnAction()
                    begin
                        Rec.ShowReservation();
                    end;
                }
                action("Order &Tracking")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;
                    ToolTip = 'Executes the Order &Tracking action';

                    trigger OnAction()
                    begin
                        Rec.ShowTracking();
                    end;
                }
                separator(Separator1000000069)
                {
                }
                action(DemandOverview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Demand Overview';
                    Image = Forecast;
                    ToolTip = 'Executes the &Demand Overview action';

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);

                        DemandOverview.Initialize(0D, 3, Rec."Job No.", '', '');
                        DemandOverview.RunModal();
                    end;
                }
            }
            group("<Action1200050015>")
            {
                Caption = '&Line';
                action("Validate Discount Percent on Selected Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Validate Discount Percent on Selected Lines';
                    Ellipsis = true;
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Validate Discount Percent on Selected Lines action';

                    trigger OnAction()
                    var
                        JobPlanningLines: Record "Job Planning Line";
                        WorkbenchMgt: Codeunit "O4N Job Workbench Mgt.";
                    begin
                        CurrPage.SaveRecord();
                        CurrPage.SetSelectionFilter(JobPlanningLines);
                        WorkbenchMgt.ApplyDiscount(JobPlanningLines);
                        CurrPage.Update(false);
                    end;
                }
                action("Create &Sales Invoice with Selected Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create &Sales Invoice with Selected Lines';
                    Ellipsis = true;
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Create &Sales Invoice with Selected Lines action';

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord();
                        CreateSalesInvoice(false);
                        CurrPage.Update(false);
                    end;
                }
                action("Create Sales &Credit Memo with Selected Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales &Credit Memo with Selected Lines';
                    Ellipsis = true;
                    Image = CreditMemo;
                    ToolTip = 'Executes the Create Sales &Credit Memo with Selected Lines action';

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord();
                        CreateSalesInvoice(true);
                        CurrPage.Update(false);
                    end;
                }
                separator(Separator1000000097)
                {
                }
                action("Get Sales Invoice/Credit Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get Sales Invoice/Credit Memo';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Get Sales Invoice/Credit Memo action';

                    trigger OnAction()
                    begin
                        GetInvoice();
                    end;
                }
            }
        }
        area(Reporting)
        {
            action("Job Actual to Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Actual to Budget';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Actual To Budget";
                ToolTip = 'Executes the Job Actual to Budget action';
            }
            action("Job Analysis")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Analysis";
                ToolTip = 'Executes the Job Analysis action';
            }
            action("Job - Planning Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job - Planning Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job - Planning Lines";
                ToolTip = 'Executes the Job - Planning Lines action';
            }
            action("Job - Suggested Billing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job - Suggested Billing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Suggested Billing";
                ToolTip = 'Executes the Job - Suggested Billing action';
            }
            action("Jobs - Transaction Detail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Jobs - Transaction Detail';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = report "Job - Transaction Detail";
                ToolTip = 'Executes the Jobs - Transaction Detail action';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("Qty. Transferred to Invoice");
        SetEditable(Rec."Qty. Transferred to Invoice" = 0);
        JobPlanningLine.Copy(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        LongDescription := Rec.Description + Rec."Description 2";
    end;

    trigger OnInit()
    begin
        "Unit CostEditable" := true;
        "Line AmountEditable" := true;
        "Line Discount %Editable" := true;
        "Line Discount AmountEditable" := true;
        "Unit PriceEditable" := true;
        "Work Type CodeEditable" := true;
        "Location CodeEditable" := true;
        "Variant CodeEditable" := true;
        "Unit of Measure CodeEditable" := true;
        DescriptionEditable := true;
        "No.Editable" := true;
        TypeEditable := true;
        "Document No.Editable" := true;
        "Currency DateEditable" := true;
        "Planning DateEditable" := true;

        "Job Task No.Visible" := true;
        "Job No.Visible" := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."System-Created Entry" = true then
            if not Confirm(EditJobPlanningLineQst, false) then
                Error('')
            else
                Rec."System-Created Entry" := false;

        Rec.Description := CopyStr(LongDescription, 1, MaxStrLen(Rec.Description));
        Rec."Description 2" := CopyStr(LongDescription, MaxStrLen(Rec.Description) + 1, MaxStrLen(Rec."Description 2"));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        Job: Record Customer;
    begin
        if Job.Get(JobNo) then
            CurrPage.Editable(not (Job.Blocked = Job.Blocked::All));

        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;
    end;

    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        Item: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        ResLegdEntry: Record "Res. Ledger Entry";
        Res: Record Resource;
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        "Currency DateEditable": Boolean;
        DescriptionEditable: Boolean;
        "Document No.Editable": Boolean;
        "Job No.Visible": Boolean;
        "Job Task No.Visible": Boolean;
        "Line AmountEditable": Boolean;
        "Line Discount %Editable": Boolean;
        "Line Discount AmountEditable": Boolean;
        "Location CodeEditable": Boolean;
        "No.Editable": Boolean;
        "Planning DateEditable": Boolean;
        TypeEditable: Boolean;
        "Unit CostEditable": Boolean;
        "Unit of Measure CodeEditable": Boolean;
        "Unit PriceEditable": Boolean;
        "Variant CodeEditable": Boolean;
        "Work Type CodeEditable": Boolean;
        JobNo: Code[20];
        EditJobPlanningLineQst: Label 'This job planning line was automatically generated. Do you want to continue?';
        LineType: Option " ","Both Schedule and Contract",Contract,Schedule;
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;
        LongDescription: Text[200];

    procedure CreateSalesInvoice(CrMemo: Boolean)
    begin
        Rec.TestField("Line No.");
        JobPlanningLine.Copy(Rec);
        CurrPage.SetSelectionFilter(JobPlanningLine);
        JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)
    end;

    procedure SetActiveField(ActiveField2: Integer)
    begin
        ActiveField := ActiveField2;
    end;

    procedure SetJobNo(No: Code[20])
    begin
        JobNo := No;
    end;

    procedure SetJobNoVisible(JobNoVisible: Boolean)
    begin
        "Job No.Visible" := JobNoVisible;
    end;

    procedure SetJobTaskNoVisible(JobTaskNoVisible: Boolean)
    begin
        "Job Task No.Visible" := JobTaskNoVisible;
    end;

    procedure SetView(var Workbench: Record "O4N Job Workbench")
    begin
        Workbench.CopyFilter("Job No. Filter", Rec."Job No.");
        Workbench.CopyFilter("Job Task No. Filter", Rec."Job Task No.");
        Workbench.CopyFilter("Date Filter", Rec."Planning Date");
        Workbench.CopyFilter("Type Filter", Rec.Type);
        Workbench.CopyFilter("No. Filter", Rec."No.");
        Workbench.CopyFilter("Work Type Code Filter", Rec."Work Type Code");
        if Workbench.GetFilter("Upcoming Invoice Filter") <> '' then
            if Workbench.GetRangeMax("Upcoming Invoice Filter") then begin
                Rec.SetRange("Contract Line", true);
                Rec.SetFilter("Qty. to Invoice", '<>%1', 0);
            end else begin
                Rec.SetRange("Contract Line");
                Rec.SetRange("Qty. to Invoice", 0);
            end;
    end;

    local procedure GetInvoice()
    begin
        JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
    end;

    local procedure LedgerEntriesLookup()
    begin
        if Rec."No." = '' then exit;
        case Rec.Type of
            Rec.Type::"G/L Account":
                begin
                    GLEntry.SetRange("G/L Account No.", Rec."No.");
                    Page.Run(Page::"General Ledger Entries", GLEntry);
                end;
            Rec.Type::Item:
                begin
                    ItemLedgEntry.SetRange("Item No.", Rec."No.");
                    Page.Run(Page::"Item Ledger Entries", ItemLedgEntry);
                end;
            Rec.Type::Resource:
                begin
                    ResLegdEntry.SetRange("Resource No.", Rec."No.");
                    Page.Run(Page::"Resource Ledger Entries", ResLegdEntry);
                end;
        end;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        if Rec."Location Code" <> xRec."Location Code" then
            PerformAutoReserve();
    end;

    local procedure NoOnAfterValidate()
    begin
        if Rec."No." <> xRec."No." then
            PerformAutoReserve();
    end;

    local procedure OpenCard()
    begin
        if Rec."No." = '' then exit;
        case Rec.Type of
            Rec.Type::"G/L Account":
                begin
                    GLAcc."No." := Rec."No.";
                    Page.Run(Page::"G/L Account Card", GLAcc);
                end;
            Rec.Type::Item:
                begin
                    Item."No." := Rec."No.";
                    Page.Run(Page::"Item Card", Item);
                end;
            Rec.Type::Resource:
                begin
                    Res."No." := Rec."No.";
                    Page.Run(Page::"Resource Card", Res);
                end;
        end;
    end;

    local procedure OpenComment()
    var
        CommentLine: Record "Comment Line";
    begin
        if Rec."No." = '' then exit;
        CommentLine.FilterGroup(2);
        case Rec.Type of
            Rec.Type::"G/L Account":
                CommentLine.SetRange("Table Name", CommentLine."Table Name"::"G/L Account");
            Rec.Type::Item:
                CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
            Rec.Type::Resource:
                CommentLine.SetRange("Table Name", CommentLine."Table Name"::Resource);
        end;
        CommentLine.SetRange("No.", Rec."No.");
        CommentLine.FilterGroup(0);
        Page.Run(Page::"Comment Sheet", CommentLine);
    end;

    local procedure OpenStatistics()
    begin
        if Rec."No." = '' then exit;
        case Rec.Type of
            Rec.Type::"G/L Account":
                begin
                    GLAcc."No." := Rec."No.";
                    Page.Run(Page::"Chart of Accounts", GLAcc);
                end;
            Rec.Type::Item:
                begin
                    Item."No." := Rec."No.";
                    Page.Run(Page::"Item Statistics", Item);
                end;
            Rec.Type::Resource:
                begin
                    Res."No." := Rec."No.";
                    Page.Run(Page::"Resource Statistics", Res);
                end;
        end;
    end;

    local procedure PerformAutoReserve()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Remaining Qty. (Base)" <> 0)
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;
    end;

    local procedure PlanningDateOnAfterValidate()
    begin
        if Rec."Planning Date" <> xRec."Planning Date" then
            PerformAutoReserve();
    end;

    local procedure QuantityOnAfterValidate()
    begin
        PerformAutoReserve();
        if (Rec.Type = Rec.Type::Item) and (Rec.Quantity <> xRec.Quantity) then
            CurrPage.Update(true);
    end;

    local procedure ReserveOnAfterValidate()
    begin
        PerformAutoReserve();
    end;

    local procedure SetEditable(Edit: Boolean)
    begin
        "Planning DateEditable" := Edit;
        "Currency DateEditable" := Edit;
        "Document No.Editable" := Edit;
        TypeEditable := Edit;
        "No.Editable" := Edit;
        DescriptionEditable := Edit;
        "Unit of Measure CodeEditable" := Edit;
        "Variant CodeEditable" := Edit;
        "Location CodeEditable" := Edit;
        "Work Type CodeEditable" := Edit;
        "Unit PriceEditable" := Edit;
        "Line Discount AmountEditable" := Edit;
        "Line Discount %Editable" := Edit;
        "Line AmountEditable" := Edit;
        "Unit CostEditable" := Edit;
    end;

    local procedure SetLineTypeFilter(NewLineTypeFilter: Integer)
    begin
        case NewLineTypeFilter of
            0, 1, 2, 3:
                LineType := NewLineTypeFilter
            else
                LineType := LineType::" ";
        end;

        if LineType = LineType::" " then begin
            Rec.SetRange("Schedule Line");
            Rec.SetRange("Contract Line");
        end else begin
            Rec.SetRange("Schedule Line", LineType in [LineType::Schedule, LineType::"Both Schedule and Contract"]);
            Rec.SetRange("Contract Line", LineType in [LineType::Contract, LineType::"Both Schedule and Contract"]);
        end;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        PerformAutoReserve();
    end;

    local procedure UsageLinkOnAfterValidate()
    begin
        PerformAutoReserve();
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        if Rec."Variant Code" <> xRec."Variant Code" then
            PerformAutoReserve();
    end;
}
