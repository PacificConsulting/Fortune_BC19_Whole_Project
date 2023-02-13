pageextension 50030 "Item_Vendor_Catalog_ext" extends "Item Vendor Catalog"
{
    // version NAVW17.00

    layout
    {

        //Unsupported feature: Change SourceExpr on "Control 2". Please convert manually.

        addafter("Vendor No.")
        {
            field("Fortune Description"; "Fortune Description")
            {
                ApplicationArea = all;
            }
            field(Type; Type)
            {
            }
        }
        addafter("Vendor Item No.")
        {
            field("Vendor Description"; "Vendor Description")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {



    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

