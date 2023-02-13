pageextension 50073 "Posted_Transfer_Shipment_ext" extends "Posted Transfer Shipment"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {
        addafter("Time of Removal")
        {
            field("E-Way Bill No."; "E-Way Bill No.")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill Date"; "E-Way Bill Date")
            {
                ApplicationArea = all;
            }
            field("Seal No."; "Seal No.")
            {
                ApplicationArea = all;
            }
            field("Load Type"; "Load Type")
            {
                ApplicationArea = all;
            }
            field("JWL Transfer No."; "JWL Transfer No.")
            {
                ApplicationArea = all;
            }
            field("JWL Transfer Date"; "JWL Transfer Date")
            {
                ApplicationArea = all;
            }
            field("Transport Vendor"; "Transport Vendor")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reporting Date"; "Vehicle Reporting Date")
            {
                ApplicationArea = all;
            }
            field("Vehicle Reporting Time"; "Vehicle Reporting Time")
            {
                ApplicationArea = all;
            }
            field("Vehicle Release Time"; "Vehicle Release Time")
            {
                ApplicationArea = all;
            }
        }
        addafter("Time of Removal")
        {
            group("GST E-Invoice1")
            {
                field("E-Invoice IRN"; "E-Invoice IRN")
                {
                    Editable = false;
                }
                field("GST Acknowledgement No."; "GST Acknowledgement No.")
                {
                    Editable = false;
                }
                field("GST Acknowledgement Dt"; "GST Acknowledgement Dt")
                {
                    Editable = false;
                }
                field("QR Code"; "QR Code")
                {
                }
                field("E-Invoice Error Remarks"; "E-Invoice Error Remarks")
                {
                }
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
            action("Generate GST E-Invoice")
            {
                Enabled = true;
                Image = Web;
                Promoted = true;
                Visible = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                // CU_GST_Transfer: Codeunit 50010; //PCPL/MIG/NSW
                begin
                    // CU_GST_Transfer.WriteIRNPayload_IRN(Rec);//CITS_RS 010121 //PCPL/MIG/NSW
                end;
            }
            action("Delivery Challan")
            {
                Enabled = Report_Visible;
                Promoted = true;

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
        TransShptHeader: Record 5744;
        RecTSH: Record 5744;
        RecTransShipmentHeader: Record 5744;
        Report_Visible: Boolean;
        Report_Visible1: Boolean;
        RecLocation: Record 14;
        TransFromCode: Code[20];
        TransToCode: Code[20];
        RecLoc: Record 14;
        FromStateCode: Code[20];
        ToStateCode: Code[20];



    trigger OnAfterGetRecord();
    begin
        //CCIT

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

