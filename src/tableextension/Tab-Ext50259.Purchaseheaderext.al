tableextension 50259 "Purchase_header_ext" extends "Purchase Header"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    fields
    {

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                vend: Record Vendor;
                recNoSeries: Record "No. Series";
                PurchSetup: Record 312;


            begin
                IF vend.Get("Buy-from Vendor No.") then;
                //CCIT-SG
                "Port of Loading-Air" := Vend."Port of Loading-Air";
                "Port of Loading-Ocean" := Vend."Port of Loading-Ocean";
                "Port of Destination-Air" := Vend."Port of Destination-Air";
                "Port of Destination-Ocean" := Vend."Port of Destination-Ocean";
                //CCIT-SG


                //CCIT-JAGA
                PurchSetup.GET;
                recNoSeries.RESET;
                recNoSeries.SETRANGE(recNoSeries.Type, recNoSeries.Type::Vendor);
                recNoSeries.SETRANGE(recNoSeries."Customer/Vendor", "Buy-from Vendor No.");
                recNoSeries.SETFILTER(recNoSeries.Code, '%1', PurchSetup."Posted Receipt Nos." + '*');
                IF recNoSeries.FINDLAST THEN
                    "Receiving No. Series" := recNoSeries.Code;

                //CCIT-JAGA

                //CCIT-JAGA
                recNoSeries.RESET;
                recNoSeries.SETRANGE(recNoSeries.Type, recNoSeries.Type::Vendor);
                recNoSeries.SETRANGE(recNoSeries."Customer/Vendor", "Buy-from Vendor No.");
                recNoSeries.SETFILTER(recNoSeries.Code, '%1', PurchSetup."Posted Invoice Nos." + '*');
                IF recNoSeries.FINDLAST THEN
                    "Posting No. Series" := recNoSeries.Code;
                //CCIT-JAGA

            end;


        }

        modify("Pay-to Vendor No.")
        {
            trigger OnAfterValidate()
            var
                vend: Record Vendor;
            begin
                IF Vend.get("Pay-to Vendor No.") then;
                "Transport Method" := Vend."Transport Method";  //CCIT-SG
            end;
        }

        //Unsupported feature: CodeModification on ""Payment Terms Code"(Field 23).OnValidate". Please convert manually.
        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
          PaymentTerms.GET("Payment Terms Code");
          IF (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
              NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
          THEN BEGIN
            VALIDATE("Due Date","Document Date");
            VALIDATE("Pmt. Discount Date",0D);
            VALIDATE("Payment Discount %",0);
          END ELSE BEGIN
            "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
            "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
            IF NOT UpdateDocumentDate THEN
              VALIDATE("Payment Discount %",PaymentTerms."Discount %")
          END;
        END ELSE BEGIN
          VALIDATE("Due Date","Document Date");
          IF NOT UpdateDocumentDate THEN BEGIN
            VALIDATE("Pmt. Discount Date",0D);
            VALIDATE("Payment Discount %",0);
          END;
        END;
        IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
          VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        IF RecPaymentTerms.GET("Payment Terms Code") THEN
          "Payment Terms Description" := RecPaymentTerms.Description;

        IF "Document Type" = "Document Type"::Invoice THEN BEGIN //CCIT-SG
            IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
              PaymentTerms.GET("Payment Terms Code");
              IF (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                  NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
              THEN BEGIN
                VALIDATE("Due Date","Document Date");
                VALIDATE("Pmt. Discount Date",0D);
                VALIDATE("Payment Discount %",0);
              END ELSE BEGIN
                "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                IF NOT UpdateDocumentDate THEN
                  VALIDATE("Payment Discount %",PaymentTerms."Discount %")
              END;
            END ELSE BEGIN
              VALIDATE("Due Date","Document Date");
              IF NOT UpdateDocumentDate THEN BEGIN
                VALIDATE("Pmt. Discount Date",0D);
                VALIDATE("Payment Discount %",0);
              END;
            END;
        END ELSE IF ("Document Type" = "Document Type"::Order) AND ("Bill Of Lading Date" = 0D) THEN BEGIN //CCIT-SG
            IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
              PaymentTerms.GET("Payment Terms Code");
              IF (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                  NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
              THEN BEGIN
                VALIDATE("Due Date","Document Date");
                VALIDATE("Pmt. Discount Date",0D);
                VALIDATE("Payment Discount %",0);
              END ELSE BEGIN
                "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                IF NOT UpdateDocumentDate THEN
                  VALIDATE("Payment Discount %",PaymentTerms."Discount %")
              END;
            END ELSE BEGIN
              VALIDATE("Due Date","Document Date");
              IF NOT UpdateDocumentDate THEN BEGIN
                VALIDATE("Pmt. Discount Date",0D);
                VALIDATE("Payment Discount %",0);
              END;
            END;
        END;
            IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
              VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");

        */
        //end;


        //Unsupported feature: CodeModification on ""Shipment Method Code"(Field 27).OnValidate". Please convert manually.
        modify("Shipment Method Code")
        {
            trigger OnAfterValidate();
            begin
                //CCIT-SG
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    RecPaymentTerms.RESET;
                    RecPaymentTerms.SETRANGE(RecPaymentTerms."Shipment Method", "Shipment Method Code");
                    RecPaymentTerms.SETRANGE(RecPaymentTerms."Customer/Vendor No.", "Buy-from Vendor No.");
                    IF RecPaymentTerms.FINDFIRST THEN BEGIN
                        "Payment Terms Code" := RecPaymentTerms.Code;

                        IF ("Bill Of Lading Date" <> 0D) THEN BEGIN
                            IF ("Payment Terms Code" <> '') AND ("Bill Of Lading Date" <> 0D) THEN BEGIN
                                //PaymentTerms.GET("Payment Terms Code");
                                IF (("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                                    NOT RecPaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                                THEN BEGIN
                                    VALIDATE("Due Date", "Bill Of Lading Date");
                                    VALIDATE("Pmt. Discount Date", 0D);
                                    VALIDATE("Payment Discount %", 0);
                                END ELSE BEGIN
                                    "Due Date" := CALCDATE(RecPaymentTerms."Due Date Calculation", "Bill Of Lading Date");
                                    "Pmt. Discount Date" := CALCDATE(RecPaymentTerms."Discount Date Calculation", "Bill Of Lading Date");
                                    IF NOT UpdateDocumentDate THEN
                                        VALIDATE("Payment Discount %", RecPaymentTerms."Discount %")
                                END;
                            END ELSE BEGIN
                                VALIDATE("Due Date", "Bill Of Lading Date");
                                IF NOT UpdateDocumentDate THEN BEGIN
                                    VALIDATE("Pmt. Discount Date", 0D);
                                    VALIDATE("Payment Discount %", 0);
                                END;
                            END;
                        END ELSE
                            IF ("Bill Of Lading Date" = 0D) THEN BEGIN
                                //CCIT-SG
                                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                    //PaymentTerms.GET("Payment Terms Code");
                                    IF (("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                                        NOT RecPaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                                    THEN BEGIN
                                        VALIDATE("Due Date", "Document Date");
                                        VALIDATE("Pmt. Discount Date", 0D);
                                        VALIDATE("Payment Discount %", 0);
                                    END ELSE BEGIN
                                        "Due Date" := CALCDATE(RecPaymentTerms."Due Date Calculation", "Document Date");
                                        "Pmt. Discount Date" := CALCDATE(RecPaymentTerms."Discount Date Calculation", "Document Date");
                                        IF NOT UpdateDocumentDate THEN
                                            VALIDATE("Payment Discount %", RecPaymentTerms."Discount %")
                                    END;
                                END ELSE BEGIN
                                    VALIDATE("Due Date", "Document Date");
                                    IF NOT UpdateDocumentDate THEN BEGIN
                                        VALIDATE("Pmt. Discount Date", 0D);
                                        VALIDATE("Payment Discount %", 0);
                                    END;
                                END;
                            END;
                    END;
                END;
                //CCIT-SG

            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate();
            begin

                //CCIT-SG
                IF RecLoc.GET(Rec."Location Code") THEN
                    IF RecLoc."Quarantine Location" <> FALSE THEN
                        ERROR('Quarantine Location is TRUE');
                //CCIT-SG

            end;


        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG-23052018
                RecPL.RESET;
                RecPL.SETRANGE(RecPL."Document No.", Rec."No.");
                RecPL.SETRANGE(RecPL."Document Type", Rec."Document Type");
                IF RecPL.FINDSET THEN
                    REPEAT
                        RecPL."Sell-to Customer No." := Rec."Sell-to Customer No.";
                        RecPL.MODIFY;
                    UNTIL RecPL.NEXT = 0;
                //CCIT-SG-23052018


            end;

        }
        modify("Transport Method")
        {
            trigger OnAfterValidate()
            begin
                IF RecVend1.GET("Buy-from Vendor No.") THEN BEGIN
                    "Port of Destination-Air" := '';
                    "Port of Loading-Air" := '';
                    "Port of Destination-Ocean" := '';
                    "Port of Loading-Ocean" := '';
                    IF "Transport Method" = 'AIR' THEN BEGIN
                        "Port of Destination-Air" := RecVend1."Port of Destination-Air";
                        "Port of Loading-Air" := RecVend1."Port of Loading-Air";
                        "Port of Destination-Ocean" := '';
                        "Port of Loading-Ocean" := '';
                    END;
                    IF "Transport Method" = 'OCEAN' THEN BEGIN
                        "Port of Destination-Ocean" := RecVend1."Port of Destination-Ocean";
                        "Port of Loading-Ocean" := RecVend1."Port of Loading-Ocean";
                        "Port of Destination-Air" := '';
                        "Port of Loading-Air" := '';
                    END;
                END;
            end;
        }


        modify("Lead Time Calculation")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG
                IF ("Order Date" <> 0D) AND (FORMAT("Lead Time Calculation") <> '') THEN BEGIN
                    ShipDate := CALCDATE("Lead Time Calculation", "Order Date");
                    "Ship By Date" := ShipDate;
                END;

                IF (FORMAT("Lead Time Calculation") <> '') AND ("Order Date" <> 0D) THEN BEGIN
                    ETADescPort := CALCDATE("Lead Time Calculation", "Order Date");
                    VALIDATE("ETD - Supplier Warehouse", ETADescPort);
                END ELSE
                    IF (FORMAT("Lead Time Calculation") = '') AND ("Order Date" <> 0D) THEN BEGIN
                        VALIDATE("ETD - Supplier Warehouse", 0D);
                    END;
                //CCIT-SG


            end;
        }
        field(50002; "Port of Loading-Air"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Loading-Air";

            trigger OnValidate();
            begin


                RecPortOfDescAir.RESET;
                RecPortOfDescAir.SETRANGE(RecPortOfDescAir."Port Of Loading-Air", "Port of Loading-Air");
                IF RecPortOfDescAir.FINDFIRST THEN
                    "Port of Destination-Air" := RecPortOfDescAir.Code;
            end;
        }
        field(50003; "Port of Loading-Ocean"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Looading-Ocean";

            trigger OnValidate();
            begin


                RecPortOfDescOcean.RESET;
                RecPortOfDescOcean.SETRANGE(RecPortOfDescOcean."Port Of Looading-Ocean", "Port of Loading-Ocean");
                IF RecPortOfDescOcean.FINDFIRST THEN
                    "Port of Destination-Ocean" := RecPortOfDescOcean.Code;
            end;
        }
        field(50004; "Port of Destination-Air"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Destination-Air";
        }
        field(50005; "Port of Destination-Ocean"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Port Of Destination-Ocean";
        }
        field(50006; "Data Logger"; Code[10])
        {
            Description = 'CCIT';
        }
        field(50008; "JWL BOND GRN No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50009; "JWL BOND GRN Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50015; "Created User"; Code[30])
        {
            Description = 'CCIT';
        }
        field(50016; "Bill Of Lading Date"; Date)
        {
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                RecPaymentTerms.RESET;
                RecPaymentTerms.SETRANGE(RecPaymentTerms."Shipment Method", "Shipment Method Code");
                RecPaymentTerms.SETRANGE(RecPaymentTerms."Customer/Vendor No.", "Buy-from Vendor No.");
                IF RecPaymentTerms.FINDFIRST THEN BEGIN
                    "Payment Terms Code" := RecPaymentTerms.Code;

                    IF ("Bill Of Lading Date" <> 0D) THEN BEGIN
                        IF ("Payment Terms Code" <> '') AND ("Bill Of Lading Date" <> 0D) THEN BEGIN
                            //PaymentTerms.GET("Payment Terms Code");
                            IF (("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                                NOT RecPaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                            THEN BEGIN
                                VALIDATE("Due Date", "Bill Of Lading Date");
                                VALIDATE("Pmt. Discount Date", 0D);
                                VALIDATE("Payment Discount %", 0);
                            END ELSE BEGIN
                                "Due Date" := CALCDATE(RecPaymentTerms."Due Date Calculation", "Bill Of Lading Date");
                                "Pmt. Discount Date" := CALCDATE(RecPaymentTerms."Discount Date Calculation", "Bill Of Lading Date");
                                IF NOT UpdateDocumentDate THEN
                                    VALIDATE("Payment Discount %", RecPaymentTerms."Discount %")
                            END;
                        END ELSE BEGIN
                            VALIDATE("Due Date", "Bill Of Lading Date");
                            IF NOT UpdateDocumentDate THEN BEGIN
                                VALIDATE("Pmt. Discount Date", 0D);
                                VALIDATE("Payment Discount %", 0);
                            END;
                        END;
                    END ELSE
                        IF ("Bill Of Lading Date" = 0D) THEN BEGIN
                            //CCIT-SG
                            IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                //PaymentTerms.GET("Payment Terms Code");
                                IF (("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                                    NOT RecPaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                                THEN BEGIN
                                    VALIDATE("Due Date", "Document Date");
                                    VALIDATE("Pmt. Discount Date", 0D);
                                    VALIDATE("Payment Discount %", 0);
                                END ELSE BEGIN
                                    "Due Date" := CALCDATE(RecPaymentTerms."Due Date Calculation", "Document Date");
                                    "Pmt. Discount Date" := CALCDATE(RecPaymentTerms."Discount Date Calculation", "Document Date");
                                    IF NOT UpdateDocumentDate THEN
                                        VALIDATE("Payment Discount %", RecPaymentTerms."Discount %")
                                END;
                            END ELSE BEGIN
                                VALIDATE("Due Date", "Document Date");
                                IF NOT UpdateDocumentDate THEN BEGIN
                                    VALIDATE("Pmt. Discount Date", 0D);
                                    VALIDATE("Payment Discount %", 0);
                                END;
                            END;
                        END;
                END;
                //CCIT-SG
            end;
        }
        field(50017; "Short Closed"; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50018; "Bill Of Lading No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50019; "Container Filter"; Option)
        {
            Description = 'CCIT';
            OptionMembers = " ","20ft-CHILLED","20ft-FROZEN","20ft-DRY","40ft-CHILLED","40ft-FROZEN","40ft-DRY";
        }
        field(50021; "ETD - Supplier Warehouse"; Date)
        {
            Description = 'CCIT';
        }
        field(50022; "ETD - Origin Port"; Date)
        {
            Description = 'CCIT';
        }
        field(50023; "Container Number"; Code[30])
        {
            Description = 'CCIT';
        }
        field(50024; "Container Seal No."; Code[30])
        {
            Description = 'CCIT';
        }
        field(50025; "ETA - Destination Port"; Date)
        {
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //"ETA - Destination CFS" := "ETA - Destination Port" + 2;
                //"ETA - Bond" := "ETA - Destination CFS" + 2;
                "ETA - Availability for Sale" := "ETA - Destination Port" + 15;
            end;
        }
        field(50026; "ETA - Destination CFS"; Date)
        {
            Description = 'CCIT';
        }
        field(50027; "ETA - Bond"; Date)
        {
            Description = 'CCIT';
        }
        field(50028; "ETA - Availability for Sale"; Date)
        {
            Description = 'CCIT';
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master"."Permit No." WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(50035; "BL Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            // TableRelation = "Bond Master"."In-Bond Bill of Entry No.";

            trigger OnValidate();
            begin
                //CCIT-SG
                /*
                RecBondMaster.RESET;
                RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", "In-Bond Bill of Entry No.");
                IF RecBondMaster.FINDFIRST THEN BEGIN
                    //MESSAGE('%1',RecBondMaster."BL/AWB No.");
                    "Bill Of Lading No." := RecBondMaster."BL/AWB No.";
                    "Bill Of Lading Date" := RecBondMaster."BL Date";
                    "In-Bond BOE Date" := RecBondMaster."In-Bond BOE Date";
                    "Bond Number" := RecBondMaster."Bond Number";
                    "Bond Sr.No." := RecBondMaster."Bond Sr.No.";
                    "Bond Date" := RecBondMaster."Bond Date";
                    "ETA - Destination CFS" := RecBondMaster."Date Of Shipment Move. at CFS";
                    "ETA - Bond" := RecBondMaster."Date of Move. from CFS Bond";
                    "ETA - Destination Port" := RecBondMaster."Shipment Arrival at Port Date";
                    "Container Number" := RecBondMaster."Container No.";
                    "Container Seal No." := RecBondMaster."Seal No";
                    "Container Filter" := RecBondMaster."Container Type";
                    CHA := RecBondMaster.CHA;
                    "Transit Days" := RecBondMaster."Total Transit Day";
                    "Data Logger" := RecBondMaster."Data Logger";
                    "Vendor Invoice No." := RecBondMaster."Supplier Invoice No.";
                    //CCIT-20042021
                    "Bill of Entry No." := RecBondMaster."In-Bond Bill of Entry No.";
                    "Bill of Entry Date" := RecBondMaster."In-Bond BOE Date";
                    //"Bill of Entry Value" := RecBondMaster."In-Bond BOE Value";
                    //"Currency Code" := RecBondMaster."Currency Code";
                    // "Exchange Rate" := RecBondMaster."Exchange Rate";
                    //CCIT-20042021
                END;
                //CCIT-SG
                */
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
        field(50041; "BL/AWB No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50042; "Order Processing Time"; Code[10])
        {
            Description = 'CCIT';
        }
        field(50043; "Transit Days"; Integer)
        {
            Description = 'CCIT';
        }
        field(50044; "Freight Forwarder"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50045; CHA; Text[50])
        {
            Description = 'CCIT';
        }
        field(50046; "Ship By Date"; Date)
        {
            Description = 'CCIT';
            NotBlank = false;
        }
        field(50047; "Shipping Line"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50048; PutAwayCreated; Boolean)
        {
            Description = 'CCIT';
        }
        field(50051; "Partial Payment Terms"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Partial Payment Terms".Code;

            trigger OnValidate();
            begin
                //CCIT-SG
                IF ("Document Date" <> 0D) AND ("Partial Payment Terms" <> '') THEN BEGIN
                    RecPartialPaymentTerms.RESET;
                    RecPartialPaymentTerms.SETRANGE(RecPartialPaymentTerms.Code, "Partial Payment Terms");
                    IF RecPartialPaymentTerms.FINDSET THEN
                        REPEAT
                            IF RecPartialPaymentTerms.Type = RecPartialPaymentTerms.Type::Advanced THEN BEGIN
                                "Due Date" := CALCDATE(RecPartialPaymentTerms."Due Date Calculation", "Document Date");
                            END ELSE
                                IF RecPartialPaymentTerms.Type = RecPartialPaymentTerms.Type::Invoiced THEN BEGIN
                                    "Due Date" := CALCDATE(RecPartialPaymentTerms."Due Date Calculation", "Posting Date");
                                END ELSE
                                    IF RecPartialPaymentTerms.Type = RecPartialPaymentTerms.Type::Shipment THEN BEGIN
                                        "Due Date" := CALCDATE(RecPartialPaymentTerms."Due Date Calculation", "Posting Date");
                                    END;

                        UNTIL RecPartialPaymentTerms.NEXT = 0;
                END;
                //CCIT-SG
            end;
        }
        field(50052; "Vendor Invoiced Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50053; "FSSAI ICA No."; Code[20])
        {
        }
        field(50054; "FSSAI Report Date"; Date)
        {
        }
        field(50055; "Outstanding Quantity In KG"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50056; "Outstanding Quantity In PCS"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity In KG" WHERE("Document Type" = FIELD("Document Type"),
                                                                                  "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
            FieldClass = FlowField;
        }
        field(50057; "Payment Terms Description"; Text[200])
        {
            Description = 'CCIT';
        }
        field(50060; "Short Closed Reason Code"; Option)
        {
            Description = 'CCIT';
            OptionCaption = '" ,Weight Loss,Short Received,FSSAI Samples from stocks,Inv / Phy – Same,Wrong PO,Duplicate PO,Old PO Data,Order Cancelled "';
            OptionMembers = " ","Weight Loss","Short Received","FSSAI Samples from stocks","Inv / Phy – Same","Wrong PO","Duplicate PO","Old PO Data","Order Cancelled";
        }
        field(50061; "Short Closed Date"; Date)
        {
            Description = 'CCIT-TK-121219';
        }
        field(50062; "TDS Amount"; Decimal)
        {
            // CalcFormula = Sum("Purchase Line"."TDS Amount" WHERE("Document No." = FIELD("No.")));
            // FieldClass = FlowField;
           

        }
        field(50063; "GST Amount"; Decimal)
        {
            // CalcFormula = Sum("Purchase Line"."Total GST Amount" WHERE("Document No." = FIELD("No.")));
            // FieldClass = FlowField;
        }
        field(50114; "Exchange Rate"; Decimal)
        {
            Description = 'CCIT';
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
      ERROR(
        Text023,
    #4..59
       (PurchCrMemoHeaderPrepmt."No." <> '')
    THEN
      MESSAGE(PostedDocsToPrintCreatedMsg);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..62

    */
    //end;


    trigger OnInsert();
    begin

        //CCIT-SG
        IF UserSetup.GET(USERID) THEN BEGIN
            "Created User" := UserSetup."User ID";
        END;
        //CCIT-SG

    end;



    var
        RecVend: Record 23;
        CustomDutyMaster: Record 50014;
        //StructureOrderDetails : Record 13794;
        Text053: TextConst ENU = 'There are unposted prepayment amounts on the document of type %1 with the number %2.', ENN = 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        VendorISDErr: TextConst Comment = '%1 = Location Code, %2 = GST Vendor Type, %3 = GST Vendor Type, %4 = GST Vendor Type', ENU = 'You cannot select Input Service Distribution Location %1 for Vendor Types %2, %3, %4.', ENN = 'You cannot select Input Service Distribution Location %1 for Vendor Types %2, %3, %4.';
        recNoSeries: Record 308;
        RecBondMaster: Record 50022;
        RecPaymentTerms: Record 3;
        ETADescPort: Date;
        ETAOriginPort: Date;
        RecLoc: Record 14;
        ShipDate: Date;
        RecVend1: Record 23;
        UserSetup: Record 91;
        RecPortOfDescOcean: Record 50019;
        RecPortOfDescAir: Record 50018;
        RecPartialPaymentTerms: Record 50027;
        RecPL: Record "Purchase Line";
        RecPaymentTerm: Record 3;
        PurchSetup: record 312;
        UpdateDocumentDate: Boolean;
}

