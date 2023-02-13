tableextension 50244 "Sales_header_ext" extends "Sales Header"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992,CCIT-Fortune

    fields
    {


        // modify("Invoice Type")
        // {
        //     OptionCaptionML = ENU = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST', ENN = 'Taxable,Bill of Supply,Export,Supplementary,Debit Note,Non-GST';


        // }


        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate();
            begin
                //CCIT-JAGA
                IF RecCust.GET("Sell-to Customer No.") THEN BEGIN
                    "Route Days Applicable" := RecCust."Route Days Applicable";
                    Sunday := RecCust.Sunday;
                    Monday := RecCust.Monday;
                    Tuesday := RecCust.Tuesday;
                    Wednesday := RecCust.Wednesday;
                    Thursday := RecCust.Thursday;
                    Friday := RecCust.Friday;
                    Saturday := RecCust.Saturday;
                END;

                //CCIT-JAGA
                /*
                //CCIT-SG
                {IF RecCust.GET("Sell-to Customer No.") THEN
                  IF NOT (RecCust."Sales Return Allowed" = TRUE) AND ((Rec."Document Type" = Rec."Document Type"::"Return Order") OR (Rec."Document Type" = Rec."Document Type"::"Credit Memo"))THEN
                    ERROR('Sales Return Order Not Allowed');}
                //CCIT-SG
                */

                //>> CS
                "Minimum Shelf Life %" := Cust."Minimum Shelf Life %";
                //<< CS

                //CCIT-SG
                "Vertical Category" := Cust."Vertical Category";
                "Vertical Sub Category" := Cust."Vertical Sub Category";
                "Outlet Area" := Cust."Outlet Area";
                "Business Format / Outlet Name" := Cust."Business Format / Outlet Name";
                //CCIT-SG
                //CCIT-Vikas
                "P.A.N No." := Cust."P.A.N. No.";
                IF "P.A.N No." <> '' THEN BEGIN
                    SalesAmt := 0;
                    TCSEntry.RESET();
                    //TCSEntry.SETRANGE("Party P.A.N. No.", "P.A.N No.");// PCPL/MIG/NSW Field Party PAN not exist in BC
                    IF TCSEntry.FIND('-') THEN
                        REPEAT
                            SalesAmt := SalesAmt + TCSEntry."TCS Amount";////TCSEntry."Sales Amount"; PCPL/MIG/NSW Sales Amount not exist in BC

                        UNTIL TCSEntry.NEXT = 0;
                END;
                "Sales Value" := SalesAmt;
                //CCIT-Vikas

                //CCIT-TK
                "Free Sample" := Cust."Free Sample";


                //CCIT-JAGA
                SalesSetup.GET;
                recNoSeries.RESET;
                recNoSeries.SETRANGE(recNoSeries.Type, recNoSeries.Type::Customer);
                recNoSeries.SETRANGE(recNoSeries."Customer/Vendor", "Sell-to Customer No.");
                recNoSeries.SETFILTER(recNoSeries.Code, '%1', SalesSetup."Posted Shipment Nos." + '*');
                IF recNoSeries.FINDLAST THEN
                    "Shipping No. Series" := recNoSeries.Code;
                //"Posting No. Series" := recNoSeries.Code;
                //CCIT-JAGA

                //CCIT-JAGA
                recNoSeries.RESET;
                recNoSeries.SETRANGE(recNoSeries.Type, recNoSeries.Type::Customer);
                recNoSeries.SETRANGE(recNoSeries."Customer/Vendor", "Sell-to Customer No.");
                recNoSeries.SETFILTER(recNoSeries.Code, '%1', SalesSetup."Posted Invoice Nos." + '*');
                IF recNoSeries.FINDLAST THEN
                    "Posting No. Series" := recNoSeries.Code;

                //CCIT-JAGA

                //CCIT-JAGA 02/11/2018
                IF RecCustomer.GET("Sell-to Customer No.") THEN BEGIN
                    LocatioCode := RecCustomer."Location Code";
                    IF RecLocation.GET(LocatioCode) THEN
                        Rec.VALIDATE("Shortcut Dimension 1 Code", RecLocation."Branch Code");
                END;
                //CCIT-JAGA 02/11/2018

                "SO Creation Time" := TIME;//CCIT-SG-17052019


            end;
            // //<<PCPL/NSW/17March2022
            // trigger OnAfterValidate()
            // var
            //     Noseries: Record 308;
            // begin
            //     IF Noseries.Get("No. Series") then begin
            //         "Location Code" := Noseries."Location Code";
            //         "Posting No. Series" := Noseries."Posting No. Series";
            //     ENd;
            // end;
            // //>>PCPL/NSW/17March2022

        }
        //Unsupported feature: CodeModification on ""Posting Date"(Field 20).OnValidate". Please convert manually.

        modify("Posting Date")
        {
            trigger OnBeforeValidate();
            begin
                IF "Posting Date" > CALCDATE('<2D>', TODAY) THEN
                    ERROR('You cannot change the posting date..');

            end;
        }

        modify("Shipment Method Code")
        {
            trigger OnAfterValidate();
            begin
                //CCIT-SG
                RecPaymentTerms.RESET;
                RecPaymentTerms.SETRANGE(RecPaymentTerms."Shipment Method", "Shipment Method Code");
                RecPaymentTerms.SETRANGE(RecPaymentTerms."Customer/Vendor No.", "Sell-to Customer No.");
                IF RecPaymentTerms.FINDFIRST THEN BEGIN
                    "Payment Terms Code" := RecPaymentTerms.Code;
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
                //CCIT-SG

            end;
        }


        //Unsupported feature: CodeModification on ""Location Code"(Field 28).OnValidate". Please convert manually.
        modify("Location Code")
        {
            trigger OnAfterValidate();
            begin
                /*
                TESTFIELD(Status,Status::Open);

                #2..30
                "Location State Code" := Location."State Code";

                //CCIT-SG
                {IF "Location Code" <> '' THEN BEGIN
                  RecLoc.GET("Location Code");
                  RecCust1.GET("Sell-to Customer No.");
                 IF (RecLoc."BOND Dispatch"=TRUE) OR (RecCust1."BOND Dispatch"=TRUE) OR (RecCust1."Duty Free" = TRUE) THEN BEGIN
                      IF RecLoc."BOND Dispatch" = FALSE THEN
                        ERROR('BOND Dispatch is false for Location %1',"Location Code");
                      IF RecCust1."BOND Dispatch" = FALSE THEN
                         ERROR('BOND Dispatch is false for Customer %1',"Sell-to Customer No.");
                      IF RecCust1."Duty Free" = FALSE THEN
                         ERROR('Duty Free is false for Customer %1',"Sell-to Customer No.");

                  END;
                END;}*/
                //CCIT-SG

                //CCIT-JAGA 06-06-2018
                RecLoc.RESET;
                IF RecLoc.GET("Location Code") THEN BEGIN
                    "Posting No. Series" := '';//RecLoc."Sales Invoice Nos."; Field Not exist in Location table BC
                    "Shipping No. Series" := '';//RecLoc."Sales Shipment Nos."; Field Not exist in Location table BC
                END;

                IF "Location Code" = '' THEN BEGIN
                    "Posting No. Series" := '';
                    "Shipping No. Series" := '';
                END;
                //CCIT-JAGA 06-06-2018
            end;

            // trigger OnBeforeValidate()
            // begin
            //     IF RecLoc.Get("Location Code") then begin
            //         "Posting No. Series" := RecLoc."Posting No. Series";
            //         Message('Posting No Series Update from Location card %1', "Posting No. Series");
            //     end;
            // end;


        }







        // field(16630; "Ship-to Customer"; Code[20]) //PCPL/MIG/NSW Field Exist in BC 18 
        // {
        //     CaptionML = ENU = 'Ship-to Customer',
        //                 ENN = 'Ship-to Customer';
        //     DataClassification = ToBeClassified;
        //     TableRelation = IF ("GST Customer Type" = CONST(Export)) "Customer.No." WHERE("GST Customer Type" = CONST(Registered));

        //     trigger OnValidate();
        //     begin
        //         /*TESTFIELD(Status,Status::Open);
        //         CheckShipToCustomer;
        //         IF NOT GSTManagement.IsGSTApplicable(Structure) THEN
        //           ERROR(GSTTypeStructErr);
        //         GetCust("Ship-to Customer");
        //         IF "Ship-to Customer" <> '' THEN BEGIN
        //           TESTFIELD("GST Customer Type","GST Customer Type"::Export);
        //           "Ship-to Code" := '';
        //           GetCust("Ship-to Customer");
        //         END ELSE
        //           IF "Ship-to Code" <> '' THEN
        //             VALIDATE("Ship-to Code");
        //         // BUG 121842 +
        //         // PA052383 +
        //         TESTFIELD("POS Out Of India",FALSE);
        //         TESTFIELD("Applies-to Doc. Type","Applies-to Doc. Type"::" ");
        //         TESTFIELD("Applies-to Doc. No.",'');
        //         ReferenceInvoiceNoValidation;
        //         // BUG 121842 -
        //         IF "Ship-to Customer" <> '' THEN BEGIN
        //           Cust.TESTFIELD("GST Customer Type",Cust."GST Customer Type"::Registered); // PA052383
        //           "Ship-to Name" := Cust.Name;
        //           "Ship-to Name 2" := Cust."Name 2";
        //           "Ship-to Address" := Cust.Address;
        //           "Ship-to Address 2" := Cust."Address 2";
        //           "Ship-to City" := Cust.City;
        //           "GST Ship-to State Code" := Cust."State Code";
        //           "Ship-to Contact" := Cust.Contact;
        //           "Ship-to Post Code" := Cust."Post Code";
        //           "Ship-to County" := Cust.County;
        //           "Ship-to Country/Region Code" := Cust."Country/Region Code";
        //           "Ship-to GST Reg. No." := Cust."GST Registration No.";
        //           IF "Ship-to Customer" <> '' THEN
        //             Cust.TESTFIELD("GST Customer Type");
        //           "Ship-to GST Customer Type" := Cust."GST Customer Type";

        //           GSTManagement.UpdateInvoiceType(Rec);
        //         END;
        //         // BUG 121842 +
        //         */

        //     end;
        // }
        field(50005; "Route Days Applicable"; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50006; Sunday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50007; Monday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50008; Tuesday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50009; Wednesday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50010; Thursday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50011; Friday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50012; Saturday; Boolean)
        {
            Description = 'CCIT-JAGA';
        }
        field(50013; "Post Batch Selection"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50014; "Short Closed"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50015; "Created User"; Code[30])
        {
            Description = 'CCIT';
        }
        field(50021; "Vertical Category"; Code[50])
        {
            Description = 'CCIT-SG';
            TableRelation = "Vertical Category";
        }
        field(50022; "Vertical Sub Category"; Code[50])
        {
            Description = 'CCIT-SG';
            TableRelation = "Vertical Sub Category".Code WHERE("Vertical Category Code" = FIELD("Vertical Category"));
        }
        field(50023; "Outlet Area"; Text[30])
        {
            Description = 'CCIT-SG';
        }
        field(50025; "Business Format / Outlet Name"; Text[100])
        {
        }
        field(50029; "License No."; Code[25])
        {
            Description = 'CCIT';
            TableRelation = "License Master"."Permit No." WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(50030; PutAwayCreated; Boolean)
        {
            Description = 'CCIT';
        }
        field(50035; "BL Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50036; "In-Bond Bill of Entry No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Bond Master"."In-Bond Bill of Entry No.";

            trigger OnValidate();
            begin
                //CCIT-SG
                RecBondMaster.RESET;
                RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", "In-Bond Bill of Entry No.");
                IF RecBondMaster.FINDFIRST THEN BEGIN
                    "BL/AWB No." := RecBondMaster."BL/AWB No.";
                    "BL Date" := RecBondMaster."BL Date";
                    "In-Bond BOE Date" := RecBondMaster."In-Bond BOE Date";
                    "Bond Number" := RecBondMaster."Bond Number";
                    "Bond Sr.No." := RecBondMaster."Bond Sr.No.";
                    "Bond Date" := RecBondMaster."Bond Date";
                    "Ex-bond BOE No." := RecBondMaster."Ex-bond BOE No.";
                    "Ex-bond BOE Date" := RecBondMaster."Ex-bond BOE Date";
                    "Ex-bond BOE No.1" := RecBondMaster."Ex-bond BOE No.1";
                    "Ex-bond BOE Date 1" := RecBondMaster."Ex-bond BOE Date 1";
                    "Ex-bond BOE No.2" := RecBondMaster."Ex-bond BOE No.2";
                    "Ex-bond BOE Date 2" := RecBondMaster."Ex-bond BOE Date 2";
                    "Ex-bond BOE No.3" := RecBondMaster."Ex-bond BOE No.3";
                    "Ex-bond BOE Date 3" := RecBondMaster."Ex-bond BOE Date 3";
                    "Ex-bond BOE No.4" := RecBondMaster."Ex-bond BOE No.4";
                    "Ex-bond BOE Date 4" := RecBondMaster."Ex-bond BOE Date 4";
                    "Ex-bond BOE No.5" := RecBondMaster."Ex-bond BOE No.5";
                    "Ex-bond BOE Date 5" := RecBondMaster."Ex-bond BOE Date 5";
                    "Ex-bond BOE No.6" := RecBondMaster."Ex-bond BOE No.6";
                    "Ex-bond BOE Date 6" := RecBondMaster."Ex-bond BOE Date 6";
                    "Ex-bond BOE No.7" := RecBondMaster."Ex-bond BOE No.7";
                    "Ex-bond BOE Date 7" := RecBondMaster."Ex-bond BOE Date 7";
                    "Ex-bond BOE No.8" := RecBondMaster."Ex-bond BOE No.8";
                    "Ex-bond BOE Date 8" := RecBondMaster."Ex-bond BOE Date 8";
                    "Ex-bond BOE No.9" := RecBondMaster."Ex-bond BOE No.9";
                    "Ex-bond BOE Date 9" := RecBondMaster."Ex-bond BOE Date 9";
                END;
                //CCIT-SG
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
        field(50042; "Ex-bond BOE No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50043; "Ex-bond BOE Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50044; "Ex-bond BOE No.1"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50045; "Ex-bond BOE Date 1"; Date)
        {
            Description = 'CCIT';
        }
        field(50046; "Ex-bond BOE No.2"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50047; "Ex-bond BOE Date 2"; Date)
        {
            Description = 'CCIT';
        }
        field(50048; "Ex-bond BOE No.3"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50049; "Ex-bond BOE Date 3"; Date)
        {
            Description = 'CCIT';
        }
        field(50050; "Ex-bond BOE No.4"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50051; "Ex-bond BOE Date 4"; Date)
        {
            Description = 'CCIT';
        }
        field(50052; "Ex-bond BOE No.5"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50053; "Ex-bond BOE Date 5"; Date)
        {
            Description = 'CCIT';
        }
        field(50054; "Ex-bond BOE No.6"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50055; "Ex-bond BOE Date 6"; Date)
        {
            Description = 'CCIT';
        }
        field(50056; "Ex-bond BOE No.7"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50057; "Ex-bond BOE Date 7"; Date)
        {
            Description = 'CCIT';
        }
        field(50058; "Ex-bond BOE No.8"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50059; "Ex-bond BOE Date 8"; Date)
        {
            Description = 'CCIT';
        }
        field(50060; "Ex-bond BOE No.9"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50061; "Ex-bond BOE Date 9"; Date)
        {
            Description = 'CCIT';
        }
        // field(50062;"E-Way Bill No.";Code[20]) //PCPL/MIG/NSW This Field Already Exist in BC 180
        // {
        //     Description = 'CCIT';
        // }
        field(50063; "E-Way Bill Date"; Date)
        {
            Description = 'CCIT';
        }
        field(50064; "Seal No."; Code[20])
        {
            Description = 'CCIT';
        }
        field(50065; "Customer Type"; Option)
        {
            OptionCaption = '" ,New,Existing"';
            OptionMembers = " ",New,Existing;
        }
        field(50066; "Sample For"; Option)
        {
            OptionCaption = '" ,Chef, Purchase Manager,Category Manager,Individual,Trade Events,Sponsorship,FSSAI/AQ/PQ"';
            OptionMembers = " ",Chef," Purchase Manager","Category Manager",Individual,"Trade Events",Sponsorship,"FSSAI/AQ/PQ";
        }
        field(50067; "Outstanding Quantity KG"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
        }
        field(50068; "Outstanding Quantity PCS"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity In KG" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("No.")));
            DecimalPlaces = 0 : 3;
            FieldClass = FlowField;
        }
        field(50069; "SO Creation Time"; Time)
        {
            Description = 'CCIT';
        }
        field(50075; "P.A.N No."; Code[10])
        {
            Editable = false;
        }
        field(50076; "Sales Value"; Decimal)
        {
            Editable = false;
        }
        field(50114; "Transport Vendor"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50115; "Last Date And Time"; DateTime)
        {
            Description = 'CCIT';
        }
        field(50116; "Calculate IGST"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50117; "ShortClose Reason Code"; Option)
        {
            OptionCaption = '" ,No Inventory,Weight Short,Wrong UOM,Wrong Order,Duplicate Order,Credit Issue, Order Test,AS per sales,As per customer request,Low Shelf Life,ERP Error"';
            OptionMembers = " ","No Inventory","Weight Short","Wrong UOM","Wrong Order","Duplicate Order","Credit Issue"," Order Test","AS per sales","As per customer request","Low Shelf Life","ERP Error";
        }
        field(50120; "Tally Invoice No."; Code[30])
        {
            Description = 'CCIT-JAGA 29/10/2018';
        }
        field(50121; "Bulk Order"; Boolean)
        {
            Description = 'RDK 120819';
        }
        field(50122; "Customer GRN/RTV No."; Code[30])
        {
            Description = '//ccit';
        }
        field(50123; "GRN/RTV Date"; Date)
        {
            Description = '//ccit';
        }
        field(50124; "PAY REF DATE"; Date)
        {
            Description = '//CCIT_TK130521';
        }
        field(70000; "Minimum Shelf Life %"; Decimal)
        {
            Description = 'SC';
        }
        field(500122; "Free Sample"; Boolean)
        {
            Description = 'CCIT-TK-121219';
        }
        field(50155; "Amount To Customer"; Decimal)
        {
            Description = 'PCPL-NSW-07 18Oct22';
        }
    }
    keys
    {
        key(KeyExt1; "Document Date")
        {
        }
    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF DOPaymentTransLogEntry.FINDFIRST THEN
      DOPaymentTransLogMgt.ValidateCanDeleteDocument("Payment Method Code","Document Type",FORMAT("Document Type"),"No.");

    #4..65
       (SalesCrMemoHeaderPrepmt."No." <> '')
    THEN
      MESSAGE(PostedDocsToPrintCreatedMsg);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..68

    */
    //end;

    trigger OnInsert();
    begin

        //CCIT-SG-30052018
        IF UserSetup.GET(UserId) THEN BEGIN
            "Created User" := UserSetup."User ID";
        END;




    end;


    //Unsupported feature: CodeInsertion on "OnModify". Please convert manually.

    // trigger OnModify();
    // begin
    //     {
    //     //CCIT-SG
    //     /*
    //     RecLoc.RESET;
    //     IF RecLoc.GET("Location Code") THEN BEGIN
    //        IF NOT (RecLoc."BOND Dispatch" = TRUE) THEN
    //           RecCust1.RESET;
    //           IF RecCust1.GET("Sell-to Customer No.") THEN
    //              IF NOT (RecCust1."BOND Dispatch" = TRUE) THEN
    //                 ERROR('BOND Dispatch false');
    //     END;
    //     */
    //     //CCIT-SG
    //     }

    // end;

    //Unsupported feature: PropertyChange. Please convert manually.


    var
        TCSEntry: Record "TCS Entry";

    var
        Text071: TextConst ENU = 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.', ENN = 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';

    var
        RecCust: Record 18;
        recNoSeries: Record 308;
        RecBondMaster: Record 50022;
        RecLoc: Record 14;
        RecCust1: Record 18;
        RecPaymentTerms: Record 3;
        RecCust2: Record 18;
        UserSetup: Record 91;
        CustBal: Decimal;
        CustCreditLimit: Decimal;
        RecLocation: Record 14;
        RecCustomer: Record 18;
        LocatioCode: Code[10];
        SalesAmt: Decimal;
        Cust: Record 18;
        SalesSetup: Record 311;
        UpdateDocumentDate: Boolean;
        RecUser: Record User;

}

