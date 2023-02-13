pageextension 50027 Job_Card_ext extends "Job Card"
{
    // version NAVW19.00.00.47444,NAVIN9.00.00.47444

    layout
    {

        //Unsupported feature: Change Editable on "Control 98". Please convert manually.


        //Unsupported feature: Change Editable on "Control 100". Please convert manually.


        //Unsupported feature: CodeInsertion on "Control 98". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        CurrencyCheck;
        */
        //end;


        //Unsupported feature: CodeInsertion on "Control 100". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //begin
        /*
        CurrencyCheck;
        */
        //end;
    }

    var
        [InDataSet]
        InvoiceCurrencyCodeEditable: Boolean;
        [InDataSet]
        CurrencyCodeEditable: Boolean;


    //Unsupported feature: CodeInsertion on "OnAfterGetRecord". Please convert manually.

    //trigger OnAfterGetRecord();
    //begin
    /*
    CurrencyCheck;
    */
    //end;


    //Unsupported feature: CodeInsertion on "OnInit". Please convert manually.

    //trigger OnInit();
    //Parameters and return type have not been exported.
    //begin
    /*
    CurrencyCodeEditable := TRUE;
    InvoiceCurrencyCodeEditable := TRUE;
    */
    //end;

    local procedure CurrencyCheck();
    begin
        IF "Currency Code" <> '' THEN
            InvoiceCurrencyCodeEditable := FALSE
        ELSE
            InvoiceCurrencyCodeEditable := TRUE;

        IF "Invoice Currency Code" <> '' THEN
            CurrencyCodeEditable := FALSE
        ELSE
            CurrencyCodeEditable := TRUE;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

