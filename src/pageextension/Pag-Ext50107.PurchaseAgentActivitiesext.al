pageextension 50107 "Purchase_Agent_Activities_ext" extends "Purchase Agent Activities"
{
    // version NAVW19.00.00.45778

    layout
    {

        //Unsupported feature: Change Visible on "Control 9". Please convert manually.


        modify(NotInvoiced)
        {
            CaptionML = ENU = 'Received but Not Invoiced', ENN = 'Not Invoiced';
            ToolTipML = ENU = 'No. of POs';
        }
        modify(PartiallyInvoiced)
        {
            ToolTipML = ENU = 'No. of POs';
        }
        addafter(PartiallyInvoiced)
        {
            cuegroup("Purchase Invoices")
            {
                Caption = 'Purchase Invoices';
                field("Pending Invoices"; "Pending Invoices")
                {
                    Caption = 'Pending Purchase Invoices';
                    DrillDownPageID = "Purchase Invoices";
                    ToolTip = 'No. of PIs';
                    ApplicationArea = all;
                }
                field("Invoices Due in Next Week"; "Invoices Due in Next Week")
                {
                    ToolTip = 'Inv.Amt. in Lacs (INR)';
                    ApplicationArea = all;
                    trigger OnDrillDown();
                    var
                        PINVH: Record 122;
                    begin
                        PINVH.SETRANGE("Due Date", TODAY, CALCDATE('0D+1W', TODAY));
                        IF PAGE.RUNMODAL(0, PINVH) = ACTION::LookupOK THEN;
                    end;
                }
            }
        }
    }



}

