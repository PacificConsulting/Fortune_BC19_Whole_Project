tableextension 50469 "Sales_Cue_ext" extends "Sales Cue"
{
    // version NAVW19.00.00.47042

    fields
    {
        field(50001; "Loc filter"; Code[250])
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50002; "Sales This Month"; Decimal)
        {
            AccessByPermission = TableData 113 = R;
            Editable = false;
        }
        field(50003; "Sales Cr Memo This Month"; Decimal)
        {
        }
        field(50004; "Invoices Due Next Week"; Decimal)
        {
        }
        field(50005; "PDC Open cheques"; Decimal)
        {
            AccessByPermission = TableData 50036 = R;
            Editable = false;
        }
        field(50006; "Horeca Sales"; Decimal)
        {
        }
        field(50007; "Retail Sales"; Decimal)
        {
        }
        field(50008; Traders; Decimal)
        {
        }
        field(50009; "Horeca CM"; Decimal)
        {
        }
        field(50010; "Retail CM"; Decimal)
        {
        }
        field(50011; "Traders CM"; Decimal)
        {
        }
    }
    PROCEDURE SetLocationFilter();
    BEGIN
        CLEAR(LocCode);
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                LocCode := LocCode + '|' + RecUserBranch."Location Code";
            UNTIL RecUserBranch.NEXT = 0;

        LocCodeText := DELCHR(LocCode, '<', '|');

        IF LocCodeText <> '' THEN
            SETRANGE("Loc filter", LocCodeText);
    END;

    PROCEDURE CalculateSalesThisMonth() SAMT: Decimal;
    VAR
        SINV: Record 113;
        SINVH: Record 112;
    BEGIN
        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SINVH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SINVH.FINDSET THEN
            REPEAT
                SINV.SETRANGE("Document No.", SINVH."No.");
                IF SINV.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SINV.Amount;
                    UNTIL SINV.NEXT = 0;
            UNTIL SINVH.NEXT = 0;
        SAMT := ROUND(SAMT / 100000, 0.01, '=');

        //   {
        //   SINVH.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        //   SINVH.SETFILTER("Location Code",LocCodeText);
        //   IF SINVH.FINDSET THEN
        //     SINV.
        //     REPEAT
        //       //SINV.CALCSUMS(SINV.Amount);
        //       SAMT += SINV.Amount;
        //     UNTIL SINV.NEXT = 0;

        //   SAMT := ROUND(SAMT / 100000,0.01,'=');
        //   }
    END;

    PROCEDURE CalculateSCNThisMonth() SCMAMT: Decimal;
    VAR
        SCM: Record 115;
        dt: Date;
    BEGIN
        SCM.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SCM.SETFILTER("Location Code", LocCodeText);
        IF SCM.FINDSET THEN
            REPEAT
                //SINV.CALCSUMS(SINV.Amount);
                SCMAMT += SCM.Amount;
            UNTIL SCM.NEXT = 0;

        SCMAMT := ROUND(SCMAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateDueNextWeek() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SINV: Record 113;
        dt: Date;
    BEGIN
        SINVH.SETRANGE("Due Date", TODAY, CALCDATE('0D+1W', TODAY));
        SINVH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SINVH.FINDSET THEN
            REPEAT
                SINV.SETRANGE("Document No.", SINVH."No.");
                IF SINV.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SINV.Amount;
                    UNTIL SINV.NEXT = 0;
            UNTIL SINVH.NEXT = 0;
        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE "CalculatePending PDCs"() SAMT: Decimal;
    VAR
        PDC: Record 50036;
        dt: Date;
    BEGIN
        PDC.SETRANGE("Creation Date", CALCDATE('-CM', TODAY), TODAY);
        PDC.SETRANGE(Open, TRUE);
        PDC.SETFILTER("Cust.Location", LocCodeText);
        IF PDC.FINDSET THEN
            REPEAT
                //SINV.CALCSUMS(SINV.Amount);
                SAMT += PDC."Cheque Amount";
            UNTIL PDC.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateHORECASales() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SINVH.SETFILTER("Customer Posting Group", '%1', 'HORECA');
        SINVH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SINVH.FINDSET THEN
            REPEAT
                SINVL.SETRANGE("Document No.", SINVH."No.");
                IF SINVL.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SINVL.Amount;
                    UNTIL SINVL.NEXT = 0;
            UNTIL SINVH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateRETAILSales() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SINVH.SETFILTER("Customer Posting Group", '%1', 'RETAIL');
        SINVH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SINVH.FINDSET THEN
            REPEAT
                SINVL.SETRANGE("Document No.", SINVH."No.");
                IF SINVL.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SINVL.Amount;
                    UNTIL SINVL.NEXT = 0;
            UNTIL SINVH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateTRADERSales() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SINVH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SINVH.SETFILTER("Customer Posting Group", '%1', 'TRADER');
        SINVH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SINVH.FINDSET THEN
            REPEAT
                SINVL.SETRANGE("Document No.", SINVH."No.");
                IF SINVL.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SINVL.Amount;
                    UNTIL SINVL.NEXT = 0;
            UNTIL SINVH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateHORECACM() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SCMH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SCMH.SETFILTER("Customer Posting Group", '%1', 'HORECA');
        SCMH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SCMH.FINDSET THEN
            REPEAT
                SCML.SETRANGE("Document No.", SCMH."No.");
                IF SCML.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SCML.Amount;
                    UNTIL SCML.NEXT = 0;
            UNTIL SCMH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateRETAILCM() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SCMH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SCMH.SETFILTER("Customer Posting Group", '%1', 'RETAIL');
        SCMH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SCMH.FINDSET THEN
            REPEAT
                SCML.SETRANGE("Document No.", SCMH."No.");
                IF SCML.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SCML.Amount;
                    UNTIL SCML.NEXT = 0;
            UNTIL SCMH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;

    PROCEDURE CalculateTRADERCM() SAMT: Decimal;
    VAR
        SINVH: Record 112;
        SCMH: Record 114;
        SINVL: Record 113;
        SCML: Record 115;
    BEGIN
        SCMH.SETRANGE("Posting Date", CALCDATE('-CM', TODAY), TODAY);
        SCMH.SETFILTER("Customer Posting Group", '%1', 'TRADER');
        SCMH.SETFILTER("Location Code", LocCodeText);
        //SINV.SETRANGE("Posting Date",CALCDATE('-CM',TODAY),TODAY);
        IF SCMH.FINDSET THEN
            REPEAT
                SCML.SETRANGE("Document No.", SCMH."No.");
                IF SCML.FINDSET THEN
                    REPEAT
                        //SINV.CALCSUMS(SINV.Amount);
                        SAMT += SCML.Amount;
                    UNTIL SCML.NEXT = 0;
            UNTIL SCMH.NEXT = 0;

        SAMT := ROUND(SAMT / 100000, 0.01, '=');
    END;


    var
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
}

