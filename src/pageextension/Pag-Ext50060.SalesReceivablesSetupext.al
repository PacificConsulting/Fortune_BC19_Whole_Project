pageextension 50060 "Sales_Receivables_Setup_ext" extends "Sales & Receivables Setup"
{
    // version NAVW19.00.00.48316,NAVIN9.00.00.48316,CCIT-Fortune

    layout
    {

        addafter("GST Dependency Type")
        {
            field("194Q Applicable Date"; "194Q Applicable Date")
            {
                ApplicationArea = all;
            }
            field(Tolerance; Tolerance)
            {
                ApplicationArea = all;
            }
            field("Post Bond SO-SCM"; "Post Bond SO-SCM")
            {
                Caption = 'Post Bond SO-SCM Yes / No';
                ApplicationArea = all;
            }
        }
        addafter("Posted Credit Memo Nos.")
        {
            field("Bond Nos."; "Bond Nos.")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

