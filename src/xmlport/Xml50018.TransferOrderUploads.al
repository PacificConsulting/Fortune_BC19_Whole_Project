xmlport 50018 "Transfer Order Uploads"
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
            tableelement("Transfer Header"; "Transfer Header")
            {
                AutoSave = false;
                XmlName = 'TransferHeader';
                textelement(No)
                {
                }
                textelement(TransferfromCode)
                {
                }
                textelement(TransfertoCode)
                {
                }
                textelement(Intransit)
                {
                }
                textelement(Postingdate)
                {
                }
                textelement(structure)
                {
                }
                textelement(branch)
                {
                }
                textelement(itemno)
                {
                }
                textelement(toqty)
                {
                }
                textelement(reasoncode)
                {
                }
                textelement(transferprice)
                {
                }
                textelement(LotNo)
                {
                }
                textelement(ManufacturingDate)
                {
                }
                textelement(expirydate)
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
                        CLEAR(TransferHeader);
                        TransferHeader.INIT();
                        TransferHeader."No." := No;
                        TransferHeader.INSERT();
                        TransferHeader.VALIDATE("Transfer-from Code", TransferfromCode);
                        TransferHeader.VALIDATE("Transfer-to Code", TransfertoCode);
                        TransferHeader.VALIDATE("In-Transit Code", Intransit);
                        EVALUATE(PostingDate2, Postingdate);
                        TransferHeader.VALIDATE("Posting Date", PostingDate2);
                        TransferHeader.VALIDATE("Shipment Date", PostingDate2);
                        //TransferHeader.VALIDATE(Structure,structure);
                        TransferHeader.VALIDATE("Shortcut Dimension 1 Code", branch);
                        TransferHeader.MODIFY;
                    END;
                    TransferLine2.RESET();
                    TransferLine2.SETRANGE("Document No.", TransferHeader."No.");
                    IF TransferLine2.FINDLAST THEN
                        "LineNo." := TransferLine2."Line No." + 10000
                    ELSE
                        "LineNo." := 10000;
                    TransferLine.INIT();
                    TransferLine."Document No." := TransferHeader."No.";
                    TransferLine."Line No." := "LineNo.";
                    TransferLine.VALIDATE("Item No.", itemno);
                    EVALUATE(Qty2, toqty);
                    TransferLine.VALIDATE(Quantity, Qty2);
                    TransferLine.VALIDATE("Reason Code", reasoncode);
                    EVALUATE(transferprice2, transferprice);
                    TransferLine.VALIDATE("Transfer Price", transferprice2);
                    TransferLine.INSERT();
                    CreateReservationTransfer(TransferHeader, TransferLine, LotNo);
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
        MESSAGE('Total %1 lines uploaded successfully..', cnt - 1);
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
        TransferHeader: Record 5740;
        TransferLine: Record 5741;
        TransferLine2: Record 5741;
        "LineNo.": Integer;
        Qty2: Decimal;
        PostingDate2: Date;
        transferprice2: Decimal;
        ManufacturingDate2: Date;

    local procedure CreateReservationTransfer(TransferHeader1: Record 5740; TransferLine1: Record 5741; LotNo: Text);
    var
        ReservationEntry: Record 337;
        Expirydate2: Date;
    begin
        ReservationEntry.INIT;
        ReservationEntry.VALIDATE("Item No.", TransferLine1."Item No.");
        ReservationEntry.VALIDATE("Location Code", TransferLine1."Transfer-from Code");
        ReservationEntry.VALIDATE("Quantity (Base)", -TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE(Description, TransferLine1.Description);
        ReservationEntry.VALIDATE("Creation Date", TransferHeader1."Order Date");
        ReservationEntry.VALIDATE("Source Type", 5741);
        ReservationEntry.VALIDATE("Source Subtype", 0);
        ReservationEntry.VALIDATE("Source ID", TransferHeader1."No.");
        ReservationEntry.VALIDATE("Source Ref. No.", TransferLine1."Line No.");
        ReservationEntry.VALIDATE("Created By", USERID);
        ReservationEntry.VALIDATE("Qty. per Unit of Measure", TransferLine1."Qty. per Unit of Measure");
        ReservationEntry.VALIDATE(Quantity, -TransferLine1.Quantity);
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Qty. to Handle (Base)", -TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Qty. to Invoice (Base)", -TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Lot No.", LotNo);
        ReservationEntry.VALIDATE("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        EVALUATE(Expirydate2, expirydate);
        ReservationEntry."Expiration Date" := Expirydate2;
        EVALUATE(ManufacturingDate2, ManufacturingDate);
        ReservationEntry."Manufacturing Date" := ManufacturingDate2;
        ReservationEntry.INSERT;
        /*
        ReservationEntry.INIT;
        ReservationEntry.VALIDATE("Item No.",TransferLine1."Item No.");
        ReservationEntry.VALIDATE("Location Code",TransferLine1."Transfer-from Code");
        ReservationEntry.VALIDATE("Quantity (Base)",TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Reservation Status",ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE(Description,TransferLine1.Description);
        ReservationEntry.VALIDATE("Creation Date",TransferHeader1."Order Date");
        ReservationEntry.VALIDATE("Source Type",5741);
        ReservationEntry.VALIDATE("Source Subtype",1);
        ReservationEntry.VALIDATE("Source ID",TransferHeader1."No.");
        ReservationEntry.VALIDATE("Source Ref. No.",TransferLine1."Line No.");
        ReservationEntry.VALIDATE("Created By",USERID);
        ReservationEntry.VALIDATE("Qty. per Unit of Measure",TransferLine1."Qty. per Unit of Measure");
        ReservationEntry.VALIDATE(Quantity,TransferLine1.Quantity);
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Qty. to Handle (Base)",TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Qty. to Invoice (Base)",TransferLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Lot No.",LotNo);
        ReservationEntry.VALIDATE("Item Tracking",ReservationEntry."Item Tracking"::"Lot No.");
        EVALUATE(Expirydate2,expirydate);
        ReservationEntry."Expiration Date" := Expirydate2;
        EVALUATE(ManufacturingDate2,ManufacturingDate);
        ReservationEntry."Manufacturing Date" := ManufacturingDate2;
        ReservationEntry.INSERT;
        */

    end;
}

