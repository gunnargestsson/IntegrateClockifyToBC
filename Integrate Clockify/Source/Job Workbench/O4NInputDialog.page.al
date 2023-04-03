page 65253 "O4N Input Dialog"
{
    Caption = 'Input Dialog';
    LinksAllowed = false;
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(AmtBox; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enter Amount';
                    CaptionClass = FieldCaption;
                    ToolTip = 'Specifies the value of the Enter Amount field';
                    Visible = AmountFieldVisible;

                    trigger OnValidate()
                    begin
                        DoAutoClose();
                    end;
                }
                field(StringBox; String)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enter string';
                    CaptionClass = FieldCaption;
                    ToolTip = 'Specifies the value of the Enter string field';
                    Visible = StringFieldVisible;

                    trigger OnValidate()
                    begin
                        DoAutoClose();
                    end;
                }
            }
        }
    }

    var
        AllowAutoClose: Boolean;
        [InDataSet]
        AmountFieldVisible: Boolean;
        AutoClosed: Boolean;
        [InDataSet]
        StringFieldVisible: Boolean;
        Amount: Decimal;
        [InDataSet]
        FieldCaption: Text[50];
        String: Text[1024];

    procedure GetAmount(var Amount2: Decimal)
    begin
        Amount2 := Amount;
    end;

    procedure GetAutoClosed(): Boolean
    begin
        exit(AutoClosed);
    end;

    procedure GetString(var String2: Text[1024])
    begin
        String2 := String;
    end;

    procedure SetAllowAutoClose(Allow: Boolean)
    begin
        AllowAutoClose := Allow;
    end;

    procedure SetAmount(Amount2: Decimal)
    begin
        Amount := Amount2;
    end;

    procedure SetFieldCaption(NewFieldCaption: Text[50])
    begin
        FieldCaption := NewFieldCaption;
    end;

    procedure SetFieldVisible(NewFieldVisible: Option Amount,String)
    begin
        AmountFieldVisible := NewFieldVisible = NewFieldVisible::Amount;
        StringFieldVisible := NewFieldVisible = NewFieldVisible::String;
    end;

    procedure SetString(String2: Text[1024])
    begin
        String := String2;
    end;

    local procedure DoAutoClose()
    begin
        if AllowAutoClose then begin
            AutoClosed := true;
            CurrPage.Close();
        end;
    end;
}
