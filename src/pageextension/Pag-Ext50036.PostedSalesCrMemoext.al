pageextension 50036 "Posted_Sales_Cr_Memo_ext" extends "Posted Sales Credit Memo"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {

        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }

        addafter("Salesperson Code")
        {
            field("Tally Invoice No."; "Tally Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Customer GRN/RTV No."; "Customer GRN/RTV No.")
            {
                ApplicationArea = all;
            }
            field("GRN/RTV Date"; "GRN/RTV Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("No. Printed")
        {
            field("Backdated Invoice No."; "Backdated Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Backdated Invoice Date"; "Backdated Invoice Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location State Code")
        {
            // field("E-Invoice IRN"; "E-Invoice IRN")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-Invoice Acknowledgment No."; "E-Invoice Acknowledgment No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-Invoice Acknowledement Dt"; "E-Invoice Acknowledement Dt")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-Invoice Error Remarks"; "E-Invoice Error Remarks")
            // {
            //     ApplicationArea = all;
            // }
            // field("E-Invoice QR"; "E-Invoice QR")
            // {
            //     ApplicationArea = all;
            // }
        }

    }
    actions
    {
        addafter(Approvals)
        {
            action("Generate E-Invoice Customized")
            {
                Enabled = true;
                Image = Web;
                Promoted = true;
                Visible = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    // cu_GSTEInvoice: Codeunit 50008; //PCPL/MIG/NSW
                    recSIHeader: Record 112;
                begin

                    // cu_GSTEInvoice.GenerateIRNPayload(recSIHeader, FALSE, Rec);//CITS_RS 010221 //PCPL/MIG/NSW
                end;
            }
        }
        addafter(ActivityLog)
        {
            action("Sales Credit Memo")
            {
                Promoted = true;

                trigger OnAction();
                begin
                    RecSalesCredMemo.RESET;
                    RecSalesCredMemo.SETRANGE(RecSalesCredMemo."No.", Rec."No.");
                    IF RecSalesCredMemo.FindFirst() then
                        REPORT.RUNMODAL(50071, TRUE, FALSE, RecSalesCredMemo);
                end;
            }
        }
    }

    var
        RecSalesCredMemo: Record 114;



}

