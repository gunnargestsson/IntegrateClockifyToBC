codeunit 70602 "Clockify to Business Central"
{

    trigger OnRun()
    begin
        ExecuteSync();
    end;

    local procedure ExecuteSync()
    var
    begin
        UpdateIntegrationRecord();
        AddToIntegrationRecord();
        ArchiveIntegrationRecord();
        GetJobs();
        CreateCustomers();
        UpdateCustomers();
        CreateJobs();
        UpdateJobs();
        CreateJobTasks();
        UpdateJobTasks();
        GetTimeSheetEntries();
        ImportTimeSheetEntries();
    end;

    local procedure AddToIntegrationRecord()
    var
        Job: Record "Job";
        JobTask: Record "Job Task";
        Integration: Record "Clockify Integration Record";
        Customer: Record Customer;
    begin
        Job.SetRange(Status, Job.Status::Open);
        Job.SetFilter("Bill-to Customer No.", '<>%1', '');
        JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
        if Job.FindSet() then
            repeat
                Integration.CreateUpdateByRecordId(Database::Job, Job.RecordId(), Job.SystemId, Job.SystemModifiedAt);
                Customer.Get(Job."Bill-to Customer No.");
                Integration.CreateUpdateByRecordId(Database::Customer, Customer.RecordId(), Customer.SystemId, Customer.SystemModifiedAt);
                JobTask.SetRange("Job No.", Job."No.");
                if JobTask.FindSet() then
                    repeat
                        Integration.CreateUpdateByRecordId(Database::"Job Task", JobTask.RecordId(), JobTask.SystemId, JobTask.SystemModifiedAt);
                    until JobTask.Next() = 0;
            until Job.Next() = 0;
        Commit();
    end;

    local procedure GetJobs()
    var
        Setup: Record "Clockify User Setup";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Setup.SetRange(Enabled, true);
        if Setup.FindSet() then
            repeat
                ClockifyApi.GetJobs(Setup);
            until Setup.Next() = 0;
    end;

    local procedure ArchiveIntegrationRecord()
    var
        Job: Record "Job";
        JobTask: Record "Job Task";
        Integration: Record "Clockify Integration Record";
        Customer: Record Customer;
    begin
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::None);
        if Integration.FindSet() then
            repeat
                case Integration."Related Table ID" of
                    Database::Customer:
                        if Customer.Get(Integration."Related Record Id") then
                            if Customer.Blocked = Customer.Blocked::All then
                                Integration.SetNextSync(Integration."Next Synchronization"::Archive);
                    Database::Job:
                        if Job.Get(Integration."Related Record Id") then
                            if Job.Status <> Job.Status::Open then
                                Integration.SetNextSync(Integration."Next Synchronization"::Archive);
                    Database::"Job Task":
                        if JobTask.Get(Integration."Related Record Id") then begin
                            Job.Get(JobTask."Job No.");
                            if Job.Status <> Job.Status::Open then
                                Integration.SetNextSync(Integration."Next Synchronization"::Archive);
                        end;
                end;
            until Integration.Next() = 0;
        Commit();
    end;

    local procedure UpdateIntegrationRecord()
    var
        Job: Record "Job";
        JobTask: Record "Job Task";
        Integration: Record "Clockify Integration Record";
        Customer: Record Customer;
    begin
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Archive);
        if Integration.FindSet() then
            repeat
                case Integration."Related Table ID" of
                    Database::Customer:
                        if Customer.Get(Integration."Related Record Id") then
                            if Customer.Blocked <> Customer.Blocked::All then
                                Integration.SetNextSync(Integration."Next Synchronization"::Create);
                    Database::Job:
                        if Job.Get(Integration."Related Record Id") then
                            if Job.Status = Job.Status::Open then
                                Integration.SetNextSync(Integration."Next Synchronization"::Create);
                    Database::"Job Task":
                        if JobTask.Get(Integration."Related Record Id") then begin
                            Job.Get(JobTask."Job No.");
                            if Job.Status = Job.Status::Open then
                                Integration.SetNextSync(Integration."Next Synchronization"::Create);
                        end;
                end;
            until Integration.Next() = 0;
        Commit();
    end;

    local procedure CreateCustomers()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::Customer);
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Create);
        if Integration.FindSet() then
            repeat
                ClockifyApi.AddClient(Integration);
            until Integration.Next() = 0;
    end;

    local procedure UpdateCustomers()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::Customer);
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Update);
        if Integration.FindSet() then
            repeat
                ClockifyApi.UpdateClient(Integration);
            until Integration.Next() = 0;
    end;

    local procedure CreateJobs()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::Job);
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Create);
        if Integration.FindSet() then
            repeat
                ClockifyApi.AddJob(Integration);
            until Integration.Next() = 0;
    end;

    local procedure UpdateJobs()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::Job);
        Integration.SetRange(Archived, false);
        Integration.SetFilter("Next Synchronization", '%1|%2', Integration."Next Synchronization"::Update, Integration."Next Synchronization"::Archive);
        if Integration.FindSet() then
            repeat
                ClockifyApi.UpdateJob(Integration);
            until Integration.Next() = 0;
    end;

    local procedure CreateJobTasks()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::"Job Task");
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Create);
        if Integration.FindSet() then
            repeat
                ClockifyApi.AddJobTask(Integration);
            until Integration.Next() = 0;
    end;

    local procedure UpdateJobTasks()
    var
        Integration: Record "Clockify Integration Record";
        ClockifyApi: Codeunit "Clockify API";
    begin
        Integration.SetCurrentKey("User Security ID", "Related Table ID");
        Integration.SetRange("Related Table ID", Database::"Job Task");
        Integration.SetRange("Next Synchronization", Integration."Next Synchronization"::Update);
        if Integration.FindSet() then
            repeat
                ClockifyApi.AddJobTask(Integration);
            until Integration.Next() = 0;
    end;

    local procedure GetTimeSheetEntries()
    var
        TimeSheet: Record "Time Sheet Header";
        Setup: Record "Clockify User Setup";
        User: Record User;
        ClockifyApi: Codeunit "Clockify API";
        ClockifyWorkspaceID: Text[35];
    begin
        Setup.Get(UserSecurityId());
        ClockifyWorkspaceID := Setup."Clockify Workspace ID";
        Setup.SetRange(Enabled, true);
        if Setup.FindSet() then
            repeat
                User.Get(Setup."User Security ID");
                TimeSheet.SetRange("Owner User ID", User."User Name");
                if TimeSheet.FindSet() then
                    repeat
                        ClockifyApi.GetTimeSheetEntries(Setup, ClockifyWorkspaceID, TimeSheet);
                    until TimeSheet.Next() = 0;
            until Setup.Next() = 0;
    end;

    local procedure ImportTimeSheetEntries()
    var
        TimeSheetEntry: Record "Clockify Time Sheet Entry";
    begin
        TimeSheetEntry.SetRange("Next Synchronization", TimeSheetEntry."Next Synchronization"::Create, TimeSheetEntry."Next Synchronization"::Update);
        if TimeSheetEntry.FindSet(true) then
            repeat
                case TimeSheetEntry."Next Synchronization" of
                    TimeSheetEntry."Next Synchronization"::Create:
                        TimeSheetEntry.InsertToTimeSheet();
                    TimeSheetEntry."Next Synchronization"::Update:
                        TimeSheetEntry.UpdateTimeSheet();
                end;
            until TimeSheetEntry.Next() = 0;
    end;
}