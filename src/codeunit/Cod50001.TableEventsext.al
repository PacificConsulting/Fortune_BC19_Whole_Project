codeunit 50001 "Table_Events_ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure OnAfterInitOutstandingQty(var SalesLine: Record "Sales Line")
    begin
        IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] THEN BEGIN
            //CCIT-SG-09032018
            IF NOT (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") THEN BEGIN
                SalesLine."Variance Qty. In KG" := SalesLine."Outstanding Quantity";
                IF RecItem2.GET(SalesLine."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            SalesLine."Variance Qty. In PCS" := SalesLine."Outstanding Quantity" / RecUOM.Weight;
                            SalesLine."Outstanding Quantity In KG" := SalesLine."Outstanding Quantity" / RecUOM.Weight;
                        END
                    END
                END;
            END;
        END Else begin
            //CCIT-SG-09032018
            IF NOT (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") THEN BEGIN
                SalesLine."Variance Qty. In KG" := SalesLine."Outstanding Quantity";
                IF RecItem2.GET(SalesLine."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            SalesLine."Variance Qty. In PCS" := SalesLine."Outstanding Quantity" / RecUOM.Weight;
                            SalesLine."Outstanding Quantity In KG" := SalesLine."Outstanding Quantity" / RecUOM.Weight;
                        END
                    END
                END;
            END;
            //CCIT-SG-10042018
            IF RecItem2.GET(SalesLine."No.") THEN BEGIN
                IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                    IF (RecUOM.Weight <> 0) THEN BEGIN
                        SalesLine."Quantity Invoiced In KG" := SalesLine."Quantity Invoiced" / RecUOM.Weight;
                    END
                END
            END;
        END;
        //CCIT-SG-10042018
        //CCIT-SG-06042018
        IF SalesLine."Outstanding Quantity" < 0 THEN BEGIN
            SalesLine."Outstanding Quantity" := 0;
            SalesLine."Outstanding Quantity In KG" := 0;
            SalesLine."Qty. to Ship In KG" := 0;
            SalesLine."Qty. to Invoice" := 0;
            SalesLine."Qty. to Invoice In KG" := 0;
        END;
        //CCIT-SG-06042018
    END;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterInitQtyToShip', '', false, false)]
    local procedure OnAfterInitQtyToShip(var SalesLine: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        GetSalesSetup();
        if (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) or
           (SalesLine."Document Type" = SalesLine."Document Type"::Invoice)
        then begin
            SalesLine."Qty. to Ship In KG" := SalesLine."Outstanding Quantity In KG"; //CCIT-SD-09-01-2018
        END;
    end;

    local procedure GetSalesSetup()
    begin
        if not SalesSetupRead then
            SalesSetup.Get();
        SalesSetupRead := true;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateWithWarehouseShip', '', false, false)]
    local procedure OnAfterUpdateWithWarehouseShip(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        IF SalesLine.Type = SalesLine.Type::Item THEN
            CASE TRUE OF
                (SalesLine."Document Type" IN [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order]) AND (SalesLine.Quantity >= 0):
                    IF Location.RequireShipment(SalesLine."Location Code") THEN BEGIN
                        SalesLine.VALIDATE(SalesLine."Qty. to Ship In KG", 0);//CCIT-SD-09-01-2018
                    END ELSE BEGIN
                        SalesLine.VALIDATE(SalesLine."Qty. to Ship In KG", SalesLine."Outstanding Quantity In KG");//CCIT-SD-09-01-2018
                    END;
                (SalesLine."Document Type" IN [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order]) AND (SalesLine.Quantity < 0):
                    IF Location.RequireReceive(SalesLine."Location Code") THEN BEGIN
                        Message('PCPL/NSW');
                    END ELSE BEGIN
                        SalesLine.VALIDATE(SalesLine."Qty. to Ship In KG", SalesLine."Outstanding Quantity In KG");//CCIT-SD-09-01-2018
                    END;

            END;
    end;

    // [EventSubscriber(ObjectType::Table, database::"Price List Header", 'OnAfterCopyFromPriceSource', '', false, false)]
    // local procedure OnAfterCopyFromPriceSource(PriceSource: Record "Price Source")
    // begin
    //     Message('Table Evenet Exe....');
    // end;

    // [EventSubscriber(ObjectType::Table, database::"Price List Header", 'OnAfterCopyToPriceSource', '', false, false)]
    // local procedure OnAfterCopyToPriceSource(var PriceSource: Record "Price Source")
    // begin
    //     Message('Table Event Exe Copy To....');
    // end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Tax", 'OnAfterValidatePurchaseLineFields', '', false, false)]
    // procedure OnAfterValidatePurchaseLineFields(var PurchaseLine: Record "Purchase Line")
    // begin
    //     //   Error('Hiiii');
    //     // Message('No Error');
    // end;

    //PCP-0070 10Feb2023 <<
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean);
    begin

        PurchInvHeader."GST Amount" := PurchHeader."GST Amount";
        Message('Inserted');
        PurchInvHeader."TDS Amount" := PurchHeader."TDS Amount";
    end;
    //PCPL-0070 10Feb2023 >>
    var
        RecItem2: Record 27;
        RecUOM: Record 5404;
        SalesSetupRead: Boolean;
        SalesSetup: Record 311;
        Location: Record 14;
}