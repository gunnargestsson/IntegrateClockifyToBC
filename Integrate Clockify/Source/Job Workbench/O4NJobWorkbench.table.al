table 65210 "O4N Job Workbench"
{
    Caption = 'Workbench';
    DataClassification = ToBeClassified;
    Permissions = tabledata Employee = r;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; "Bill-to Customer No. Filter"; Code[20])
        {
            Caption = 'Bill-to Customer No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(18; "Person Responsible Filter"; Code[20])
        {
            Caption = 'Person Responsible Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(19; "Status Filter"; Option)
        {
            Caption = 'Status Filter';
            FieldClass = FlowFilter;
            InitValue = "Order";
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;
        }
        field(21; "Global Dimension 1 Filter"; Code[20])
        {
            Caption = 'Global Dimension 1 Filter';
            CaptionClass = '1,3,1';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(22; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            CaptionClass = '1,3,2';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(23; "Employee No. Filter"; Code[20])
        {
            Caption = 'Employee No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(24; "Open Registration Filter"; Boolean)
        {
            Caption = 'Open Registration Filter';
            FieldClass = FlowFilter;
        }
        field(25; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(55; "Upcoming Invoice Filter"; Boolean)
        {
            Caption = 'Upcoming Invoice Filter';
            FieldClass = FlowFilter;
        }
        field(103; "Job No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(104; "No. Filter"; Code[20])
        {
            Caption = 'No. Filter';
            FieldClass = FlowFilter;
        }
        field(106; "Type Filter"; Option)
        {
            Caption = 'Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,G/L Account';
            OptionMembers = Resource,Item,"G/L Account";
        }
        field(107; "Work Type Code Filter"; Code[10])
        {
            Caption = 'Work Type Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "Work Type";
        }
        field(1000; "Job Task No. Filter"; Code[20])
        {
            Caption = 'Job Task No. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No. Filter"));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
}
