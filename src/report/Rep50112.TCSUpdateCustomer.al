report 50112 "TCS Update Customer"
{
    // version CCIT-Vikas
    /* //PCPL/MIG/NSW Filed not Exist in BC18
    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/TCS Update Customer.rdl';
    ApplicationArea=all;
    UsageCategory=ReportsAndAnalysis
    
    dataset
    {
        
        dataitem(DataItem1000000000;Table13786)
        {
            DataItemTableView = WHERE(Type=CONST(Customer));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                TCSEntry5.RESET;
                TCSEntry5.SETRANGE("Party Type",TCSEntry5."Party Type"::Customer);
                TCSEntry5.SETRANGE("Party Code","NOD/NOC Header"."No.");
                //TCSEntry5.SETFILTER("Posting Date",'<>%1',061120D);
                IF NOT TCSEntry5.FIND('-') THEN BEGIN
                    InvoiceAmt:=0;
                    CustLedgEntry.RESET();
                    CustLedgEntry.SETFILTER("Document Type",'%1|%2',CustLedgEntry."Document Type"::Invoice,CustLedgEntry."Document Type"::"Credit Memo");
                    CustLedgEntry.SETRANGE("Customer No.","NOD/NOC Header"."No.");
                    CustLedgEntry.SETFILTER("Posting Date",'>=%1',040120D);
                    CustLedgEntry.CALCFIELDS("Amount (LCY)");
                    IF CustLedgEntry.FIND('-') THEN REPEAT
                      CustLedgEntry.CALCFIELDS("Amount (LCY)");
                       InvoiceAmt:= InvoiceAmt+ CustLedgEntry."Amount (LCY)";
                      UNTIL CustLedgEntry.NEXT=0;

                    TCSEntry1.RESET();
                    IF TCSEntry1.FINDLAST THEN;

                    Customer.GET("NOD/NOC Header"."No.");

                    TCSEntry.INIT();
                    TCSEntry."Entry No." := TCSEntry1."Entry No."+1;
                    TCSEntry."Account Type" := TCSEntry."Account Type"::"G/L Account";
                    TCSEntry."Account No." := '208118';
                    TCSEntry."Document Type" := TCSEntry."Document Type"::Invoice;
                    TCSEntry."Document No.":= 'Opening TCS';
                    TCSEntry."Party Type" := TCSEntry."Party Type"::Customer;
                    TCSEntry."Party Code" := "NOD/NOC Header"."No.";
                    TCSEntry."TCS Nature of Collection" := 'TCS-CUST';
                    TCSEntry."Assessee Code" := "NOD/NOC Header"."Assesse Code";
                    TCSEntry."TCS Type" := TCSEntry."TCS Type"::A;
                    TCSEntry."Party P.A.N. No." := Customer."P.A.N. No.";
                    TCSEntry."Invoice Amount":= InvoiceAmt;
                    TCSEntry."Sales Amount":= InvoiceAmt;
                    TCSEntry."Surcharge Base Amount":= InvoiceAmt;
                    TCSEntry."TCS Base Amount" := InvoiceAmt;
                    TCSEntry."Posting Date" := TODAY;
                    TCSEntry."Party Account No."  := '208118';
                    TCSEntry.INSERT;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        MESSAGE('Opening Created Successfully');
    end;
*/
    var
        CustLedgEntry: Record 21;
        InvoiceAmt: Decimal;
        TCSEntry: Record "TCS Entry";
        TCSEntry1: Record "TCS Entry";
        Customer: Record 18;
        TCSEntry5: Record "TCS Entry";

}

