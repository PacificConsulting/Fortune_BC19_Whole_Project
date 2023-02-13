pageextension 50188 "Posted_Transfer_Ship_ext" extends "Posted Transfer Shipments"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {
        addafter("Transfer-to Code")
        {
            field("Transfer Order No."; "Transfer Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Receipt Date")
        {
            field("E-Way Bill No."; "E-Way Bill No.")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill Date"; "E-Way Bill Date")
            {
                ApplicationArea = all;
            }
            field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
            {
                ApplicationArea = all;
            }
            field("In-Bond BOE Date"; "In-Bond BOE Date")
            {
                ApplicationArea = all;
            }
            field("Ex-bond BOE No."; "Ex-bond BOE No.")
            {
                ApplicationArea = all;
            }
            field("E-Invoice IRN"; "E-Invoice IRN")
            {
                ApplicationArea = all;
            }
            field("GST Acknowledgement No."; "GST Acknowledgement No.")
            {
                ApplicationArea = all;
            }
            field("GST Acknowledgement Dt"; "GST Acknowledgement Dt")
            {
                ApplicationArea = all;
            }
            field("Ex-bond BOE Date"; "Ex-bond BOE Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Tax Invoice")
            {
                Enabled = Report_Visible1;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin

                    RecTSH.RESET;
                    RecTSH.SETRANGE(RecTSH."No.", "No.");
                    REPORT.RUNMODAL(50010, TRUE, FALSE, RecTSH);
                end;
            }
            action("Delivery Challan")
            {
                Enabled = Report_Visible;
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecTSH.RESET;
                    RecTSH.SETRANGE(RecTSH."No.", "No.");
                    IF RecTSH.FindFirst() then
                    //REPORT.RUNMODAL(50021,TRUE,FALSE,RecTSH);
                    //17-06-19 +
                    BEGIN
                        RecLoc.RESET;
                        IF RecLoc.GET(RecTSH."Transfer-from Code") THEN BEGIN
                            FromStateCode := RecLoc."State Code";
                        END;

                        RecLoc.RESET;
                        IF RecLoc.GET(RecTSH."Transfer-to Code") THEN BEGIN
                            ToStateCode := RecLoc."State Code";
                        END;

                        IF (FromStateCode = 'MH') THEN BEGIN
                            IF (ToStateCode = 'MH') THEN
                                REPORT.RUNMODAL(50011, TRUE, FALSE, RecTSH)
                            ELSE
                                REPORT.RUNMODAL(50021, TRUE, FALSE, RecTSH);
                        END ELSE
                            REPORT.RUNMODAL(50021, TRUE, FALSE, RecTSH);
                    END;
                end;

            }
        }
    }

    var
        RecTSH: Record 5744;
        RecTransShipmentHeader: Record 5744;
        Report_Visible: Boolean;
        Report_Visible1: Boolean;
        RecLocation: Record 14;
        TransFromCode: Code[20];
        TransToCode: Code[20];
        RecLoc: Record 14;
        FromStateCode: Code[10];
        ToStateCode: Code[10];


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin
        //CCIT
        Report_Visible := TRUE;
        Report_Visible1 := TRUE;

        IF RecLocation.GET("Transfer-from Code") THEN
            TransFromCode := RecLocation."State Code";
        IF RecLocation.GET("Transfer-to Code") THEN
            TransToCode := RecLocation."State Code";

        IF TransFromCode = TransToCode THEN
            Report_Visible := TRUE
        ELSE
            Report_Visible := FALSE;

        IF TransFromCode <> TransToCode THEN
            Report_Visible1 := TRUE
        ELSE
            Report_Visible1 := FALSE;
        //CCIT

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

