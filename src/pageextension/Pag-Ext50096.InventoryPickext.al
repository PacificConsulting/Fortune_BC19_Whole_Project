pageextension 50096 "Inventory_Pick_ext" extends "Inventory Pick"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {

        addafter("Shipment Date")
        {
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Qty to Handle"; "Total Qty to Handle")
            {
                ApplicationArea = all;
            }
            field("Transport Method"; "Transport Method")
            {
                ApplicationArea = all;
            }
            field("Mode of Transport"; "Mode of Transport")
            {
                ApplicationArea = all;
            }
            field("Vehicle No."; "Vehicle No.")
            {
                ApplicationArea = all;
            }
            field("LR/RR No."; "LR/RR No.")
            {
                ApplicationArea = all;
            }
            field("LR/RR Date"; "LR/RR Date")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill No."; "E-Way Bill No.")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill Date"; "E-Way Bill Date")
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
            field("Seal No."; "Seal No.")
            {
                ApplicationArea = all;
            }
            field("Load Type"; "Load Type")
            {
                ApplicationArea = all;
            }
            field("Transport Vendor"; "Transport Vendor")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                RecWAL2.RESET;
                RecWAL2.SETRANGE(RecWAL2."Source No.", "Source No.");
                IF RecWAL2.FINDSET THEN
                    REPEAT
                        IF RecWAL2."Expiration Date" < "Posting Date" then
                            Error('Selected Lot No, %1 is Expired', RecWAL2."Lot No.");
                    UNTIL RecWAL2.NEXT = 0;
            end;
        }
        modify("P&ost")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 06/12/2018
                // "Posting Date" := Today;//PCPL/NSW/07 15June22
                // Modify();

                IF Rec."Source Document" = Rec."Source Document"::"Outbound Transfer" THEN BEGIN
                    TESTFIELD("Mode of Transport");
                    TESTFIELD("Vehicle No.");
                    TESTFIELD("LR/RR No.");
                    TESTFIELD("LR/RR Date");
                    TESTFIELD("Load Type");
                    TESTFIELD("External Document No.");
                    TESTFIELD("Transport Vendor");
                END;
                //CCIT-JAGA 06/12/2018
                RecWAL2.RESET;
                RecWAL2.SETRANGE(RecWAL2."Source No.", "Source No.");
                IF RecWAL2.FINDSET THEN
                    REPEAT
                        IF RecWAL2."Expiration Date" < "Posting Date" then
                            Error('Selected Lot No, %1 is Expired', RecWAL2."Lot No.");
                    UNTIL RecWAL2.NEXT = 0;

                //JAGA 08102018
                RecWAL2.RESET;
                RecWAL2.SETRANGE(RecWAL2."Source No.", "Source No.");
                IF RecWAL2.FINDSET THEN
                    REPEAT
                        WALLotNo2 := RecWAL2."Lot No.";

                        RecWAL3.RESET;
                        RecWAL3.SETRANGE(RecWAL3."Source No.", "Source No.");
                        IF RecWAL3.FINDSET THEN
                            REPEAT
                                IF RecWAL3."Line No." <> RecWAL2."Line No." THEN BEGIN
                                    IF RecWAL3."Item No." = RecWAL2."Item No." THEN BEGIN
                                        IF RecWAL3."Lot No." = WALLotNo2 THEN
                                            ERROR('Same Lot No " %1 " Can not be used twice', WALLotNo2);
                                    END;
                                END;
                            UNTIL RecWAL3.NEXT = 0;
                    UNTIL RecWAL2.NEXT = 0;
                //JAGA 08102018

                //CCIT-SG-11042018
                RecWAL1.RESET;
                RecWAL1.SETRANGE(RecWAL1."Source No.", Rec."Source No.");
                RecWAL1.SETRANGE(RecWAL1."Location Code", Rec."Location Code");
                IF RecWAL1.FINDSET THEN
                    REPEAT
                        RecSL.RESET;
                        RecSL.SETRANGE(RecSL."Document No.", RecWAL1."Source No.");
                        RecSL.SETRANGE(RecSL."Line No.", RecWAL1."Source Line No.");
                        IF RecSL.FINDSET THEN
                            REPEAT
                                RecILE.RESET;
                                //RecILE.SETRANGE(RecILE."Customer No.",RecWAL1."Source No.");
                                RecILE.SETRANGE(RecILE."Location Code", RecWAL1."Location Code");
                                RecILE.SETRANGE(RecILE."Lot No.", RecWAL1."Lot No.");
                                RecILE.SETRANGE(RecILE."Item No.", RecWAL1."Item No.");
                                RecILE.SETRANGE(RecILE.Reserved, TRUE);
                                RecILE.SETFILTER(RecILE."Remaining Quantity", '<>%1', 0);
                                IF RecILE.FINDFIRST THEN
                                    IF RecILE."Customer No." <> RecSL."Sell-to Customer No." THEN
                                        ERROR('This Quantity is reserved for Customer %1', RecILE."Customer No.");
                                IF (RecILE."Customer License No." <> RecSL."Customer License No.") AND (RecILE."Customer No." = RecSL."Sell-to Customer No.") THEN
                                    ERROR('This Quantity is reserved for Customer License No. %1', RecILE."Customer License No.");
                            UNTIL RecSL.NEXT = 0;
                    UNTIL RecWAL1.NEXT = 0;
                //CCIT-SG-11042018

                "Posting Date" := Today;//PCPL/NSW/07 15June22
                Modify();//PCPL/NSW/07 15June22

            end;

            trigger OnAfterAction()
            var
            begin
                //CCIT-SG
                RecTL.RESET;
                RecTL.SETRANGE(RecTL."Document No.", "Source No.");
                IF RecTL.FINDFIRST THEN BEGIN
                    UtilizedQty := 0;
                    RecTransShipLine.RESET;
                    RecTransShipLine.SETRANGE(RecTransShipLine."Customer License No.", RecTL."Customer License No.");
                    IF RecTransShipLine.FINDSET THEN
                        REPEAT
                            UtilizedQty += RecTransShipLine.Quantity;
                            RecDutyFreeLic.RESET;
                            RecDutyFreeLic.SETRANGE(RecDutyFreeLic."License No.", RecTL."Customer License No.");
                            IF RecDutyFreeLic.FINDFIRST THEN BEGIN
                                RecDutyFreeLic."Utilized License Quantity" := UtilizedQty;
                                RecDutyFreeLic.VALIDATE("Utilized License Quantity");
                                RecDutyFreeLic.MODIFY;
                            END;
                        UNTIL RecTransShipLine.NEXT = 0;
                END;
                //CCIT-SG
                Rec."Posting Date" := TODAY;
                //----- CCIT-SG
                // ILE.Reset();
                // ILE.SetRange("Order No.", "Source No.");
                // ILE.SetFilter("Expiration Date", '<>%1', 0D);
                // IF ILE.FindFirst() then begin
                //     ILE11.reset;
                //     ILE11.SetRange("Document No.", ILE."Document No.");
                //     ILE11.SetFilter("Expiration Date", '%1', 0D);
                //     IF ILE11.FindFirst() then begin
                //         ILE11.validate("Expiration Date", ILE."Expiration Date");
                //         ILE11.Modify();
                //     end;
                // end;


            END;
        }

        modify(AutofillQtyToHandle)
        {
            trigger OnAfterAction()
            var
                WAL: Record "Warehouse Activity Line";
                WAH: Record "Warehouse Activity Header";
                WAL11: Record "Warehouse Activity Line";
            begin
                WAH.Reset();
                WAH.SetRange("No.", "No.");
                WAH.SetRange("Source No.", "Source No.");
                IF WAH.FindFirst() then begin
                    WAL.Reset();
                    WAL.SetRange("No.", WAH."No.");
                    IF WAL.FindSet() then
                        repeat
                            WAL11.Reset();
                            WAL11.SetRange("No.", WAL."No.");
                            WAL11.SetRange("Line No.", WAL."Line No.");
                            WAL11.SetRange("Source No.", WAL."Source No.");
                            WAL11.SetRange("Source Line No.", WAL."Source Line No.");
                            IF WAL11.FindFirst() then begin
                                WAL11.validate("Tolerance Qty", WAL11."Qty. Outstanding");
                                WAL11."Actual Qty In KG" := WAL11."Qty. Outstanding";
                                WAL11."Tolerance Qty in PCS" := WAL11."Actual Qty In KG" / wal.Weight1; //PCPL-0070 17Jan23
                                WAL11."Actual Qty In PCS" := WAL11."Tolerance Qty in PCS";
                                WAL11.Modify();
                            end;
                        until WAL.Next = 0;
                end;

            end;

        }
        modify("Delete Qty. to Handle")
        {
            trigger OnAfterAction()
            var
                RecWAL: Record "Warehouse Activity Line";
                RecWAH: Record "Warehouse Activity Header";
                RecWAL11: Record "Warehouse Activity Line";
            begin
                RecWAH.Reset();
                RecWAH.SetRange("No.", "No.");
                RecWAH.SetRange("Source No.", "Source No.");
                IF RecWAH.FindFirst() then begin
                    RecWAL.Reset();
                    RecWAL.SetRange("No.", RecWAH."No.");
                    IF RecWAL.FindSet() then
                        repeat
                            RecWAL11.Reset();
                            RecWAL11.SetRange("No.", RecWAL."No.");
                            RecWAL11.SetRange("Line No.", RecWAL."Line No.");
                            RecWAL11.SetRange("Source No.", RecWAL."Source No.");
                            RecWAL11.SetRange("Source Line No.", RecWAL."Source Line No.");
                            IF RecWAL11.FindFirst() then begin
                                RecWAL11.validate("Tolerance Qty", 0);
                                RecWAL11."Actual Qty In KG" := 0;
                                RecWAL11."Actual Qty In PCS" := 0;
                                RecWAL11.Modify();
                            end;
                        until RecWAL.Next = 0;
                end;

            end;

        }
        addafter("Picking List")
        {
            action("Pick List Report")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."No.", "No.");
                    REPORT.RUNMODAL(50015, TRUE, FALSE, RecWAH);
                end;
            }

        }
    }

    var
        RecWAL: Record 5767;
        RecUOM: Record 5404;
        QtyToHandleKG: Decimal;
        RecTH: Record 5740;
        RecSH: Record 36;
        RecTL: Record 5741;
        RecCust: Record 18;
        RecTransShipLine: Record 5745;
        UtilizedQty: Decimal;
        RecDutyFreeLic: Record 50025;
        RecWAH: Record 5766;
        RecILE: Record 32;
        RecWAH1: Record 5766;
        RecWAL1: Record 5767;
        RecSL: Record 37;
        RecWAL2: Record 5767;
        WALQty: Decimal;
        RecILE2: Record 32;
        TotalILEQty: Decimal;
        LotToleranceQty: Decimal;
        FinLotQty: Decimal;
        "Tolerance Qty": Decimal;
        RecSalesAndReceivableSetup: Record 311;
        WALLotNo2: Code[20];
        RecWAL3: Record 5767;
        ILE: record "Item Ledger Entry";
        ILE11: record "Item Ledger Entry";


    //Unsupported feature: CodeModification on "OnDeleteRecord". Please convert manually.

    trigger OnDeleteRecord(): Boolean;
    begin
        //CCIT-SG
        RecTH.RESET;
        RecTH.SETRANGE(RecTH."No.", Rec."Source No.");
        IF RecTH.FINDFIRST THEN BEGIN
            RecTH.PickListCreated := FALSE;
            RecTH.MODIFY;
        END;
        RecSH.RESET;
        RecSH.SETRANGE(RecSH."No.", Rec."Source No.");
        IF RecSH.FINDFIRST THEN BEGIN
            RecSH.PutAwayCreated := FALSE;
            RecSH.MODIFY;
        END;
        //CCIT-SG

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

