codeunit 90000 "Integrate Clockify Tests"
{
    Description = 'Description';
    Subtype = Test;

    trigger OnRun();
    begin
        IsInitialized := false;
    end;

    [Test]
    procedure "Default_Build_Test"()
    begin
        Initialize();
        // [GIVEN] Default 
        // [WHEN] Build 
        // [THEN] Test 
    end;

    local procedure Initialize();
    begin
        ClearLastError();
        LibraryVariableStorage.Clear();
        if IsInitialized then
            exit;



        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

    end;

    var
        Assert: Codeunit "Library Assert";
        Any: Codeunit "Any";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        IsInitialized: Boolean;
}
