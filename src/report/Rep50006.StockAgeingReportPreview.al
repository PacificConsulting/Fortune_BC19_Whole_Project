report 50006 "Stock Ageing Report Preview"
{
    // version To be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Stock Ageing Report Preview.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", "Document No.", "Location Code", "Lot No.")
                                ORDER(Ascending)
                                WHERE("Entry Type" = FILTER('Purchase' | 'Transfer' | 'Positive Adjmt.' | 'Negative Adjmt.' | 'Sale'),
                                      "Remaining Quantity" = FILTER(<> 0));
            RequestFilterFields = "Location Code", "Item No.";
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

            trigger OnAfterGetRecord();
            begin
                Sr_No += 1;

                CLEAR(ShelfLifePerAvailable);
                CLEAR(DaysToExpire);
                CLEAR(TotalUseShelfLifeDays);

                TotalUseShelfLifeDays := "Item Ledger Entry"."Expiration Date" - "Item Ledger Entry"."Manufacturing Date";
                IF "Item Ledger Entry"."Expiration Date" <> 0D THEN
                    DaysToExpire := "Item Ledger Entry"."Expiration Date" - TODAY;

                IF TotalUseShelfLifeDays <> 0 THEN
                    ShelfLifePerAvailable := ROUND((DaysToExpire / TotalUseShelfLifeDays) * 100);

                RecItem.RESET;
                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    Description := RecItem.Description;
                END;

                IF RecItem.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            ConvQty := ("Item Ledger Entry"."Remaining Quantity" / RecUOM.Weight);
                        END
                    END
                END;
            end;

            trigger OnPreDataItem();
            begin
                Sr_No := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Sr_No: Integer;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Integer;
        ShelfLifePerAvailable: Decimal;
        RecItem: Record 27;
        RecUOM: Record 5404;
        ConvQty: Decimal;
        Description: Text[50];
}

