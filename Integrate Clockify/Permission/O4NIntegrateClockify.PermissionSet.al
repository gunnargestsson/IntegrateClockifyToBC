permissionset 70651 O4NIntegrateClockify
{
    Assignable = true;
    Caption = 'Integrate Clockify', MaxLength = 30;
    Permissions =
        table "Clockify Integration Record" = X,
        tabledata "Clockify Integration Record" = RMID,
        table "Clockify Time Sheet Entry" = X,
        tabledata "Clockify Time Sheet Entry" = RMID,
        table "Clockify User Setup" = X,
        tabledata "Clockify User Setup" = RMID,
        table "O4N Job Workbench" = X,
        tabledata "O4N Job Workbench" = RMID,
        table "O4NPeriod Buffer" = X,
        tabledata "O4NPeriod Buffer" = RMID,
        codeunit "Clockify API" = X,
        codeunit "Clockify Http Request" = X,
        codeunit "Clockify Job Queue" = X,
        codeunit "Clockify to Business Central" = X,
        codeunit "O4NTime Management" = X,
        codeunit "O4N TimeSheet Mgt" = X,
        page "Clockify Integration List" = X,
        page "Clockify Time Sheet Entry List" = X,
        page "Clockify User Setup Card" = X,
        page "Clockify User Setup List" = X,
        page "O4NJob Fact Box" = X,
        page "O4NJob Task Fact Box" = X,
        page "O4NJob Task Part" = X,
        page "O4NJob Workbench" = X,
        page "O4NTime Sheet Factbox" = X;
}
