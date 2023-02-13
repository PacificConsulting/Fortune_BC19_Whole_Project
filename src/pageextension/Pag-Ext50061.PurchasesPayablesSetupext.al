pageextension 50061 "Purchases_Payables_Setup_ext" extends "Purchases & Payables Setup"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    layout
    {

        addafter("Default Qty. to Receive")
        {
            field("Social Welfare charges"; "Social Welfare charges")
            {
                ApplicationArea = all;
            }
            field("Date 194Q Before"; "Date 194Q Before")
            {
                ApplicationArea = all;
            }
            field("Date 194Q After"; "Date 194Q After")
            {
                ApplicationArea = all;
            }
            field("Custom Duty %"; "Custom Duty %")
            {
                ApplicationArea = all;
            }
            field(Tolerance; Tolerance)
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

