page 70602 "Clockify Integration List"
{

    PageType = List;
    SourceTable = "Clockify Integration Record";
    Caption = 'Clockify Integration Record List';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Security ID field';
                    Caption = 'User Security ID';
                }
                field("Integration Id"; Rec."Integration Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Integration ID field';
                    Caption = 'Integration ID';
                }
                field("Related Table ID"; Rec."Related Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table ID field';
                    Caption = 'Table ID';
                }
                field("Related Record Id"; Format(Rec."Related Record Id"))
                {
                    Caption = 'Related Record Id';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Related Record Id field';
                }
                field("Related Record System Id"; Rec."Related Record System Id")
                {
                    Caption = 'Related Record System Id';
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Related Record System Id field';
                }
                field("Clockify Workspace ID"; Rec."Clockify Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify Workspace ID field';
                    Caption = 'Clockify Workspace ID';
                }
                field("Clockify ID"; Rec."Clockify ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify ID field';
                    Caption = 'Clockify ID';
                }
                field(Archived; Rec.Archived)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archived field';
                    Caption = 'Archived';
                }
                field("Next Synchronization"; Rec."Next Synchronization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Synchronization field';
                    Caption = 'Next Synchronization';
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date Time field';
                    Caption = 'Last Modified Date Time';
                }
                field("Last Synchronization"; Rec."Last Synchronization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Synchronization field';
                    Caption = 'Last Synchronization';
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
                Caption = 'View Record';
                ApplicationArea = All;
                ToolTip = 'View the Business Central record specified in this integration record';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Card;
                trigger OnAction()
                var
                    PageMgt: Codeunit "Page Management";
                begin
                    PageMgt.PageRunModal(Rec."Related Record Id");
                end;
            }
        }
    }


}
