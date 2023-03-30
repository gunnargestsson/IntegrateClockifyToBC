table 70601 "Clockify Time Sheet Entry"
{
    Caption = 'Clockify Time Sheet Entry';
    DataClassification = EndUserIdentifiableInformation;
    fields
    {
        field(1; "Clockify ID"; Text[35])
        {
            Caption = 'Clockify ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Clockify User ID"; Text[35])
        {
            Caption = 'Clockify User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; Billable; Boolean)
        {
            Caption = 'Billable';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Job Task ID"; Text[35])
        {
            Caption = 'Job Task ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; "Job ID"; Text[35])
        {
            Caption = 'Job ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; Locked; Boolean)
        {
            Caption = 'Locked';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; "Next Synchronization"; Enum "Clockify Synchronization Type")
        {
            Caption = 'Next Synchronization';
            DataClassification = SystemMetadata;
        }
        field(9; "Clockify Workspace ID"; Text[35])
        {
            Caption = 'Clockify Workspace ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; "Start Time"; DateTime)
        {
            Caption = 'Start Time';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "End Time"; DateTime)
        {
            Caption = 'End Time';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Entry Duration"; Text[20])
        {
            Caption = 'Entry Duration';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Time Sheet Detail ID"; Guid)
        {
            Caption = 'Time Sheet Detail ID';
            DataClassification = SystemMetadata;
        }
        field(14; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Time Sheet Line ID"; Guid)
        {
            Caption = 'Time Sheet Line ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Clockify ID")
        {
            Clustered = true;
        }
        key(Registration; "Clockify User ID", "Next Synchronization")
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

    procedure InsertToTimeSheet()
    var
        Setup: Record "Clockify User Setup";
        JobTask: Record "Job Task";
        TimeSheet: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
    begin
        if not VerifyData(TimeSheet, Setup, JobTask) then exit;
        FindOrCreateTimeSheetLine(TimeSheet, JobTask, Setup."Default Work Type", TimeSheetLine);
        AddDetailLine(TimeSheet, TimeSheetLine);
        SetNextSync("Next Synchronization"::None);
    end;

    procedure ReadFromJson(Json: JsonToken) ChangedEntry: Boolean
    var
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
        JValue: JsonToken;
        TimeIntervalJson: JsonToken;
    begin
        Json.AsObject().Get('id', JValue);
        "Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify ID"));
        ChangedEntry := Find();
        TimeSheetEntry := Rec;
        if Json.AsObject().Get('description', JValue) then
            Description := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Description));
        Json.AsObject().Get('userId', JValue);
        "Clockify User ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify User ID"));
        if Json.AsObject().Get('billable', JValue) then
            Billable := JValue.AsValue().AsBoolean();
        Json.AsObject().Get('taskId', JValue);
        "Job Task ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Job Task ID"));
        Json.AsObject().Get('projectId', JValue);
        "Job ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Job ID"));
        Json.AsObject().Get('workspaceId', JValue);
        "Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Clockify Workspace ID"));
        if Json.AsObject().Get('locked', JValue) then
            Locked := JValue.AsValue().AsBoolean();
        if Json.AsObject().Get('timeInterval', TimeIntervalJson) then begin
            if TimeIntervalJson.AsObject().Get('start', JValue) then
                "Start Time" := JValue.AsValue().AsDateTime();
            if TimeIntervalJson.AsObject().Get('end', JValue) then
                "End Time" := JValue.AsValue().AsDateTime();
            if TimeIntervalJson.AsObject().Get('duration', JValue) then
                "Entry Duration" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen("Entry Duration"));
        end;
        "Next Synchronization" := "Next Synchronization"::Create;
        Quantity := Round(("End Time" - "Start Time") / 3600000, 0.5, '>');
        if ChangedEntry then begin
            Modify();
            if (TimeSheetEntry."Job ID" <> "Job ID") or (TimeSheetEntry."Job Task ID" <> "Job Task ID") or (TimeSheetEntry."Start Time" <> "Start Time") or (TimeSheetEntry."End Time" <> "End Time") or (TimeSheetEntry.Description <> Description) then
                TimeSheetEntry.SetNextSync("Next Synchronization"::Update);
        end else
            Insert();
    end;

    procedure SetNextSync(NextSync: Enum "Clockify Synchronization Type")
    var
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
    begin
        ApplyFilter(TimeSheetEntry);
        TimeSheetEntry.ModifyAll("Next Synchronization", NextSync);
    end;

    procedure UpdateTimeSheet()
    var
        Setup: Record "Clockify User Setup";
        JobTask: Record "Job Task";
        TimeSheet: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
    begin
        if not VerifyData(TimeSheet, Setup, JobTask) then exit;
        FindOrCreateTimeSheetLine(TimeSheet, JobTask, Setup."Default Work Type", TimeSheetLine);
        UpdateDetailLine(TimeSheet, TimeSheetLine);
        SetNextSync("Next Synchronization"::None);
    end;

    local procedure AddDetailLine(TimeSheet: Record "Time Sheet Header"; TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetDetail: Record "Time Sheet Detail";
    begin
        if TimeSheetDetail.Get(TimeSheet."No.", TimeSheetLine."Line No.", DT2Date("Start Time")) then
            TimeSheetDetail.Delete();
        TimeSheetDetail.Init();
        TimeSheetDetail.SystemId := CreateGuid();
        TimeSheetDetail."Date" := DT2Date("Start Time");
        TimeSheetDetail."Job No." := TimeSheetLine."Job No.";
        TimeSheetDetail."Job Task No." := TimeSheetLine."Job Task No.";
        TimeSheetDetail."Resource No." := TimeSheet."Resource No.";
        TimeSheetDetail."Time Sheet Line No." := TimeSheetLine."Line No.";
        TimeSheetDetail."Time Sheet No." := TimeSheetLine."Time Sheet No.";
        TimeSheetDetail."Type" := TimeSheetLine."Type";
        TimeSheetDetail."Last Modified DateTime" := RoundDateTime(CurrentDateTime());
        TimeSheetDetail.Quantity := GetTotalQuantity();
        TimeSheetDetail.Insert(false, true);
        SetTimeSheetDetailID(TimeSheetDetail.SystemId);
    end;

    local procedure ApplyFilter(var TimeSheetEntry: Record "Clockify Time Sheet Entry")
    begin
        TimeSheetEntry.SetRange("Clockify User ID", "Clockify User ID");
        TimeSheetEntry.SetRange("Clockify Workspace ID", "Clockify Workspace ID");
        TimeSheetEntry.SetRange("Job ID", "Job ID");
        TimeSheetEntry.SetRange("Job Task ID", "Job Task ID");
        TimeSheetEntry.SetRange(Description, Description);
        TimeSheetEntry.SetRange("Start Time", CreateDateTime(DT2Date("Start Time"), 000000T), CreateDateTime(DT2Date("Start Time"), 235959T));
    end;

    local procedure FindOrCreateTimeSheetLine(TimeSheet: Record "Time Sheet Header"; JobTask: Record "Job Task"; DefaultWorkTypeCode: Code[10]; var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetLineDescription: Text;
    begin
        if Description = '' then
            TimeSheetLineDescription := JobTask.Description
        else
            TimeSheetLineDescription := Description;

        TimeSheetLine.SetRange("Time Sheet No.", TimeSheet."No.");
        TimeSheetLine.SetRange("Type", TimeSheetLine."Type"::Job);
        TimeSheetLine.SetRange("Job No.", JobTask."Job No.");
        TimeSheetLine.SetRange("Job Task No.", JobTask."Job Task No.");
        TimeSheetLine.SetRange("Work Type Code", DefaultWorkTypeCode);
        TimeSheetLine.SetRange(Description, CopyStr(TimeSheetLineDescription, 1, MaxStrLen(TimeSheetLine.Description)));
        TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Open);
        if TimeSheetLine.FindFirst() then begin
            "Time Sheet Line ID" := TimeSheetLine.SystemId;
            Modify();
            exit;
        end;
        TimeSheetLine.SetRange("Type");
        TimeSheetLine.SetRange("Job No.");
        TimeSheetLine.SetRange("Job Task No.");
        TimeSheetLine.SetRange("Work Type Code");
        TimeSheetLine.SetRange(Description);
        TimeSheetLine.SetRange(Status);
        if not TimeSheetLine.FindLast() then;
        "Time Sheet Line ID" := CreateGuid();
        TimeSheetLine.Init();
        TimeSheetLine.Chargeable := Billable;
        TimeSheetLine.Description := CopyStr(TimeSheetLineDescription, 1, MaxStrLen(TimeSheetLine.Description));
        TimeSheetLine."Job No." := JobTask."Job No.";
        TimeSheetLine."Job Task No." := JobTask."Job Task No.";
        TimeSheetLine."Line No." := TimeSheetLine."Line No." + 10000;
        TimeSheetLine."Time Sheet No." := TimeSheet."No.";
        TimeSheetLine."Time Sheet Starting Date" := TimeSheet."Starting Date";
        TimeSheetLine."Type" := TimeSheetLine."Type"::Job;
        TimeSheetLine."Work Type Code" := DefaultWorkTypeCode;
        TimeSheetLine.SystemId := "Time Sheet Line ID";
        TimeSheetLine.Insert(false, true);
        Modify();
    end;

    local procedure GetTotalQuantity(): Decimal;
    var
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
    begin
        ApplyFilter(TimeSheetEntry);
        TimeSheetEntry.CalcSums(Quantity);
        exit(TimeSheetEntry.Quantity);
    end;

    local procedure SetTimeSheetDetailID(TimeSheetDetailID: Guid)
    var
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
    begin
        ApplyFilter(TimeSheetEntry);
        TimeSheetEntry.ModifyAll("Time Sheet Detail ID", TimeSheetDetailID);
    end;

    local procedure UpdateDetailLine(TimeSheet: Record "Time Sheet Header"; TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetDetail: Record "Time Sheet Detail";
    begin
        TimeSheetDetail.GetBySystemId("Time Sheet Detail ID");
        TimeSheetDetail.Delete();
        TimeSheetDetail."Date" := DT2Date("Start Time");
        TimeSheetDetail."Job No." := TimeSheetLine."Job No.";
        TimeSheetDetail."Job Task No." := TimeSheetLine."Job Task No.";
        TimeSheetDetail."Last Modified DateTime" := RoundDateTime(CurrentDateTime());
        TimeSheetDetail.Quantity := GetTotalQuantity();
        TimeSheetDetail."Resource No." := TimeSheet."Resource No.";
        TimeSheetDetail."Time Sheet Line No." := TimeSheetLine."Line No.";
        TimeSheetDetail."Time Sheet No." := TimeSheetLine."Time Sheet No.";
        TimeSheetDetail."Type" := TimeSheetLine."Type";
        TimeSheetDetail.Insert();
    end;

    local procedure VerifyData(var TimeSheet: Record "Time Sheet Header"; var Setup: Record "Clockify User Setup"; var JobTask: Record "Job Task"): Boolean
    var
        Integration: Record "Clockify Integration Record";
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
        Job: Record Job;
        User: Record User;
    begin
        TimeSheetEntry.Copy(Rec);
#pragma warning disable AA0181
        if not TimeSheetEntry.Find() then exit;
#pragma warning restore AA0181
        if not Setup.FindByClockifyID("Clockify User ID") then exit;
        User.Get(Setup."User Security ID");
        TimeSheet.SetRange("Owner User ID", User."User Name");
        TimeSheet.SetRange("Starting Date", 0D, DT2Date("Start Time"));
        TimeSheet.SetRange("Ending Date", DT2Date("Start Time"), DMY2Date(31, 12, 9999));
        if not TimeSheet.FindFirst() then exit;
        if not Integration.FindByClockifyId(TimeSheetEntry."Clockify Workspace ID", Database::Job, "Job ID") then exit;
        Job.Get(Integration."Related Record Id");
        if not Integration.FindByClockifyId(TimeSheetEntry."Clockify Workspace ID", Database::"Job Task", "Job Task ID") then exit;
        JobTask.Get(Integration."Related Record Id");
        exit(true);
    end;
}