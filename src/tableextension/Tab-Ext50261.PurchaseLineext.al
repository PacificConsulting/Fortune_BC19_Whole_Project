tableextension 50261 "Purchase_Line_ext" extends "Purchase Line"
{
    // version TFS225977,CCIT-Fortune,CCIT-TDS

    fields
    {
        // modify("TDS Section Code")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         NewPurchLine.Reset();
        //         NewPurchLine.SetRange("Document No.", "Document No.");
        //         NewPurchLine.SetRange("Line No.", "Line No.");
        //         if NewPurchLine.FindFirst() then
        //             TaxRecordID := NewPurchLine.RecordId();

        //         TDSAmt := GetTDSAmtLineWise(TaxRecordID, ComponentJobject);
        //         Message('TDS: %1', TDSAmt);
        //     end;
        // }

        modify("Applies-to ID (Delivery)")
        {
            CaptionML = ENU = 'Applies-to ID (Delivery)';
        }
        modify("Applies-to ID (Receipt)")
        {
            CaptionML = ENU = 'Applies-to ID (Receipt)';
        }
        modify("Delivery Challan Date")
        {
            CaptionML = ENU = 'Delivery Challan Date';
        }

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin

                IF RecVendor.GET("Buy-from Vendor No.") THEN
                    "Buy-from Vendor Name" := RecVendor.Name;

            end;

        }

        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG-23052018
                IF recPH.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                    "Buy-from Vendor No." := recPH."Buy-from Vendor No.";
                    "Sell-to Customer No." := recPH."Sell-to Customer No.";
                END;
                //CCIT-SG-23052018


            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                IF RecItem.Get("No.") then;
                "Sell-to Customer No." := PurchHeader."Sell-to Customer No.";//ccit
                "Storage Categories" := RecItem."Storage Categories"; //CCIT-SG
                                                                      //CCIT-SG
                RecPH1.RESET;
                RecPH1.SETRANGE(RecPH1."No.", "Document No.");
                IF RecPH1.FINDFIRST THEN
                    "License No." := RecPH1."License No.";

                /*{recPL2.RESET;
                recPL2.SETRANGE(recPL2."Document No.", Rec."Document No.");
                recPL2.SETRANGE(recPL2."Document Type", Rec."Document Type");
                recPL2.SETRANGE(recPL2.Type, Rec.Type::Item);
                recPL2.SETRANGE(recPL2."No.", Rec."No.");
                IF recPL2.FINDFIRST THEN
                    ERROR('Item %1 Allready Exist', Rec."No.");
                }*/
                IF RecItem11.GET(Rec."No.") THEN BEGIN
                    Rec."Conversion UOM" := RecItem11."Conversion UOM";
                    Rec."Description 2" := RecItem11."Description 2";
                END;
                RecPH1.RESET;
                RecPH1.SETRANGE(RecPH1."No.", "Document No.");
                IF RecPH1.FINDFIRST THEN
                    IF RecPH1."Location Code" = '' THEN
                        ERROR('Location Code Not Blank on Purchase Header');
                //CCIT-SG

                //---- CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        Weight := RecUOM.Weight;
                    END
                END;
                //---- CCIT-SG

            end;

        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            //  {IF (RecItem2.Tolerance = FALSE) AND ((Rec.Quantity MOD RecUOM.Weight) <> 0) THEN
                            //                         ERROR('Please Enter Correct Qty in KG')
                            //                     ELSE }
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            //"Outstanding Quantity In KG" := Rec.Quantity / RecUOM.Weight;
                            "Qty. to Receive In KG" := "Conversion Qty";
                            "Qty. to Invoice In KG" := "Conversion Qty";
                            "Quantity (Base) In KG" := "Conversion Qty";
                            //"Qty. to Receive (Base) In KG" := "Conversion Qty"; //CCIT-SG-17012018
                            //"Qty. to Invoice (Base) In KG" := "Conversion Qty"; //CCIT-SG-17012018
                        END
                    END
                END;

                TotalLineQty := 0;
                PurchLine22.RESET;
                PurchLine22.SETFILTER(PurchLine22."Document No.", Rec."Document No.");
                IF PurchLine22.FINDSET THEN
                    REPEAT
                        TotalLineQty += PurchLine22.Quantity;
                    UNTIL PurchLine22.NEXT = 0;
                IF Rec."License No." <> '' THEN BEGIN
                    IF RecLic.GET(Rec."License No.") THEN BEGIN
                        TotLicQty := RecLic."Balance Quantity";
                        IF ((TotalLineQty + Rec.Quantity) > TotLicQty) THEN
                            ERROR('Inventory  available  is %1 for this Vendor against License No. %2', TotLicQty, Rec."License No.");
                    END;
                END;
                IF Rec."HS Code" <> '' THEN BEGIN
                    IF RecHS.GET(Rec."HS Code") THEN BEGIN
                        TotLicQty := RecHS."Avilable Quantity";
                        IF ((TotalLineQty + Rec.Quantity) > TotLicQty) THEN
                            ERROR('Inventory  available  is %1 for this Vendor against HS Code %2', TotLicQty, Rec."HS Code");
                    END;
                END;
                //CCIT-SG

                //CCIT-SG-29052018
                IF ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
                    "Return Qty. to Ship" := Quantity;
                    VALIDATE("Return Qty. to Ship");
                END;
                //CCIT-SG-29052018
                //CCIT-SG
                IF NOT ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
                    "Qty. to Receive" := Quantity;
                    VALIDATE("Qty. to Receive");
                    "Qty. to Invoice" := Quantity;
                    VALIDATE("Qty. to Invoice");
                END;

                IF RecUOM11.GET("No.", "Unit of Measure Code") THEN BEGIN
                    IF RecItem11.GET("No.") THEN BEGIN
                        RecItem11."Purchase Order Conversion" := "Outstanding Qty. (Base)" * RecUOM11.Weight;
                        RecItem11."Sales Order Conversion" := "Outstanding Qty. (Base)" * RecUOM11.Weight;
                        RecItem11.MODIFY;
                    END;
                END;
                //---- CCIT-SG


            end;

        }

        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            //  {IF (RecItem2.Tolerance = FALSE) AND ((Rec."Qty. to Invoice" MOD RecUOM.Weight) <> 0) THEN
                            //                 ERROR('Please Enter Correct Qty in KG')
                            //             ELSE}
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Invoice In KG" := "Qty. to Invoice" / RecUOM.Weight;
                            "Qty. to Receive In KG" := "Qty. to Invoice In KG";
                        END
                    END
                END;
                //CCIT-SG


            end;

        }


        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            //   {IF (RecItem2.Tolerance = FALSE) AND ((Rec."Qty. to Receive" MOD RecUOM1.Weight) <> 0) THEN
                            //                 ERROR('Please Enter Correct Qty in KG')
                            //             ELSE }
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Receive In KG" := "Qty. to Receive" / RecUOM1.Weight;
                            "Qty. to Invoice In KG" := "Qty. to Receive In KG";
                        END
                    END
                END;
                //CCIT-SG


            end;
        }


        modify("Quantity Received")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Quantity Received" := RecUOM.Weight; //PCPL-064
                            Validate("Quantity Received");//pcpl-064

                            "Quantity Received In KG" := "Quantity Received" * RecUOM.Weight;
                            VALIDATE("Quantity Received In KG");
                            //"Outstanding Quantity In KG" := "Conversion Qty" - "Quantity Received In KG";
                            "Qty. to Receive In KG" := "Conversion Qty" - "Quantity Received In KG";
                        END
                    END
                END;
                //CCIT-SG
                "Saleable Qty. In KG" := "Quantity Received"; //CCIT-SG-07022018
                "Saleable Qty. In PCS" := "Quantity Received In KG";  //CCIT-SG-07022018

                //VALIDATE("Saleable Qty. In KG","Quantity Received");
                //VALIDATE("Saleable Qty. In PCS","Quantity Received In KG");

            end;
        }



        //modify("Reason Code")  //PCPL/MIG/NSW
        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        //CCIT
        IF RecReasonCode.GET("Reason Code") THEN
        BEGIN
           IF RecReasonCode.Blocked = TRUE THEN
              ERROR('This Reason Code is Blocked');
        END;
        //CCIT
        */
        //end;



        field(50024; "Total Qty. In KG"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Document No." = FIELD("Document No."),
                                                              "Document Type" = FIELD("Document Type")));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50025; "Total PO Amount"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Line Amount" WHERE("Document No." = FIELD("Document No."),
                                                                   "Document Type" = FIELD("Document Type")));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50026; "Excess Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF (Rec."Unit of Measure Code" = 'PCS') THEN BEGIN
                    IF RecUOM1.GET(Rec."No.", 'PCS') THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN
                            "Excess Qty In PCS" := Rec."Excess Qty In KG" * RecUOM1.Weight;
                    END;
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
                IF (Rec."Unit of Measure Code" = 'PCS') THEN BEGIN
                    IF RecUOM1.GET(Rec."No.", 'PCS') THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN
                            "Excess Qty In KG" := Rec."Excess Qty In PCS" / RecUOM1.Weight;
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50028; "Tracking Exists"; Boolean)
        {
            CalcFormula = Exist("Reservation Entry" WHERE("Source ID" = FIELD("Document No."),
                                                           "Source Ref. No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master"."Permit No." WHERE("Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnValidate();
            begin
                /*
                RecHSMaster.RESET;
                RecHSMaster.SETRANGE(RecHSMaster."License Code","License No.");
                IF RecHSMaster.FINDSET THEN
                  REPEAT
                     IF NOT (RecHSMaster."Item Code" = Rec."No.") THEN
                       ERROR('For Item No. %1 License No. And HS Code Not available',Rec."No.");
                  UNTIL RecHSMaster.NEXT=0;
                */

            end;
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
                //---- CCIT-SG
                IF Type = Type::Item THEN BEGIN
                    IF RecItem2.GET(Rec."No.") THEN BEGIN
                        IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                Quantity := Rec."Conversion Qty" * RecUOM1.Weight;
                                VALIDATE(Quantity);
                                "Qty. to Invoice In KG" := "Conversion Qty";
                                "Qty. to Receive In KG" := "Conversion Qty";
                                "Qty. to Receive" := Quantity;
                                "Qty. to Invoice" := Quantity;

                            END
                        END
                    END;

                    IF "Unit Cost" <> 0 THEN
                        "Line Amount" := "Unit Cost" * Quantity;
                    VALIDATE("Line Amount");
                    //"Quantity (Base) In KG" := "Conversion Qty";
                    //"Outstanding Qty. (Base) In KG" := "Conversion Qty";
                    //"Quantity (Base)" := Quantity;
                    // "Outstanding Qty. (Base)" := Quantity;
                END;

                TotalLineQty := 0;
                PurchLine22.RESET;
                PurchLine22.SETFILTER(PurchLine22."Document No.", Rec."Document No.");
                IF PurchLine22.FINDSET THEN
                    REPEAT
                        TotalLineQty += PurchLine22.Quantity;
                    UNTIL PurchLine22.NEXT = 0;
                //MESSAGE('%1',TotalLineQty);
                IF Rec."License No." <> '' THEN BEGIN
                    IF RecLic.GET(Rec."License No.") THEN BEGIN
                        TotLicQty := RecLic."Balance Quantity";
                        IF ((TotalLineQty + Rec.Quantity) > TotLicQty) THEN
                            ERROR('Inventory  available  is %1 for this Vendor against License No. %2', TotLicQty, Rec."License No.");
                    END;
                END;


                //---- CCIT-SG
            end;
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
        field(50068; "Qty. to Invoice In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            /*IF (RecItem2.Tolerance = FALSE) AND ((Rec."Qty. to Invoice In KG" MOD RecUOM1.Weight) <> 0) THEN
                               ERROR('Please Enter Correct Qty in KG')
                             ELSE*/
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Qty. to Invoice" := Rec."Qty. to Invoice In KG" / RecUOM1.Weight;
                            "Qty. to Receive In KG" := "Qty. to Invoice In KG";
                            "Qty. to Receive" := "Qty. to Invoice";
                            //"Qty. to Invoice (Base) In KG" := "Qty. to Invoice In KG";//CCIT-SG-17012018
                            //"Qty. to Receive (Base) In KG" := "Qty. to Receive In KG"//CCIT-SG-17012018
                        END
                    END
                END;
                IF "Qty. to Invoice In KG" > Quantity THEN
                    ERROR('You can not receive more than %1 units', "Conversion Qty");
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
                RecPurchAndReceivableSetup.GET;
                IF RecPurchAndReceivableSetup.Tolerance <> 0 THEN BEGIN
                    ToleranceQty := (RecPurchAndReceivableSetup.Tolerance * Rec.Quantity) / 100;
                    QtyToReceive := Rec.Quantity + ToleranceQty;
                    IF "Qty. to Receive" > QtyToReceive THEN
                        ERROR('Qty. TO Receive In KG not greater than %1', QtyToReceive);
                END;
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Qty. to Receive" := Rec."Qty. to Receive In KG" * RecUOM1.Weight;
                            "Qty. to Invoice" := "Qty. to Receive";
                            "Qty. to Invoice In KG" := "Qty. to Receive In KG";
                            //"Qty. to Invoice (Base) In KG" := "Qty. to Invoice In KG";//CCIT-SG-17012018
                            //"Qty. to Receive (Base) In KG" := "Qty. to Receive In KG"//CCIT-SG-17012018
                        END;
                    END;
                END;
                /*IF NOT (RecPurchAndReceivableSetup.Tolerance <> 0) THEN BEGIN
                  IF "Qty. to Receive" > Quantity THEN
                    ERROR('You can not receive more than %1 units',Quantity);
                  "Qty. to Invoice In KG" := "Qty. to Receive In KG";
                END;*/
                //CCIT-SG

            end;
        }
        field(50070; "HS Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "HS Code Master"."HS Code" WHERE("License Code" = FIELD("License No."),
                                                              "Item Code" = FIELD("No."));
        }
        field(50071; "Quantity (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50072; "Outstanding Qty. (Base) In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
            Editable = false;
        }
        field(50073; "Quantity Received In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50074; "Quantity Invoiced In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50075; "Outstanding Quantity In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //"Saleable Qty. In PCS" := Quantity - "Damage Qty. In PCS";
            end;
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //"Saleable Qty. In KG" := Quantity - "Damage Qty. In KG";
            end;
        }
        field(50082; "BOE Qty.In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF Type = Type::Item THEN BEGIN
                    IF RecItem2.GET(Rec."No.") THEN BEGIN
                        IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                "BOE Qty.In KG" := Rec."BOE Qty.In PCS" / RecUOM1.Weight;
                            END
                        END
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50083; "BOE Qty.In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                IF Type = Type::Item THEN BEGIN
                    IF RecItem2.GET(Rec."No.") THEN BEGIN
                        IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                "BOE Qty.In PCS" := Rec."BOE Qty.In KG" * RecUOM1.Weight;
                            END
                        END
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."No.") THEN BEGIN
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
                IF RecItem2.GET(Rec."No.") THEN BEGIN
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
        field(50124; "Sell-to Customer No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = Customer;
        }
        field(50125; "Buy-from Vendor Name"; Text[250])
        {
        }
        field(50126; "TCS Nature of Collection"; Code[10])
        {
            CaptionML = ENU = 'TCS Nature of Collection',
                        ENN = 'TCS Nature of Collection';
            TableRelation = "TCS Nature Of Collection";

            trigger OnLookup();
            var
                NatureOfCollection: Record 18811;
                TempNatureOfCollection: Record 18811 temporary;
            begin
                //PCPL/MIG/NSW NOD NOC table not exist in BC
                // NOCLine.RESET;
                // NOCLine.SETRANGE(Type,NODLines.Type::Vendor);
                // NOCLine.SETRANGE("No.","Buy-from Vendor No.");
                // NOCLine.SETRANGE("TCS for Vendor",TRUE);
                // IF NOCLine.FIND('-') THEN
                //   REPEAT
                //     NatureOfCollection.GET(NOCLine."NOD/NOC");
                //     TempNatureOfCollection := NatureOfCollection;
                //     TempNatureOfCollection.INSERT;
                //   UNTIL NOCLine.NEXT = 0;

                IF PAGE.RUNMODAL(PAGE::"TCS Nature of Collections", TempNatureOfCollection) = ACTION::LookupOK THEN
                    "TCS Nature of Collection" := TempNatureOfCollection.Code;
                VALIDATE("TCS Nature of Collection");
            end;

            trigger OnValidate();
            begin
                GetPurchHeader;
                IF TCSNOC.GET("TCS Nature of Collection") THEN
                    //"TCS Type" := TCSNOC."TCS Type" //PCPL/MIG/NSW
                    // ELSE //PCPL/MIG/NSW
                    "TCS Type" := "TCS Type"::" ";
                //PCPL/MIG/NSW
                // IF GSTManagement.CheckGSTStrucure(PurchHeader.Structure) THEN BEGIN
                //   PurchHeader.TESTFIELD("Applies-to Doc. No.",'');
                //   PurchHeader.TESTFIELD("Applies-to ID",'');
                // END;
                //PCPL/MIG/NSW
                IF PurchHeader."Applies-to Doc. No." <> '' THEN
                    PurchHeader.TESTFIELD("Applies-to Doc. No.", '');
                IF (PurchHeader."Applies-to ID" <> '') AND ("TCS Nature of Collection" <> xRec."TCS Nature of Collection") THEN
                    PurchHeader.TESTFIELD("Applies-to ID", '');
                IF "TCS Nature of Collection" <> '' THEN BEGIN
                    //PCPL/MIG/NSW
                    //   NOCLine.RESET;
                    //   NOCLine.SETRANGE(Type,NODLines.Type::Vendor);
                    //   NOCLine.SETRANGE("No.","Buy-from Vendor No.");
                    //   NOCLine.SETRANGE("NOD/NOC","TCS Nature of Collection");
                    //   IF NOT NOCLine.FINDFIRST THEN
                    //     ERROR(NOCNotFoundErr,"TCS Nature of Collection","Buy-from Vendor No.");
                END;
                InitTCS(Rec);
            end;
        }
        field(50127; "TCS %"; Decimal)
        {
            DecimalPlaces = 2 : 3;
            Editable = false;

            trigger OnValidate();
            begin
                //PCPL/MIG/NSW  
                //  "Bal. TDS Including SHE CESS" :=
                //  ROUND(("TDS %" * (1 + "Surcharge %" / 100)) * Amount / 100,Currency."Amount Rounding Precision");
            end;
        }
        field(50128; "TCS Base Amount"; Decimal)
        {
            Editable = false;
        }
        field(50129; "TCS Type"; Option)
        {
            CaptionML = ENU = 'TCS Type',
                        ENN = 'TCS Type';
            OptionCaptionML = ENU = ' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H',
                              ENN = ' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H';
            OptionMembers = " ",A,B,C,D,E,F,G,H,I,J,K,L,M,N,"1H";
        }
        field(50130; "Purchase Amount"; Decimal)
        {
            Editable = false;
        }
        field(50131; "Price Inclusive of Tax"; Boolean)
        {
            CaptionML = ENU = 'Price Inclusive of Tax',
                        ENN = 'Price Inclusive of Tax';

            trigger OnValidate();
            var
            // StrOrderDetails : Record 13794; //PCPL/MIG/NSW Object not Exist in BC18
            // StrOrderLines : Record 13795;
            // SaleLineDetailBuffer : Record 16583;
            begin
                /*//tcsTestStatusOpen;
                GetSalesHeader;
                TESTFIELD(Type,Type::Item);
                IF "Price Inclusive of Tax" THEN BEGIN
                  VALIDATE("Line Discount %");
                  SalesHeader.TESTFIELD("Free Supply",FALSE);
                END;
                IF NOT "Price Inclusive of Tax" THEN BEGIN
                  "PIT Structure" := '';
                  StrOrderDetails.RESET;
                  StrOrderDetails.SETCURRENTKEY("Document Type","Document No.",Type);
                  StrOrderDetails.SETRANGE(Type,StrOrderDetails.Type::Sale);
                  StrOrderDetails.SETRANGE("Document Type","Document Type");
                  StrOrderDetails.SETRANGE("Document No.","Document No.");
                  StrOrderDetails.SETRANGE("Document Line No.","Line No.");
                  StrOrderDetails.SETRANGE("Price Inclusive of Tax",TRUE);
                  StrOrderDetails.DELETEALL;
                
                  StrOrderLines.RESET;
                  StrOrderLines.SETCURRENTKEY("Document Type","Document No.",Type);
                  StrOrderLines.SETRANGE(Type,StrOrderLines.Type::Sale);
                  StrOrderLines.SETRANGE("Document Type","Document Type");
                  StrOrderLines.SETRANGE("Document No.","Document No.");
                  StrOrderLines.SETRANGE("Line No.","Line No.");
                  StrOrderLines.SETRANGE("Price Inclusive of Tax",TRUE);
                  StrOrderLines.DELETEALL;
                
                  SaleLineDetailBuffer.RESET;
                  SaleLineDetailBuffer.SETRANGE(Type,StrOrderLines.Type::Sale);
                  SaleLineDetailBuffer.SETRANGE("Document Type","Document Type");
                  SaleLineDetailBuffer.SETRANGE("Document No.","Document No.");
                  SaleLineDetailBuffer.SETRANGE("Line No.","Line No.");
                  SaleLineDetailBuffer.DELETEALL;
                
                  InitExciseAmount;
                  "Amount Added to Excise Base" := 0;
                  "Excise Base Amount" := 0;
                  "Amount Added to Tax Base" := 0;
                  "Tax Base Amount" := 0;
                  "Charges To Customer" := 0;
                  "Unit Price" := 0;
                  "Line Amount" := 0;
                  "Unit Price Incl. of Tax" := 0;
                  "Outstanding Amount" := 0;
                  "Outstanding Amount (LCY)" := 0;
                  "Amount To Customer UPIT" := 0;
                  VALIDATE("Line Discount %");
                  VALIDATE(Quantity);
                  UpdateTaxAmounts;
                  UpdateGSTAmounts("GST Base Amount");
                END;
                */

            end;
        }
        field(50132; "GST On Assessable Value"; Boolean)
        {
            CaptionML = ENU = 'GST On Assessable Value',
                        ENN = 'GST On Assessable Value';

            trigger OnValidate();
            var
                GSTGroup: Record 18004;
            begin
                /*//tcsTESTFIELD("Currency Code");
                TESTFIELD("GST Group Code");
                IF GSTGroup.GET("GST Group Code") THEN
                  GSTGroup.TESTFIELD("GST Group Type",GSTGroup."GST Group Type"::Goods);
                TESTFIELD("PIT Structure",'');
                TESTFIELD("Unit Price Incl. of Tax",0);
                IF Type = Type::"Charge (Item)" THEN
                  TESTFIELD("GST On Assessable Value",FALSE);
                "GST Assessable Value (LCY)" := 0;
                "GST Base Amount" := 0;
                "Total GST Amount" := 0;
                */

            end;
        }
        field(50133; "GST Assessable Value (LCY)"; Decimal)
        {
            CaptionML = ENU = 'GST Assessable Value (LCY)',
                        ENN = 'GST Assessable Value (LCY)';

            trigger OnValidate();
            begin
                TESTFIELD("GST On Assessable Value", TRUE);
                IF "GST Assessable Value (LCY)" = 0 THEN BEGIN
                    //  "GST Base Amount" := 0;
                    //"Total GST Amount" := 0;
                END;
            end;
        }
        field(50134; "TCS Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Editable = false;
        }
        field(50140; "TDS Section"; Code[10])
        {
            Caption = 'TDS Section';
            trigger OnLookup()
            var
                Section: Record "TDS Section";
                AllowedSections: Record "Allowed Sections";
                TDSTCSSetup: Record "TDS TCS Setup";
                Vend: Record Vendor;
                TDS: Decimal;
                TDS1: Decimal;
                TDSSec: Record "TDS Section";
                CalculateTax: Codeunit "Calculate Tax";
            begin
                AllowedSections.Reset();
                AllowedSections.SetRange("Vendor No", "Buy-from Vendor No.");
                if AllowedSections.FindSet() then
                    repeat
                        section.setrange(code, AllowedSections."TDS Section");
                        if Section.FindFirst() then
                            Section.Mark(true);
                    until AllowedSections.Next() = 0;
                Section.setrange(code);
                section.MarkedOnly(true);
                if page.RunModal(Page::"TDS Sections", Section) = Action::LookupOK then begin
                    "TDS Section" := Section.ecode;
                end;

                //Start
                IF Vend.Get("Buy-from Vendor No.") then begin
                    IF Vend."Applicability of 206AB" = Vend."Applicability of 206AB"::"Not Comply" then begin
                        TDSTCSSetup.Reset();
                        TDSTCSSetup.SetCurrentKey("TDS %");
                        TDSTCSSetup.Ascending(TRUE);
                        TDSTCSSetup.SetRange(eTDS, "TDS Section");
                        TDSTCSSetup.SetRange("Assessee Code", Vend."Assessee Code");
                        IF TDSTCSSetup.FindLast() then begin
                            TDSSec.Reset();
                            TDSSec.SetRange(TDSSec.Code, TDSTCSSetup."Section Code");
                            IF TDSSec.FindFirst() then;
                        END;
                        Validate("TDS Section Code", TDSSec.Code);
                        CLEAR(CalculateTax);
                        CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);

                    end;

                END;

            END;
        }
        field(500130; IsShortClosed; Boolean)
        {
            CalcFormula = Lookup("Purchase Header"."Short Closed" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(500131; "Short Closed Date"; Date)
        {
            CalcFormula = Lookup("Purchase Header"."Short Closed Date" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT-TK-121219';
            FieldClass = FlowField;
        }
        field(500132; "Short Closed Reasson Code"; Option)
        {
            CalcFormula = Lookup("Purchase Header"."Short Closed Reason Code" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT-TK-121219';
            FieldClass = FlowField;
            OptionMembers = " ","Weight Loss","Short Received","FSSAI Samples from stocks","Inv / Phy – Same","Wrong PO","Duplicate PO";
        }
        field(500133; "Bill Of Entry No."; Text[20])
        {
            Description = 'CCIT_kj_27-04-21';
        }

    }



    trigger OnInsert();
    begin
        //PCPL/MIG/NSW
        /*    //CCIT Vikas
            nodnoc.RESET();
            nodnoc.SETRANGE(Type,nodnoc.Type::Vendor);
            nodnoc.SETRANGE("No.","Buy-from Vendor No.");
            IF nodnoc.FIND('-') THEN BEGIN
                NodNocLine.RESET();
                NodNocLine.SETRANGE("No.",nodnoc."No.");
                NodNocLine.SETRANGE("TCS for Vendor",TRUE);
                IF NodNocLine.FIND('-') THEN
                   VALIDATE("TCS Nature of Collection",NodNocLine."NOD/NOC");
            END;
        */
        //PCPL/MIG/NSW
    end;

    LOCAL PROCEDURE InitTCS(VAR PurchaseLine: Record 39);
    BEGIN
        WITH PurchaseLine DO BEGIN
            "TCS Base Amount" := 0;
            "Purchase Amount" := 0;
            "TCS %" := 0;
            //"Surcharge %" := 0;
            //tcs"eCESS % on TDS/TCS" := 0;
            //tcs"SHE Cess % on TDS/TCS" := 0;
            "TCS Amount" := 0;
            //"Surcharge Amount" := 0;
            //tcs"eCESS on TDS/TCS Amount" := 0;
            //tcs"SHE Cess on TDS/TCS Amount" := 0;
            //tcs"Total TDS/TCS Incl. SHE CESS" := 0;
            //tcs"Bal. TDS/TCS Including SHECESS" := 0;
        END;
    END;

    PROCEDURE MaxQtyToInvoiceKG(): Decimal;
    BEGIN
        IF "Prepayment Line" THEN
            EXIT(1);

        //IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        //  EXIT("Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced");

        EXIT("Quantity Received In KG" + "Qty. to Receive In KG" - "Quantity Invoiced In KG");
    END;

    var
        TaxRecordID: RecordId;
        ComponentJobject: JsonObject;
        TDSAmt: Decimal;
        PurchLine: Record 39;
        NewPurchLine: Record 39;
        CannotChangeVATGroupWithPrepmInvErr: TextConst ENU = 'You cannot change the VAT product posting group because prepayment invoices have been posted.\\You need to post the prepayment credit memo to be able to change the VAT product posting group.', ENN = 'You cannot change the VAT product posting group because prepayment invoices have been posted.\\You need to post the prepayment credit memo to be able to change the VAT product posting group.';
        CannotChangePrepmtAmtDiffVAtPctErr: TextConst ENU = 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.', ENN = 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.';
        TDSNatureOfDeductionErr: TextConst Comment = '%1 = Payment Entry No,%2 = Document Type , %3 = Document No', ENU = 'TDS Nature of Deduction must be same in Advance Payment Entry No. %1 and Document Type %2, Document No %3.', ENN = 'TDS Nature of Deduction must be same in Advance Payment Entry No. %1 and Document Type %2, Document No %3.';
        POSasGSTGroupErr: TextConst ENU = 'POS as Vendor State is not applicable for Goods.', ENN = 'POS as Vendor State is not applicable for Goods.';
        POSasGSTGroupRevChergeErr: TextConst ENU = 'POS as Vendor State is not applicable for Reverse charge.', ENN = 'POS as Vendor State is not applicable for Reverse charge.';
        POSasGSTCreditErr: TextConst ENU = 'POS as Vendor State is not applicable for Availment.', ENN = 'POS as Vendor State is not applicable for Availment.';
        POSasVendorErr: TextConst Comment = '%1 = Field Name', ENU = 'POS as Vendor State is only applicable for Registered vendor, current vendor is %1.', ENN = 'POS as Vendor State is only applicable for Registered vendor, current vendor is %1.';
        CurrencyCodePOSErr: TextConst Comment = '%1 = Field Name', ENU = 'Currency code should be blank for POS as Vendor State, current value is %1.', ENN = 'Currency code should be blank for POS as Vendor State, current value is %1.';
        TypeErr: TextConst Comment = '%1 = Field Name', ENU = 'POS as Vendor state is only applicable for G/L Account, the current value is %1.', ENN = 'POS as Vendor state is only applicable for G/L Account, the current value is %1.';
        POSasVendorISDErr: TextConst ENU = 'POS as Vendor State is not applicable for ISD Location.', ENN = 'POS as Vendor State is not applicable for ISD Location.';
        GSTUnregisteredNotAppErr: TextConst ENU = 'GST is not applicable for Unregistered Vendors.', ENN = 'GST is not applicable for Unregistered Vendors.';
        NGLStructErr: TextConst ENU = 'You can select Non-GST Line field in transaction only for GST related structure.', ENN = 'You can select Non-GST Line field in transaction only for GST related structure.';
        "-----------": Integer;
        RecUOM: Record 5404;
        PurchLineUOM: Text[20];
        RecUOM1: Record 5404;
        RecPH1: Record 38;
        recPH: Record 38;
        RecLicNo: Record 50023;
        PODate: Date;
        EXPDate: Date;
        TotalLicQty: Decimal;
        RecILE: Record 32;
        TotalLicConversionQty: Decimal;
        RecUOM11: Record 5404;
        RecItem11: Record 27;
        recPL2: Record 39;
        recPH3: Record 38;
        RecPurchAndReceivableSetup: Record 312;
        ToleranceQty: Decimal;
        QtyToReceive: Decimal;
        UserSetup: Record 91;
        RecLicMaster: Record 50023;
        RecHSMaster: Record 50024;
        RecItem2: Record 27;
        RecLic: Record 50023;
        TotLicQty: Decimal;
        TotalLineQty: Decimal;
        PurchLine22: Record 39;
        RecItem: Record 27;
        Desc2: Text[50];
        RecHS: Record 50024;
        RecPurchLine: Record 39;
        RecVendor: Record 23;
        //TCSBuffer : array [2] of Record 16509 temporary;
        TCSBaseLCY: Decimal;
        TCSSetup: Record 18814;
        //NOCLine : Record "13785";
        TCSNOC: Record 18811;
        //nodnoc : Record "13786";
        //NodNocLine : Record "13785";
        TCSNatureOfCollectionErr: TextConst ENU = 'TCS Nature of Collection must be same in both documents.', ENN = 'TCS Nature of Collection must be same in both documents.';
        NOCNotFoundErr: TextConst Comment = '%1 = TCS Nature of Collection,%2 = Customer No', ENU = 'The field TCS Nature of collection contains a value ''%1'' that cannot be found for Customer %2.', ENN = 'The field TCS Nature of collection contains a value ''%1'' that cannot be found for Customer %2.';
        GSTGroupEqualErr: TextConst Comment = '%1 = Payment Entry No,%2 = Document Type , %3 = Document No', ENU = 'GST Group Code and TCS must be same in Advance Payment Entry No. %1 and Document Type %2, Document No %3.', ENN = 'GST Group Code and TCS must be same in Advance Payment Entry No. %1 and Document Type %2, Document No %3.';
        "Purch&Pay": Record 312;
        RECITEM1: Record 27;
        RecPuchAndPayable: Record 312;
        TDS_BaseAmt1: Decimal;
        TDS_BaseAmt2: Decimal;
        RecTDSEntry: Record 18689;
        RecTDSEntry1: Record 18689;
        Total_TDS_BaseAmt: Decimal;
        RecVend: Record 23;
        Vend_PAN_No: Code[20];
        RecReasonCode: Record 231;
        GSTManagement: Codeunit 18015;
        Currency: Record Currency;
        PurchHeader: record 38;
        VarItemVendor: Record 99;
        CustomDutyMaster: Record 50014;
        //StructureOrderDetails : Record 13795; //PCPL/MIG/NSW
        // RecItem : Record 27;
        PreviousAmount1: Decimal;
        InvoiceAmt1: Decimal;
        PaymentAmt1: Decimal;
        PreviousTDSAmt1: Decimal;
        TotalTDSBaseLCY: Decimal;

    local procedure GetTDSAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'TDS');
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        //        TCSAMTLinewise := ComponentAmt;
        //until TaxTransactionValue.Next() = 0;
        exit(ComponentAmt)

    end;


}

