pageextension 50069 "Fixed_Asset_List_ext" extends "Fixed Asset List"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {
        addafter("Search Description")
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
            field("Warranty Date"; "Warranty Date")
            {
                ApplicationArea = all;
            }
            field("Serial No."; "Serial No.")
            {
                ApplicationArea = all;
            }
            field("Next Service Date"; "Next Service Date")
            {
                ApplicationArea = all;
            }
            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                ApplicationArea = all;
            }
        }
    }
}

