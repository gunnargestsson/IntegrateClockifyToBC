page 70602 "Clockify Integration List"
{
    Caption = 'Clockify Integration Record List';
    PageType = List;
    SourceTable = "Clockify Integration Record";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                    Caption = 'User Security ID';
                    ToolTip = 'Specifies the value of the User Security ID field';
                }
                field("Integration Id"; Rec."Integration Id")
                {
                    ApplicationArea = All;
                    Caption = 'Integration ID';
                    ToolTip = 'Specifies the value of the Integration ID field';
                }
                field("Related Table ID"; Rec."Related Table ID")
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    ToolTip = 'Specifies the value of the Table ID field';
                }
                field("Related Record Id"; Format(Rec."Related Record Id"))
                {
                    ApplicationArea = All;
                    Caption = 'Related Record Id';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Related Record Id field';
                }
                field("Related Record System Id"; Rec."Related Record System Id")
                {
                    ApplicationArea = All;
                    Caption = 'Related Record System Id';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Related Record System Id field';
                }
                field("Clockify Workspace ID"; Rec."Clockify Workspace ID")
                {
                    ApplicationArea = All;
                    Caption = 'Clockify Workspace ID';
                    ToolTip = 'Specifies the value of the Clockify Workspace ID field';
                }
                field("Clockify ID"; Rec."Clockify ID")
                {
                    ApplicationArea = All;
                    Caption = 'Clockify ID';
                    ToolTip = 'Specifies the value of the Clockify ID field';
                }
                field(Archived; Rec.Archived)
                {
                    ApplicationArea = All;
                    Caption = 'Archived';
                    ToolTip = 'Specifies the value of the Archived field';
                }
                field("Next Synchronization"; Rec."Next Synchronization")
                {
                    ApplicationArea = All;
                    Caption = 'Next Synchronization';
                    ToolTip = 'Specifies the value of the Next Synchronization field';
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Last Modified Date Time';
                    ToolTip = 'Specifies the value of the Last Modified Date Time field';
                }
                field("Last Synchronization"; Rec."Last Synchronization")
                {
                    ApplicationArea = All;
                    Caption = 'Last Synchronization';
                    ToolTip = 'Specifies the value of the Last Synchronization field';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ViewRecord)
            {
                ApplicationArea = All;
                Caption = 'View Record';
                Image = Card;
                ToolTip = 'View the Business Central record specified in this integration record';
                trigger OnAction()
                var
                    PageMgt: Codeunit "Page Management";
                begin
                    PageMgt.PageRunModal(Rec."Related Record Id");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ViewRecord_Promoted; ViewRecord)
                {
                }
            }
        }
    }
}
