pageextension 50063 "Column_Layout_ext" extends "Column Layout"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Cost Object Totaling")
        {
            field("Entry Type"; "Entry Type")
            {
                ApplicationArea = all;
            }
            field("Document No. filter"; "Document No. filter")
            {
                ApplicationArea = all;
            }
        }
    }
}

