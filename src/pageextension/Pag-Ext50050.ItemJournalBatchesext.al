pageextension 50050 "Item_Journal_Batches_ext" extends "Item Journal Batches"
{
    // version NAVW17.00

    actions
    {
        addafter("Post and &Print")
        {
            action("Item Journal Upload")
            {
                Promoted = true;
                ApplicationArea = all;
                RunObject = XMLport 50004;
            }
        }
    }
}

