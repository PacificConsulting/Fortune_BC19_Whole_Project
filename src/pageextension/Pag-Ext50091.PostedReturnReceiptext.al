pageextension 50091 "Posted_Return_Receipt_ext" extends "Posted Return Receipt"
{

    layout
    {

        addafter("Salesperson Code")
        {
            field("Tally Invoice No."; "Tally Invoice No.")
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
            field("Customer GRN/RTV No."; "Customer GRN/RTV No.")
            {
                ApplicationArea = all;
            }
            field("GRN/RTV Date"; "GRN/RTV Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bill-to City")
        {
            field("Applies-to Doc. Type"; "Applies-to Doc. Type")
            {
                ApplicationArea = all;
            }
            field("Applies-to Doc. No."; "Applies-to Doc. No.")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addbefore("Update Document")
        {
            action("Sales Goods Return")

            {
                Promoted = true;
                ShortCutKey = 'Ctrl+k';
                ApplicationArea = all;
                PromotedCategory = New;
                Image = Print;


                trigger OnAction();
                begin
                    ReturnRcptHeader.RESET;
                    ReturnRcptHeader.SETRANGE(ReturnRcptHeader."No.", "No.");
                    REPORT.RUNMODAL(50051, TRUE, FALSE, ReturnRcptHeader);
                end;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.
    var
        ReturnRcptHeader: Record "Return Receipt Header";

}

