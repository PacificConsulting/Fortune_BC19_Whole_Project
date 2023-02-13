pageextension 50018 "Sales_credit_memo_ext" extends "Sales Credit Memo"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {
        modify("Salesperson Code")
        {
            trigger OnBeforeValidate()
            begin
                //CCIT-JAGA 29/10/2018
                IF RecSaleaPerson.GET("Salesperson Code") THEN BEGIN
                    SalesPersonName := RecSaleaPerson.Name;
                END;
                //CCIT-JAGA 29/10/2018

            end;
        }
        addafter("Sell-to Post Code")
        {
            field("Customer GRN/RTV No."; "Customer GRN/RTV No.")
            {
                ApplicationArea = all;
            }
            field("GRN/RTV Date"; "GRN/RTV Date")
            {
                ApplicationArea = all;
            }
            field("Order Date"; "Order Date")
            {
                CaptionML = ENU = 'Customer Cr.Memo Date',
                            ENN = 'Order Date';
                ApplicationArea = all;


            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; SalesPersonName)
            {
                ApplicationArea = all;
            }
            field("Tally Invoice No."; "Tally Invoice No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Applies-to Doc. Type")
        {
            field("Vertical Category"; "Vertical Category")
            {
                ApplicationArea = all;
            }
            field("Vertical Sub Category"; "Vertical Sub Category")
            {
                ApplicationArea = all;
            }
            field("Outlet Area"; "Outlet Area")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location State Code")
        {
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
            field("Return Receipt No."; "Return Receipt No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Due Date")
        {
            field("Amount To Customer"; "Amount To Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

    }
    actions
    {


        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                // rdk230919 -
                //PCPL-0070 15Dec2022 <<
                GetGSTAmountTotal(Rec, TotalGSTAmount1);
                GetTCSAmountTotal(Rec, TotalTCSAmt);
                GetPostedSalesInvStatisticsAmount(Rec, TotalAmt);
                rec."Amount To Customer" := TotalAmt + TotalGSTAmount1 + TotalTCSAmt;
                Modify();
                //PCPL-0070 15Dec2022 >>

                Salessetup.GET;
                //IF NOT Salessetup."Post Bond SO-SCM" THEN
                IF (Salessetup."Post Bond SO-SCM") AND (Rec."Location Code" <> 'SNOW BOND') THEN BEGIN
                    //CCIT-JAGA 30/10/2018
                    IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                        ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                    // TESTFIELD(Structure);
                    //CCIT-JAGA 30/10/2018

                    // rdk 10-05-2019
                    SalesLine.RESET;
                    SalesLine.SETRANGE(SalesLine."Document No.", "No.");
                    SalesLine.SETFILTER(SalesLine."No.", '<>%1', '');
                    IF SalesLine.FINDSET THEN
                        REPEAT
                        BEGIN
                            SalesLine.TESTFIELD("Reason Code");
                        END;
                        UNTIL SalesLine.NEXT = 0;

                    // rdk end
                END;
                // rdk230919 +
                //<<PCPL/NSW/17March2022
                // IF RecLocation.Get("Location Code") then begin
                //     "Posting No. Series" := RecLocation."Sales Cr Memo No.";
                //     Rec.Modify();
                //     Message('Posting No Series Updated %1', "Posting No. Series");
                // ENd;
                //>>PCPL/NSW/17March2022

            end;
        }

        modify(Post)
        {
            trigger OnBeforeAction()
            begin

                Rec."Posting Date" := Today;
                Rec.Modify();
                //CCIT-JAGA 30/10/2018
                IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                    ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');

                // rdk230919 -
                //Salessetup.GET;
                //IF NOT Salessetup."Post Bond SO-SCM" THEN
                //IF (Salessetup."Post Bond SO-SCM") AND (Rec."Location Code" <> 'SNOW BOND') THEN
                // TESTFIELD(Structure);

                //CCIT-JAGA 30/10/2018

                //CCIT-JAGA  23/10/2018
                SalesLine.RESET;
                SalesLine.SETRANGE(SalesLine."Document No.", "No.");
                SalesLine.SETFILTER(SalesLine."No.", '<>%1', '');
                IF SalesLine.FINDSET THEN
                    REPEAT
                        SalesLine.TESTFIELD("Reason Code");
                    //SalesLine.TESTFIELD("Item code");//CCIT-TK-061219
                    UNTIL SalesLine.NEXT = 0;
                //CCIT-JAGA  23/10/2018

            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 20/11/2018
                RecCLE.RESET;
                RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                IF RecCLE.FINDFIRST THEN BEGIN
                    //   CALCFIELDS("Amount to Customer");
                    IF saleHeaderN.GET("Applies-to Doc. No.") then; //PCPL/NSW/MIG New Code Add
                    RecCLE.CALCFIELDS(Amount);
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    IF AmountToCust > RecCLE.Amount THEN //PCPL/NSW/MIG New Code Add
                        ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', AmountToCust, RecCLE.Amount);
                END;
                //CCIT-JAGA 20/11/2018
            end;
        }


    }

    var
        RecSaleaPerson: Record 13;
        SalesPersonName: Text[50];
        RecCLE: Record 21;
        SalesLine: Record 37;
        Salessetup: Record 311;




    trigger OnAfterGetRecord();
    begin
        //CCIT-JAGA 29/10/2018
        CLEAR(SalesPersonName);
        IF RecSaleaPerson.GET("Salesperson Code") THEN BEGIN
            SalesPersonName := RecSaleaPerson.Name;
        END;
        //CCIT-JAGA 29/10/2018

    end;
    //<<PCPL/NSW/MIG
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

    //PCPL-0070 15Dec2022 <<
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
                GSTAmount += GetGSTAmount(SalesLine.RecordId());
            until SalesLine.Next() = 0;
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

    //PCPL-0070 15Dec2022 >>

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

    var
        CustCheckCreditLimit: Page 343;

        OK: Boolean;
        CustCrLimitConfirmQst: TextConst ENU = 'The customer''s credit limit has been exceeded. Do you still want to continue?;ENN=The customer''s credit limit has been exceeded. Do you still want to continue?';
        TotalGSTAmount: Decimal;
        TotalAmount: Decimal;
        AmountToCust: Decimal;
        saleHeaderN: Record 36;
        RecLocation: Record 14;
        TotalGSTAmount1: Decimal;
        TotalTCSAmt: Decimal;
        TotalAmt: Decimal;


}

