pageextension 50032 "Posted_sales_ship_ext" extends "Posted Sales Shipment"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067

    layout
    {

        addafter("Salesperson Code")
        {
            field("Sales Person Name"; SalesPersonName)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        RecSP: Record 13;
        SalesPersonName: Text[50];


    //Unsupported feature: CodeInsertion on "OnAfterGetCurrRecord". Please convert manually.

    trigger OnAfterGetCurrRecord();
    begin

        //CCIT-JAGA
        CLEAR(SalesPersonName);
        IF RecSP.GET("Salesperson Code") THEN
            SalesPersonName := RecSP.Name;
        //CCIT-JAGA

    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

