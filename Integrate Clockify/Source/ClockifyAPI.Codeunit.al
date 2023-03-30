codeunit 70601 "Clockify API"
{
    procedure GetUserJson(Setup: Record "Clockify User Setup") Json: JsonToken;
    var
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/user', 'GET', Setup.GetAPIKey(), Request);
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        exit(WebRequest.ReadAsJson(Response));
    end;

    procedure GetTimeSheetEntries(Setup: Record "Clockify User Setup"; ClockifyWorkspaceID: Text[35]; TimeSheet: Record "Time Sheet Header")
    var
        TimeEntry: Record "Clockify Time Sheet Entry";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Json: JsonToken;
        EntryJson: JsonToken;
        EndOfJson: Boolean;
        PageNo: Integer;
    begin
        while not EndOfJson do begin
            PageNo += 1;
            WebRequest.SetRequest(
                Setup."API Base Endpoint" + '/workspaces/' + ClockifyWorkspaceID +
                '/user/' + Setup."Clockify ID" + '/time-entries' +
                '?start=' + format(CreateDateTime(TimeSheet."Starting Date", 000000T), 0, 9) +
                '&end=' + format(CreateDateTime(TimeSheet."Ending Date", 235959T), 0, 9) +
                '&page-size=10&project-required=1&task-required=1&consider-duration-format=true&in-progress=false' +
                '&page=' + Format(PageNo, 0, 9),
                'GET', Setup.GetAPIKey(), Request);
            LogRequestActivity(Setup, Request);
            WebRequest.SendRequest(Request, Response);
            LogResponseActivity(Setup, Request.GetRequestUri, Response);
            Json := WebRequest.ReadAsJson(Response);
            EndOfJson := Json.AsArray().Count() = 0;
            foreach EntryJson in Json.AsArray() do
                TimeEntry.ReadFromJson(EntryJson);
            Commit();
        end;
    end;

    procedure GetJobs(Setup: Record "Clockify User Setup")
    var
        Integration: Record "Clockify Integration Record";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Json: JsonToken;
        EntryJson: JsonToken;
        JValue: JsonToken;
        EndOfJson: Boolean;
        PageNo: Integer;
    begin
        while not EndOfJson do begin
            PageNo += 1;
            WebRequest.SetRequest(
                Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" +
                '/projects/' +
                '?page-size=10' +
                '&page=' + Format(PageNo, 0, 9),
                'GET', Setup.GetAPIKey(), Request);
            LogRequestActivity(Setup, Request);
            WebRequest.SendRequest(Request, Response);
            LogResponseActivity(Setup, Request.GetRequestUri, Response);
            Json := WebRequest.ReadAsJson(Response);
            EndOfJson := Json.AsArray().Count() = 0;
            foreach EntryJson in Json.AsArray() do begin
                EntryJson.AsObject().Get('id', JValue);
                if Integration.FindByClockifyId(Setup."Clockify Workspace ID", Database::Job, CopyStr(JValue.AsValue().AsText(), 1, 35)) then
                    if EntryJson.AsObject().Get('archived', JValue) then
                        if Integration.Archived <> JValue.AsValue().AsBoolean() then begin
                            Integration.Archived := JValue.AsValue().AsBoolean();
                            Integration.Modify();
                        end;
            end;
            Commit();
        end;
    end;

    procedure AddClient(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Customer: Record Customer;
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not Customer.Get(Integration."Related Record Id") then exit;
        if Customer.Name = '' then exit;
        RequestJson.Add('name', Customer.Name);
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/clients', 'POST', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        if ResponseJson.Get('workspaceId', JValue) then
            Integration."Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify Workspace ID"));
        if ResponseJson.Get('archived', JValue) then
            Integration.Archived := JValue.AsValue().AsBoolean();
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    procedure UpdateClient(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Customer: Record Customer;
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not Customer.Get(Integration."Related Record Id") then exit;
        if Customer.Name = '' then exit;
        RequestJson.Add('name', Customer.Name);
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/clients/' + Integration."Clockify ID", 'PUT', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        if ResponseJson.Get('workspaceId', JValue) then
            Integration."Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify Workspace ID"));
        if ResponseJson.Get('archived', JValue) then
            Integration.Archived := JValue.AsValue().AsBoolean();
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    procedure AddJob(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Job: Record Job;
        Customer: Record Customer;
        CustomerIntegration: Record "Clockify Integration Record";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        EstimateJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not Job.Get(Integration."Related Record Id") then exit;
        if Job.Description = '' then exit;
        Job.Calcfields("Scheduled Res. Qty.");
        Customer.Get(Job."Bill-to Customer No.");
        if not CustomerIntegration.FindByRecordId(Setup."Clockify Workspace ID", Database::Customer, Customer.RecordId()) then exit;
        if CustomerIntegration."Clockify ID" = '' then exit;
        RequestJson.Add('name', Job.Description);
        RequestJson.Add('clientId', CustomerIntegration."Clockify ID");
        RequestJson.Add('isPublic', false);
        EstimateJson.Add('estimate', Job."Scheduled Res. Qty.");
        EstimateJson.Add('type', 'AUTO');
        RequestJson.Add('estimate', EstimateJson);
        RequestJson.Add('color', '#f44336');
        RequestJson.Add('billable', true);
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/projects', 'POST', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        if ResponseJson.Get('workspaceId', JValue) then
            Integration."Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify Workspace ID"));
        if ResponseJson.Get('archived', JValue) then
            Integration.Archived := JValue.AsValue().AsBoolean();
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    procedure UpdateJob(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Job: Record Job;
        Customer: Record Customer;
        CustomerIntegration: Record "Clockify Integration Record";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        EstimateJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not Job.Get(Integration."Related Record Id") then exit;
        if Job.Description = '' then exit;
        Job.Calcfields("Scheduled Res. Qty.");
        Customer.Get(Job."Bill-to Customer No.");
        if not CustomerIntegration.FindByRecordId(Setup."Clockify Workspace ID", Database::Customer, Customer.RecordId()) then exit;
        if CustomerIntegration."Clockify ID" = '' then exit;
        RequestJson.Add('name', Job.Description);
        RequestJson.Add('clientId', CustomerIntegration."Clockify ID");
        RequestJson.Add('isPublic', false);
        EstimateJson.Add('estimate', Job."Scheduled Res. Qty.");
        EstimateJson.Add('type', 'AUTO');
        RequestJson.Add('estimate', EstimateJson);
        RequestJson.Add('color', '#f44336');
        RequestJson.Add('billable', true);
        RequestJson.Add('archived', Integration."Next Synchronization" = Integration."Next Synchronization"::Archive);
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/projects/' + Integration."Clockify ID", 'PUT', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        if ResponseJson.Get('workspaceId', JValue) then
            Integration."Clockify Workspace ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify Workspace ID"));
        if ResponseJson.Get('archived', JValue) then
            Integration.Archived := JValue.AsValue().AsBoolean();
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    procedure AddJobTask(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Job: Record Job;
        JobTask: Record "Job Task";
        JobIntegration: Record "Clockify Integration Record";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not JobTask.Get(Integration."Related Record Id") then exit;
        Job.Get(JobTask."Job No.");
        if not JobIntegration.FindByRecordId(Setup."Clockify Workspace ID", Database::Job, Job.RecordId()) then exit;
        if JobIntegration."Clockify ID" = '' then exit;
        if JobTask.Description = '' then exit;
        RequestJson.Add('name', JobTask.Description);
        RequestJson.Add('projectId', JobIntegration."Clockify ID");
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/projects/' + JobIntegration."Clockify ID" + '/tasks', 'POST', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        Integration."Clockify Workspace ID" := JobIntegration."Clockify Workspace ID";
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    procedure UpdateJobTask(Integration: Record "Clockify Integration Record");
    var
        Setup: Record "Clockify User Setup";
        Job: Record Job;
        JobTask: Record "Job Task";
        JobIntegration: Record "Clockify Integration Record";
        WebRequest: Codeunit "Clockify Http Request";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        RequestJson: JsonObject;
        ResponseJson: JsonObject;
        JValue: JsonToken;
    begin
        Setup.Get(Integration."User Security ID");
        if not Setup.Enabled then exit;
        if not JobTask.Get(Integration."Related Record Id") then exit;
        Job.Get(JobTask."Job No.");
        if not JobIntegration.FindByRecordId(Setup."Clockify Workspace ID", Database::Job, Job.RecordId()) then exit;
        if JobIntegration."Clockify ID" = '' then exit;
        if JobTask.Description = '' then exit;
        RequestJson.Add('name', JobTask.Description);
        RequestJson.Add('projectId', JobIntegration."Clockify ID");
        WebRequest.SetRequest(Setup."API Base Endpoint" + '/workspaces/' + Setup."Clockify Workspace ID" + '/projects/' + JobIntegration."Clockify ID" + '/tasks/' + Integration."Clockify ID", 'PUT', Setup.GetAPIKey(), Request);
        WebRequest.SetRequestContent(Request, 'application/json', RequestJson.AsToken());
        LogRequestActivity(Setup, Request);
        WebRequest.SendRequest(Request, Response);
        LogResponseActivity(Setup, Request.GetRequestUri, Response);
        ResponseJson := WebRequest.ReadAsJson(Response).AsObject();
        if ResponseJson.Get('id', JValue) then
            Integration."Clockify ID" := CopyStr(JValue.AsValue().AsText(), 1, MaxStrLen(Integration."Clockify ID"));
        Integration."Clockify Workspace ID" := JobIntegration."Clockify Workspace ID";
        Integration.SetNextSync(Integration."Next Synchronization"::None);
        Commit();
    end;

    local procedure LogRequestActivity(Setup: Record "Clockify User Setup"; Request: HttpRequestMessage)
    var
        ActivityLog: Record "Activity Log";
        Json: Text;
    begin
        if not Setup."Log Activity" then exit;

        if UpperCase(Request.Method()) in ['POST', 'PATCH', 'PUT'] then begin
            Request.Content().ReadAs(Json);
            ActivityLog.LogActivity(Setup, ActivityLog.Status::Success, SentMsg, Request.GetRequestUri(), Json);
        end;

    end;

    local procedure LogResponseActivity(Setup: Record "Clockify User Setup"; Uri: Text; Response: HttpResponseMessage);
    var
        ActivityLog: Record "Activity Log";
        Json: Text;
    begin
        if not Setup."Log Activity" then exit;


        Response.Content().ReadAs(Json);
        ActivityLog.LogActivity(Setup, ActivityLog.Status::Success, ReceivedMsg, Uri, Json);
    end;



    var
        SentMsg: Label 'Message Sent', MaxLength = 30;
        ReceivedMsg: Label 'Message Received', MaxLength = 30;
}