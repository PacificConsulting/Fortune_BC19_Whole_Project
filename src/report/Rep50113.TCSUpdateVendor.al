report 50113 "TCS Update Vendor"
{
    // version CCIT-Vikas
    /*
        DefaultLayout = RDLC;
        RDLCLayout = './TCS Update Vendor.rdlc';

        dataset
        {
            dataitem(DataItem1000000000;Table13786)
            {
                DataItemTableView = WHERE(Type=CONST(Vendor));
                RequestFilterFields = "No.";

                trigger OnAfterGetRecord();
                begin
                    TCSEntry5.RESET;
                    TCSEntry5.SETRANGE("Party Type",TCSEntry5."Party Type"::Vendor);
                    TCSEntry5.SETRANGE("Party Code","NOD/NOC Header"."No.");
                    //TCSEntry5.SETFILTER("Posting Date",'<>%1',061120D);
                    IF NOT TCSEntry5.FIND('-') THEN BEGIN
                        InvoiceAmt:=0;
                        VendLedgEntry.RESET();
                        VendLedgEntry.SETFILTER("Document Type",'%1|%2',VendLedgEntry."Document Type"::Invoice,VendLedgEntry."Document Type"::"Credit Memo");
                        VendLedgEntry.SETRANGE("Vendor No.","NOD/NOC Header"."No.");
                        VendLedgEntry.SETFILTER("Posting Date",'>=%1',040120D);
                        VendLedgEntry.CALCFIELDS("Amount (LCY)");
                        IF VendLedgEntry.FIND('-') THEN REPEAT
                          VendLedgEntry.CALCFIELDS("Amount (LCY)");
                           InvoiceAmt:= InvoiceAmt+ VendLedgEntry."Amount (LCY)";
                          UNTIL VendLedgEntry.NEXT=0;

                        TCSEntry1.RESET();
                        IF TCSEntry1.FINDLAST THEN;

                        Vendor.GET("NOD/NOC Header"."No.");
                        InvoiceAmt := ABS(InvoiceAmt);
                        TCSEntry.INIT();
                        TCSEntry."Entry No." := TCSEntry1."Entry No."+1;
                        TCSEntry."Account Type" := TCSEntry."Account Type"::"G/L Account";
                        TCSEntry."Account No." := '107164';
                        TCSEntry."Document Type" := TCSEntry."Document Type"::Invoice;
                        TCSEntry."Document No.":= 'Opening TCS';
                        TCSEntry."Party Type" := TCSEntry."Party Type"::Vendor;
                        TCSEntry."Party Code" := "NOD/NOC Header"."No.";
                        TCSEntry."TCS Nature of Collection" := 'TCS-VEN';
                        TCSEntry."Assessee Code" := "NOD/NOC Header"."Assesse Code";
                        TCSEntry."TCS Type" := TCSEntry."TCS Type"::B;
                        TCSEntry."Party P.A.N. No." := Vendor."P.A.N. No.";
                        TCSEntry."Invoice Amount":= InvoiceAmt;
                        TCSEntry."Sales Amount":= InvoiceAmt;
                        TCSEntry."Surcharge Base Amount":= InvoiceAmt;
                        TCSEntry."TCS Base Amount" := InvoiceAmt;
                        TCSEntry."Posting Date" := TODAY;
                        TCSEntry."Party Account No."  := '107164';
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

        var
            VendLedgEntry : Record "25";
            InvoiceAmt : Decimal;
            TCSEntry : Record "16514";
            TCSEntry1 : Record "16514";
            Vendor : Record "23";
            TCSEntry5 : Record "16514";
            */
}

