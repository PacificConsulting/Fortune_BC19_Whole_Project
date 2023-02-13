pageextension 50098 "Posted_Invt_Put_away_Subf_ext" extends "Posted Invt. Put-away Subform"
{
    // version NAVW19.00.00.45778

    layout
    {
        modify(Quantity)
        {
            CaptionML = ENU = 'Quantity In KG', ENN = 'Quantity';
        }
        addafter("Location Code")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
        }
    }
}

