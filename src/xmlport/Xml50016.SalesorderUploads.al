xmlport 50016 "Sales order Uploads"
{
    // version CCIT-Vikas

    DefaultFieldsValidation = false;
    Direction = Both;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("Sales Header"; "Sales Header")
            {
                AutoSave = false;
                XmlName = 'SalesHeader';
                textelement(DocumentType)
                {
                }
                textelement(No)
                {
                }
                textelement(CustomerNo)
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(OrderDate)
                {
                }
                textelement(BranchCode)
                {
                }
                textelement("PostingNo.")
                {
                }
                textelement(LocationCode)
                {
                }
                textelement(Structure1)
                {
                }
                textelement(VerticalCategory)
                {
                }
                textelement(VerticalSubCategory)
                {
                }
                textelement(Type)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(QtyinKG)
                {
                }
                textelement(UnitPriceExTax)
                {
                }
                textelement(RateInPcs)
                {
                }
                textelement(CustPriceGroup)
                {
                }
                textelement(SpecialPrice)
                {
                }
                textelement("LotNo.")
                {
                }
                textelement(ManufacturingDate)
                {
                }
                textelement(ExpiryDate)
                {
                }
                textelement(QtyBasekg)
                {
                }
                textelement(QtyToHandlekg)
                {
                }

                trigger OnAfterInsertRecord();
                begin
                    cnt += 1;
                    IF cnt = 1 THEN
                        currXMLport.SKIP;

                    EVALUATE(NewNo, No);
                    IF NewNo <> PrevNo THEN BEGIN
                        COMMIT;
                        CLEAR(SalesHeader);
                        SalesHeader.INIT();
                        IF DocumentType = 'Order' THEN
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                        ELSE
                            IF DocumentType = 'Return Order' THEN
                                SalesHeader."Document Type" := SalesHeader."Document Type"::"Return Order"
                            ELSE
                                IF DocumentType = 'Credit Memo' THEN
                                    SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                        SalesHeader.INIT();
                        IF DocumentType = 'Invoice' THEN
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;

                        SalesHeader."No." := No;
                        SalesHeader.INSERT;
                        SalesHeader.VALIDATE("Sell-to Customer No.", CustomerNo);
                        EVALUATE(PostingDate2, PostingDate);
                        SalesHeader.VALIDATE("Posting Date", PostingDate2);
                        EVALUATE(OrderDate2, OrderDate);
                        SalesHeader.VALIDATE("Order Date", OrderDate2);
                        SalesHeader.VALIDATE("Posting No.", "PostingNo.");
                        SalesHeader.VALIDATE("Vertical Category", VerticalCategory);
                        SalesHeader.VALIDATE("Vertical Sub Category", VerticalSubCategory);
                        SalesHeader.VALIDATE("Location Code", LocationCode);
                        // SalesHeader.VALIDATE("Shortcut Dimension 1 Code",BranchCode);
                        // SalesHeader.VALIDATE(Structure,Structure1);
                        SalesHeader.MODIFY;
                    END;
                    SalesLine2.RESET();
                    //SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type"::Order);
                    SalesLine2.SETRANGE("Document No.", SalesHeader."No.");
                    IF SalesLine2.FINDLAST THEN
                        "LineNo." := SalesLine2."Line No." + 10000
                    ELSE
                        "LineNo." := 10000;
                    SalesLine.INIT();
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := "LineNo.";
                    SalesLine."Sell-to Customer No." := CustomerNo;
                    IF Type = 'Item' THEN
                        SalesLine.Type := SalesLine.Type::Item
                    ELSE
                        IF Type = 'G/L Account' THEN
                            SalesLine.Type := SalesLine.Type::"G/L Account";

                    SalesLine.VALIDATE("No.", ItemNo);
                    //SalesLine.VALIDATE("Customer Price Group",CustPriceGroup);
                    SalesLine."Customer Price Group" := CustPriceGroup;
                    //EVALUATE(RateInPcs2,RateInPcs);
                    //SalesLine.VALIDATE("Rate In PCS",RateInPcs2);
                    EVALUATE(Qty2, QtyinKG);
                    SalesLine.VALIDATE("Main Quantity in KG", Qty2);
                    EVALUATE(UnitPrice, UnitPriceExTax);
                    SalesLine.VALIDATE("Unit Price", UnitPrice);
                    //SalesLine."Special Price" := SpecialPrice;
                    SalesLine.INSERT();
                    IF SalesLine.Type = SalesLine.Type::Item THEN
                        CreateReservationSales(SalesHeader, SalesLine, "LotNo.");
                    PrevNo := '';
                    PrevNo := NewNo;
                    CLEAR(LocationCode);
                end;
            }
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

    trigger OnPostXmlPort();
    begin
        MESSAGE('Total %1 lines uploaded successfully..', cnt);
    end;

    trigger OnPreXmlPort();
    begin
        cnt := 0;
    end;

    var
        lastEntryNo: Integer;
        cnt: Integer;
        EIRCnt: Integer;
        NewNo: Code[25];
        PrevNo: Code[25];
        SalesHeader: Record 36;
        SalesLine: Record 37;
        SalesLine2: Record 37;
        "LineNo.": Integer;
        Qty2: Decimal;
        PostingDate2: Date;
        OrderDate2: Date;
        UnitPrice: Decimal;
        RateInPcs2: Decimal;
        ExpiryDate2: Date;
        ManufacturingDate2: Date;

    local procedure CreateReservationSales(SalesHeader1: Record 36; SalesLine1: Record 37; LotNo: Text);
    var
        ReservationEntry: Record 337;
    begin
        ReservationEntry.INIT;
        ReservationEntry.VALIDATE("Item No.", SalesLine1."No.");
        ReservationEntry.VALIDATE("Location Code", SalesLine1."Location Code");
        ReservationEntry.VALIDATE("Quantity (Base)", -SalesLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE(Description, SalesLine1.Description);
        ReservationEntry.VALIDATE("Creation Date", SalesHeader1."Order Date");
        ReservationEntry.VALIDATE("Source Type", 37);
        ReservationEntry.VALIDATE("Source Subtype", 1);
        ReservationEntry.VALIDATE("Source ID", SalesHeader1."No.");
        ReservationEntry.VALIDATE("Source Ref. No.", SalesLine1."Line No.");
        ReservationEntry.VALIDATE("Shipment Date", SalesHeader1."Shipment Date");
        ReservationEntry.VALIDATE("Created By", USERID);
        ReservationEntry.VALIDATE("Qty. per Unit of Measure", SalesLine1."Qty. per Unit of Measure");
        ReservationEntry.VALIDATE(Quantity, -SalesLine1.Quantity);
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Qty. to Handle (Base)", -SalesLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Qty. to Invoice (Base)", -SalesLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Lot No.", LotNo);
        ReservationEntry.VALIDATE("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        EVALUATE(ExpiryDate2, ExpiryDate);
        ReservationEntry."Expiration Date" := ExpiryDate2;
        EVALUATE(ManufacturingDate2, ManufacturingDate);
        ReservationEntry."Manufacturing Date" := ManufacturingDate2;
        ReservationEntry.INSERT;
    end;
}

