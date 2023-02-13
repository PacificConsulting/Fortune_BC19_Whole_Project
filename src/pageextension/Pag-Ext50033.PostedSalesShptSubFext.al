pageextension 50033 "Posted_Sales_Shpt_SubF_ext" extends "Posted Sales Shpt. Subform"
{
    // version NAVW19.00.00.45778

    layout
    {

        addafter("No.")
        {
            field("GST Group Code"; "GST Group Code")
            {
                ApplicationArea = all;
            }
            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        modify(UndoShipment)
        {
            trigger OnBeforeAction();
            begin

                //CCIT-SG
                RecPostInvPickLine.RESET;
                RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source No.", "Order No.");
                RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source Line No.", "Order Line No.");
                IF RecPostInvPickLine.FINDSET THEN
                    REPEAT
                        RecPostInvPickLine.DELETE;
                    UNTIL RecPostInvPickLine.NEXT = 0;
                //CCIT-SG



            end;
        }
    }

    var
        RecPostInvPickLine: Record 7343;
}

