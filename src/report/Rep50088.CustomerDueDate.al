report 50088 "Customer_Due_Date"
{
    // version CCIT-JAGA

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Customer_Due_Date.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Invoice),
                                      "Remaining Amount" = FILTER(<> 0));
            RequestFilterFields = "Due Date";
            column(Customer_No; "Cust. Ledger Entry"."Customer No.")
            {
            }
            column(Doc_No; "Cust. Ledger Entry"."Document No.")
            {
            }
            column(Due_Date; "Cust. Ledger Entry"."Due Date")
            {
            }
            column(Due_Amount; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Cus_Name; Cus_Name)
            {
            }

            trigger OnAfterGetRecord();
            begin
                //RecCust.RESET;
                IF RecCust.GET("Cust. Ledger Entry"."Customer No.") THEN
                    Cus_Name := RecCust.Name;
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

    var
        Cus_Name: Text[50];
        RecCust: Record 18;
}

