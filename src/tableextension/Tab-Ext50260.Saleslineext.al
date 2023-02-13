tableextension 50260 "Sales_line_ext" extends "Sales Line"
{
    // version TFS225977,NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune,CCIT-TCS

    fields
    {
        // modify("TCS Type")
        // {
        //     OptionCaptionML = ENU=' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H',ENN=' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H';

        //     //Unsupported feature: Change OptionString on ""TCS Type"(Field 16503)". Please convert manually.

        // }
        // modify("Service Tax SBC %")
        // {
        //     CaptionML = ENU='Service Tax SBC %';
        // }
        modify("Customer Price Group")
        {
            trigger OnAfterValidate()
            begin
                "Rate In PCS" := ("Unit Price" * Quantity) / "Conversion Qty"; //PCPL/NSW/150322 New Code add
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate();
            var
                Item: Record 27;
            begin

                "Main Quantity in KG" := TempSalesLine."Main Quantity in KG";//CCIT-SD-23-05-2018

                //CCIT-SG
                if Item.Get("No.") then;
                "Storage Categories" := Item."Storage Categories";
                "Brand Name" := Item."Brand Name";
                //CCIT-SG

                UpdateUnitPrice(FIELDNO("No.")); //CCIT-SG

                //CCIT-SG
                RecSH1.RESET;
                RecSH1.SETRANGE(RecSH1."No.", "Document No.");
                IF RecSH1.FINDFIRST THEN
                    "License No." := RecSH1."License No.";

                IF RecItem.GET(Rec."No.") THEN BEGIN
                    Rec."Conversion UOM" := RecItem."Conversion UOM";
                    Rec."Sales Category" := RecItem."Sales Category";
                END;

                recSL2.RESET;
                recSL2.SETRANGE(recSL2."Document No.", Rec."Document No.");
                recSL2.SETRANGE(recSL2."Document Type", Rec."Document Type");
                recSL2.SETRANGE(recSL2.Type, Rec.Type::Item);
                recSL2.SETRANGE(recSL2."No.", Rec."No.");
                IF recSL2.FINDFIRST THEN
                    ERROR('Item %1 Allready Exist', Rec."No.");

                //CCIT-SG
                //---- CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        Weight := RecUOM.Weight;
                    END
                END;
                //---- CCIT-SG
                /*//CCIT-SG-070318
                IF Type = Type::Item THEN BEGIN
                    RecSPrice.RESET;
                    RecSPrice.SETRANGE(RecSPrice."Item No.",Rec."No.");
                    RecSPrice.SETRANGE(RecSPrice."Sales Code",Rec."Customer Price Group");
                    //RecSPrice.SETRANGE(RecSPrice."Customer Code",Rec."Sell-to Customer No.");
                    IF RecSPrice.FINDFIRST THEN
                    "Rate In PCS" := RecSPrice."Conversion Price Per PCS";
                END;
                //CCIT-SG-070318*/

                //CCIT-JAGA 02/11/2018
                RecSalesHeader.RESET;
                RecSalesHeader.SETRANGE(RecSalesHeader."No.", "Document No.");
                IF RecSalesHeader.FINDFIRST THEN
                    Rec.VALIDATE("Shortcut Dimension 1 Code", RecSalesHeader."Shortcut Dimension 1 Code");
                //CCIT-JAGA 02/11/2018

            end;
        }


        //Unsupported feature: CodeModification on "Quantity(Field 15).OnValidate". Please convert manually.
        modify(Quantity)
        {
            trigger OnAfterValidate();
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            //MESSAGE('%1',"Conversion Qty");
                            "Outstanding Quantity In KG" := Rec.Quantity / RecUOM.Weight;
                            "Qty. to Invoice In KG" := "Conversion Qty";
                        END
                    END
                END;
                //CCIT-SG


                //---- CCIT-SG

                //CCIT-SG-19032018
                "Amount In PCS" := "Rate In PCS" * "Conversion Qty";
                //CCIT-SG-19032018
                //CCIT-SD-14-05-2018 -
                IF Quantity <= "Main Quantity in KG" THEN
                    "Main Quantity in KG" := Quantity;
                //CCIT-SD-14-05-2018 +

            end;
        }

        //Unsupported feature: CodeModification on ""Qty. to Invoice"(Field 17).OnValidate". Please convert manually.
        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                IF NOT (RecSalesAndReceivableSetup.Tolerance <> 0) THEN BEGIN  //CCIT-SG-04042018

                END;//CCIT-SG-04042018
                    //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            /*IF (RecItem2.Tolerance = FALSE) AND ((Rec."Qty. to Invoice" MOD RecUOM1.Weight) <> 0) THEN
                               ERROR('Please Enter Correct Qty in KG')
                            ELSE*/
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Invoice In KG" := "Qty. to Invoice" / RecUOM1.Weight;
                            "Qty. to Ship In KG" := "Qty. to Invoice In KG";
                        END
                    END
                END;
                //CCIT-SG

            end;

        }

        //Unsupported feature: CodeModification on ""Qty. to Ship"(Field 18).OnValidate". Please convert manually.
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin

                //CCIT-SD-24-04-2018 +
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            Rec."Qty. to Ship In KG" := "Qty. to Ship" / RecUOM1.Weight;
                            "Qty. to Invoice In KG" := "Qty. to Ship In KG";
                        END
                    END
                END;
                IF (RecSalesAndReceivableSetup.Tolerance = 0) THEN BEGIN  //CCIT-SG

                END; //CCIT-SG

            end;
        }

        modify("Quantity Shipped")
        {
            trigger OnAfterValidate();
            begin
                //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Quantity Shipped In KG" := "Quantity Shipped" / RecUOM.Weight;
                            VALIDATE("Quantity Shipped In KG");
                            "Outstanding Quantity In KG" := "Conversion Qty" - "Quantity Shipped In KG";
                            "Qty. to Ship In KG" := "Conversion Qty" - "Quantity Shipped In KG";
                        END
                    END
                END;
                //CCIT-SG

            end;

        }
        //Unsupported feature: CodeInsertion on ""Quantity Invoiced"(Field 61)". Please convert manually.
        modify("Quantity Invoiced")
        {
            trigger OnAfterValidate();
            begin

                //CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Quantity Invoiced In KG" := "Quantity Invoiced" / RecUOM.Weight;
                            VALIDATE("Quantity Invoiced In KG");
                            "Outstanding Quantity In KG" := "Conversion Qty" - "Quantity Invoiced In KG";
                            "Qty. to Invoice In KG" := "Conversion Qty" - "Quantity Invoiced In KG";
                        END
                    END
                END;
                //CCIT-SG

            end;


        }


        //Unsupported feature: CodeModification on ""GST Group Code"(Field 16602).OnValidate". Please convert manually.
        // modify("GST Group Code")
        // {
        //     trigger OnAfterValidate();
        //     begin
        //         //Type::"G/L Account" : TESTFIELD("GST Group Type","GST Group Type"::Service);//CCIT-SG-19072018
        //         //Type::"Fixed Asset",Type::Resource,Type::Item : TESTFIELD("GST Group Type", "GST Group Type"::Goods);
        //     END;


        // }


        //<<PCPL/NSW/MIG Fields Already Exists
        // field(16612;"GST On Assessable Value";Boolean)
        // {
        //     CaptionML = ENU='GST On Assessable Value',
        //                 ENN='GST On Assessable Value';

        //     trigger OnValidate();
        //     var
        //         GSTGroup : Record "16404";
        //     begin
        //         TESTFIELD("Currency Code");
        //         TESTFIELD("GST Group Code");
        //         IF GSTGroup.GET("GST Group Code") THEN
        //           GSTGroup.TESTFIELD("GST Group Type",GSTGroup."GST Group Type"::Goods);
        //         TESTFIELD("PIT Structure",'');
        //         TESTFIELD("Unit Price Incl. of Tax",0);
        //         IF Type = Type::"Charge (Item)" THEN
        //           TESTFIELD("GST On Assessable Value",FALSE);
        //         "GST Assessable Value (LCY)" := 0;
        //         "GST Base Amount" := 0;
        //         "Total GST Amount" := 0;
        //     end;
        // }
        // field(16613;"GST Assessable Value (LCY)";Decimal)
        // {
        //     CaptionML = ENU='GST Assessable Value (LCY)',
        //                 ENN='GST Assessable Value (LCY)';

        //     trigger OnValidate();
        //     begin
        //         TESTFIELD("GST On Assessable Value",TRUE);
        //         IF "GST Assessable Value (LCY)" = 0 THEN BEGIN
        //           "GST Base Amount" := 0;
        //           "Total GST Amount" := 0;
        //         END;
        //     end;
        // } //>>PCPL/NSW/MIG
        field(16625; "Sales Amount"; Decimal)
        {
            CaptionML = ENU = 'Sales Amount',
                        ENN = 'Sales Amount';
            Editable = false;
        }
        field(50004; "Brand Name"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Brand Name";
        }
        field(50026; "Available Qty.In KG"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Customer No." = FIELD("Sell-to Customer No."),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  Reserved = CONST(true)));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50028; "Available Qty.In PCS"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Conversion Qty" WHERE("Item No." = FIELD("No."),
                                                                          "Customer No." = FIELD("Sell-to Customer No."),
                                                                          "Location Code" = FIELD("Location Code"),
                                                                          Reserved = CONST(true)));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master"."Permit No.";
        }
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //---- CCIT-SG

                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            VALIDATE(Quantity, Rec."Conversion Qty" * RecUOM1.Weight);
                            //"Line Amount" := Quantity * "Unit Price";
                            "Line Amount" := Quantity * "Unit Price";
                        END
                    END
                END;


                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                    InitOutstanding;
                    IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                        InitQtyToReceive
                    ELSE
                        InitQtyToShip;
                    //InitQtyToAsm;



                    SetDefaultQuantity;
                END;
                /*
                IF Rec."License No." <>'' THEN BEGIN
                  IF RecLicNo.GET(Rec."License No.") THEN BEGIN
                       recSH.RESET;
                       recSH.SETRANGE(recSH."No.","Document No.");
                       IF recSH.FINDFIRST THEN
                        PODate := recSH."Posting Date";
                        EXPDate := RecLicNo."License Expiry Date";
                        IF PODate < EXPDate THEN BEGIN
                            TotalLicConversionQty :=0;
                            RecILE.RESET;
                            RecILE.SETRANGE(RecILE."Item No.",Rec."No.");
                            RecILE.SETRANGE(RecILE."License No.",Rec."License No.");
                            IF RecILE.FINDSET THEN
                              REPEAT
                                TotalLicConversionQty := TotalLicConversionQty + RecILE."Conversion Qty";
                                //MESSAGE('%1   %2',TotalLicQty,Rec.Quantity);
                              UNTIL RecILE.NEXT = 0;
                
                          IF (Quantity > TotalLicConversionQty) THEN
                            ERROR('Inventory not available for this Item No. against License No. %1',Rec."License No.");
                          END ELSE  IF PODate > EXPDate THEN
                              ERROR('License has been Expired');
                 END;
                END;
                */
                //---- CCIT-SG
                //CCIT-SG-19032018
                "Amount In PCS" := "Rate In PCS" * "Conversion Qty";
                //CCIT-SG-19032018

                //CCIT-JAGA
                CLEAR(TotalQtyInPCS);
                RecILE.RESET;
                RecILE.SETRANGE("Item No.", "No.");
                RecILE.SETRANGE(RecILE."Location Code", "Location Code");
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
        field(50061; "Variance Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50062; "Salable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50063; "Variance Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50064; "Salable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
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
                            "Qty. to Invoice" := Rec."Qty. to Invoice In KG" * RecUOM1.Weight;
                            "Qty. to Ship In KG" := "Qty. to Invoice In KG";
                            "Qty. to Ship" := "Qty. to Invoice";
                        END
                    END
                END;
                //IF "Qty. to Invoice" > Quantity THEN
                //ERROR('You can not receive more than %1 units',Quantity);
                //CCIT-SG
            end;
        }
        field(50069; "Qty. to Ship In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Qty. to Ship" := Rec."Qty. to Ship In KG" * RecUOM1.Weight;
                            "Qty. to Invoice" := "Qty. to Ship";
                            "Qty. to Invoice In KG" := "Qty. to Ship In KG";
                        END
                    END
                END;
                //IF "Qty. to Ship" >= Quantity THEN
                //ERROR('You can not receive more than %1 units',Quantity);
                "Qty. to Invoice In KG" := "Qty. to Ship In KG";
                //CCIT-SG
            end;
        }
        field(50070; "Quantity Shipped In KG"; Decimal)
        {
            AccessByPermission = TableData 110 = R;
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
            Editable = false;
        }
        field(50071; "Quantity Invoiced In KG"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CCIT';
            Editable = false;
        }
        field(50072; "Outstanding Quantity In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50082; FOC; Boolean)
        {
            Description = 'CCIT';
        }
        field(50084; "Customer License No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Duty Free License Master"."License No." WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate();
            begin
                IF RecDutyFreeLicMaster.GET("Customer License No.") THEN BEGIN
                    "Customer License Name" := RecDutyFreeLicMaster."License Name";
                    "Customer License Date" := RecDutyFreeLicMaster."License Date";
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
        field(50088; "Reason For Free Sample"; Option)
        {
            OptionCaption = '" ,New Product,Liquidation,Friend & Family,Market Penetration,Competitor,Government Department,Wet Sampling"';
            OptionMembers = " ","New Product",Liquidation,"Friend & Family","Market Penetration",Competitor,"Government Department","Wet Sampling";
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50112; "Reason Code"; Code[10])
        {
            Description = 'CCIT_TK';
            TableRelation = "Reason Code";

            trigger OnValidate();
            begin
                //CCIT
                IF RecReasonCode.GET("Reason Code") THEN BEGIN
                    IF RecReasonCode.Blocked = TRUE THEN
                        ERROR('This Reason Code is Blocked');
                END;
                //CCIT
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
        field(50124; "Rate In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50125; "Amount In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50126; "Special Price"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ",Free,Retail,Horeca,Olive,"DEL-DISTRI",CHEHPL1819,"CHE DISTRI",RATNDEEPN,HORECA1718,"MUM-DISTRI",GNB,FUTURE,"TRENT HYP",RELIANCE,BB,HAICO,SURYAHY,BALAJIGB,GHYANSHYAM,VJIETHAHYD,"DIS GOA",GODFREY,"TRA&DIS10%",RATND,GROFF,"HYD TRADER",GOA,CHENNAI,BANGALORE,DELHI,RAJASTHAN,MUMBAI,HYDERABAD,"CPL-HORECA","CPL-RETAIL","MOTHER-WH","CPL-GOA","DPL 20-21";
        }
        field(50127; "Main Quantity in KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';

            trigger OnValidate();
            begin
                VALIDATE(Quantity, "Main Quantity in KG");
                IF Type = Type::Item THEN
                    UpdateUnitPrice(FIELDNO("Main Quantity in KG"));
                //CCIT-SD-14-05-2018 -
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            /*IF (RecItem2.Tolerance = FALSE) AND ((Rec."Main Quantity in KG" MOD RecUOM.Weight) <> 0) THEN
                               ERROR('Please Enter Correct Qty in KG')
                            ELSE */
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Main Quantity in PCS" := "Main Quantity in KG" / RecUOM.Weight;
                        END
                    END
                END;
                //CCIT-SD-14-05-2018 +
                CheckItemAvailable(FIELDNO("Main Quantity in KG"));  //CCIT 03/06/2018

            end;
        }
        field(50128; "Main Quantity in PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';

            trigger OnValidate();
            begin

                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            VALIDATE("Main Quantity in KG", Rec."Main Quantity in PCS" * RecUOM1.Weight);
                            //"Line Amount" := Quantity * "Unit Price";
                            "Line Amount" := "Main Quantity in KG" * "Unit Price";
                            //CCIT-SG-12062018
                            "Qty. to Ship" := "Main Quantity in KG";
                            "Qty. to Invoice" := "Main Quantity in KG";
                            "Qty. to Invoice In KG" := "Main Quantity in PCS";
                            "Qty. to Ship In KG" := "Main Quantity in PCS";
                            "Outstanding Quantity In KG" := "Main Quantity in PCS";
                            "Outstanding Quantity" := "Main Quantity in KG";
                            //CCIT-SG-12062018
                        END
                    END
                END;
            end;
        }
        field(50129; Tolerance; Boolean)
        {
            Description = 'CCIT-SD-14-05-2018';
        }
        field(50130; IsShortClosed; Boolean)
        {
            CalcFormula = Lookup("Sales Header"."Short Closed" WHERE("No." = FIELD("Document No.")));
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50131; "Item code"; Code[20])
        {
            Description = 'RDK 190919 - for GL CN desc';
            TableRelation = Item;

            trigger OnValidate();
            begin
                IF RecItem.GET("Item code") THEN begin
                    Description := RecItem.Description;
                    "HSN/SAC Code" := RecItem."HSN/SAC Code";
                    "GST Group Code" := RecItem."GST Group Code";
                end;

            end;
        }
        field(50132; "Allow discount"; Boolean)
        {
            CalcFormula = Lookup(Customer."Allow Line Disc." WHERE("No." = FIELD("Sell-to Customer No.")));
            Description = '//CCIT-TK-071220';
            FieldClass = FlowField;
        }
        field(70000; "Minimum Shelf Life %"; Decimal)
        {
            CalcFormula = Lookup("Sales Header"."Minimum Shelf Life %" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "No." = FIELD("Document No.")));
            Description = 'SC';
            FieldClass = FlowField;
        }
        field(50133; "TCS Section"; Code[10])

        {
            Caption = 'TCS Section';
            trigger OnLookup()
            var
                AllowedNOC: Record "Allowed NOC";
                TCSNatureOfCollection: Record "TCS Nature Of Collection";
                TCSNatureOfCollections: Page "TCS Nature Of Collections";
                Cust: Record 18;
                TDSTCSSetup: record "TDS TCS Setup";
                TCSNC: Record "TCS Nature Of Collection";
                CalculateTax: Codeunit "Calculate Tax";
            begin
                TCSNatureOfCollection.Reset();
                AllowedNOC.Reset();
                AllowedNOC.SetRange("Customer No.", "Sell-to Customer No.");
                if AllowedNOC.FindSet() then
                    repeat
                        TCSNatureOfCollection.SetRange(Code, AllowedNOC."TCS Nature of Collection");
                        TCSNatureOfCollection.SetRange("TCS on Recpt. Of Pmt.", false);
                        if TCSNatureOfCollection.FindFirst() then
                            TCSNatureOfCollection.Mark(true);
                    until AllowedNOC.Next() = 0;
                TCSNatureOfCollection.SetRange(Code);
                TCSNatureOfCollection.MarkedOnly(true);
                TCSNatureOfCollections.SetTableView(TCSNatureOfCollection);
                TCSNatureOfCollections.LookupMode(true);
                TCSNatureOfCollections.Editable(false);
                if TCSNatureOfCollections.RunModal() = Action::LookupOK then begin
                    TCSNatureOfCollections.GetRecord(TCSNatureOfCollection);
                    //CheckDefaultandAssignNOC(SalesLine, TCSNatureOfCollection.Code);
                    "TCS Section" := TCSNatureOfCollection.eTCS;
                end;

                If Cust.Get("Sell-to Customer No.") then begin
                    IF Cust."TCS 206 CAA Applicable" = Cust."TCS 206 CAA Applicable"::"Non Comply" then begin
                        TDSTCSSetup.Reset();
                        TDSTCSSetup.SetCurrentKey("TDS %");
                        TDSTCSSetup.Ascending(TRUE);
                        TDSTCSSetup.SetRange(eTDS, "TCS Section");
                        TDSTCSSetup.SetRange("Assessee Code", Cust."Assessee Code");
                        IF TDSTCSSetup.FindLast() then begin
                            TCSNC.Reset();
                            TCSNC.SetRange(TCSNC.Code, TDSTCSSetup."Section Code");
                            IF TCSNC.FindFirst() then;
                        END;
                        Validate("TCS Nature of Collection", TCSNC.Code);
                        CLEAR(CalculateTax);
                        CalculateTax.CallTaxEngineOnSalesLine(Rec, xRec);
                    end;
                end;

                // //Start
                // IF Vend.Get("Buy-from Vendor No.") then begin
                //     IF Vend."Applicability of 206AB" = Vend."Applicability of 206AB"::"Not Comply" then begin
                //         TDSTCSSetup.Reset();
                //         TDSTCSSetup.SetCurrentKey("TDS %");
                //         TDSTCSSetup.Ascending(TRUE);
                //         TDSTCSSetup.SetRange(eTDS, "TDS Section");
                //         TDSTCSSetup.SetRange("Assessee Code", Vend."Assessee Code");
                //         IF TDSTCSSetup.FindLast() then begin
                //             TDSSec.Reset();
                //             TDSSec.SetRange(TDSSec.Code, TDSTCSSetup."Section Code");
                //             IF TDSSec.FindFirst() then;
                //         END;
                //         Validate("TDS Section Code", TDSSec.Code);
                //         CLEAR(CalculateTax);
                //         CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);

                //     end;
                // END;
            END;
        }
        field(50140; "MRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
        }
        field(50141; "Tolerance Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/NSW/MIG';
            DecimalPlaces = 0 : 3;

        }
        field(50160; "Invt.Pick Tolerance Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
    }

    var
        // RecSH : Record 36;
        RecSL: Record 37;
        RecLoc: Record 14;
        Customer: Record 18;
        FixedAmt: Decimal;
        VariableAmt: Decimal;
        AdjustedAmt: Decimal;
        DiffAdjustmentAmt: Decimal;

        TempErrorMessage: Record 700 temporary;
        UnitPriceChangedMsg: TextConst Comment = '%1 = Type caption %2 = No.', ENU = 'The unit price for %1 %2 that was copied from the posted document has been changed.', ENN = 'The unit price for %1 %2 that was copied from the posted document has been changed.';
        CannotChangeVATGroupWithPrepmInvErr: TextConst ENU = 'You cannot change the VAT product posting group because prepayment invoices have been posted.\\You need to post the prepayment credit memo to be able to change the VAT product posting group.', ENN = 'You cannot change the VAT product posting group because prepayment invoices have been posted.\\You need to post the prepayment credit memo to be able to change the VAT product posting group.';
        CannotChangePrepmtAmtDiffVAtPctErr: TextConst ENU = 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.', ENN = 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.';

        TCSNatureOfCollectionErr: TextConst ENU = 'TCS Nature of Collection must be same in both documents.', ENN = 'TCS Nature of Collection must be same in both documents.';
        NOCNotFoundErr: TextConst Comment = '%1 = TCS Nature of Collection,%2 = Customer No', ENU = 'The field TCS Nature of collection contains a value ''%1'' that cannot be found for Customer %2.', ENN = 'The field TCS Nature of collection contains a value ''%1'' that cannot be found for Customer %2.';
        LCYTxt: TextConst ENU = ' (LCY)', ENN = ' (LCY)';
        NGLStructErr: TextConst ENU = 'You can select Non-GST Line field in transaction only for GST related structure.', ENN = 'You can select Non-GST Line field in transaction only for GST related structure.';
        GSTShipToStateCodeErr: TextConst ENU = 'GST Transaction with Ship-to Code is not allowed against Unregistered Customer.', ENN = 'GST Transaction with Ship-to Code is not allowed against Unregistered Customer.';
        GSTPlaceOfSupplyErr: TextConst ENU = 'You must select Ship-to Code or Ship-to Customer in transaction header.', ENN = 'You must select Ship-to Code or Ship-to Customer in transaction header.';
        "--------------": Integer;
        RecUOM: Record 5404;
        RecSalesAndReceivableSetup: Record 311;
        QtyToShip: Decimal;
        ToleranceQty: Decimal;
        RecUOM1: Record 5404;
        RecSalesAndReceivableSetup1: Record 311;
        QtyToShip1: Decimal;
        ToleranceQty1: Decimal;
        RecSH1: Record 36;
        TotalLicQty: Decimal;
        RecILE: Record 32;
        TotalLicConversionQty: Decimal;
        RecLicNo: Record 50023;
        EXPDate: Date;
        recSH: Record 36;
        PODate: Date;
        RecItem: Record 27;
        RecItem2: Record 27;
        recSL2: Record 37;
        RecSPrice: Record 7002;
        RecDutyFreeLicMaster: Record 50025;
        TotalQtyInPCS: Decimal;
        RecSalesHeader: Record 36;
        //nodnoc : Record 13786;
        //NodNocLine : Record 13785;
        RecSalesAndRecSetup: Record 311;
        RecCust1: Record 18;
        RecReasonCode: Record 231;
        TempSalesLine: Record 37;
}

