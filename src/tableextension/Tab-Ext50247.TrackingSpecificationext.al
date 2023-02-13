tableextension 50247 "Tracking_Specification_ext" extends "Tracking Specification"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621,CCIT-Fortune

    fields
    {


        modify("Quantity (Base)")
        {
            trigger OnAfterValidate()
            begin
                //CITS-SD-26-12-17 -
                //UpdateRemaningQty;
                IF RecItem.GET("Item No.") THEN BEGIN
                    IF (RecItem."Base Unit of Measure" = 'PCS') THEN BEGIN
                        IF RecUOM1.GET(RecItem."No.", 'PCS') THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN
                                Rec."Qty. to Handle (Base) In KG" := ("Quantity (Base)" / RecUOM1.Weight);
                            "Remainig Qty. In KG" := ("Quantity (Base)" / RecUOM1.Weight);//ActualQty - (UseBaseQty + Rec."Qty. to Handle (Base) In KG");//
                        END;
                    END;
                END;

                //CITS-SD-26-12-17

            end;
        }





        modify("Serial No.")
        {
            trigger OnAfterValidate()
            begin
                //>> CS
                InitManufacturingDate;
                //<< CS

            end;
        }

        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                //TESTFIELD("Manufacturing Date");

                //Message(Format("Buffer Status2"));
                IF "Expiration Date" <> 0D then begin
                    IF "Expiration Date" < "Manufacturing Date" THEN
                        ERROR('Expiration Date Should not be less than Manufacturing Date');
                end;
                //CCIT-SG
                //CITS-SD-29-12-17 -
                UpdateLotWALine;
                //CITS-SD-29-12-17 +

            end;
        }



        modify("Qty. to Handle (Base)")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG - Open By CITS-SD-26-12-17 -
                IF RecItem.GET("Item No.") THEN BEGIN
                    IF (RecItem."Base Unit of Measure" = 'PCS') THEN BEGIN
                        IF RecUOM1.GET(RecItem."No.", 'PCS') THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN
                                "Qty. to Handle (Base) In KG" := Rec."Qty. to Handle (Base)" * RecUOM1.Weight;
                        END;
                    END;
                END;
                //CCIT-SG


            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                IF "Lot No." <> xRec."Lot No." THEN BEGIN
                    //>> CS
                    InitManufacturingDate; //PCPL/MIG/NSW Temp Block this code 190322
                    //<< CS

                END;
                "Buffer Status2" := 0;//"Buffer Status2"::""; //PCPL/MIG/NSW 170322 New Code add due to Exp date Blank

                //CCIT-SG
                IF "Lot No." <> '' THEN
                    LotExists := TRUE
                ELSE
                    LotExists := FALSE;
                //CCIT-SG
                //CITS-SD-29-12-17 -
                UpdateLotWALine;
                //CITS-SD-29-12-17 +


            end;
        }



        field(50000; "MFG Date"; Date)
        {
            Description = 'CCIT-JAGA';
        }
        field(50001; LotExists; Boolean)
        {
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(50500; "Actual Batch"; Code[20])
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50501; "Actual MFG Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50502; "Actual EXP Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50503; "Actual Batch PCS"; Decimal)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(70000; "Manufacturing Date"; Date)
        {
            Description = 'CS';

            trigger OnValidate();
            begin
                //CITS-SD-29-12-17 -
                UpdateLotWALine;
                //CITS-SD-29-12-17 +
                IF "Expiration Date" <> 0D then begin
                    IF "Expiration Date" < "Manufacturing Date" THEN
                        ERROR('Expiration Date Should not be less than Manufacturing Date');
                END;

            end;
        }
        field(70001; "New Manufacturing Date"; Date)
        {
            Description = 'CS';

            trigger OnValidate();
            begin
                //>> CS
                WMSManagement.CheckItemTrackingChange(Rec, xRec);
                //<< CS
            end;
        }
        field(70002; "Qty. to Handle (Base) In KG"; Decimal)
        {
            Description = 'CCIT';

            trigger OnValidate();
            begin

                RemainQtyKG := "Quantity (Base)";
                //QtytoHandleBase :=0;
                IF RecItem.GET("Item No.") THEN BEGIN
                    IF (RecItem."Base Unit of Measure" = 'PCS') THEN BEGIN
                        IF RecUOM1.GET(RecItem."No.", 'PCS') THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN
                                QtytoHandleBase := Rec."Qty. to Handle (Base) In KG" / RecUOM1.Weight;

                        END;
                    END;
                END;

                //"Qty. to Handle (Base)":= QtytoHandleBase;
                VALIDATE("Qty. to Handle (Base)", QtytoHandleBase);
                VALIDATE("Quantity (Base)", "Qty. to Handle (Base)");
                VALIDATE("Qty. to Invoice (Base)", "Qty. to Handle (Base)");
                //CCIT-SG
            end;
        }
        field(70003; "Remainig Qty. In KG"; Decimal)
        {
            Description = 'CCIT';
        }
        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CITS-SD-26-12-17';
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';

            trigger OnValidate();
            begin
                //CCIT-JAGA 03/11/2018
                //TESTFIELD("PO Manufacturing Date");
                IF "PO Manufacturing Date" > "PO Expiration Date" THEN
                    ERROR('Expiry Date Should be greater than the Manufacturing Date');
                //CCIT-JAGA 03/11/2018
            end;
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';

            trigger OnValidate();
            begin
                //CCIT-JAGA 03/11/2018
                //TESTFIELD("PO Manufacturing Date");
                IF "PO Manufacturing Date" > "PO Expiration Date" THEN
                    ERROR('Expiry Date Should be greater than the Manufacturing Date');
                //CCIT-JAGA 03/11/2018
            end;
        }
    }


    PROCEDURE InitManufacturingDate();
    VAR
        ItemTrackingMgt: Codeunit 6500;
        MfgDate: Date;
        EntriesExist: Boolean;
    BEGIN
        //>> CS
        IF ("Serial No." = xRec."Serial No.") AND ("Lot No." = xRec."Lot No.") THEN
            EXIT;

        //"Manufacturing Date" := 0D;//CITS-SD-27-12-2017

        MfgDate := "Manufacturing Date";//ItemTrckmgt.ExistingManufacturingDate("Item No.", "Variant Code", "Lot No.", "Serial No.", FALSE, EntriesExist); //PCPL/MIG/NSW Fun Missing in BC18//
        IF EntriesExist THEN BEGIN
            "Manufacturing Date" := MfgDate;
            //"Buffer Status2" := "Buffer Status2"::"ExpDate blocked";
        END ELSE
            ;//"Buffer Status2" := 0;

        IF IsReclass THEN BEGIN
            "New Manufacturing Date" := "Manufacturing Date";
            "Warranty Date" := ItemTrackingMgt.ExistingWarrantyDate("Item No.", "Variant Code", "Lot No.", "Serial No.", EntriesExist);
        END;
        //<< CS
    END;

    PROCEDURE SetMinShelfLife(_MinShelfLife: Decimal);
    BEGIN
        //>> CS
        MinShelfLife := _MinShelfLife;
        //<< CS
    END;

    PROCEDURE UpdateRemaningQty();
    VAR
        PurchLine: Record 39;
        RecReservEntry: Record 337;
    BEGIN
        //CITS-SD-26-12-2017 -
        ActualQty := 0;
        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", "Source ID");
        PurchLine.SETRANGE("No.", "Item No.");
        PurchLine.SETRANGE("Line No.", "Source Ref. No.");
        IF PurchLine.FINDFIRST THEN
            ActualQty := PurchLine."Conversion Qty";

        UseBaseQty := 0;
        RESET;
        RecReservEntry.SETRANGE("Item No.", "Item No.");
        RecReservEntry.SETRANGE("Source ID", "Source ID");
        RecReservEntry.SETFILTER("Lot No.", '<>%1', "Lot No.");
        IF RecReservEntry.FINDSET THEN
            REPEAT
                UseBaseQty += RecReservEntry."Qty. to Handle (Base) In KG";
            UNTIL RecReservEntry.NEXT = 0;
        //CITS-SD-26-12-2017 +
    END;

    LOCAL PROCEDURE UpdateLotWALine();
    VAR
        WALine: Record 5767;
    BEGIN
        //CITS-SD-29-12-2017 -
        WALine.RESET;
        WALine.SETRANGE("Source No.", "Source ID");
        WALine.SETRANGE("Item No.", "Item No.");
        WALine.SETRANGE("Lot No.", xRec."Lot No.");
        IF WALine.FINDFIRST THEN BEGIN
            IF ("Lot No." <> xRec."Lot No.") AND (WALine."Lot No." <> '') THEN
                WALine."Lot No." := "Lot No.";
            IF ("Expiration Date" <> xRec."Expiration Date") AND (WALine."Expiration Date" <> 0D) THEN
                WALine."Expiration Date" := "Expiration Date";
            IF ("Manufacturing Date" <> xRec."Manufacturing Date") AND (WALine."Manufacturing Date" <> 0D) THEN
                WALine."Manufacturing Date" := "Manufacturing Date";
            WALine.MODIFY;
        END;
        //CITS-SD-29-12-2017 +
    END;


    var
        MinShelfLife: Decimal;
        RecUOM1: Record 5404;
        RecItem: Record 27;
        QtytoHandleBase: Decimal;
        RemainQtyKG: Decimal;
        ActualQty: Decimal;
        UseBaseQty: Decimal;
        QtyToHandle: Decimal;
        RecSalesAndReceivableSetup: Record 311;
        ToleranceQty: Decimal;
        WMSManagement: Codeunit 7302;
        ItemTrckmgt: Codeunit 50007;
}

