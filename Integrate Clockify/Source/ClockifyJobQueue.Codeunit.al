codeunit 70603 "Clockify Job Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if Codeunit.Run(Codeunit::"Clockify to Business Central") then
            ResetNoOfFailures()
        else
            AddToNoOffailures();

        ThrowIfMaxNoOfFailures();
    end;

    var
        Setup: Record "Clockify User Setup";
        JobQueueTok: Label 'Job Queue Execuition', MaxLength = 30;


    local procedure ResetNoOfFailures()
    begin
        Setup.Get(UserSecurityId());
        if Setup."No. of Failures" = 0 then exit;
        Setup."No. of Failures" := 0;
        Setup.Modify();
    end;

    local procedure AddToNoOfFailures()
    begin
        Setup.Get(UserSecurityId());
        Setup."No. of Failures" += 1;
        Setup.Modify();
        LogActivityError();
    end;

    local procedure ThrowIfMaxNoOfFailures()
    begin
        Setup.Get(UserSecurityId());
        if Setup."No. of Failures" >= Setup."Max. No. of Failures" then
            Error(GetLastErrorText());
    end;

    local procedure LogActivityError();
    var
        ActivityLog: Record "Activity Log";
    begin
        if not Setup."Log Activity" then exit;
        ActivityLog.LogActivity(Setup, ActivityLog.Status::Failed, JobQueueTok, GetLastErrorText(), GetLastErrorCallStack());
    end;

}