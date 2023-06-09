permissionset 70650 "Integrate Clockify"
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
        codeunit "Clockify API" = X,
        codeunit "Clockify Http Request" = X,
        codeunit "Clockify Job Queue" = X,
        codeunit "Clockify to Business Central" = X,
        page "Clockify Integration List" = X,
        page "Clockify Time Sheet Entry List" = X,
        page "Clockify User Setup Card" = X,
        page "Clockify User Setup List" = X;
}
