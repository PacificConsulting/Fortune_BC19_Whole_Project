pageextension 50076 "Posted_Tran_Rcpt_Subform_ext" extends "Posted Transfer Rcpt. Subform"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        addafter(Quantity)
        {
            field("No. of Boxes"; "No. of Boxes")
            {
                ApplicationArea = all;
            }
            field("Transfer Serial No."; "Transfer Serial No.")
            {
                ApplicationArea = all;
            }
            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
            }
            field("Customer License Name"; "Customer License Name")
            {
                ApplicationArea = all;
            }
            field("Customer License Date"; "Customer License Date")
            {
                ApplicationArea = all;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Transfer To Reason Code"; "Transfer To Reason Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("License No."; "License No.")
            {
                ApplicationArea = all;
            }
            field(Weight; Weight)
            {
                ApplicationArea = all;
            }
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
            field(Reserved; Reserved)
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

