pageextension 50117 "TDS_setup_ext" extends "TDS Setup"
{
    // version NAVIN9.00.00.45778

    layout
    {
        addafter("TDS Nil Challan Nos.")
        {
            field("Rate 206AB"; "Rate 206AB")
            {
                ApplicationArea = all;
            }
            field("Double Rate Of TDS"; "Double Rate Of TDS")
            {
                ApplicationArea = all;
            }
        }
    }
}

