pageextension 50062 "Currency_Exch_Rates_ext" extends "Currency Exchange Rates"
{
    // version NAVW17.00,CCIT-Fortune

    layout
    {
        addafter("Fix Exchange Rate Amount")
        {
            field("End Date"; "End Date")
            {
                ApplicationArea = all;
            }
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

