pageextension 50016 "Sales_Order_ext" extends "Sales Order"
{
    // version NAVW19.00.00.48316,NAVIN9.00.00.48316,CCIT-Fortune


    layout
    {
        modify("Sell-to Customer No.")
        {
            ApplicationArea = all;
            trigger OnAfterValidate()
            var
                Customer1: Record customer;
            begin
                EditableField := False;
                Customer1.get("Sell-to Customer No.");
                if Customer1."Editable Sales Order" then begin
                    Clear(Rec."Sell-to Customer Name 2");
                    Clear(Rec."Sell-to Address");
                    Clear(Rec."Sell-to Address 2");
                    EditableField := true;
                end;
                Customer1.Get(Rec."Sell-to Customer No.");
            end;
        }
        modify("Sell-to Address")
        {
            Editable = EditableField;
            ApplicationArea = All;
        }

        modify("Sell-to Address 2")
        {
            Editable = EditableField;
            ApplicationArea = All;
        }

        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = all;
                //Editable = true;
                Editable = EditableField;
            }
        }
        addafter(Status)
        {
            field("Amount To Customer"; "Amount To Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Sell-to Contact")
        {
            field("SO Creation Time"; "SO Creation Time")
            {

                Editable = false;
                ApplicationArea = all;

            }
            field("Customer Posting Group"; "Customer Posting Group")
            {

            }
            field("Created User"; "Created User")
            {
                Editable = false;
            }
        }
        addafter("Created User")
        {
            field("Sales Person Name"; SalesPersonName)
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Bulk Order"; "Bulk Order")
            {
                ApplicationArea = all;
            }
            field("Last Date And Time"; "Last Date And Time")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vertical Sub Category"; "Vertical Sub Category")
            {
                ApplicationArea = all;
            }
            field("Business Format / Outlet Name"; "Business Format / Outlet Name")
            {
                ApplicationArea = all;
            }
            field("<PAY REF>"; "Your Reference")
            {
                CaptionML = ENU = '<PAY REF>',
                            ENN = 'Your Reference';
                ApplicationArea = all;
            }
            field("PAY REF DATE"; "PAY REF DATE")
            {
                ApplicationArea = all;
            }
            field("Outlet Area"; "Outlet Area")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shipment Date")
        {

            field("Customer Type"; "Customer Type")
            {
                ApplicationArea = all;
            }
            field("Sample For"; "Sample For")
            {
                ApplicationArea = all;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                Enabled = true;
                ApplicationArea = all;
            }
            field("Shipping No. Series"; "Shipping No. Series")
            {
                Editable = false;
                ApplicationArea = all;
                Enabled = false;
            }
            field("Free Sample"; "Free Sample")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {

            field("Vertical Category"; "Vertical Category")
            {
                ApplicationArea = all;
            }
        }
        addafter("Assigned User ID")
        {
            field("Post Batch Selection"; "Post Batch Selection")
            {
                ApplicationArea = all;
            }
            field("License No."; "License No.")
            {
                ApplicationArea = all;
            }
            field("Minimum Shelf Life %"; "Minimum Shelf Life %")
            {
                ApplicationArea = all;
            }
            field("Short Closed"; "Short Closed")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("ShortClose Reason Code"; "ShortClose Reason Code")
            {
                ApplicationArea = all;
            }
            field("Calculate IGST"; "Calculate IGST")
            {
                ApplicationArea = all;
                Visible = IGSTBoolean;
            }
            field("P.A.N No."; "P.A.N No.")
            {
                ApplicationArea = all;
            }
            field("Sales Value"; "Sales Value")
            {
                ApplicationArea = all;
            }
        }
        addafter(General)
        {
            group("Route Days")
            {
                field("Route Days Applicable"; "Route Days Applicable")
                {
                    ApplicationArea = all;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = all;
                }
                field(Monday; Monday)
                {
                    ApplicationArea = all;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = all;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = all;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = all;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = all;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = all;
                }
            }
            group("Bond Details")
            {
                field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = all;
                }
                field("In-Bond BOE Date"; "In-Bond BOE Date")
                {
                    ApplicationArea = all;
                }
                field("BL/AWB No."; "BL/AWB No.")
                {
                    ApplicationArea = all;
                }
                field("BL Date"; "BL Date")
                {
                    ApplicationArea = all;
                }
                field("Bond Number"; "Bond Number")
                {
                    ApplicationArea = all;
                }
                field("Bond Sr.No."; "Bond Sr.No.")
                {
                    ApplicationArea = all;
                }
                field("Bond Date"; "Bond Date")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No."; "Ex-bond BOE No.")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date"; "Ex-bond BOE Date")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.1"; "Ex-bond BOE No.1")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 1"; "Ex-bond BOE Date 1")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.2"; "Ex-bond BOE No.2")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 2"; "Ex-bond BOE Date 2")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.3"; "Ex-bond BOE No.3")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 3"; "Ex-bond BOE Date 3")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.4"; "Ex-bond BOE No.4")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 4"; "Ex-bond BOE Date 4")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.5"; "Ex-bond BOE No.5")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 5"; "Ex-bond BOE Date 5")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.6"; "Ex-bond BOE No.6")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 6"; "Ex-bond BOE Date 6")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.7"; "Ex-bond BOE No.7")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 7"; "Ex-bond BOE Date 7")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.8"; "Ex-bond BOE No.8")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 8"; "Ex-bond BOE Date 8")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE No.9"; "Ex-bond BOE No.9")
                {
                    ApplicationArea = all;
                }
                field("Ex-bond BOE Date 9"; "Ex-bond BOE Date 9")
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("Bill-to Name")
        {
            field("Bill-to Name 2"; "Bill-to Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("LR/RR Date")
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
        }
        addafter("Bill Of Export No.")
        {
            field("Shipping No."; "Shipping No.")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        modify("In&vt. Put-away/Pick Lines")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-SG-21022018
                RecWAH.RESET;
                RecWAH.SETRANGE(RecWAH."Source No.", Rec."No.");
                RecWAH.SETFILTER(RecWAH."Source Document", '%1', RecWAH."Source Document"::"Sales Order");
                IF NOT "Short Closed" THEN
                    PAGE.RUNMODAL(PAGE::"Warehouse Activity List", RecWAH)
                ELSE
                    ERROR('You can not open this Pick List because This Sales Order Already Short Closed..');
                //CCIT-SG-21022018

            end;
        }
        modify("Print Confirmation")
        {
            Visible = false;
        }

        modify(Release)
        {
            trigger OnAfterAction()
            var
                Cust_Dee: Record 18;
            begin
                // GetGSTAmountTotal(Rec, TotalGSTAmount1);
                // GetTCSAmountTotal(Rec, TotalTCSAmt);
                // GetPostedSalesInvStatisticsAmount(Rec, TotalAmt);
                // rec."Amount To Customer" := TotalAmt + TotalGSTAmount1 + TotalTCSAmt;
                // Modify();
                // //PCPL-0070 <<
                // Cust_Dee.Get(Rec."Sell-to Customer No.");
                // AvailableCreditLimit := Cust_Dee.CalcAvailableCredit();
                // if rec."Amount To Customer" > AvailableCreditLimit then
                //     Error('%1 Credit Limit is over of this customer', Rec."Sell-to Customer No.");
                // //PCPL-0070>>
            end;

            trigger OnBeforeAction()
            var
                RecLocation: Record 14;
                Customer1: record 18;
                SalesLine: Record 37;
                Cust_Dee: Record 18;
                TotalAmtToCus: Decimal;
                SH: Record "Sales Header";
                AvaiCreLim: Decimal;
            begin
                GetGSTAmountTotal(Rec, TotalGSTAmount1);
                GetTCSAmountTotal(Rec, TotalTCSAmt);
                GetPostedSalesInvStatisticsAmount(Rec, TotalAmt);
                rec."Amount To Customer" := TotalAmt + TotalGSTAmount1 + TotalTCSAmt;
                Modify();
                SalesSetup.GET;
                IF "Document Type" = "Document Type"::Order THEN
                    //TESTFIELD(Structure); //ccit
                IF "External Document No." = '' THEN
                        ERROR('Customer PO No. should not blank');
                IF "Order Date" = 0D THEN
                    ERROR('Customer PO Date Should not blank on Sales Header.');
                IF "Promised Delivery Date" = 0D THEN
                    ERROR('CRDD/PO Exp. Date not blank on Sales Header');
                //CCIT-SG-21062018

                //<<PCPL/MIG/NSW 25May22
                IF Customer1.GET("Sell-to Customer No.") then begin
                    IF Customer1."TCS 206 CAA Applicable" = Customer1."TCS 206 CAA Applicable"::Comply then begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document No.", "No.");
                        IF SalesLine.FindSet() then
                            repeat
                                SalesLine.TestField("TCS Nature of Collection");
                                SalesLine.TestField("Unit Price");
                            until SalesLine.Next = 0;
                    end;
                end;
                //>>PCPL/MIG/NSW 25May22


                //CCIT-SG-120918
                //<<PCPL/MIG/NSW
                saleHeaderN.Reset();
                saleHeaderN.SetRange("No.", "No.");
                saleHeaderN.SetRange("Document Type", "Document Type"::Order);
                IF saleHeaderN.FindFirst() then;
                //>>PCPL/MIG/NSW
                IF RecCust1.GET("Sell-to Customer No.") THEN BEGIN
                    RecCust1.CALCFIELDS(Balance);
                    //Rec.CALCFIELDS("Amount to Customer"); //PCPL/MIG/NSW
                    CustBal := RecCust1.Balance;
                    CustCreditLimit := RecCust1."Credit Limit (LCY)";
                    IF CustBal > CustCreditLimit THEN
                        ERROR('Customer Exceed Credit Limit');
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    //IF (Rec."Amount to Customer" > (CustCreditLimit - CustBal)) THEN PCPL/MIG/NSW
                    IF (/*AmountToCust*/ rec."Amount To Customer" > (CustCreditLimit - CustBal)) THEN
                        ERROR('Customer Exceed Credit Limit');
                END;

                //PCPL-0070 <<

                Cust_Dee.Get(Rec."Sell-to Customer No.");
                AvailableCreditLimit := Cust_Dee.CalcAvailableCredit() + TotalAmt;
                if rec."Amount To Customer" > AvailableCreditLimit then
                    Error('%1 Credit Limit is over of this customer', Rec."Sell-to Customer No.");

                //PCPL-0070>>
                /*
                Cust_Dee.Get(Rec."Sell-to Customer No.");
                SH.Reset;
                SH.SetRange("Sell-to Customer No.", Cust_Dee."No.");
                SH.SetRange(Status, SH.Status::Released);
                if SH.FindSet() then
                    repeat
                        TotalAmtToCus += SH."Amount To Customer";
                    until SH.Next() = 0;

                AvaiCreLim := Cust_Dee.CalcAvailableCredit() - TotalAmtToCus;

                if Rec."Amount To Customer" > AvaiCreLim then
                    Error('%1 Credit Limit is over of this customer', Rec."Sell-to Customer No.")
                    */
            end;
        }

        modify("Create Inventor&y Put-away/Pick")
        {
            trigger OnBeforeAction()
            begin
                TESTFIELD("Shortcut Dimension 1 Code");//CCIT-SG-12062018
                RecSL.RESET;
                RecSL.SETRANGE(RecSL."Document No.", Rec."No.");
                IF RecSL.FINDSET THEN
                    REPEAT
                        RecSL.TESTFIELD(RecSL."Unit Price");
                    UNTIL RecSL.NEXT = 0;
                //CCIT-SG-21022018
                IF NOT "Short Closed" THEN
                    CreateInvtPutAwayPick
                ELSE
                    ERROR('You can not create Pick List because this Sales Order already Short Closed....');
                //CCIT-SG-21022018

            end;

        }

        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                // //CCIT-PRI-191118
                // ERROR('You do not have following permission');
                // //CCIT-PRI-191118

                IF NOT "Short Closed" THEN BEGIN

                    //CCIT-JAGA
                    RecDate.GET(RecDate."Period Type"::Date, "Posting Date");

                    AllowPost := FALSE;

                    IF Rec.Sunday = TRUE THEN
                        IF RecDate."Period Name" = 'Sunday' THEN
                            AllowPost := TRUE;
                    IF Rec.Monday = TRUE THEN
                        IF RecDate."Period Name" = 'Monday' THEN
                            AllowPost := TRUE;
                    IF Rec.Tuesday = TRUE THEN
                        IF RecDate."Period Name" = 'Tuesday' THEN
                            AllowPost := TRUE;
                    IF Rec.Wednesday = TRUE THEN
                        IF RecDate."Period Name" = 'Wednesday' THEN
                            AllowPost := TRUE;
                    IF Rec.Thursday = TRUE THEN
                        IF RecDate."Period Name" = 'Thursday' THEN
                            AllowPost := TRUE;
                    IF Rec.Friday = TRUE THEN
                        IF RecDate."Period Name" = 'Friday' THEN
                            AllowPost := TRUE;
                    IF Rec.Saturday = TRUE THEN
                        IF RecDate."Period Name" = 'Saturday' THEN
                            AllowPost := TRUE;

                    IF AllowPost OR ((AllowPost = FALSE) AND ("Route Days Applicable" = FALSE)) THEN BEGIN
                        IF RecCust.GET(Rec."Sell-to Customer No.") THEN BEGIN
                            IF RecCust.Referance = TRUE THEN BEGIN
                                ERROR('Customer PO/SO No. must have value in Sales Header.');
                            END;
                            //Post(CODEUNIT::"Sales-Post (Yes/No)")
                        END ELSE
                            ERROR('Day is not matching');
                    END;
                END ELSE BEGIN
                    ERROR('You can not post Short Closed SO');
                END;


                //CCIT-JAGA

            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have Permission');
                //CCIT-PRI-191118

            end;
        }

        addbefore(post)
        {
            group(Process)
            {
                CaptionML = ENU = 'Process',
                            ENN = 'P&osting';
                Image = Post;
                action("Short Closed1")
                {
                    Caption = 'Short Closed';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        TESTFIELD("ShortClose Reason Code");
                        //CCIT-SG
                        RecWAH.RESET;
                        RecWAH.SETRANGE(RecWAH."Source No.", "No.");
                        IF RecWAH.FINDFIRST THEN
                            ERROR('Warehouse Activity Lines are Created first delete these lines and then Short Cloesd.');
                        //CCIT-SG

                        //rdk 14-05-2019
                        RecResEnt.RESET;
                        RecResEnt.SETRANGE(RecResEnt."Source ID", "No.");
                        IF RecResEnt.FINDFIRST THEN
                            ERROR('Reservation Entry Lines are Created first  delete these lines and then Short Cloesd.');

                        RecTRackSpecs.RESET;
                        RecResEnt.SETRANGE(RecResEnt."Source ID", "No.");
                        IF RecResEnt.FINDFIRST THEN
                            ERROR('TRacking Specifications Lines are Created first delete these lines and then Short Cloesd.');
                        //rdk end

                        //CCIT-PRI
                        IF NOT CONFIRM(Text003, FALSE, "No.") THEN
                            EXIT;

                        RecSL.RESET;
                        RecSL.SETRANGE(RecSL."Document No.", "No.");
                        RecSL.SETFILTER(RecSL."Qty. to Ship", '<>%1', 0);
                        IF RecSL.FINDFIRST THEN
                            REPEAT
                                RecSL."Outstanding Quantity" := 0;
                                RecSL."Outstanding Qty. (Base)" := 0;
                                RecSL."Outstanding Quantity In KG" := 0;
                                RecSL.MODIFY;
                            UNTIL RecSL.NEXT = 0;
                        "Short Closed" := TRUE;
                        //CCIT-PRI

                        //IF "Short Closed" = TRUE THEN
                    end;
                }
            }
        }
        addafter(Post)
        {
            // action("Sales Order")
            // {
            //     Promoted = true;

            //     trigger OnAction();
            //     begin

            //         RecSH1.RESET;
            //         RecSH1.SETRANGE(RecSH1."No.", "No.");
            //         REPORT.RUNMODAL(50008, TRUE, FALSE, RecSH1);
            //     end;
            // }
        }
        addafter("&Print")
        {
            action("Print Confirmation 1")
            {
                Promoted = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    RecSH1.RESET;
                    RecSH1.SETRANGE(RecSH1."No.", "No.");
                    REPORT.RUNMODAL(50123, TRUE, FALSE, RecSH1);
                    //REPORT.RUNMODAL(18009, TRUE, FALSE, RecSH1);
                end;
            }
        }
    }

    var
        //RecSL: Record 37;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        SalesSetup: record 311;
        RecDate: Record 2000000007;
        RecSH: Record 36;
        AllowPost: Boolean;
        RecSH1: Record 36;
        RecCust: Record 18;
        RecSaleaPerson: Record 13;
        SalesPersonName: Text[100];
        ShortClosed: Boolean;
        RecWAH: Record 5766;
        RecSL: Record 37;
        Text003: Label 'Do you want to short close Order %1 ?';
        IGSTBoolean: Boolean;
        RecCust1: Record 18;
        CustBal: Decimal;
        CustCreditLimit: Decimal;
        RecResEnt: Record 337;
        RecTRackSpecs: Record 336;

    trigger OnDeleteRecord(): Boolean;
    begin

        ERROR('You do not have permission');

    end;

    trigger OnOpenPage();
    begin
        /*
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FindSet() THEN
            REPEAT
                LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
        LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
        IF LocCodeText <> '' THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
            SETFILTER("Location Code", LocCodeText);
            FILTERGROUP(0);
        END;
        */

        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        SETFILTER("Location Code", '');
        FILTERGROUP(0);



        //CCIT
        IF "Short Closed" = FALSE THEN
            ShortClosed := TRUE;
        //CCIT

        //CCIT-SG
        IF (USERID = 'FORTUNE\AJIT') OR (USERID = 'FORTUNE\LOGISTICSMGR') OR (USERID = 'FORTUNE\JWL') THEN
            IGSTBoolean := TRUE
        ELSE
            IGSTBoolean := FALSE;
        //CCIT-SG

    end;
    //<<PCPL/NSW/MIG
    trigger OnAfterGetRecord()
    var
    begin
        FILTERGROUP(2);
        SETFILTER("Short Closed", '%1', false); //PCPL/NSW/07 30May22
        FILTERGROUP(0);
    end;

    procedure GetSalesStatisticsAmount(
        SalesHeader: Record "Sales Header";
        var GSTAmount: Decimal; var AmountToCust: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        Clear(GSTAmount);
        Clear(TotalAmount);
        Clear(AmountToCust);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(SalesLine.RecordId());
                TotalAmount += SalesLine."Line Amount" - SalesLine."Line Discount Amount";
            until SalesLine.Next() = 0;
        AmountToCust := GSTAmount + TotalAmount;
    end;

    local procedure GetGSTAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
    end;

    //>>PCPL/NSW/MIG

    procedure GetGSTAmountTotal(
      SalesHeader: Record 36;
      var GSTAmount: Decimal)
    var
        SalesLine: Record 37;
    begin
        Clear(GSTAmount);
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount11(SalesLine.RecordId());
            until SalesLine.Next() = 0;
    end;

    local procedure GetGSTAmount11(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then begin
            TaxTransactionValue.CalcSums(Amount);
            TaxTransactionValue.CalcSums(Percent);

        end;
        exit(TaxTransactionValue.Amount);
    end;

    procedure GetTCSAmountTotal(
           SalesHeader: Record 36;
           var TCSAmount: Decimal)
    var
        SalesLine: Record 37;
        TCSManagement: Codeunit "TCS Management";
        i: Integer;
        RecordIDList: List of [RecordID];
    begin
        Clear(TCSAmount);
        // Clear(TCSPercent);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
            until SalesLine.Next() = 0;

        for i := 1 to RecordIDList.Count() do begin
            TCSAmount += GetTCSAmount(RecordIDList.Get(i));
        end;

        TCSAmount := TCSManagement.RoundTCSAmount(TCSAmount);
    end;

    local procedure GetTCSAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
    begin
        if not TCSSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
    end;

    procedure GetPostedSalesInvStatisticsAmount(
            SalesHeader: Record 36;
            var TotalInclTaxAmount: Decimal)
    var
        SalesLine: Record 37;
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                TotalInclTaxAmount += SalesLine.Amount;
            until SalesLine.Next() = 0;


        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;


    var
        CustCheckCreditLimit: Page 343;

        OK: Boolean;
        CustCrLimitConfirmQst: TextConst ENU = 'The customer''s credit limit has been exceeded. Do you still want to continue?;ENN=The customer''s credit limit has been exceeded. Do you still want to continue?';
        TotalGSTAmount: Decimal;
        TotalAmount: Decimal;
        AmountToCust: Decimal;
        saleHeaderN: Record 36;
        Noseries: Record 308;
        EditableField: Boolean;
        TotalGSTAmount1: Decimal;
        TotalTCSAmt: Decimal;
        TotalAmt: Decimal;
        AvailableCreditLimit: Decimal; //PCPL-0070
}

