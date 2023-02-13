pageextension 50232 "Inventory_Put_away_ext" extends "Inventory Put-away"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        modify("Source No.")
        {
            //Unsupported feature: Change Name on "Control 11". Please convert manually.
            CaptionML = ENU = 'Purchase Order No.', ENN = 'Source No.';
            Importance = Promoted;
        }
        modify(WhseActivityLines)
        {
            Enabled = true;
        }
        addafter("Source No.")
        {
            field("No. Series"; "No. Series")
            {
                ApplicationArea = all;
            }
        }
        addafter("Destination No.")
        {
            field("Country Code"; "Country Code")
            {
                ApplicationArea = all;
            }
            field("Country Name"; "Country Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("ETA - Destination Port"; "ETA - Destination Port")
            {
                ApplicationArea = all;
            }
            field("ETA - Destination CFS"; "ETA - Destination CFS")
            {
                ApplicationArea = all;
            }
            field("ETA - Bond"; "ETA - Bond")
            {
                ApplicationArea = all;
            }
            field("JWL BOND GRN No."; "JWL BOND GRN No.")
            {
                ApplicationArea = all;
                Caption = '<SNW  BOND GRN No.>';
            }
            field("JWL BOND GRN Date"; "JWL BOND GRN Date")
            {
                ApplicationArea = all;
                Caption = '<SNW  BOND GRN Date>';
            }
            field("JWL Transfer No."; "JWL Transfer No.")
            {
                ApplicationArea = all;
                Caption = '<SNW  Transfer No.>';
            }
            field("JWL Transfer Date"; "JWL Transfer Date")
            {
                ApplicationArea = all;
                Caption = '<SNW  Transfer Date>';
            }
            field("Order Date"; "OrderDate WareActHed")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.")
        {
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Qty to Handle"; "Total Qty to Handle")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.2")
        {
            field("Load Type"; "Load Type")
            {
                ApplicationArea = all;
            }
            field("License No."; "License No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Transport Vendor"; "Transport Vendor")
            {
                ApplicationArea = all;
            }
            field("Mode of Transport"; "Mode of Transport")
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
            field("Vehicle No."; "Vehicle No.")
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
            field("Vehicle Releasing Time"; "Vehicle Releasing Time")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {


        //Unsupported feature: CodeModification on "Action 18.OnAction". Please convert manually.
        modify("P&ost")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 06/12/2018
                IF Rec."Source Document" = Rec."Source Document"::"Inbound Transfer" THEN BEGIN
                    TESTFIELD("Mode of Transport");
                    TESTFIELD("Vehicle No.");
                    TESTFIELD("LR/RR No.");
                    TESTFIELD("LR/RR Date");
                    TESTFIELD("Load Type");
                    TESTFIELD("External Document No.");
                    TESTFIELD("Transport Vendor");
                    TESTFIELD("Vehicle Reporting Date");
                    TESTFIELD("Vehicle Releasing Time");
                    TESTFIELD("Vehicle Reporting Time");
                END;
                //CCIT-JAGA 06/12/2018
                //JAGA 06102018
                RecWAL4.RESET;
                RecWAL4.SETRANGE(RecWAL4."Source No.", "Source No.");
                IF RecWAL4.FINDFIRST THEN
                    RecWAL4.TESTFIELD("Reason Code");
                //JAGA 06102018

                //ccit san
                CheckLotMfgExp;
                CheckAllBarcodeCreatedOrNot;

                // "Posting Date" := Today;//PCPL/NSW/07 15June22
                //Modify();//PCPL/NSW/07 15June22

            end;


            trigger OnAfterAction()
            begin
                //CCIT-SG-18042018
                //IF NOT CONFIRM(Text001,FALSE,Rec."No.")THEN
                //IF NOT CONFIRM(Text001,FALSE,RecPH."Receiving No. Series")THEN
                //EXIT;
                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Source No.");
                IF RecPH.FINDFIRST THEN
                    MESSAGE('GRN Has beem posted with the GRN No : %1', RecPH."Last Receiving No.");
                //CCIT-SG-18042018

                //CCIT-SG
                //update Utilized License Quantity in license master
                RecPL.RESET;
                RecPL.SETRANGE(RecPL."Document No.", "Source No.");
                IF RecPL.FINDFIRST THEN BEGIN
                    UtilizedQty := 0;
                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Source No.", RecPL."Buy-from Vendor No.");
                    RecILE.SETFILTER(RecILE."Document Type", '%1', RecILE."Document Type"::"Purchase Receipt");
                    RecILE.SETRANGE(RecILE."License No.", RecPL."License No.");
                    IF RecILE.FINDSET THEN
                        REPEAT
                                UtilizedQty += RecILE.Quantity;
                        UNTIL RecILE.NEXT = 0;
                    IF RecLic.GET(RecPL."License No.") THEN BEGIN
                        RecLic."Utilized License Quantity" := UtilizedQty;
                        RecLic.VALIDATE(RecLic."Utilized License Quantity");
                        RecLic.MODIFY;
                        //IF RecLic.MODIFY THEN
                        //MESSAGE('%1 qty updated On License Master',UtilizedQty);
                    END;
                END;

                //update used quantity in HS code license master
                RecWAL2.RESET;
                RecWAL2.SETRANGE(RecWAL2."No.", Rec."No.");
                IF RecWAL2.FINDSET THEN
                    REPEAT
                            RecPL.RESET;
                        RecPL.SETRANGE(RecPL."Document No.", RecWAL2."Source No.");
                        RecPL.SETRANGE(RecPL."Line No.", RecWAL2."Source Line No.");
                        IF RecPL.FINDSET THEN
                            //MESSAGE('%1',RecPL."No.");
                            REPEAT
                                    UsedQty := 0;
                                RecILE.RESET;
                                RecILE.SETRANGE(RecILE."Source No.", RecPL."Buy-from Vendor No.");
                                RecILE.SETFILTER(RecILE."Document Type", '%1', RecILE."Document Type"::"Purchase Receipt");
                                RecILE.SETRANGE(RecILE."License No.", RecPL."License No.");
                                RecILE.SETRANGE(RecILE."HS Code", RecPL."HS Code");
                                RecILE.SETRANGE(RecILE."Item No.", RecPL."No.");
                                IF RecILE.FINDSET THEN
                                    REPEAT
                                            UsedQty += RecILE.Quantity;
                                        //MESSAGE('%1',UsedQty);
                                        RecHSMaster.RESET;
                                        RecHSMaster.SETRANGE(RecHSMaster."License Code", RecPL."License No.");
                                        RecHSMaster.SETRANGE(RecHSMaster."HS Code", RecPL."HS Code");
                                        RecHSMaster.SETRANGE(RecHSMaster."Item Code", RecPL."No.");
                                        IF RecHSMaster.FINDSET THEN
                                            REPEAT
                                                    //MESSAGE('%1  %2',RecHSMaster."License Code",RecHSMaster."HS Code");
                                                    RecHSMaster."Used Quantity" := UsedQty;
                                                RecHSMaster.VALIDATE(RecHSMaster."Used Quantity");
                                                RecHSMaster.MODIFY;
                                            UNTIL RecHSMaster.NEXT = 0;
                                    UNTIL RecILE.NEXT = 0;
                            UNTIL RecPL.NEXT = 0;
                    UNTIL RecWAL2.NEXT = 0;

                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", Rec."Source No.");
                IF RecPH.FINDFIRST THEN BEGIN
                    //RecPH."Posting Date" := TODAY;
                    RecPH."JWL BOND GRN No." := Rec."JWL BOND GRN No.";
                    RecPH."JWL BOND GRN Date" := Rec."JWL BOND GRN Date";
                    RecPH.MODIFY;
                    //Rec."Posting Date" := TODAY;

                END;
                //CCIT-SG

            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 06/12/2018
                IF Rec."Source Document" = Rec."Source Document"::"Inbound Transfer" THEN BEGIN
                    TESTFIELD("Mode of Transport");
                    TESTFIELD("Vehicle No.");
                    TESTFIELD("LR/RR No.");
                    TESTFIELD("LR/RR Date");
                    TESTFIELD("Load Type");
                    TESTFIELD("External Document No.");
                    TESTFIELD("Transport Vendor");
                END;
                //CCIT-JAGA 06/12/2018

                //JAGA 06102018
                RecWAL4.RESET;
                RecWAL4.SETRANGE(RecWAL4."Source No.", "Source No.");
                IF RecWAL4.FINDFIRST THEN
                    RecWAL4.TESTFIELD("Reason Code");
                //JAGA 06102018

                //ccit san
                CheckLotMfgExp;
                CheckAllBarcodeCreatedOrNot;

            end;
        }

        addafter("Posted Put-aways")
        {
            action("Barcode List")
            {
                Caption = 'Barcode List';
                Image = BarCode;
                RunObject = Page 50021;
                //RunPageLink = Field7 = FIELD("No.");//PCPL/MIG/NSW
                ApplicationArea = all;
            }
        }
        addafter("&Print")
        {
            action("Put Away Report")
            {
                Promoted = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    RecWAH.RESET;
                    RecWAH.SETRANGE(RecWAH."No.", "No.");
                    REPORT.RUNMODAL(50012, TRUE, FALSE, RecWAH);
                end;
            }
            group("&Mail")
            {
                CaptionML = ENU = '&Mail',
                            ENN = '&Order Confirmation';
                Image = Email;
                action("Send Mail")
                {
                    CaptionML = ENU = 'Send Mail',
                                ENN = 'Email Confirmation';
                    Ellipsis = true;
                    Image = Mail;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        //SendMailPost.SendMailFROMPO(Rec);//CITS-MM
                        //SendMailPost.SendMailFromPutAway(Rec);
                    end;
                }
            }
        }
    }

    var
        PageInvPutSub: Page 7376;
        recWhsActLines: Record 5767;
        WhseActivityLines1: Page 7376;
        RecPostInvPAH: Record 7340;
        RecWAH: Record 5766;
        RecWAL: Record 5767;
        RecPL: Record 39;
        RecPH: Record 38;
        RecTH: Record 5740;
        UtilizedQty: Decimal;
        RecILE: Record 32;
        RecLic: Record 50023;
        UsedQty: Decimal;
        RecHSMaster: Record 50024;
        RecWAL1: Record 5767;
        QuarentineQty: Decimal;
        QuarantineLoc: Code[20];
        LocCode: Code[10];
        RecLoc: Record 14;
        RecLoc1: Record 14;
        QuanDocNo: Code[20];
        QuanItemNo: Code[20];
        QuanMFG: Date;
        QuanEXP: Date;
        TempWAL: Record 5767 temporary;
        ItemJournalLine: Record 83;
        ItemJnlPostLine: Codeunit 22;
        RecWAL2: Record 5767;
        Text001: Label 'GRN No. :  %1  is Done.';
        RecWAL4: Record 5767;


    //Unsupported feature: CodeModification on "OnDeleteRecord". Please convert manually.

    trigger OnDeleteRecord(): Boolean;
    begin
        //CCIT-SG
        RecPH.RESET;
        RecPH.SETRANGE(RecPH."No.", Rec."Source No.");
        IF RecPH.FINDFIRST THEN BEGIN
            RecPH.PutAwayCreated := FALSE;
            RecPH.MODIFY;
        END;
        RecTH.RESET;
        RecTH.SETRANGE(RecTH."No.", Rec."Source No.");
        IF RecTH.FINDFIRST THEN BEGIN
            RecTH.PutAwayCreated := FALSE;
            RecTH.MODIFY;
        END;
        //CCIT-SG

    end;



    //Unsupported feature: CodeModification on "PostPutAwayYesNo(PROCEDURE 3)". Please convert manually.

    //procedure PostPutAwayYesNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.WhseActivityLines.PAGE.PostPutAwayYesNo;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    CurrPage.WhseActivityLines.PAGE.PostPutAwayYesNo;
    */
    //end;

    local procedure CheckAllBarcodeCreatedOrNot();
    var
        RecWhseActLines: Record 5767;
        item: Record 27;
    begin
        /*
        RecWhseActLines.RESET;
        RecWhseActLines.SETRANGE(RecWhseActLines."No.",Rec."No.");
        IF RecWhseActLines.FINDFIRST THEN
          REPEAT
              IF item.GET(RecWhseActLines."Item No.") THEN
                IF item.BarcodeRequired THEN BEGIN
                  RecWhseActLines.CALCFIELDS(RecWhseActLines."No. Of Barcode Printed");
                  //IF RecWhseActLines."Qty. to Handle" <> RecWhseActLines."No. Of Barcode Printed" THEN
                    //  ERROR('"Quantity To Handle" must be equal to "No. Of Barcode Printed" in Line No. %1',RecWhseActLines."Line No.");
                END;
          UNTIL RecWhseActLines.NEXT=0;
        */

    end;

    local procedure CheckLotMfgExp();
    var
        RecWhseActLines: Record 5767;
    begin
        RecWhseActLines.RESET;
        RecWhseActLines.SETRANGE(RecWhseActLines."No.", Rec."No.");
        IF RecWhseActLines.FINDFIRST THEN
            REPEAT
                    IF RecWhseActLines."Lot No." = '' THEN
                        ERROR('Lot No. must not be blank on Document %1 Line %2', RecWhseActLines."No.", RecWhseActLines."Line No.");
                IF RecWhseActLines."Warranty Date" = 0D THEN
                    ERROR('Manufacturing Date must not be blank on Document %1 Line %2', RecWhseActLines."No.", RecWhseActLines."Line No.");
                IF RecWhseActLines."Expiration Date" = 0D THEN
                    ERROR('Expiration Date must not be blank on Document %1 Line %2', RecWhseActLines."No.", RecWhseActLines."Line No.");
            UNTIL RecWhseActLines.NEXT = 0;

    end;

    local procedure "---------------------------------------"();
    begin
    end;

    local procedure CreateItemJournalLine(lRecWAL: Record 5767; lQuan_Loc: Code[10]);
    var
        ItemJournalBatch: Record 233;
        NoSeriesManagement: Codeunit 396;
        DocNo: Code[20];
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        LineNo: Integer;
        CreateReservEntry: Codeunit 99000830;
        ForReservEntry: record "Reservation entry";
    begin
        //CCIT-SG-01022018
        LineNo := 0;

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", 'TRANSFER');
        ItemJournalLine.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF ItemJournalLine.FINDLAST THEN BEGIN
            DocNo := ItemJournalLine."Document No.";
            LineNo := ItemJournalLine."Line No.";
        END;

        //LineNo := LineNo + 10000;
        /*
        ItemJournalBatch.GET('TRANSFER','DEFAULT');
        IF DocNo = '' THEN
          DocNo := NoSeriesManagement.GetNextNo(ItemJournalBatch."No. Series",WORKDATE,FALSE);
        */
        /*ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name",'TRANSFER');
        ItemJournalLine.SETRANGE("Journal Batch Name",'DEFAULT');
        ItemJournalLine.SETRANGE("Item No.",lRecWAL."Item No.");
        IF NOT ItemJournalLine.FINDFIRST THEN BEGIN*/
        ItemJournalLine.INIT;
        ItemJournalLine."Journal Template Name" := 'TRANSFER';
        ItemJournalLine."Journal Batch Name" := 'DEFAULT';
        ItemJournalLine."Line No." := LineNo + 10000;

        ItemJournalLine."Document No." := lRecWAL."No.";
        ItemJournalLine.VALIDATE("Posting Date", WORKDATE);
        ItemJournalLine.VALIDATE("Item No.", lRecWAL."Item No.");
        ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.VALIDATE("Location Code", lRecWAL."Location Code");
        ItemJournalLine.VALIDATE("New Location Code", lQuan_Loc);


        ItemJournalLine.VALIDATE(Quantity, lRecWAL."Quarantine Qty In KG");//("Conversion Qty"/"Cutting In (Pc)"));
        //ItemJournalLine.VALIDATE("Lot No.",lRecWAL."Lot No.");
        //VALIDATE("New Lot No.",lRecWAL."Lot No.");
        ItemJournalLine.VALIDATE("Manufacturing Date", lRecWAL."Manufacturing Date");
        ItemJournalLine.VALIDATE("Expiration Date", lRecWAL."Expiration Date");
        ItemJournalLine.VALIDATE("Actual Batch", lRecWAL."Actual Batch");
        ItemJournalLine.VALIDATE("Actual MFG Date", lRecWAL."Actual MFG Date");
        ItemJournalLine.VALIDATE("Actual EXP Date", lRecWAL."Actual EXP Date");
        ItemJournalLine.VALIDATE("Actual Batch PCS", lRecWAL."Actual Batch PCS");
        ItemJournalLine.VALIDATE("Actual Qty In KG", lRecWAL."Actual Qty In KG");
        ItemJournalLine.INSERT(TRUE);



        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Lot No.", lRecWAL."Lot No.");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.SETRANGE("Location Code", lQuan_Loc);
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                    WhseEntry.RESET;
                WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
                WhseEntry.SETFILTER("Reference No.", ItemLedgerEntry."Document No.");
                WhseEntry.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                WhseEntry.SETRANGE("Lot No.", lRecWAL."Lot No.");
                IF WhseEntry.FINDFIRST THEN BEGIN
                    ItemJournalLine.VALIDATE("Bin Code", WhseEntry."Bin Code");
                    ItemJournalLine.MODIFY;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer THEN BEGIN
            /* //<<PCPL/MIG/NSW/040522
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type",
              ItemJournalLine."Journal Template Name",
              ItemJournalLine."Journal Batch Name",
              0,
              ItemJournalLine."Line No.",
              ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity,
              ItemJournalLine.Quantity,
              lRecWAL."Serial No.",
              lRecWAL."Lot No.");
            */ //>>PCPL/MIG/NSW/040522

            //<<PCPL/MIG/NSW/040522 New Below Code add and Above coe comment coz function para has changed in BC19
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type".AsInteger(), ItemJournalLine."Journal Template Name",
              ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity, ItemJournalLine.Quantity, ForReservEntry);
            //>>PCPL/MIG/NSW/040522

            CreateReservEntry.SetNewSerialLotNo(lRecWAL."Serial No.", lRecWAL."Lot No.");
            /* //PCPL/MIG/NSW
            CreateReservEntry.SetDates(
              ItemJournalLine."Warranty Date", lRecWAL."Expiration Date", lRecWAL."Manufacturing Date");
            CreateReservEntry.SetPOData(
              lRecWAL."PO Expiration Date", lRecWAL."PO Lot No.", lRecWAL."PO Manufacturing Date");
            //CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");
            CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine.Quantity);
            CreateReservEntry.SetRemainQtyInKG(ItemJournalLine.Quantity);
            */ //PCPL/MIG/NSW
            CreateReservEntry.CreateEntry(
              ItemJournalLine."Item No.",
              ItemJournalLine."Variant Code",
              ItemJournalLine."Location Code",
              ItemJournalLine.Description,
              ItemJournalLine."Posting Date",
              ItemJournalLine."Document Date",
              0,
              3);
        END;

        //CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",ItemJournalLine);
        /*IF _EntryType = _EntryType::"Positive Adjmt." THEN BEGIN
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Reference No.","Registering Date");
            WhseEntry.SETFILTER("Reference No.",ItemLedgerEntry."Document No.");
            WhseEntry.SETRANGE("Line No.",ItemLedgerEntry."Document Line No.");
            WhseEntry.SETRANGE("Lot No.","Select Lot No.");
            IF WhseEntry.FINDFIRST THEN BEGIN
              ItemJournalLine.VALIDATE("Bin Code",WhseEntry."Bin Code");
              ItemJournalLine.MODIFY;
            END;
        
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              ItemJournalLine."Entry Type",
              "Journal Template Name",
              "Journal Batch Name",
              0,
              ItemJournalLine."Line No.",
              ItemJournalLine."Qty. per Unit of Measure",
              ItemJournalLine.Quantity,
              ItemJournalLine.Quantity,
              ItemLedgerEntry."Serial No.",
              ItemLedgerEntry."Lot No.");
        
            CreateReservEntry.SetDates(
              ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date", ItemLedgerEntry."Manufacturing Date");
            CreateReservEntry.SetQtyToHandleBaseInKG(ItemJournalLine."Conversion Qty");
            CreateReservEntry.SetRemainQtyInKG("Conversion Qty");
            CreateReservEntry.CreateEntry(
              ItemJournalLine."Item No.",
              ItemJournalLine."Variant Code",
              ItemJournalLine."Location Code",
              ItemJournalLine.Description,
              ItemJournalLine."Posting Date",
              ItemJournalLine."Document Date",
              0,
              3);
        END;*/
        //END;
        //CCIT-SG-01022018

    end;

    local procedure QuarantineProcess(Rec_WAL: Record 5767; Quan_Loc: Code[10]);
    var
        ToItem: Record 27;
        i: Integer;
        IUOM: Record 5404;
    begin

        CreateItemJournalLine(Rec_WAL, QuarantineLoc);
    end;

    local procedure UpdateReservationEntry(pSelectLot: Code[20]; pLineNo: Integer);
    var
        ItemJournalLine: Record 83;
        ItemJournalBatch: Record 233;
        ItemLedgerEntry: Record 32;
        WhseEntry: Record 7312;
        CreateReservEntry: Codeunit 99000830;
    begin
        //CCIT-SD-I1-02-01-2017 -
        /*ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Lot No.",pSelectLot);
        ItemLedgerEntry.SETRANGE("Item No.","Item No.");
        ItemLedgerEntry.SETRANGE("Location Code","Location Code");
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        //ItemLedgerEntry.SETRANGE("Document Line No.","Purch. Rcpt. Line"."Line No.");
        IF ItemLedgerEntry.FINDSET THEN BEGIN
          //REPEAT
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Reference No.","Registering Date");
            WhseEntry.SETFILTER("Reference No.",ItemLedgerEntry."Document No.");
            WhseEntry.SETRANGE("Line No.",ItemLedgerEntry."Document Line No.");
            WhseEntry.SETRANGE("Lot No.",pSelectLot);
            IF WhseEntry.FINDFIRST THEN BEGIN
              VALIDATE("Bin Code",WhseEntry."Bin Code");
              MODIFY;
            END;
        
            //IF _EntryType = _EntryType::"Negative Adjmt." THEN BEGIN
            CreateReservEntry.CreateReservEntryFor(
              DATABASE::"Item Journal Line",
              "Entry Type",
              "Journal Template Name",
              "Journal Batch Name",
              0,
              pLineNo,
              "Qty. per Unit of Measure",
              Quantity,
              Quantity,
              "Serial No.",
              pSelectLot);
        
            CreateReservEntry.SetDates(
              ItemLedgerEntry."Warranty Date", ItemLedgerEntry."Expiration Date", ItemLedgerEntry."Manufacturing Date");
            CreateReservEntry.SetPOData(
              ItemLedgerEntry."Expiration Date",ItemLedgerEntry."PO Lot No.",ItemLedgerEntry."PO Manufacturing Date");
            CreateReservEntry.SetApplyToEntryNo(ItemLedgerEntry."Entry No.");
            CreateReservEntry.SetQtyToHandleBaseInKG("Conversion Qty");
            CreateReservEntry.SetRemainQtyInKG("Conversion Qty");
            CreateReservEntry.CreateEntry(
              "Item No.",
              "Variant Code",
              "Location Code",
              Description,
              ItemLedgerEntry."Posting Date",
              ItemLedgerEntry."Document Date",
              0,
              3);
        
            END;
          //UNTIL ItemLedgerEntry.NEXT = 0;
        //CCIT-SD-I1-02-01-2017 +
        */

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

