table 70654 "Clockify Integration Record"
{
    Caption = 'Clockify Integration Record';
    DataClassification = EndUserIdentifiableInformation;
    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Security ID";
        }
        field(2; "Integration Id"; Guid)
        {
            Caption = 'Integration ID';
            DataClassification = SystemMetadata;
        }
        field(3; "Related Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = SystemMetadata;
        }
        field(4; "Related Record Id"; RecordId)
        {
            Caption = 'Related Record ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Clockify Workspace ID"; Text[35])
        {
            Caption = 'Clockify Workspace ID';
            DataClassification = SystemMetadata;
        }
        field(6; "Clockify ID"; Text[35])
        {
            Caption = 'Clockify ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; Archived; Boolean)
        {
            Caption = 'Archived';
            DataClassification = SystemMetadata;
        }
        field(8; "Next Synchronization"; Enum "Clockify Synchronization Type")
        {
            Caption = 'Next Synchronization';
            DataClassification = SystemMetadata;
        }
        field(9; "Related Record System Id"; Guid)
        {
            Caption = 'Related Record System Id';
            DataClassification = SystemMetadata;
        }
        field(13; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Last Synchronization"; DateTime)
        {
            Caption = 'Last Synchronization';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "User Security ID", "Integration Id")
        {
            Clustered = true;
        }
        key(Related; "Related Table ID", "Related Record Id")
        {
        }
        key(Clockify; "Related Table ID", "Clockify ID", "Next Synchronization")
        {
        }
    }

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;

    procedure CreateUpdateByRecordId(RelatedTableID: Integer; RelatedRecordID: RecordId; RelatedRecordSystemId: Guid; LastModifiedDateTime: DateTime): Boolean
    var
        Setup: Record "Clockify User Setup";
    begin
        Setup.Get(UserSecurityId());
        if not FindByRecordId(Setup."Clockify Workspace ID", RelatedTableID, RelatedRecordID) then begin
            Init();
            "User Security ID" := Setup."User Security ID";
            "Integration Id" := CreateGuid();
            "Related Table ID" := RelatedTableID;
            "Related Record Id" := RelatedRecordID;
            "Related Record System Id" := RelatedRecordSystemId;
            "Last Modified Date Time" := LastModifiedDateTime;
            "Next Synchronization" := "Next Synchronization"::Create;
            Insert();
        end else begin
            "Related Record System Id" := RelatedRecordSystemId;
            if LastModifiedDateTime > "Last Modified Date Time" then
                "Next Synchronization" := "Next Synchronization"::Update;
            Modify();
        end;
    end;

    procedure FindByClockifyId(ClockifyWorkspaceID: Text[35]; RelatedTableID: Integer; ClockifyID: Text[35]): Boolean
    begin
        SetRange("Clockify Workspace ID", ClockifyWorkspaceID);
        SetRange("Related Table ID", RelatedTableID);
        SetRange("Clockify ID", ClockifyID);
        exit(FindFirst());
    end;

    procedure FindByRecordId(ClockifyWorkspaceID: Text[35]; RelatedTableID: Integer; RelatedRecordID: RecordId): Boolean
    begin
        SetRange("Clockify Workspace ID", ClockifyWorkspaceID);
        SetRange("Related Table ID", RelatedTableID);
        SetRange("Related Record Id", RelatedRecordID);
        exit(FindFirst());
    end;

    procedure SetNextSync(NextSync: Enum "Clockify Synchronization Type")
    var
        Integration: Record "Clockify Integration Record";
    begin
        Integration := Rec;
        Integration."Next Synchronization" := NextSync;
        Integration.Modify();
    end;
}