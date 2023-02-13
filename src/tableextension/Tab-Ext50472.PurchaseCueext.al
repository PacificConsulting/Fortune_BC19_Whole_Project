tableextension 50472 "Purchase_Cue_ext" extends "Purchase Cue"
{
    // version NAVW19.00.00.45778

    fields
    {
        modify("Outstanding Purchase Orders")
        {
            CaptionML = ENU = 'Outstanding Import Purchase Orders', ENN = 'Outstanding Purchase Orders';

            //Unsupported feature: Change Description on ""Outstanding Purchase Orders"(Field 4)". Please convert manually.

        }
        field(50000; "Pending Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = FILTER(Invoice),
                                                         "Responsibility Center" = FIELD("Responsibility Center Filter")));
            Description = 'RDK 29-08-2019';
            FieldClass = FlowField;
        }
        field(50001; "Invoices Due in Next Week"; Decimal)
        {
            Description = 'RDK 29-08-2019';
        }
    }
    PROCEDURE CalculateDueNextWeek() SAMT: Decimal;
    VAR
        PINVH: Record 122;
        PINV: Record 123;
        dt: Date;
    BEGIN
        PINVH.SETRANGE("Due Date", TODAY, CALCDATE('0D+1W', TODAY));
        //PINVH.SETFILTER("Location Code",LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF PINVH.FINDSET THEN
            REPEAT
                PINV.SETRANGE("Document No.", PINVH."No.");
                IF PINV.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += (PINV.Amount * PINVH."Currency Factor");
                    UNTIL PINV.NEXT = 0;
            UNTIL PINVH.NEXT = 0;
        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

}

