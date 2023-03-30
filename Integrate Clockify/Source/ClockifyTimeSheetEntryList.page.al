page 70601 "Clockify Time Sheet Entry List"
{

    PageType = List;
    SourceTable = "Clockify Time Sheet Entry";
    Caption = 'Clockify Time Sheet Entry List';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Clockify ID"; Rec."Clockify ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify ID field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Clockify User ID"; Rec."Clockify User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify User ID field';
                }
                field(Billable; Rec.Billable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Billable field';
                }
                field("Job Task ID"; Rec."Job Task ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Task ID field';
                }
                field("Job ID"; Rec."Job ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job ID field';
                }
                field(Locked; Rec.Locked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Locked field';
                }
                field("Next Synchronization"; Rec."Next Synchronization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Synchronization field';
                }
                field("Clockify Workspace ID"; Rec."Clockify Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify Workspace ID field';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Time field';
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Time field';
                }
                field("Entry Duration"; Rec."Entry Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Duration field';
                }
                field("Time Sheet Line ID"; Rec."Time Sheet Line ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Sheet Line ID field';
                }
                field("Time Sheet Detail ID"; Rec."Time Sheet Detail ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Sheet Detail ID field';
                }
            }
        }
    }

}
