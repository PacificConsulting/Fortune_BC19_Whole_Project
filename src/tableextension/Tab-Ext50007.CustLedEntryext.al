tableextension 50007 "Cust_Led_Entry_ext" extends "Cust. Ledger Entry"
{
    // version TFS225977

    fields
    {
        field(50021; "Vertical Category"; Code[50])
        {
            Description = 'CCIT';
        }
        field(50022; "Vertical Sub Category"; Code[50])
        {
            Description = 'CCIT';
        }
        field(50023; "Outlet Name"; Text[50])
        {
            Description = 'CCIT';
        }
        field(50025; "Business Format / Outlet Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50026; "Ref. Invoice No."; Code[20])
        {
            CalcFormula = Lookup("Sales Cr.Memo Header"."Applies-to Doc. No." WHERE("No." = FIELD("Document No."),
                                                                                     "Posting Date" = FIELD("Posting Date"),
                                                                                     "Sell-to Customer No." = FIELD("Sell-to Customer No.")));
            Description = 'CCIT AN';
            FieldClass = FlowField;
        }
        field(50027; "Tally Inv. No."; Code[30])
        {
            CalcFormula = Lookup("Sales Cr.Memo Header"."Tally Invoice No." WHERE("No." = FIELD("Document No."),
                                                                                   "Posting Date" = FIELD("Posting Date"),
                                                                                   "Sell-to Customer No." = FIELD("Sell-to Customer No.")));
            Description = 'CCIT AN';
            FieldClass = FlowField;
        }
        field(50028; "Item Charges Invoice"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line"."Line Amount" WHERE("Document No." = FIELD("Document No."),
                                                                        Type = FILTER('Charge (Item)'),
                                                                        "Sell-to Customer No." = FIELD("Customer No.")));
            Description = 'CCIT SUD';
            FieldClass = FlowField;
        }
    }

    PROCEDURE CalcAppliedTCSBase(AppliedAmount: Decimal; TCSNatureofCollection: Code[10]): Decimal;
    VAR
        TCSEntry: Record 18810;
        ApplicationRatio: Decimal;
        TCSBaseAmount: Decimal;
    BEGIN
        CALCFIELDS(Amount);
        IF Amount = 0 THEN
            EXIT(0);
        TCSEntry.SETCURRENTKEY("Transaction No.", "TCS Nature of Collection");
        TCSEntry.SETRANGE("Transaction No.", "Transaction No.");
        TCSEntry.SETRANGE("TCS Nature of Collection", TCSNatureofCollection);
        IF TCSEntry.FINDSET THEN
            REPEAT
                IF TCSEntry."TCS Base Amount" = 0 THEN
                    TCSBaseAmount += 0//TCSEntry."Work Tax Base Amount"
                ELSE
                    TCSBaseAmount += TCSEntry."TCS Base Amount" + TCSEntry."Total TCS Including SHE CESS";
            UNTIL TCSEntry.NEXT = 0;

        IF ABS(AppliedAmount) >= TCSBaseAmount THEN
            ApplicationRatio := 1
        ELSE
            ApplicationRatio := AppliedAmount / TCSBaseAmount;

        EXIT(ROUND(TCSBaseAmount * ApplicationRatio));
    END;


    var
        Location: Record 14;



}

