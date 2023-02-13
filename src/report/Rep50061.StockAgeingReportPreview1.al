report 50061 "Stock Ageing Report Preview-1"
{
    // version CCIT-JAGA

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Stock Ageing Report Preview-1.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Document No.", "Location Code", "Lot No.")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'),
                                      "Remaining Quantity" = FILTER(> 0));
            RequestFilterFields = "Item No.";
            column(Sr_No; Sr_No)
            {
            }
            column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(Description_ItemLedgerEntry; Description)
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(ConversionQty_ItemLedgerEntry; ConvQty)
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
            column(MFGDate_ItemLedgerEntry; "Item Ledger Entry"."Manufacturing Date")
            {
            }
            column(ExpirationDate_ItemLedgerEntry; "Item Ledger Entry"."Expiration Date")
            {
            }
            column(TotalUseShelfLifeDays; TotalUseShelfLifeDays)
            {
            }
            column(ShelfLifePerAvailable; ShelfLifePerAvailable)
            {
            }
            column(QtyPcs; QtyPCS)
            {
            }
            column(QtyKgs; QtyKgs)
            {
            }
            column(LocCode; LocCode)
            {
            }
            column(Batch; Batch)
            {
            }
            column(MfgDate; MfgDate)
            {
            }
            column(ExpDate; ExpDate)
            {
            }
            column(TotQtyKgs; TotQtyKgs)
            {
            }
            column(TotQtyPcs; TotQtyPcs)
            {
            }
            column(FromDate; From_Date)
            {
            }
            column(ToDate; To_Date)
            {
            }
            column(tempkgs; TempTotKgs)
            {
            }

            trigger OnAfterGetRecord();
            begin


                CLEAR(ShelfLifePerAvailable);
                CLEAR(DaysToExpire);
                CLEAR(TotalUseShelfLifeDays);
                CLEAR(QtyPCS);
                CLEAR(QtyKgs);
                //--------------------------------------------------------------------------------
                //CCIT 19/02/2018

                RecILE.RESET;
                //RecILE1.RESET;
                RecILE.SETRANGE(RecILE."Item No.", "Item Ledger Entry"."Item No.");

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    RecILE.SETRANGE(RecILE."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        RecILE.SETRANGE(RecILE."Posting Date", 99990101D, AsOnDate);//010199D

                RecILE.SETRANGE(RecILE."Location Code", "Item Ledger Entry"."Location Code");
                RecILE.SETRANGE(RecILE."Lot No.", "Item Ledger Entry"."Lot No.");
                RecILE.SETRANGE(RecILE."MFG Date", "Item Ledger Entry"."MFG Date");
                RecILE.SETRANGE(RecILE."Expiration Date", "Item Ledger Entry"."Expiration Date");
                RecILE.SETFILTER(RecILE.Quantity, '>%1', 0);

                IF RecILE.FINDSET THEN
                    REPEAT
                        LocCode := RecILE."Location Code";
                        Batch := RecILE."Lot No.";
                        ExpDate := RecILE."Expiration Date";
                        MfgDate := RecILE."Manufacturing Date";

                        RecItem.RESET;
                        IF RecItem.GET(RecILE."Item No.") THEN BEGIN
                            IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM.Weight <> 0) THEN BEGIN
                                    QtyPCS := QtyPCS + (RecILE."Remaining Quantity" / RecUOM.Weight);
                                END;
                            END;
                        END;

                        QtyKgs := QtyKgs + RecILE."Remaining Quantity";

                        IF RecILE."Expiration Date" <> 0D THEN
                            TotalUseShelfLifeDays := RecILE."Expiration Date" - RecILE."Manufacturing Date";
                        IF RecILE."Expiration Date" <> 0D THEN
                            DaysToExpire := RecILE."Expiration Date" - TODAY;

                        IF TotalUseShelfLifeDays <> 0 THEN
                            ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);

                        RecItem.RESET;
                        IF RecItem.GET(RecILE."Item No.") THEN BEGIN
                            Description := RecItem.Description;
                            //MESSAGE('%1', RecItem.COUNT);
                        END;

                        TempTotKgs += RecILE."Remaining Quantity";

                    UNTIL RecILE.NEXT = 0;

                TotQtyKgs += "Item Ledger Entry"."Remaining Quantity";

                IF RecItem01.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    IF RecUnitMeas.GET(RecItem01."No.", RecItem01."Base Unit of Measure") THEN BEGIN
                        IF RecUOM.Weight <> 0 THEN BEGIN
                            TotQtyPcs += ("Item Ledger Entry"."Remaining Quantity" / RecUnitMeas.Weight);
                        END;
                    END;
                END;

                //--------------------------------------------------------------------------------

            end;

            trigger OnPreDataItem();
            begin
                //Sr_No := Sr_No + 1;
                // Date Filter
                //CCIT-PRI-280318

                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode1 := LocCode1 + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode1, '<', '|');

                //IF LocCodeText <> '' THEN
                IF LocFilter = '' THEN
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocCodeText)
                ELSE
                    "Item Ledger Entry".SETFILTER("Item Ledger Entry"."Location Code", LocFilter);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Posting Date", 99990101D, AsOnDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Form Date - To Date Filter")
                {
                    field("From Date"; From_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                    field("To Date"; To_Date)
                    {
                        Caption = 'To Date';

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                }
                group("As On Date Filter")
                {
                    field("As On Date"; AsOnDate)
                    {

                        trigger OnValidate();
                        begin
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                                AsOnDate := 0D;
                                MESSAGE('From Date - To Date allready Entered...');
                            END;
                        end;
                    }
                    field("Location Code"; LocFilter)
                    {
                        TableRelation = Location.Code;
                    }
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

    trigger OnPreReport();
    begin
        Sr_No := 0;
    end;

    var
        Sr_No: Integer;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Integer;
        ShelfLifePerAvailable: Decimal;
        RecItem: Record 27;
        RecUOM: Record 5404;
        ConvQty: Decimal;
        Description: Text[50];
        RecILE: Record 32;
        LocCode: Code[35];
        Batch: Code[25];
        MfgDate: Date;
        ExpDate: Date;
        QtyPCS: Decimal;
        QtyKgs: Decimal;
        TotQtyKgs: Decimal;
        TotQtyPcs: Decimal;
        RecILE1: Record 32;
        QtyPcsTot: Decimal;
        QtyKgsTot: Decimal;
        RecUnitMeas: Record 5404;
        RecItem01: Record 27;
        From_Date: Date;
        To_Date: Date;
        TempTotKgs: Decimal;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode1: Code[1024];
        LocCodeText: Text[1024];
        LocFilter: Code[20];
}

