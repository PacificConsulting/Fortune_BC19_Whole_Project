pageextension 50111 "Sales_Credit_Memos_ext" extends "Sales Credit Memos"
{
    // version NAVW19.00.00.45778
    layout
    {
        addafter("Location Code")
        {
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            begin
                //CCIT-JAGA 30/10/2018
                IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                    ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                // TESTFIELD(Structure);
                //CCIT-JAGA 30/10/2018

            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //<<PCPL/MIG/NSW
                saleHeaderN.Reset();
                saleHeaderN.SetRange("No.", "No.");
                saleHeaderN.SetRange("Document Type", "Document Type"::Order);
                IF saleHeaderN.FindFirst() then;
                //>>PCPL/MIG/NSW
                //CCIT-JAGA 20/11/2018
                RecCLE.RESET;
                RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                IF RecCLE.FINDFIRST THEN BEGIN
                    //CALCFIELDS("Amount to Customer");
                    RecCLE.CALCFIELDS(Amount);
                    //MESSAGE('%1 ... %2',"Amount to Customer",RecCLE.Amount);
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    //IF "Amount to Customer" > RecCLE.Amount THEN
                    IF AmountToCust > RecCLE.Amount THEN
                        ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', AmountToCust, RecCLE.Amount);
                END;
                //CCIT-JAGA 20/11/2018

                //CCIT-JAGA 30/10/2018
                IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                    ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                //TESTFIELD(Structure);
                //CCIT-JAGA 30/10/2018

            end;
        }
        modify("Preview Posting")
        {
            trigger OnBeforeAction()
            begin
                //<<PCPL/MIG/NSW
                saleHeaderN.Reset();
                saleHeaderN.SetRange("No.", "No.");
                saleHeaderN.SetRange("Document Type", "Document Type"::Order);
                IF saleHeaderN.FindFirst() then;
                //CCIT-JAGA 20/11/2018
                RecCLE.RESET;
                RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                IF RecCLE.FINDFIRST THEN BEGIN
                    RecCLE.CalcFields(Amount);
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    //IF "Amount to Customer" > RecCLE.Amount THEN
                    IF AmountToCust > RecCLE.Amount THEN
                        ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', AmountToCust, RecCLE.Amount);
                END;
                //CCIT-JAGA 20/11/2018

            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                //<<PCPL/MIG/NSW
                saleHeaderN.Reset();
                saleHeaderN.SetRange("No.", "No.");
                saleHeaderN.SetRange("Document Type", "Document Type"::Order);
                IF saleHeaderN.FindFirst() then;
                //CCIT-JAGA 20/11/2018
                RecCLE.RESET;
                RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                IF RecCLE.FINDFIRST THEN BEGIN
                    //CALCFIELDS("Amount to Customer");
                    RecCLE.CALCFIELDS(Amount);
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    //IF "Amount to Customer" > RecCLE.Amount THEN
                    IF AmountToCust > RecCLE.Amount THEN
                        ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', AmountToCust, RecCLE.Amount);
                END;
                //CCIT-JAGA 20/11/2018

            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            begin
                //<<PCPL/MIG/NSW
                saleHeaderN.Reset();
                saleHeaderN.SetRange("No.", "No.");
                saleHeaderN.SetRange("Document Type", "Document Type"::Order);
                IF saleHeaderN.FindFirst() then;
                //CCIT-JAGA 20/11/2018
                RecCLE.RESET;
                RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                IF RecCLE.FINDFIRST THEN BEGIN
                    RecCLE.CALCFIELDS(Amount);
                    GetSalesStatisticsAmount(saleHeaderN, TotalGSTAmount, AmountToCust);//PCPL/NSW/MIG New Code Add
                    //IF "Amount to Customer" > RecCLE.Amount THEN
                    IF AmountToCust > RecCLE.Amount THEN
                        ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', AmountToCust, RecCLE.Amount);
                END;
                //CCIT-JAGA 20/11/2018

            end;
        }

    }

    var
        RecCLE: Record 21;
        RecUserSetup: Record 91;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    trigger OnOpenPage();
    begin

        //CCIT-SG-05062018
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                //IF RecUserBranch."Location Code" <> '' THEN
                LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
        LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
        IF LocCodeText <> '' THEN BEGIN
            SETFILTER("Location Code", LocCodeText);
        END;
        IF LocCodeText <> '' THEN
            ClearHide := FALSE
        ELSE
            ClearHide := TRUE;
        //CCIT-SG-05062018

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
        //    CustCrLimitConfirmQst: TextConst ENU = 'The customer''s credit limit has been exceeded. Do you still want to continue?;ENN=The customer''s credit limit has been exceeded. Do you still want to continue?';
        TotalGSTAmount: Decimal;
        TotalAmount: Decimal;
        AmountToCust: Decimal;
        saleHeaderN: Record 36;

}

