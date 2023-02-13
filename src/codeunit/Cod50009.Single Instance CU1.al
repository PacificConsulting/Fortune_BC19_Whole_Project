codeunit 50009 "Single Instance CU1"
{
    // version MOD01

    SingleInstance = true;

    trigger OnRun();
    begin
        IF NOT StoreToTemp THEN BEGIN
          StoreToTemp := TRUE;
        END ELSE
          PAGE.RUNMODAL(0,TempGLEntry);
    end;

    var
        TempGLEntry : Record 17 temporary;
        StoreToTemp : Boolean;

    procedure InsertGL(GLEntry : Record 17);
    begin
        IF StoreToTemp THEN BEGIN
          TempGLEntry := GLEntry;
          IF NOT TempGLEntry.INSERT THEN BEGIN
             TempGLEntry.DELETEALL;
             TempGLEntry.INSERT;
         END;
        END;
    end;
}

