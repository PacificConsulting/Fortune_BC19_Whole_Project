pageextension 50105 "Acc_Receivable_Activities_ext" extends "Acc. Receivable Activities"
{
    // version NAVW17.00

    layout
    {



        addafter("Approved Sales Orders")
        {
            cuegroup("Pending Documents")
            {

                Caption = 'Pending Documents';
                field("Purch.Invoices Not Posted"; "Purch.Invoices Not Posted")
                {
                    DrillDownPageID = "Purchase List";
                    ApplicationArea = all;
                }
                field("Bank Payments Not Posted"; "Bank Payments Not Posted")
                {
                    ApplicationArea = all;
                }
                field("Cash Payments Not Posted"; "Cash Payments Not Posted")
                {
                    ApplicationArea = all;
                }
                field("Pending Contra Entries"; "Pending Contra Entries")
                {
                    ApplicationArea = all;
                }
                field("Open PDCS for the Month"; "Open PDCS for the Month")
                {
                    DrillDownPageID = "PDC Cheques";
                    ApplicationArea = all;
                }
            }
        }
    }




    trigger OnAfterGetRecord();
    begin

        CalculateCueFieldValues;

    end;


    local procedure CalculateCueFieldValues();
    var
        SalesCue: Record 9053;
    begin
        IF FIELDACTIVE("Open PDCS for the Month") THEN
            "Open PDCS for the Month" := SalesCue."CalculatePending PDCs";
    end;
}

