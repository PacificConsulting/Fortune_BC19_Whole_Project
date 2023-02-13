pageextension 50024 "Purchase_list_ext" extends "Purchase List"
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621

    layout
    {

        addafter("Buy-from Vendor No.")
        {
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = all;
            }
            field("Bill of Entry No."; "Bill of Entry No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Assigned User ID")
        {
            field(Amount; Amount)
            {
                ApplicationArea = all;
            }
            field("Document Date"; "Document Date")
            {
                ApplicationArea = all;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = all;
            }
            field("Due Date"; "Due Date")
            {
                ApplicationArea = all;
            }
        }
    }
}

