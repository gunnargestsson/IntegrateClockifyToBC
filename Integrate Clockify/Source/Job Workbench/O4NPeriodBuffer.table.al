table 65211 "O4NPeriod Buffer"
{
    Caption = 'Accounting Period';
    DataClassification = ToBeClassified;
    LookupPageId = "Accounting Periods";
    TableType = Temporary;

    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Name; Text[10])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Starting Date", Name)
        {
        }
    }
}
