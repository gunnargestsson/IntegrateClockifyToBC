page 70600 "Clockify User Setup Card"
{
    AdditionalSearchTerms = 'time sheet integration';
    PageType = Card;
    SourceTable = "Clockify User Setup";
    Caption = 'Clockify User Setup Card';
    LinksAllowed = false;
    ShowFilter = false;
    UsageCategory = None;
    PromotedActionCategories = 'New,Process,Report,Encryption,Navigate';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("API Key"; ApiKey)
                {
                    Caption = 'API Key';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = EditableByNotEnabled;
                    ExtendedDatatype = Masked;
                    ToolTip = 'Api Key as specified in setting on your Clockify home page';
                    trigger OnValidate()
                    begin
                        Rec.SetAPIKey(ApiKey);
                    end;
                }
                field("API Base Endpoint"; Rec."API Base Endpoint")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Enable the integration synchronization process';
                }
                field("Manual Synchronization"; Rec."Manual Synchronization")
                {
                    ApplicationArea = All;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Disables the Job Queue Entry creation';
                }
                field("Default Work Type"; Rec."Default Work Type")
                {
                    ApplicationArea = All;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies the default work type that will be used on time sheet entries';
                    ShowMandatory = true;
                }
                field("Log Activity"; Rec."Log Activity")
                {
                    ApplicationArea = All;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies wether the integration activity is stored in the activity log';
                }
                field("Max. No. of Failures"; Rec."Max. No. of Failures")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. No. of Failures field';
                    Editable = EditableByNotEnabled;
                    BlankZero = true;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enabled field';
                    trigger OnValidate()
                    begin
                        UpdateBasedOnEnable();
                    end;
                }
                field(ShowEnableWarningField; ShowEnableWarning)
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Editable = false;
                    Enabled = NOT EditableByNotEnabled;
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the ShowEnableWarning field';

                    trigger OnDrillDown()
                    begin
                        DrilldownCode();
                    end;
                }

            }
            group(Clockify)
            {
                Caption = 'Clockify User Information';
                field("Clockify ID"; Rec."Clockify ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clockify identification';
                }
                field("Clockify Name"; Rec."Clockify Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clockify user name';
                }
                field("Clockify E-Mail Address"; Rec."Clockify E-Mail Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clockify registration e-mail address';
                }
                field("Clockify Workspace ID"; Rec."Clockify Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clockify active workspace identification';
                }
                field("Clockify Status"; Rec."Clockify Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Clockify user status';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(JobQueueEntry)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Queue Entry';
                Enabled = Rec.Enabled;
                Image = JobListSetup;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'View or edit the jobs that automatically integrate your time sheet with Clockify.';

                trigger OnAction()
                begin
                    Rec.ShowJobQueueEntry();
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                ToolTip = 'See the status and any errors integration with Clockify.';

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec);
                end;
            }
            action(Synchronize)
            {
                ApplicationArea = All;
                Caption = 'Synchronize';
                Image = OutlookSyncFields;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Start the Clockify to Business Central synchronization process.';
                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Clockify to Business Central");
                end;
            }
        }
        area(Navigation)
        {
            action(IntegrationRecords)
            {
                Caption = 'Integration Records';
                ToolTip = 'View the integration records for Clockify';
                Image = InteractionLog;
                RunObject = page "Clockify Integration List";
                ApplicationArea = All;
            }
            action(TimeSheetEntries)
            {
                Caption = 'Time Sheet Entries';
                ToolTip = 'View the time sheet entries from Clockify';
                Image = Timesheet;
                RunObject = page "Clockify Time Sheet Entry List";
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InitializeAPISetup();
        UpdateBasedOnEnable();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ApiKey := Rec.GetAPIKey()
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateBasedOnEnable();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Rec.Enabled then
            if not Confirm(StrSubstNo(EnableServiceQst, CurrPage.Caption), true) then
                exit(false);
    end;

    var
        ApiKey: Text;
        ShowEnableWarning: Text;
        EditableByNotEnabled: Boolean;
        EnabledWarningTok: Label 'You must disable the service before you can make changes.';
        DisableEnableQst: Label 'Do you want to disable the Clockify integation?';
        EnableServiceQst: Label 'The %1 is not enabled. Are you sure you want to exit?', Comment = '%1 = pagecaption (Clockify User Setup Card)';

    local procedure UpdateBasedOnEnable()
    begin
        EditableByNotEnabled := (not Rec.Enabled) and CurrPage.Editable;
        ShowEnableWarning := '';
        if CurrPage.Editable and Rec.Enabled then
            ShowEnableWarning := EnabledWarningTok;
    end;

    local procedure DrilldownCode()
    begin
        if Confirm(DisableEnableQst, true) then begin
            Rec.Enabled := false;
            UpdateBasedOnEnable();
            CurrPage.Update();
        end;
    end;
}
