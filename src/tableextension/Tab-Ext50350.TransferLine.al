tableextension 50350 Transfer_Line_ext extends "Transfer Line"
{
    // version TFS225977,CCIT-Fortune

    fields
    {


        // modify("Applies-to Entry (Ship)")
        // {
        //     CaptionML = ENU='Applies-to Entry (Ship)';
        // }



        //Unsupported feature: CodeModification on ""Item No."(Field 3).OnValidate". Please convert manually.
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                IF Item.Get("Item No.") then;
                VALIDATE("Storage Categories", Item."Storage Categories"); //CCIT-SG
                VALIDATE("Sales Category", Item."Sales Category"); //CCIT-SG

                //CCIT-SG
                RecTH1.RESET;
                RecTH1.SETRANGE(RecTH1."No.", "Document No.");
                IF RecTH1.FINDFIRST THEN
                    "License No." := RecTH1."License No.";

                IF RecItem.GET(Rec."Item No.") THEN
                    Rec."Conversion UOM" := RecItem."Conversion UOM";
                //CCIT-SG
                //---- CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        Weight := RecUOM.Weight;
                    END
                END;
                //---- CCIT-SG
            end;
        }



        //Unsupported feature: CodeModification on "Quantity(Field 4).OnValidate". Please convert manually.
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN

                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Outstanding Quantity In KG" := Rec.Quantity / RecUOM.Weight;
                            "Qty. to Ship" := Quantity;
                            //"Qty. to Receive" := Quantity;
                            "Qty. to Ship In KG" := "Conversion Qty";
                            //"Qty. to Receive In KG" := "Conversion Qty"; 
                        END
                    END
                END;
                //CCIT-SG



                TotalLineQty := 0;
                TransLine22.RESET;
                TransLine22.SETFILTER(TransLine22."Document No.", Rec."Document No.");
                IF TransLine22.FINDSET THEN
                    REPEAT
                        TotalLineQty += TransLine22."Conversion Qty";
                    UNTIL TransLine22.NEXT = 0;
                IF Rec."Customer License No." <> '' THEN BEGIN
                    IF RecDutyFreeLicMaster.GET(Rec."Customer License No.") THEN BEGIN
                        TotLicQtyDutyFree := RecDutyFreeLicMaster."Remainig License Quantity";
                        IF ((TotalLineQty + Rec."Conversion Qty") > TotLicQtyDutyFree) THEN
                            ERROR('Inventory  available  is %1 for this Customer against Duty Free License No. %2', TotLicQtyDutyFree, Rec."Customer License No.");
                    END;
                END;
                //---- CCIT-SG

            end;
        }



        //Unsupported feature: CodeModification on ""Qty. to Ship"(Field 6).OnValidate". Please convert manually.
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Ship In KG" := "Qty. to Ship" / RecUOM1.Weight;
                            //"Qty. to Receive In KG" := "Qty. to Ship In KG";
                            //"Qty. to Receive" := "Qty. to Ship";
                        END
                    END
                END;
                //CCIT-SG

            end;
        }



        //Unsupported feature: CodeModification on ""Qty. to Receive"(Field 7).OnValidate". Please convert manually.
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            //   {IF (RecItem2.Tolerance = FALSE) AND ((Rec."Qty. to Receive" MOD RecUOM1.Weight) <> 0) THEN
                            //     ERROR('Please Enter Correct Qty in KG')
                            //  ELSE} 
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Receive In KG" := "Qty. to Receive" / RecUOM1.Weight;
                            "Qty. to Ship In KG" := "Qty. to Receive In KG";
                        END
                    END
                END;
                //CCIT-SG

            end;
        }

        //Unsupported feature: CodeModification on ""Quantity Shipped"(Field 8).OnValidate". Please convert manually.
        modify("Quantity Shipped")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Quantity Shipped In KG" := "Quantity Shipped" / RecUOM.Weight;
                            VALIDATE("Quantity Shipped In KG");
                            "Outstanding Quantity In KG" := "Conversion Qty" - "Quantity Shipped In KG";
                            "Qty. to Ship In KG" := "Conversion Qty" - "Quantity Shipped In KG";
                            VALIDATE("Qty. to Ship In KG");
                        END
                    END
                END;
                //CCIT-SG

            end;
        }

        //Unsupported feature: CodeModification on ""Quantity Received"(Field 9).OnValidate". Please convert manually.
        modify("Quantity Received")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Quantity Received In KG" := "Quantity Received" / RecUOM.Weight;
                            VALIDATE("Quantity Received In KG");
                            "Outstanding Quantity In KG" := "Conversion Qty" - "Quantity Received In KG";
                            "Qty. to Receive In KG" := "Conversion Qty" - "Quantity Received In KG";
                            VALIDATE("Qty. to Receive In KG");
                        END
                    END
                END;
                //CCIT-SG

            end;
        }





        field(50026; "Excess Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin

                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Excess Qty In PCS" := Rec."Excess Qty In KG" * RecUOM1.Weight;
                        END
                    END
                END;
                //CCIT-SG
            end;
        }
        field(50027; "Excess Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin

                //CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Excess Qty In KG" := Rec."Excess Qty In PCS" / RecUOM1.Weight;
                        END
                    END
                END;
                //CCIT-SG
            end;
        }
        field(50028; "Tracking Exists"; Boolean)
        {
            CalcFormula = Exist("Reservation Entry" WHERE("Source ID" = FIELD("Document No."),
                                                           "Source Ref. No." = FIELD("Line No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master";
        }
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                /*InitQtyInTransit;
                InitOutstandingQty;
                InitQtyToShip;
                InitQtyToReceive;
                ReserveTransferLine.VerifyQuantity(Rec,xRec);
                UpdateWithWarehouseShipReceive;
                */
                //---- CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            Quantity := Rec."Conversion Qty" * RecUOM1.Weight;
                            VALIDATE(Quantity);
                            "Outstanding Quantity In KG" := "Conversion Qty";
                            "Qty. to Ship" := Quantity;
                            "Qty. to Receive" := Quantity;
                            "Qty. to Receive In KG" := "Conversion Qty";
                            "Qty. to Ship In KG" := "Conversion Qty";
                        END
                    END
                END;
                "Outstanding Quantity" := Quantity;
                "Outstanding Qty. (Base)" := Quantity;
                "Quantity (Base)" := Quantity;

                //CCIT-SG
                /*IF Rec."License No." <> '' THEN BEGIN
                    IF RecLicNo.GET(Rec."License No.") THEN BEGIN
                       recTH.RESET;
                       recTH.SETRANGE(recTH."No.","Document No.");
                       IF recTH.FINDFIRST THEN
                        PODate := recTH."Posting Date";
                        EXPDate := RecLicNo."Permit Expiry Date";
                        IF PODate < EXPDate THEN BEGIN
                            TotalLicConversionQty :=0;
                            RecILE.RESET;
                            RecILE.SETRANGE(RecILE."Item No.",Rec."Item No.");
                            RecILE.SETRANGE(RecILE."License No.",Rec."License No.");
                            IF RecILE.FINDSET THEN
                              REPEAT
                                TotalLicConversionQty := TotalLicConversionQty + RecILE."Conversion Qty";
                                //MESSAGE('%1   %2',TotalLicQty,Rec.Quantity);
                              UNTIL RecILE.NEXT = 0;
                
                            IF ("Conversion Qty" > TotalLicConversionQty) THEN
                              ERROR('Inventory not available for this Item No. against License No. %1',Rec."License No.");
                       END ELSE IF PODate > EXPDate THEN
                        ERROR('License has been Expired');
                 END;
                END;*/

                TotalLineQty := 0;
                TransLine22.RESET;
                TransLine22.SETFILTER(TransLine22."Document No.", Rec."Document No.");
                IF TransLine22.FINDSET THEN
                    REPEAT
                        TotalLineQty += TransLine22.Quantity;
                    UNTIL TransLine22.NEXT = 0;
                IF Rec."Customer License No." <> '' THEN BEGIN
                    IF RecDutyFreeLicMaster.GET(Rec."Customer License No.") THEN BEGIN
                        TotLicQtyDutyFree := RecDutyFreeLicMaster."Remainig License Quantity";
                        IF ((TotalLineQty + Rec.Quantity) > TotLicQtyDutyFree) THEN
                            ERROR('Inventory  available  is %1 for this Customer against Duty Free License No. %2', TotLicQtyDutyFree, Rec."Customer License No.");
                    END;
                END;
                //---- CCIT-SG
                //UpdateAmounts;


                //CCIT-JAGA
                CLEAR(TotalQtyInPCS);
                RecILE.RESET;
                RecILE.SETRANGE("Item No.", "Item No.");
                RecILE.SETRANGE(RecILE."Location Code", "Transfer-from Code");
                IF RecILE.FINDSET THEN
                    REPEAT
                        TotalQtyInPCS += RecILE."Remainig Qty. In KG";
                    UNTIL RecILE.NEXT = 0;

                IF "Conversion Qty" > TotalQtyInPCS THEN
                    IF NOT CONFIRM('Conversion qty is less than the available qty... Do you want to continue?') THEN
                        ERROR('Conversiion qty is less than the available quantity');
                //CCIT-JAGA

            end;
        }
        field(50032; "Customer No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Customer;

            trigger OnValidate();
            begin
                //CCIT-SG
                IF RecCust.GET("Customer No.") THEN
                    "Customer Name" := RecCust.Name;
                //CCIT-SG
            end;
        }
        field(50033; "Customer Name"; Text[50])
        {
            Description = 'CCIT';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(50034; Reserved; Boolean)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Bond Master"."In-Bond Bill of Entry No.";

            trigger OnValidate();
            begin
                RecBondMaster.RESET;
                RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", Rec."In-Bond Bill of Entry No.");
                IF RecBondMaster.FINDFIRST THEN
                    REPEAT
                        "Bond Number" := RecBondMaster."Bond Number";
                        "Bond Date" := RecBondMaster."Bond Date";
                        "Bond Sr.No." := RecBondMaster."Bond Sr.No.";
                        "In-Bond BOE Date" := RecBondMaster."In-Bond BOE Date";
                        "Supplier Invoice No." := RecBondMaster."Supplier Invoice No.";
                        "Supplier Invoice Date" := RecBondMaster."Supplier Invoice Date";
                        "Supplier Invoice No.1" := RecBondMaster."Supplier Invoice No.1";
                        "Supplier Invoice Date 1" := RecBondMaster."Supplier Invoice Date 1";
                        "Supplier Invoice No.2" := RecBondMaster."Supplier Invoice No.2";
                        "Supplier Invoice Date 2" := RecBondMaster."Supplier Invoice Date 2";
                        "Supplier Invoice No.3" := RecBondMaster."Supplier Invoice No.3";
                        "Supplier Invoice Date 3" := RecBondMaster."Supplier Invoice Date 3";
                        "Supplier Invoice No.4" := RecBondMaster."Supplier Invoice No.4";
                        "Supplier Invoice Date 4" := RecBondMaster."Supplier Invoice Date 4";
                        "Supplier Invoice Sr.No." := RecBondMaster."Supplier Invoice Sr.No.";
                        "Supplier Invoice Sr.No.1" := RecBondMaster."Supplier Invoice Sr.No.1";
                        "Supplier Invoice Sr.No.2" := RecBondMaster."Supplier Invoice Sr.No.2";
                        "Supplier Invoice Sr.No.3" := RecBondMaster."Supplier Invoice Sr.No.3";
                        "Supplier Invoice Sr.No.4" := RecBondMaster."Supplier Invoice Sr.No.4";
                    UNTIL RecBondMaster.NEXT = 0;
            end;
        }
        field(50037; "In-Bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50038; "Bond Number"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50039; "Bond Sr.No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50040; "Bond Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50065; "Conversion UOM"; Code[10])
        {
            Description = 'CCIT';
            NotBlank = false;
            TableRelation = "Unit of Measure";
        }
        field(50066; "Storage Categories"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",FREEZER,CHILLED,DRY;
        }
        field(50068; "Qty. to Ship In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Qty. to Ship" := Rec."Qty. to Ship In KG" * RecUOM1.Weight;
                            "Qty. to Receive" := "Qty. to Ship";
                            "Qty. to Receive In KG" := "Qty. to Ship In KG";
                        END
                    END
                END;
                IF "Qty. to Ship" > Quantity THEN
                    ERROR('You can not receive more than %1 units', Quantity);
                "Qty. to Receive In KG" := "Qty. to Ship In KG";
                //CCIT-SG
            end;
        }
        field(50069; "Qty. to Receive In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Qty. to Receive" := Rec."Qty. to Receive In KG" * RecUOM1.Weight;
                            "Qty. to Ship" := "Qty. to Receive";
                            "Qty. to Ship In KG" := "Qty. to Receive In KG";
                        END
                    END
                END;
                IF "Qty. to Receive" > Quantity THEN
                    ERROR('You can not receive more than %1 units', Quantity);
                "Qty. to Ship In KG" := "Qty. to Receive In KG";
                //CCIT-SG
            end;
        }
        field(50070; "Quantity Shipped In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50071; "Outstanding Quantity In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50072; "Quantity Received In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50073; "No. of Boxes"; Decimal)
        {
        }
        field(50074; "Transfer Serial No."; Code[20])
        {
        }
        field(50083; "Duty Free Available Qty. KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50084; "Customer License No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Duty Free License Master"."License No." WHERE("Customer No." = FIELD("Customer No."));

            trigger OnValidate();
            begin
                IF RecDutyFreeLicMaster.GET("Customer License No.") THEN BEGIN
                    "Customer License Name" := RecDutyFreeLicMaster."License Name";
                    "Customer License Date" := RecDutyFreeLicMaster."License Date";
                    "Duty Free Available Qty. KG" := RecDutyFreeLicMaster."Remainig License Quantity";
                END;
            end;
        }
        field(50085; "Customer License Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50086; "Customer License Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
        }
        field(50088; "Supplier Invoice No.1"; Code[20])
        {
        }
        field(50089; "Supplier Invoice Sr.No.1"; Code[20])
        {
        }
        field(50090; "Supplier Invoice Date 1"; Date)
        {
        }
        field(50091; "Gross Weight 1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50092; "Net Weight 1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50093; "Supplier Invoice No.2"; Code[20])
        {
        }
        field(50094; "Supplier Invoice Sr.No.2"; Code[20])
        {
        }
        field(50095; "Supplier Invoice Date 2"; Date)
        {
        }
        field(50096; "Gross Weight 2"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50097; "Net Weight 2"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50098; "Supplier Invoice No.3"; Code[20])
        {
        }
        field(50099; "Supplier Invoice Sr.No.3"; Code[20])
        {
        }
        field(50100; "Supplier Invoice Date 3"; Date)
        {
        }
        field(50101; "Gross Weight 3"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50102; "Net Weight 3"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50103; "Supplier Invoice No.4"; Code[20])
        {
        }
        field(50104; "Supplier Invoice Sr.No.4"; Code[20])
        {
        }
        field(50105; "Supplier Invoice Date 4"; Date)
        {
        }
        field(50106; "Gross Weight 4"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50107; "Net Weight 4"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50108; "Supplier Invoice No."; Code[100])
        {
        }
        field(50109; "Supplier Invoice Sr.No."; Code[20])
        {
        }
        field(50110; "Supplier Invoice Date"; Date)
        {
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Quarantine Qty In KG" := "Quarantine Qty In PCS" * RecUOM1.Weight;
                        END
                    END
                END;
                "Actual Qty In PCS" := "Conversion Qty" - "Quarantine Qty In PCS";
                "Actual Qty In KG" := Quantity - "Quarantine Qty In KG";
            end;
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Quarantine Qty In PCS" := "Quarantine Qty In KG" / RecUOM1.Weight;
                        END
                    END
                END;
                "Actual Qty In KG" := Quantity - "Quarantine Qty In KG";
                "Actual Qty In PCS" := "Conversion Qty" - "Quarantine Qty In PCS";
            end;
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50124; "Custom Duty Amount1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD';
            MinValue = 0;

            trigger OnValidate();
            var
                Vendor: Record 23;
            begin
                //<<PCPL/MIG/NSW
                // GetTransHeader;
                // IF NOT GSTManagement.IsGSTApplicable(TransHeader.Structure) THEN
                //     EXIT;
                //>>PCPL/MIG/NSW
                /*
                Vendor.GET(PurchHeader."Buy-from Vendor No.");
                IF NOT (Vendor."GST Vendor Type" IN [Vendor."GST Vendor Type"::Import,Vendor."GST Vendor Type"::SEZ]) THEN
                  ERROR(GSTVendorTypeErr,Vendor."GST Vendor Type"::Import,Vendor."GST Vendor Type"::SEZ);
                IF NOT (Type IN [Type::Item,Type::"Fixed Asset"]) THEN
                  TESTFIELD("Custom Duty Amount",0);
                */

            end;
        }
        field(50125; "GST Assessable Value1"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD';

            trigger OnValidate();
            var
                Vendor: Record 23;
                RecHSNCode: Record "HSN/SAC";
            begin
                // GetTransHeader; //<<PCPL/MIG/NSW
                // IF NOT GSTManagement.IsGSTApplicable(TransHeader.Structure) THEN
                //   EXIT
                // // rdk230919 -
                // ELSE
                //   BEGIN
                //     IF "HSN/SAC Code" = '' THEN
                //       ERROR('HSN Code missing')
                //     ELSE
                //       BEGIN
                //         IF RecHSNCode.GET("GST Group Code","HSN/SAC Code") THEN
                //           "Custom Duty Amount1" := ROUND("GST Assessable Value1" * RecHSNCode."Customs Duty %"/100,0.01,'=');
                //       END;
                //   END;
                // rdk230919 +
                //>>PCPL/MIG/NSW
                /*
                Vendor.GET(PurchHeader."Buy-from Vendor No.");
                IF NOT (Vendor."GST Vendor Type" IN [Vendor."GST Vendor Type"::Import,Vendor."GST Vendor Type"::SEZ]) THEN
                  ERROR(GSTVendorTypeErr,Vendor."GST Vendor Type"::Import,Vendor."GST Vendor Type"::SEZ);
                IF NOT (Type IN [Type::Item,Type::"Fixed Asset"]) THEN
                  TESTFIELD("GST Assessable Value",0);
                */

            end;
        }
        field(50126; "Transfer From Reason Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Reason Code";
        }
        field(50127; "Transfer To Reason Code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50128; Duty; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50129; Cess; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50130; Surcharge; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-27-04-2018';
        }
        field(50250; "Reason Code"; Code[10])
        {
            Description = 'CCIT-DINESH';
            TableRelation = "Reason Code";
        }
        field(50251; "Product SR No.BE"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50252; "Invoice SR No.BE"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50253; "Box/Case No."; Code[20])
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
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50505; "Reason For TO"; Boolean)
        {
            Description = 'CCIT-JAGA-19-05-18';
        }
    }
    keys
    {

        //Unsupported feature: PropertyChange on ""Document No.,Line No."(Key)". Please convert manually.

    }



    var
        ToLocForGSTCalculation: Code[20];
        lLocation: Record 14;



    var
        "---------------": Integer;
        RecUOM: Record 5404;
        RecCust: Record 18;
        RecUOM1: Record 5404;
        RecTH1: Record 5740;
        RecILE: Record 32;
        TotalLicQty: Decimal;
        TotalLicConversionQty: Decimal;
        RecLicNo: Record 50023;
        recTH: Record 5740;
        PODate: Date;
        EXPDate: Date;
        RecItem: Record 27;
        RecItem2: Record 27;
        RecBondMaster: Record 50022;
        RecDutyFreeLicMaster: Record 50025;
        TotalLicConversionQty1: Integer;
        TotLicQtyDutyFree: Decimal;
        TransLine22: Record 5741;
        TotalLineQty: Decimal;
        TotalQtyInPCS: Decimal;
        GSTManagement: Codeunit 18015;
        Item: Record Item;
}

