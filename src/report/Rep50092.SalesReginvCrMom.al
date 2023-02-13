report 50092 "Sales Reg inv-Cr Mom"
{
    // version RDK original

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Reg inv-Cr Mom.rdl';
    ProcessingOnly = false;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Cust; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Salesperson Code";
            dataitem(SIH; "Sales Invoice Header")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Sell-to Customer No.");
                dataitem(SIL; "Sales Invoice Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        WHERE(Quantity = FILTER(<> 0),
                                              Type = FILTER(Item));

                    trigger OnAfterGetRecord();
                    begin
                        IF SIL.Quantity = 0 THEN
                            CurrReport.SKIP;

                        IF NOT Temp_CustItemMom.GET(SIL."Sell-to Customer No.", SIL."No.") THEN BEGIN
                            Temp_CustItemMom.INIT;
                            Temp_CustItemMom."Code 1" := SIL."Sell-to Customer No.";
                            Temp_CustItemMom."Code 2" := SIL."No.";
                            Temp_CustItemMom."Unit of Measure Code" := SIL."Unit of Measure Code";

                            IF (SIL."Posting Date" >= MonthFrom_Date[1]) AND (SIL."Posting Date" <= MonthTo_date[1]) THEN BEGIN
                                Temp_CustItemMom."Month 1 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 1 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 1 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[2]) AND (SIL."Posting Date" <= MonthTo_date[2]) THEN BEGIN
                                Temp_CustItemMom."Month 2 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 2 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 2 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[3]) AND (SIL."Posting Date" <= MonthTo_date[3]) THEN BEGIN
                                Temp_CustItemMom."Month 3 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 3 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 3 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[4]) AND (SIL."Posting Date" <= MonthTo_date[4]) THEN BEGIN
                                Temp_CustItemMom."Month 4 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 4 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 4 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[5]) AND (SIL."Posting Date" <= MonthTo_date[5]) THEN BEGIN
                                Temp_CustItemMom."Month 5 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 5 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 5 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[6]) AND (SIL."Posting Date" <= MonthTo_date[6]) THEN BEGIN
                                Temp_CustItemMom."Month 6 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 6 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 6 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[7]) AND (SIL."Posting Date" <= MonthTo_date[7]) THEN BEGIN
                                Temp_CustItemMom."Month 7 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 7 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 7 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[8]) AND (SIL."Posting Date" <= MonthTo_date[8]) THEN BEGIN
                                Temp_CustItemMom."Month 8 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 8 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 8 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[9]) AND (SIL."Posting Date" <= MonthTo_date[9]) THEN BEGIN
                                Temp_CustItemMom."Month 9 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 9 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 9 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[10]) AND (SIL."Posting Date" <= MonthTo_date[10]) THEN BEGIN
                                Temp_CustItemMom."Month 10 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 10 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 10 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[11]) AND (SIL."Posting Date" <= MonthTo_date[11]) THEN BEGIN
                                Temp_CustItemMom."Month 11 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 11 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 11 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[12]) AND (SIL."Posting Date" <= MonthTo_date[12]) THEN BEGIN
                                Temp_CustItemMom."Month 12 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 12 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 12 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            Temp_CustItemMom.INSERT;
                        END
                        ELSE BEGIN
                            Temp_CustItemMom."Unit of Measure Code" := SIL."Unit of Measure Code";
                            IF (SIL."Posting Date" >= MonthFrom_Date[1]) AND (SIL."Posting Date" <= MonthTo_date[1]) THEN BEGIN
                                Temp_CustItemMom."Month 1 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 1 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 1 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[2]) AND (SIL."Posting Date" <= MonthTo_date[2]) THEN BEGIN
                                Temp_CustItemMom."Month 2 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 2 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 2 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[3]) AND (SIL."Posting Date" <= MonthTo_date[3]) THEN BEGIN
                                Temp_CustItemMom."Month 3 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 3 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 3 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[4]) AND (SIL."Posting Date" <= MonthTo_date[4]) THEN BEGIN
                                Temp_CustItemMom."Month 4 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 4 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 4 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[5]) AND (SIL."Posting Date" <= MonthTo_date[5]) THEN BEGIN
                                Temp_CustItemMom."Month 5 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 5 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 5 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[6]) AND (SIL."Posting Date" <= MonthTo_date[6]) THEN BEGIN
                                Temp_CustItemMom."Month 6 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 6 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 6 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[7]) AND (SIL."Posting Date" <= MonthTo_date[7]) THEN BEGIN
                                Temp_CustItemMom."Month 7 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 7 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 7 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[8]) AND (SIL."Posting Date" <= MonthTo_date[8]) THEN BEGIN
                                Temp_CustItemMom."Month 8 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 8 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 8 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[9]) AND (SIL."Posting Date" <= MonthTo_date[9]) THEN BEGIN
                                Temp_CustItemMom."Month 9 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 9 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 9 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[10]) AND (SIL."Posting Date" <= MonthTo_date[10]) THEN BEGIN
                                Temp_CustItemMom."Month 10 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 10 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 10 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[11]) AND (SIL."Posting Date" <= MonthTo_date[11]) THEN BEGIN
                                Temp_CustItemMom."Month 11 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 11 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 11 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            IF (SIL."Posting Date" >= MonthFrom_Date[12]) AND (SIL."Posting Date" <= MonthTo_date[12]) THEN BEGIN
                                Temp_CustItemMom."Month 12 Amount" += SIL.Amount;
                                Temp_CustItemMom."Month 12 Qty" += SIL."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 12 Qty Kgs" += SIL.Quantity //kgs
                            END;

                            Temp_CustItemMom.MODIFY;
                        END;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SIL.SETRANGE("Posting Date", MonthFrom_Date[1], MonthTo_date[12]);
                    end;
                }

                trigger OnPreDataItem();
                begin
                    SIH.SETRANGE("Posting Date", MonthFrom_Date[1], MonthTo_date[12]);
                end;
            }
            dataitem(SCMH; "Sales Cr.Memo Header")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Sell-to Customer No.");
                dataitem(SCML; "Sales Cr.Memo Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        WHERE(Quantity = FILTER(<> 0),
                                              Type = FILTER(Item));

                    trigger OnAfterGetRecord();
                    begin
                        IF SCML.Quantity = 0 THEN
                            CurrReport.SKIP;

                        IF NOT Temp_CustItemMom.GET(SCML."Sell-to Customer No.", SCML."No.") THEN BEGIN
                            Temp_CustItemMom.INIT;
                            Temp_CustItemMom."Code 1" := SCML."Sell-to Customer No.";
                            Temp_CustItemMom."Code 2" := SCML."No.";
                            Temp_CustItemMom."Unit of Measure Code" := SCML."Unit of Measure Code";

                            IF (SCML."Posting Date" >= MonthFrom_Date[1]) AND (SCML."Posting Date" <= MonthTo_date[1]) THEN BEGIN
                                Temp_CustItemMom."Month 1 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 1 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 1 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[2]) AND (SCML."Posting Date" <= MonthTo_date[2]) THEN BEGIN
                                Temp_CustItemMom."Month 2 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 2 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 2 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[3]) AND (SCML."Posting Date" <= MonthTo_date[3]) THEN BEGIN
                                Temp_CustItemMom."Month 3 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 3 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 3 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[4]) AND (SCML."Posting Date" <= MonthTo_date[4]) THEN BEGIN
                                Temp_CustItemMom."Month 4 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 4 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 4 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[5]) AND (SCML."Posting Date" <= MonthTo_date[5]) THEN BEGIN
                                Temp_CustItemMom."Month 5 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 5 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 5 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[6]) AND (SCML."Posting Date" <= MonthTo_date[6]) THEN BEGIN
                                Temp_CustItemMom."Month 6 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 6 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 6 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[7]) AND (SCML."Posting Date" <= MonthTo_date[7]) THEN BEGIN
                                Temp_CustItemMom."Month 7 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 7 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 7 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[8]) AND (SCML."Posting Date" <= MonthTo_date[8]) THEN BEGIN
                                Temp_CustItemMom."Month 8 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 8 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 8 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[9]) AND (SCML."Posting Date" <= MonthTo_date[9]) THEN BEGIN
                                Temp_CustItemMom."Month 9 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 9 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 9 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[10]) AND (SCML."Posting Date" <= MonthTo_date[10]) THEN BEGIN
                                Temp_CustItemMom."Month 10 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 10 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 10 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[11]) AND (SCML."Posting Date" <= MonthTo_date[11]) THEN BEGIN
                                Temp_CustItemMom."Month 11 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 11 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 11 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[12]) AND (SCML."Posting Date" <= MonthTo_date[12]) THEN BEGIN
                                Temp_CustItemMom."Month 12 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 12 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 12 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            Temp_CustItemMom.INSERT;
                        END
                        ELSE BEGIN
                            IF (SCML."Posting Date" >= MonthFrom_Date[1]) AND (SCML."Posting Date" <= MonthTo_date[1]) THEN BEGIN
                                Temp_CustItemMom."Month 1 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 1 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 1 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[2]) AND (SCML."Posting Date" <= MonthTo_date[2]) THEN BEGIN
                                Temp_CustItemMom."Month 2 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 2 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 2 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[3]) AND (SCML."Posting Date" <= MonthTo_date[3]) THEN BEGIN
                                Temp_CustItemMom."Month 3 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 3 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 3 Qty Kgs" -= SCML.Quantity;//kgs
                            END;


                            IF (SCML."Posting Date" >= MonthFrom_Date[4]) AND (SCML."Posting Date" <= MonthTo_date[4]) THEN BEGIN
                                Temp_CustItemMom."Month 4 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 4 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 4 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[5]) AND (SCML."Posting Date" <= MonthTo_date[5]) THEN BEGIN
                                Temp_CustItemMom."Month 5 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 5 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 5 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[6]) AND (SCML."Posting Date" <= MonthTo_date[6]) THEN BEGIN
                                Temp_CustItemMom."Month 6 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 6 Qty" -= SCML."Conversion Qty";//pcs
                                Temp_CustItemMom."Month 6 Qty Kgs" -= SCML.Quantity;//kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[7]) AND (SCML."Posting Date" <= MonthTo_date[7]) THEN BEGIN
                                Temp_CustItemMom."Month 7 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 7 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 7 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[8]) AND (SCML."Posting Date" <= MonthTo_date[8]) THEN BEGIN
                                Temp_CustItemMom."Month 8 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 8 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 8 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[9]) AND (SCML."Posting Date" <= MonthTo_date[9]) THEN BEGIN
                                Temp_CustItemMom."Month 9 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 9 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 9 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[10]) AND (SCML."Posting Date" <= MonthTo_date[10]) THEN BEGIN
                                Temp_CustItemMom."Month 10 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 10 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 10 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[11]) AND (SCML."Posting Date" <= MonthTo_date[11]) THEN BEGIN
                                Temp_CustItemMom."Month 11 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 11 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 11 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            IF (SCML."Posting Date" >= MonthFrom_Date[12]) AND (SCML."Posting Date" <= MonthTo_date[12]) THEN BEGIN
                                Temp_CustItemMom."Month 12 Amount" -= SCML.Amount;
                                Temp_CustItemMom."Month 12 Qty" -= SCML."Conversion Qty"; //pcs
                                Temp_CustItemMom."Month 12 Qty Kgs" -= SCML.Quantity //kgs
                            END;

                            Temp_CustItemMom.MODIFY;
                        END;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SCML.SETRANGE("Posting Date", MonthFrom_Date[1], MonthTo_date[12]);
                    end;
                }

                trigger OnPreDataItem();
                begin
                    SCMH.SETRANGE("Posting Date", MonthFrom_Date[1], MonthTo_date[12]);
                end;
            }

            trigger OnPreDataItem();
            begin
                CLEAR(LocCode);
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    Cust.SETFILTER(Cust."Location Code", LocCodeText);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("As On Date"; AsOnDate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin

        Temp_CustItemMom.RESET;
        IF Temp_CustItemMom.COUNT <> 0 THEN BEGIN
            Temp_CustItemMom.FINDSET;
            XCCD := Temp_CustItemMom."Code 1";
            REPEAT
                CCD := Temp_CustItemMom."Code 1";

                IF CCD <> XCCD THEN BEGIN
                    /*
                    MakeExcelDataBodyTotal;
                    FOR CtrTtl := 1 TO 12 DO BEGIN
                      CustTotalAmount[CtrTtl]:=0;
                      CustTotalQty[CtrTtl] :=0;
                      CustTotalQtyKgs[CtrTtl] := 0;
                    END;

                    CustTotalAmount[1]:=0;
                    CustTotalQty[1] :=0;
                    CustTotalQtyKgs[1] := 0;
                    CustTotalAmount[2] :=0;
                    CustTotalQty[2] :=0;
                    CustTotalQtyKgs[2] := 0;
                    CustTotalAmount[3] :=0;
                    CustTotalQty[3] :=0;
                    CustTotalQtyKgs[3] := 0;
                    CustTotalAmount[4] :=0;
                    CustTotalQty[4] :=0;
                    CustTotalQtyKgs[4] := 0;
                    CustTotalAmount[5] :=0;
                    CustTotalQty[5] :=0;
                    CustTotalQtyKgs[5] := 0;
                    CustTotalAmount[6] :=0;
                    CustTotalQty[6] :=0;
                    CustTotalQtyKgs[6] := 0;
                    */
                END;

                BEGIN
                    MakeExcelDataBody;

                    CustTotalAmount[1] += Temp_CustItemMom."Month 1 Amount";
                    CustTotalQty[1] += Temp_CustItemMom."Month 1 Qty";
                    CustTotalQtyKgs[1] += Temp_CustItemMom."Month 1 Qty Kgs";

                    CustTotalAmount[2] += Temp_CustItemMom."Month 2 Amount";
                    CustTotalQty[2] += Temp_CustItemMom."Month 2 Qty";
                    CustTotalQtyKgs[2] += Temp_CustItemMom."Month 2 Qty Kgs";

                    CustTotalAmount[3] += Temp_CustItemMom."Month 3 Amount";
                    CustTotalQty[3] += Temp_CustItemMom."Month 3 Qty";
                    CustTotalQtyKgs[3] += Temp_CustItemMom."Month 3 Qty Kgs";

                    CustTotalAmount[4] += Temp_CustItemMom."Month 4 Amount";
                    CustTotalQty[4] += Temp_CustItemMom."Month 4 Qty";
                    CustTotalQtyKgs[4] += Temp_CustItemMom."Month 4 Qty Kgs";

                    CustTotalAmount[5] += Temp_CustItemMom."Month 5 Amount";
                    CustTotalQty[5] += Temp_CustItemMom."Month 5 Qty";
                    CustTotalQtyKgs[5] += Temp_CustItemMom."Month 5 Qty Kgs";

                    CustTotalAmount[6] += Temp_CustItemMom."Month 6 Amount";
                    CustTotalQty[6] += Temp_CustItemMom."Month 6 Qty";
                    CustTotalQtyKgs[6] += Temp_CustItemMom."Month 6 Qty Kgs";

                    CustTotalAmount[7] += Temp_CustItemMom."Month 7 Amount";
                    CustTotalQty[7] += Temp_CustItemMom."Month 7 Qty";
                    CustTotalQtyKgs[7] += Temp_CustItemMom."Month 7 Qty Kgs";

                    CustTotalAmount[8] += Temp_CustItemMom."Month 8 Amount";
                    CustTotalQty[8] += Temp_CustItemMom."Month 8 Qty";
                    CustTotalQtyKgs[8] += Temp_CustItemMom."Month 8 Qty Kgs";

                    CustTotalAmount[9] += Temp_CustItemMom."Month 9 Amount";
                    CustTotalQty[9] += Temp_CustItemMom."Month 9 Qty";
                    CustTotalQtyKgs[9] += Temp_CustItemMom."Month 9 Qty Kgs";

                    CustTotalAmount[10] += Temp_CustItemMom."Month 10 Amount";
                    CustTotalQty[10] += Temp_CustItemMom."Month 10 Qty";
                    CustTotalQtyKgs[10] += Temp_CustItemMom."Month 10 Qty Kgs";

                    CustTotalAmount[11] += Temp_CustItemMom."Month 11 Amount";
                    CustTotalQty[11] += Temp_CustItemMom."Month 11 Qty";
                    CustTotalQtyKgs[11] += Temp_CustItemMom."Month 11 Qty Kgs";

                    CustTotalAmount[12] += Temp_CustItemMom."Month 12 Amount";
                    CustTotalQty[12] += Temp_CustItemMom."Month 12 Qty";
                    CustTotalQtyKgs[12] += Temp_CustItemMom."Month 12 Qty Kgs";


                    XCCD := Temp_CustItemMom."Code 1";
                END
            UNTIL Temp_CustItemMom.NEXT = 0;
            MakeExcelDataBodyTotal;
        END;

        CreateExcelbook;

    end;

    trigger OnPreReport();
    begin

        From_date := CALCDATE('-11M', AsOnDate);
        To_date := CALCDATE('CM', AsOnDate);


        MonthFrom_Date[1] := CALCDATE('-CM', From_date);
        MonthTo_date[1] := CALCDATE('CM', From_date);
        MonthFrom_Date[2] := CALCDATE('CM+1M-CM', MonthFrom_Date[1]);
        MonthTo_date[2] := CALCDATE('CM', MonthFrom_Date[2]);
        MonthFrom_Date[3] := CALCDATE('CM+1M-CM', MonthFrom_Date[2]);
        MonthTo_date[3] := CALCDATE('CM', MonthFrom_Date[3]);
        MonthFrom_Date[4] := CALCDATE('CM+1M-CM', MonthFrom_Date[3]);
        MonthTo_date[4] := CALCDATE('CM', MonthFrom_Date[4]);
        MonthFrom_Date[5] := CALCDATE('CM+1M-CM', MonthFrom_Date[4]);
        MonthTo_date[5] := CALCDATE('CM', MonthFrom_Date[5]);
        MonthFrom_Date[6] := CALCDATE('CM+1M-CM', MonthFrom_Date[5]);
        MonthTo_date[6] := CALCDATE('CM', MonthFrom_Date[6]);
        MonthFrom_Date[7] := CALCDATE('CM+1M-CM', MonthFrom_Date[6]);
        MonthTo_date[7] := CALCDATE('CM', MonthFrom_Date[7]);

        MonthFrom_Date[8] := CALCDATE('CM+1M-CM', MonthFrom_Date[7]);
        MonthTo_date[8] := CALCDATE('CM', MonthFrom_Date[8]);

        MonthFrom_Date[9] := CALCDATE('CM+1M-CM', MonthFrom_Date[8]);
        MonthTo_date[9] := CALCDATE('CM', MonthFrom_Date[9]);

        MonthFrom_Date[10] := CALCDATE('CM+1M-CM', MonthFrom_Date[9]);
        MonthTo_date[10] := CALCDATE('CM', MonthFrom_Date[10]);

        MonthFrom_Date[11] := CALCDATE('CM+1M-CM', MonthFrom_Date[10]);
        MonthTo_date[11] := CALCDATE('CM', MonthFrom_Date[11]);

        MonthFrom_Date[12] := CALCDATE('CM-CM', AsOnDate);
        MonthTo_date[12] := To_date;

        MakeExcelDataHeader;
    end;

    var
        Temp_CustItemMom: Record 50034 temporary;
        ExcelBuf: Record 370 temporary;
        Rec_Cust: Record 18;
        Rec_Item: Record 27;
        RecUserBranch: Record 50029;
        RecSalesperson: Record 13;
        AsOnDate: Date;
        From_date: Date;
        To_date: Date;
        MonthYear: Text[20];
        MonthFrom_Date: array[12] of Date;
        MonthTo_date: array[12] of Date;
        SalesQty: array[12] of Decimal;
        SalesAmt: array[12] of Decimal;
        Cust_Item: Option Customer,Item;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        MonthDateChr: array[12] of Text[50];
        CCD: Code[20];
        XCCD: Code[20];
        CustTotalQty: array[12] of Decimal;
        CustTotalAmount: array[12] of Decimal;
        CustTotalQtyKgs: array[12] of Decimal;
        CustItemTotalQty: Decimal;
        CustitemTotalAmount: Decimal;
        CustItemTotalQtyKgs: Decimal;
        CtrTtl: Integer;
        MnthTxt: array[12] of Text[50];

    procedure MakeExcelInfo();
    begin
    end;

    procedure CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\SalesMoM.xlsx', 'SalesMoM', 'SalesMoM', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\SalesMoM.xlsx', 'SalesMoM', 'SalesMoM', COMPANYNAME, USERID);
        //PCPL/MIG/NSW Filed not Exist in BC18
    end;

    procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Customer Item Month On Month', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date :' + FORMAT(MonthFrom_Date[1]) + '  To  ' + FORMAT(MonthTo_date[12]), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('Customer Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cust.Creation Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Cust.Mst.Sales Person', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Reporting Field', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Unit of Measure', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[1] := FORMAT(MonthFrom_Date[1], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[1] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[1] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[1] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[2] := FORMAT(MonthFrom_Date[2], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[2] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[2] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[2] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[3] := FORMAT(MonthFrom_Date[3], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[3] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[3] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[3] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[4] := FORMAT(MonthFrom_Date[4], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[4] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[4] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[4] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[5] := FORMAT(MonthFrom_Date[5], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[5] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[5] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[5] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[6] := FORMAT(MonthFrom_Date[6], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[6] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[6] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[6] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[7] := FORMAT(MonthFrom_Date[7], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[7] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[7] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[7] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[8] := FORMAT(MonthFrom_Date[8], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[8] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[8] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[8] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[9] := FORMAT(MonthFrom_Date[9], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[9] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[9] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[9] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[10] := FORMAT(MonthFrom_Date[10], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[10] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[10] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[10] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);


        MonthDateChr[11] := FORMAT(MonthFrom_Date[11], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[11] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[11] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[11] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        MonthDateChr[12] := FORMAT(MonthFrom_Date[12], 0, '<Month Text,3> <Year,2>');

        ExcelBuf.AddColumn(MonthDateChr[12] + ' Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[12] + ' Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(MonthDateChr[12] + ' Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('Total Qty Kgs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Qty PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    begin
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn(Temp_CustItemMom."Code 1", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        IF Rec_Cust.GET(Temp_CustItemMom."Code 1") THEN BEGIN
            ExcelBuf.AddColumn(Rec_Cust.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Rec_Cust."Created Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            IF RecSalesperson.GET(Rec_Cust."Salesperson Code") THEN
                ExcelBuf.AddColumn(RecSalesperson.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
            ELSE
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

            ExcelBuf.AddColumn(Rec_Cust."Sales Reporting Field", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Rec_Cust."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        END
        ELSE BEGIN
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        END;

        ExcelBuf.AddColumn(Temp_CustItemMom."Code 2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        IF Rec_Item.GET(Temp_CustItemMom."Code 2") THEN
            ExcelBuf.AddColumn(Rec_Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Temp_CustItemMom."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 1 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 1 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 1 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 2 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 2 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 2 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 3 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 3 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 3 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 4 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 4 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 4 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 5 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 5 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 5 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 6 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 6 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 6 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 7 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 7 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 7 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 8 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 8 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 8 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 9 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 9 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 9 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 10 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 10 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 10 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 11 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 11 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 11 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(Temp_CustItemMom."Month 12 Qty Kgs", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 12 Qty", FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Temp_CustItemMom."Month 12 Amount", FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        CustItemTotalQtyKgs := Temp_CustItemMom."Month 1 Qty Kgs" + Temp_CustItemMom."Month 2 Qty Kgs" + Temp_CustItemMom."Month 3 Qty Kgs" +
                               Temp_CustItemMom."Month 4 Qty Kgs" + Temp_CustItemMom."Month 5 Qty Kgs" + Temp_CustItemMom."Month 6 Qty Kgs" +
                               Temp_CustItemMom."Month 7 Qty Kgs" + Temp_CustItemMom."Month 8 Qty Kgs" + Temp_CustItemMom."Month 9 Qty Kgs" +
                               Temp_CustItemMom."Month 10 Qty Kgs" + Temp_CustItemMom."Month 11 Qty Kgs" + Temp_CustItemMom."Month 12 Qty Kgs";

        CustItemTotalQty := Temp_CustItemMom."Month 1 Qty" + Temp_CustItemMom."Month 2 Qty" + Temp_CustItemMom."Month 3 Qty"
                            + Temp_CustItemMom."Month 4 Qty" + Temp_CustItemMom."Month 5 Qty" + Temp_CustItemMom."Month 6 Qty"
                            + Temp_CustItemMom."Month 7 Qty" + Temp_CustItemMom."Month 8 Qty" + Temp_CustItemMom."Month 9 Qty"
                            + Temp_CustItemMom."Month 10 Qty" + Temp_CustItemMom."Month 11 Qty" + Temp_CustItemMom."Month 12 Qty";

        CustitemTotalAmount := Temp_CustItemMom."Month 1 Amount" + Temp_CustItemMom."Month 2 Amount" +
                               Temp_CustItemMom."Month 3 Amount" + Temp_CustItemMom."Month 4 Amount" +
                               Temp_CustItemMom."Month 5 Amount" + Temp_CustItemMom."Month 6 Amount" +
                               Temp_CustItemMom."Month 7 Amount" + Temp_CustItemMom."Month 8 Amount" +
                               Temp_CustItemMom."Month 9 Amount" + Temp_CustItemMom."Month 10 Amount" +
                               Temp_CustItemMom."Month 11 Amount" + Temp_CustItemMom."Month 12 Amount";

        ExcelBuf.AddColumn(CustItemTotalQtyKgs, FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustItemTotalQty, FALSE, '', FALSE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustitemTotalAmount, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
    end;

    procedure MakeExcelDataFooter();
    begin
    end;

    procedure MakeExcelInfo1();
    begin
    end;

    procedure MakeExcelDataHeader1();
    begin
    end;

    procedure MakeExcelDataBodyTotal();
    begin
        ExcelBuf.NewRow;

        //ExcelBuf.AddColumn(XCCD,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        /*IF Rec_Cust.GET(XCCD) THEN
          ExcelBuf.AddColumn(Rec_Cust.Name,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text)
        ELSE
        */
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        FOR CtrTtl := 1 TO 12 DO BEGIN
            ExcelBuf.AddColumn(CustTotalQtyKgs[CtrTtl], FALSE, '', TRUE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(CustTotalQty[CtrTtl], FALSE, '', TRUE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(CustTotalAmount[CtrTtl], FALSE, '', TRUE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        END;

        /*
        ExcelBuf.AddColumn(CustTotalQtyKgs[1],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[1],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[1],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn(CustTotalQtyKgs[2],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[2],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[2],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn(CustTotalQtyKgs[3],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[3],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[3],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn(CustTotalQtyKgs[4],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[4],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[4],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn(CustTotalQtyKgs[5],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[5],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[5],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        
        ExcelBuf.AddColumn(CustTotalQtyKgs[6],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalQty[6],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustTotalAmount[6],FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        */

        CustItemTotalQtyKgs := 0;
        CustItemTotalQty := 0;
        CustitemTotalAmount := 0;


        FOR CtrTtl := 1 TO 12 DO BEGIN
            CustItemTotalQtyKgs += CustTotalQtyKgs[CtrTtl];
            CustItemTotalQty += CustTotalQty[CtrTtl];
            CustitemTotalAmount += CustTotalAmount[CtrTtl];
        END;

        /*
        CustItemTotalQtyKgs := CustTotalQtyKgs[1] + CustTotalQtyKgs[2] + CustTotalQtyKgs[3] +
                               CustTotalQtyKgs[4] + CustTotalQtyKgs[5] + CustTotalQtyKgs[6] ;
        
        CustItemTotalQty := CustTotalQty[1] + CustTotalQty[2] + CustTotalQty[3] + CustTotalQty[4] +
                            CustTotalQty[5] + CustTotalQty[6];
        
        CustitemTotalAmount := CustTotalAmount[1] + CustTotalAmount[2] +CustTotalAmount[3] +
                               CustTotalAmount[4] + CustTotalAmount[5] +CustTotalAmount[6];
        */

        ExcelBuf.AddColumn(CustItemTotalQtyKgs, FALSE, '', TRUE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustItemTotalQty, FALSE, '', TRUE, FALSE, FALSE, '#,##0.000', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CustitemTotalAmount, FALSE, '', TRUE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.NewRow;

    end;

    procedure MakeExcelDataFooter1();
    begin
    end;
}

