codeunit 50003 "Item Jnl Reclass"
{

    trigger OnRun();
    begin
        InsertItemReclass;
    end;

    var
        RecILE: Record 32;
        RecItemJnlLine: Record 83;
        ItemJnlBatch: Record 233;
        NoSeriesMgt: Codeunit 396;
        IJL: Record 83;
        LineNo: Integer;
        RecLoc: Record 14;
        RecLocBlock: Record 14;
        LocBlock: Code[20];
        recResEntry: Record 337;
        lastEntryNo: Integer;
        LastrecResEntry: Record 337;
        Loc: Record 14;
        RecDimValue: Record 349;
        RecLocation: Record 14;

    procedure InsertItemReclass();
    begin

        Loc.RESET;
        Loc.SETRANGE(Loc."Use As In-Transit", FALSE);
        //Loc.SETFILTER(Code,'<>%1|<>%2','@*BB*','@*BLOC*');
        Loc.SETFILTER(Code, '<>%1', '@*BB*');
        IF Loc.FINDFIRST THEN
            REPEAT
                RecILE.RESET;
                RecILE.SETRANGE(RecILE."Expiration Date", TODAY + 1);
                RecILE.SETFILTER(RecILE."Remaining Quantity", '<>%1', 0);
                RecILE.SETRANGE(RecILE."Location Code", Loc.Code);
                IF RecILE.FINDFIRST THEN
                    REPEAT
                        RecItemJnlLine.INIT;
                        ItemJnlBatch.GET('TRANSFER', 'EXPIRYMOV');

                        RecItemJnlLine."Journal Template Name" := 'TRANSFER';
                        RecItemJnlLine."Journal Batch Name" := 'EXPIRYMOV';
                        IF ItemJnlBatch."No. Series" <> '' THEN BEGIN
                            CLEAR(NoSeriesMgt);
                            RecItemJnlLine."Document No." := NoSeriesMgt.TryGetNextNo(ItemJnlBatch."No. Series", TODAY);
                        END;
                        // CLEAR(LineNo) ;
                        IJL.RESET;
                        IJL.SETRANGE(IJL."Document No.", RecItemJnlLine."Document No.");
                        IF IJL.FINDLAST THEN
                            LineNo := LineNo + 10000
                        ELSE
                            LineNo := 10000;
                        // MESSAGE('%1',RecItemJnlLine."Document No.") ;
                        RecItemJnlLine."Line No." := LineNo;
                        RecItemJnlLine."Entry Type" := RecItemJnlLine."Entry Type"::Transfer;
                        RecItemJnlLine.VALIDATE(RecItemJnlLine."Item No.", RecILE."Item No.");
                        RecItemJnlLine.VALIDATE("Location Code", RecILE."Location Code");
                        RecItemJnlLine.VALIDATE("Reason Code", 'EXPIRED');
                        RecItemJnlLine.VALIDATE(RecItemJnlLine."Source Code", 'RECLASSJNL');

                        RecLoc.RESET;
                        RecLoc.SETRANGE(RecLoc.Code, RecILE."Location Code");
                        IF RecLoc.FINDFIRST THEN BEGIN
                            RecLocBlock.RESET;
                            RecLocBlock.SETRANGE(RecLocBlock."Post Code", RecLoc."Post Code");
                            RecLocBlock.SETRANGE(RecLocBlock.Loc_Block, TRUE);
                            IF RecLocBlock.FINDFIRST THEN
                                RecItemJnlLine."New Location Code" := RecLocBlock.Code;
                        END;
                        //JAGA
                        //CCIT-JAGA 03/11/2018
                        RecLocation.RESET;
                        IF RecLocation.GET(RecILE."Location Code") THEN BEGIN
                            RecItemJnlLine.VALIDATE("New Shortcut Dimension 1 Code", RecLocation."Branch Code");
                        END;

                        RecLocation.RESET;
                        IF RecLocation.GET(RecItemJnlLine."Location Code") THEN BEGIN
                            RecItemJnlLine.VALIDATE("Shortcut Dimension 1 Code", RecLocation."Branch Code");
                        END;
                        //CCIT-JAGA 03/11/2018

                        //JAGA
                        RecItemJnlLine.VALIDATE(RecItemJnlLine.Quantity, RecILE."Remaining Quantity");
                        RecItemJnlLine."Posting Date" := TODAY;
                        RecItemJnlLine.INSERT;

                        //MESSAGE('Lines Inserted') ;
                        LastrecResEntry.RESET;
                        LastrecResEntry.SETFILTER(LastrecResEntry."Entry No.", '<>%1', 0);
                        IF LastrecResEntry.FINDLAST THEN
                            lastEntryNo := lastEntryNo + 1;


                        recResEntry.INIT;
                        recResEntry."Entry No." := lastEntryNo;
                        recResEntry.VALIDATE(recResEntry."Item No.", RecItemJnlLine."Item No.");
                        recResEntry.VALIDATE(recResEntry."Location Code", RecItemJnlLine."Location Code");
                        recResEntry."Reservation Status" := recResEntry."Reservation Status"::Prospect;  //CITS-MM
                        recResEntry."Item Tracking" := recResEntry."Item Tracking"::"Lot No.";
                        recResEntry."Variant Code" := RecItemJnlLine."Variant Code";
                        recResEntry."Source Type" := 83;
                        recResEntry."Source Subtype" := RecItemJnlLine."Entry Type";
                        recResEntry."Source ID" := RecItemJnlLine."Journal Template Name";
                        recResEntry."Source Batch Name" := RecItemJnlLine."Journal Batch Name";
                        recResEntry."Source Ref. No." := RecItemJnlLine."Line No.";
                        recResEntry."Qty. per Unit of Measure" := RecItemJnlLine."Qty. per Unit of Measure";
                        recResEntry."Creation Date" := TODAY;
                        recResEntry."Created By" := USERID;
                        recResEntry.VALIDATE(recResEntry."Quantity (Base)", RecItemJnlLine."Quantity (Base)");
                        recResEntry.VALIDATE(recResEntry."Qty. to Handle (Base) In KG", RecItemJnlLine."Conversion Qty");
                        recResEntry."Quantity (Base)" := recResEntry."Quantity (Base)" * -1;
                        recResEntry.VALIDATE(recResEntry."Quantity (Base)");
                        recResEntry.VALIDATE(recResEntry."Lot No.", RecILE."Lot No.");
                        recResEntry.VALIDATE(recResEntry."New Lot No.", RecILE."Lot No.");
                        recResEntry.VALIDATE("New Manufacturing Date", RecItemJnlLine."New Item Manufacturing Date");
                        recResEntry.VALIDATE("New Expiration Date", RecItemJnlLine."New Item Expiration Date");
                        //recResEntry.VALIDATE(, "Item Journal Line"."New Item Expiration Date");
                        recResEntry.VALIDATE("Expiration Date", RecILE."Expiration Date");
                        recResEntry.VALIDATE("Manufacturing Date", RecILE."Manufacturing Date");
                        recResEntry.INSERT;

                        //lastEntryNo += 1;

                        COMMIT;
                    UNTIL RecILE.NEXT = 0;
            UNTIL Loc.NEXT = 0;
    end;
}

