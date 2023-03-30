page 70603 "Clockify User Setup List"
{
    ApplicationArea = All;
    Caption = 'Clockify User Setup List';
    CardPageId = "Clockify User Setup Card";
    PageType = List;
    SourceTable = "Clockify User Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Security ID field';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enabled field';
                }
                field("Clockify ID"; Rec."Clockify ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify ID field';
                }
                field("Clockify Name"; Rec."Clockify Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify Name field';
                }
                field("Clockify E-Mail Address"; Rec."Clockify E-Mail Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify E-Mail Address field';
                }
                field("Clockify Workspace ID"; Rec."Clockify Workspace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify Workspace ID field';
                }
                field("Clockify Status"; Rec."Clockify Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clockify Status field';
                }
                field("Manual Synchronization"; Rec."Manual Synchronization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manual Synchronization field';
                }
                field("Default Work Type"; Rec."Default Work Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Work Type field';
                }
                field("Log Activity"; Rec."Log Activity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Log Activity field';
                }
            }
        }
    }
}
