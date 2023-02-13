xmlport 50017 "Purchase order Uploads"
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
            tableelement("Purchase Header"; "Purchase Header")
            {
                AutoSave = false;
                XmlName = 'PurchaseHeader';
                textelement(DocumentType)
                {
                }
                textelement(No)
                {
                }
                textelement(VendorNo)
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
                textelement(Type)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(QtyinKG)
                {
                }
                textelement("LotNo.")
                {
                    MinOccurs = Zero;
                }
                textelement(ManufacturingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(ExpiryDate)
                {
                    MinOccurs = Zero;
                }
                textelement(QtyBasekg)
                {
                    MinOccurs = Zero;
                }
                textelement(QtyToHandlekg)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInsertRecord();
                begin
                    cnt += 1;
                    IF cnt = 1 THEN
                        currXMLport.SKIP;

                    EVALUATE(NewNo, No);
                    IF NewNo <> PrevNo THEN BEGIN
                        COMMIT;
                        CLEAR(PurchaseHeader);
                        PurchaseHeader.INIT();
                        IF DocumentType = 'Order' THEN
                            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order
                        ELSE
                            IF DocumentType = 'Return Order' THEN
                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Return Order"
                            ELSE
                                IF DocumentType = 'Credit Memo' THEN
                                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";


                        PurchaseHeader."No." := No;
                        PurchaseHeader.INSERT;
                        PurchaseHeader.VALIDATE("Buy-from Vendor No.", VendorNo);
                        EVALUATE(PostingDate2, PostingDate);
                        PurchaseHeader.VALIDATE("Posting Date", PostingDate2);
                        EVALUATE(OrderDate2, OrderDate);
                        PurchaseHeader.VALIDATE("Order Date", OrderDate2);
                        PurchaseHeader.VALIDATE("Posting No.", "PostingNo.");
                        PurchaseHeader.VALIDATE("Location Code", LocationCode);
                        // PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code",BranchCode);
                        // PurchaseHeader.VALIDATE(Structure,Structure1);
                        //  PurchaseHeader."Vendor Order No." := VendorOrderNo;
                        PurchaseHeader.MODIFY;
                    END;
                    PurchaseLine2.RESET();
                    PurchaseLine2.SETRANGE("Document Type", PurchaseLine2."Document Type"::Order);
                    PurchaseLine2.SETRANGE("Document No.", PurchaseHeader."No.");
                    IF PurchaseLine2.FINDLAST THEN
                        "LineNo." := PurchaseLine2."Line No." + 10000
                    ELSE
                        "LineNo." := 10000;
                    PurchaseLine.INIT();
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := "LineNo.";
                    PurchaseLine."Buy-from Vendor No." := VendorNo;
                    IF Type = 'Item' THEN
                        PurchaseLine.Type := PurchaseLine.Type::Item
                    ELSE
                        IF Type = 'G/L Account' THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";

                    PurchaseLine.VALIDATE("No.", ItemNo);
                    EVALUATE(Qty2, QtyinKG);
                    PurchaseLine.VALIDATE(Quantity, Qty2);
                    //EVALUATE(UnitPrice,UnitPriceExTax);
                    //PurchaseLine.VALIDATE("Unit Price",UnitPrice);
                    //PurchaseLine."Special Price" := SpecialPrice;
                    PurchaseLine.INSERT();
                    CreateReservationSales(PurchaseHeader, PurchaseLine, "LotNo.");
                    PrevNo := '';
                    PrevNo := NewNo;
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
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseLine2: Record 39;
        "LineNo.": Integer;
        Qty2: Decimal;
        PostingDate2: Date;
        OrderDate2: Date;
        UnitPrice: Decimal;
        RateInPcs2: Decimal;
        ExpiryDate2: Date;
        ManufacturingDate2: Date;

    local procedure CreateReservationSales(PurchaseHeader1: Record 38; PurchaseLine1: Record 39; LotNo: Text);
    var
        ReservationEntry: Record 337;
    begin
        ReservationEntry.INIT;
        ReservationEntry.VALIDATE("Item No.", PurchaseLine1."No.");
        ReservationEntry.VALIDATE("Location Code", PurchaseLine1."Location Code");
        ReservationEntry.VALIDATE("Quantity (Base)", PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE(Description, PurchaseLine1.Description);
        ReservationEntry.VALIDATE("Creation Date", PurchaseHeader1."Order Date");
        ReservationEntry.VALIDATE("Source Type", 39);
        ReservationEntry.VALIDATE("Source Subtype", 1);
        ReservationEntry.VALIDATE("Source ID", PurchaseHeader1."No.");
        ReservationEntry.VALIDATE("Source Ref. No.", PurchaseLine1."Line No.");
        ReservationEntry.VALIDATE("Created By", USERID);
        ReservationEntry.VALIDATE("Qty. per Unit of Measure", PurchaseLine1."Qty. per Unit of Measure");
        ReservationEntry.VALIDATE(Quantity, PurchaseLine1.Quantity);
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Qty. to Handle (Base)", PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Qty. to Invoice (Base)", PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Lot No.", LotNo);
        ReservationEntry.VALIDATE("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        EVALUATE(ExpiryDate2, ExpiryDate);
        ReservationEntry."Expiration Date" := ExpiryDate2;
        EVALUATE(ManufacturingDate2, ManufacturingDate);
        ReservationEntry."Manufacturing Date" := ManufacturingDate2;
        ReservationEntry.INSERT;
    end;
}

