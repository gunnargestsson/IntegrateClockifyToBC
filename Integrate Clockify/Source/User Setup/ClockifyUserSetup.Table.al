table 70600 "Clockify User Setup"
{
    Caption = 'Clockify User Setup';
    DataCaptionFields = "Clockify Name";
    DataClassification = EndUserIdentifiableInformation;
    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Security ID";
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin
                TestField("Default Work Type");
                if Enabled then
                    Enabled := HasAPIKey();
                if Enabled then
                    Enabled := GetClockifyUser();
                if CanScheduleJobQueue() then
                    if Enabled and not "Manual Synchronization" then begin
                        ScheduleJobQueueEntry();
                        if Confirm(JobQEntriesCreatedQst) then
                            ShowJobQueueEntry();
                    end else
                        CancelJobQueueEntry();
            end;
        }
        field(3; "API Base Endpoint"; Text[250])
        {
            Caption = 'API Base Endpoint';
            DataClassification = SystemMetadata;
        }
        field(4; "API Key ID"; Guid)
        {
            Caption = 'API Key ID';
            DataClassification = SystemMetadata;
        }
        field(5; "Clockify ID"; Text[35])
        {
            Caption = 'Clockify ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(6; "Clockify Name"; Text[250])
        {
            Caption = 'Clockify Name';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(7; "Clockify E-Mail Address"; Text[80])
        {
            Caption = 'Clockify E-Mail Address';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Clockify Workspace ID"; Text[35])
        {
            Caption = 'Clockify Workspace ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(9; "Clockify Status"; Text[10])
        {
            Caption = 'Clockify Status';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(10; "Manual Synchronization"; Boolean)
        {
            Caption = 'Manual Synchronization';
            DataClassification = SystemMetadata;
        }
        field(11; "Default Work Type"; Code[10])
        {
            Caption = 'Default Work Type';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Work Type";
        }
        field(12; "Log Activity"; Boolean)
        {
            Caption = 'Log Activity';
            DataClassification = SystemMetadata;
        }
        field(13; "Max. No. of Failures"; Integer)
        {
            Caption = 'Max. No. of Failures';
            DataClassification = SystemMetadata;
        }
        field(14; "No. of Failures"; Integer)
        {
            Caption = 'No. of Failures';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "User Security ID")
        {
            Clustered = true;
        }
    }

    var
        JobQEntriesCreatedQst: Label 'Job queue entries for integration with Clockify have been created.\\Do you want to open the Job Queue Entries window?';

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    var
        Integration: Record "Clockify Integration Record";
    begin
        if Count() = 1 then
            CancelJobQueueEntry();
        Integration.SetRange("User Security ID", "User Security ID");
        Integration.ModifyAll("Next Synchronization", Integration."Next Synchronization"::Retired);
        DeleteAPIKey();
    end;

    trigger OnRename()
    begin
    end;

    procedure CancelJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"Clockify Job Queue") then
            JobQueueEntry.Cancel();
    end;

    procedure CanScheduleJobQueue(): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";
        User: Record User;
    begin
        if not User.Get("User Security ID") then exit(false);
        if User."License Type" <> User."License Type"::"Full User" then exit(false);
        exit(JobQueueEntry.WritePermission());
    end;

    procedure DeleteAPIKey()
    begin
        if HasAPIKey() then
            IsolatedStorage.Delete("API Key ID", DataScope::Module);
    end;

    procedure FindByClockifyID(ClockifyID: Text[35]): Boolean
    begin
        SetRange("Clockify ID", ClockifyID);
        exit(FindFirst() and Enabled);
    end;

    procedure GetAPIKey() ApiKey: Text;
    begin
        if not HasAPIKey() then exit('');
        IsolatedStorage.Get("API Key ID", DataScope::Module, ApiKey);
    end;

    procedure HasAPIKey(): Boolean
    begin
        if IsNullGuid("API Key ID") then
            "API Key ID" := CreateGuid();
        exit(IsolatedStorage.Contains("API Key ID", DataScope::Module));
    end;

    procedure InitializeAPISetup()
    begin
        "API Base Endpoint" := 'https://api.clockify.me/api/v1';
    end;

    procedure ScheduleJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        DummyRecId: RecordId;
    begin
        CancelJobQueueEntry();
        JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
          Codeunit::"Clockify Job Queue", DummyRecId);
    end;

    procedure SetAPIKey(ApiKey: Text)
    begin
        if HasAPIKey() then
            IsolatedStorage.Delete("API Key ID", DataScope::Module);
        if ApiKey = '' then exit;
        if EncryptionEnabled() then
            IsolatedStorage.SetEncrypted("API Key ID", ApiKey, DataScope::Module)
        else
            IsolatedStorage.Set("API Key ID", ApiKey, DataScope::Module);
        Modify();
    end;

    procedure ShowJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"Clockify Job Queue") then
            Page.Run(Page::"Job Queue Entries", JobQueueEntry);
    end;

    local procedure GetClockifyUser(): Boolean
    var
        ClockifyApi: Codeunit "Clockify API";
        Json: JsonToken;
        JValue: JsonToken;
    begin
        Json := ClockifyApi.GetUserJson(Rec);
        if not Json.AsObject().Get('id', JValue) then exit(false);
        "Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify ID"));
        if not Json.AsObject().Get('name', JValue) then exit(false);
        "Clockify Name" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify Name"));
        if not Json.AsObject().Get('email', JValue) then exit(false);
        "Clockify E-Mail Address" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify E-Mail Address"));
        if not Json.AsObject().Get('activeWorkspace', JValue) then exit(false);
        "Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify Workspace ID"));
        if not Json.AsObject().Get('status', JValue) then exit(false);
        "Clockify Status" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify Status"));
        exit(Modify());
    end;
}