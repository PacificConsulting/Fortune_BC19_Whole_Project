report 50049 "Goods Receipt Note"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Goods Receipt Note.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            column(JWLGRNNo_PurchRcptHeader; "Purch. Rcpt. Header"."JWL GRN No.")
            {
            }
            column(JWLGRNDate_PurchRcptHeader; "Purch. Rcpt. Header"."JWL GRN Date")
            {
            }
            column(OrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Order No.")
            {
            }
            column(ContainerNumber_PurchRcptHeader; "Purch. Rcpt. Header"."Container Number")
            {
            }
            column(ContainerSeal_PurchRcptHeader; "Purch. Rcpt. Header"."Container Seal #")
            {
            }
            column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
            {
            }
            column(OrderDate_PurchRcptHeader; "Purch. Rcpt. Header"."Order Date")
            {
            }
            column(PostingDate_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Date")
            {
            }
            column(DocumentDate_PurchRcptHeader; "Purch. Rcpt. Header"."Document Date")
            {
            }
            column(FSSAIICANo_PurchRcptHeader; "Purch. Rcpt. Header"."FSSAI ICA No.")
            {
            }
            column(FSSAIReportDate_PurchRcptHeader; "Purch. Rcpt. Header"."FSSAI Report Date")
            {
            }
            column(POQty; POQty)
            {
            }
            column(LocName; LocName)
            {
            }
            column(LocAddr1; LocAddr1)
            {
            }
            column(LocAddr2; LocAddr2)
            {
            }
            column(LocPostCode; LocPostCode)
            {
            }
            column(LocContact; LocContact)
            {
            }
            column(LocCity; LocCity)
            {
            }
            column(LocCountry; LocCountry)
            {
            }
            column(RecCompInfo_Picture; RecCompInfo.Picture)
            {
            }
            column(Comp_Name; RecCompInfo.Name)
            {
            }
            column(InvoiceNo; InvoiceNo)
            {
            }
            column(VendorName; "Purch. Rcpt. Header"."Pay-to Name")
            {
            }
            column(DataLogger; "Purch. Rcpt. Header"."Data Logger")
            {
            }
            column(InBoundBOEDate; "Purch. Rcpt. Header"."In-Bond BOE Date")
            {
            }
            column(BondNumber; "Purch. Rcpt. Header"."Bond Number")
            {
            }
            column(ContainerFilter; "Purch. Rcpt. Header"."Container Filter")
            {
            }
            column(ContainerSealN0; "Purch. Rcpt. Header"."Container Seal #")
            {
            }
            column(BL; BLNo)
            {
            }
            column(BLDate_PurchRcptHeader; BLDate)
            {
            }
            column(LocationCode_PurchRcptHeader; "Purch. Rcpt. Header"."Location Code")
            {
            }
            column(VendorInvoicedDate_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Invoiced Date")
            {
            }
            column(InBondBillofEntryNo_PurchRcptHeader; "Purch. Rcpt. Header"."In-Bond Bill of Entry No.")
            {
            }
            column(ContainerFilter_PurchRcptHeader; ContainerType)
            {
            }
            dataitem("Posted Invt. Put-away Header"; "Posted Invt. Put-away Header")
            {
                DataItemLink = "Source No." = FIELD("No.");
                column(POQtyPCSTotal; POQtyPCSTotal)
                {
                }
                column(TotQtyQtyKg; TotQtyQtyKg)
                {
                }
                column(TotQtyPCS; TotQtyPCS)
                {
                }
                dataitem("Posted Invt. Put-away Line"; "Posted Invt. Put-away Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    column(ManufacturingDate_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Manufacturing Date")
                    {
                    }
                    column(LotNo_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Lot No.")
                    {
                    }
                    column(ExpirationDate_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Expiration Date")
                    {
                    }
                    column(ReasonCode_PostedInvtPutawayLine; ReasonDes)
                    {
                    }
                    column(ConversionQty_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Conversion Qty")
                    {
                    }
                    column(ItemNo_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Item No.")
                    {
                    }
                    column(Description_PostedInvtPutawayLine; "Posted Invt. Put-away Line".Description)
                    {
                    }
                    column(Quantity_PostedInvtPutawayLine; "Posted Invt. Put-away Line".Quantity)
                    {
                    }
                    column(POLotNo_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."PO Lot No.")
                    {
                    }
                    column(POExpirationDate_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."PO Expiration Date")
                    {
                    }
                    column(POManufacturingDate_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."PO Manufacturing Date")
                    {
                    }
                    column(SaleableQtyInPCS_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Saleable Qty. In PCS")
                    {
                    }
                    column(DamageQtyInPCS_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Damage Qty. In PCS")
                    {
                    }
                    column(SaleableQtyInKG_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Saleable Qty. In KG")
                    {
                    }
                    column(DamageQtyInKG_PostedInvtPutawayLine; "Posted Invt. Put-away Line"."Damage Qty. In KG")
                    {
                    }
                    column(GRNQtyPCS; GRNQtyPCS)
                    {
                    }
                    column(POQtyKGTotal; POQtyKGTotal)
                    {
                    }
                    column(GRNQtyPCSTotal; GRNQtyPCSTotal)
                    {
                    }
                    column(UOM; UOM)
                    {
                    }
                    column(ManuDate; ManuDate)
                    {
                    }
                    column(expirationDate; expirationDate)
                    {
                    }
                    trigger OnAfterGetRecord();
                    begin
                        //CCIT-JAGA 07/12/2018
                        CLEAR(ReasonDes);
                        IF RecReasoCode.GET("Posted Invt. Put-away Line"."Reason Code") THEN
                            ReasonDes := RecReasoCode.Description;
                        //CCIT-JAGA 07/12/2018
                        IF RecItem.GET("Posted Invt. Put-away Line"."Item No.") THEN BEGIN
                            UOM := RecItem."Conversion UOM";
                            IF RecUOM1.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM1.Weight <> 0) THEN BEGIN
                                    //MESSAGE('%1  %2',"Posted Invt. Put-away Line"."Item No.","Posted Invt. Put-away Line".Quantity);
                                    GRNQtyPCS := ("Posted Invt. Put-away Line".Quantity / RecUOM1.Weight);

                                END;
                            END;
                        END;
                        //MESSAGE('%1',GRNQtyPCS);

                        GRNQtyPCSTotal += GRNQtyPCS;
                        POQtyKGTotal += "Posted Invt. Put-away Line".Quantity + "Posted Invt. Put-away Line"."Damage Qty. In PCS";
                        //POQtyPCSTotal += "Posted Invt. Put-away Line"."Conversion Qty" + "Posted Invt. Put-away Line"."Damage Qty. In KG";
                        POQtyPCSTotal += GRNQtyPCS + "Posted Invt. Put-away Line"."Damage Qty. In KG";
                        //MESSAGE('%1',POQtyPCSTotal);

                        //TotQtyQtyPCS += "Posted Invt. Put-away Line".Quantity + "Posted Invt. Put-away Line"."Damage Qty. In PCS";
                        //MESSAGE('%1',TotQtyQtyPCS);

                        //MESSAGE(Dates)
                        Clear(ManuDate);
                        Clear(expirationDate);
                        RecILE.Reset;
                        RecILE.SetRange("Item No.", "Item No.");
                        RecILE.SetRange("Lot No.", "Lot No.");
                        //Message(Format(RecILE.Count));
                        If RecILE.FindFirst THEN begin
                            ManuDate := RecILE."Warranty Date";
                            //Message(Format(ManuDate));
                            expirationDate := RecILE."Expiration Date";

                        end;


                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(TotQtyQtyKg);
                    PostedInvtPutAwayLine.RESET;
                    PostedInvtPutAwayLine.SETRANGE(PostedInvtPutAwayLine."No.", "Posted Invt. Put-away Header"."No.");
                    IF PostedInvtPutAwayLine.FINDFIRST THEN
                        REPEAT
                            TotQtyQtyKg += PostedInvtPutAwayLine.Quantity + PostedInvtPutAwayLine."Damage Qty. In PCS";

                            IF ItemRec.GET(PostedInvtPutAwayLine."Item No.") THEN BEGIN
                                IF UOMRec.GET(ItemRec."No.", ItemRec."Base Unit of Measure") THEN BEGIN
                                    IF (UOMRec.Weight <> 0) THEN BEGIN
                                        //MESSAGE('%1  %2',"Posted Invt. Put-away Line"."Item No.","Posted Invt. Put-away Line".Quantity);
                                        TotQtyPCS += (PostedInvtPutAwayLine.Quantity / UOMRec.Weight) + PostedInvtPutAwayLine."Damage Qty. In KG";

                                    END;
                                END;
                            END;

                        UNTIL PostedInvtPutAwayLine.NEXT = 0;
                end;
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(Comment_PurchCommentLine; "Purch. Comment Line".Comment)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin




                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Purch. Rcpt. Header"."Order No.");
                IF RecPH.FINDFIRST THEN BEGIN
                    InvoiceNo := RecPH."Vendor Invoice No.";
                    ContainerType := FORMAT(RecPH."Container Filter");
                    BLNo := RecPH."Bill Of Lading No.";
                    BLDate := RecPH."Bill Of Lading Date";
                    //DataLogger := RecPH."Data Logger";
                    //MESSAGE('%1 %2',BLNo,BLDate);
                END;


                IF RecLocation.GET("Purch. Rcpt. Header"."Location Code") THEN BEGIN
                    LocName := RecLocation.Name;
                    LocAddr1 := RecLocation.Address;
                    LocAddr2 := RecLocation."Address 2";
                    LocCity := RecLocation.City;
                    LocCountry := RecLocation.County;
                    LocContact := RecLocation.Contact;
                    LocPostCode := RecLocation."Post Code";
                END;
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

    trigger OnPreReport();
    begin
        RecCompInfo.GET;
        RecCompInfo.CALCFIELDS(Picture);
    end;

    var
        BLNo: Code[20];
        BLDate: Date;
        ContainerType: Text[20];
        RecPL: Record 39;
        POQty: Decimal;
        RecLocation: Record 14;
        LocName: Text[200];
        LocAddr1: Text[200];
        LocAddr2: Text[200];
        LocPostCode: Code[20];
        LocContact: Text[25];
        LocCity: Text[20];
        LocCountry: Text[20];
        RecCompInfo: Record 79;
        RecItem: Record 27;
        POQtyPCS: Decimal;
        POQtyKG: Decimal;
        GRNQtyPCS: Decimal;
        GRNQtyKG: Decimal;
        RecUOM: Record 5404;
        RecILE: Record 32;
        BatchNo: Code[20];
        EXPDate: Date;
        MFGDate: Date;
        RecUOM1: Record 5404;
        RecPostInvPutAwayLine: Record 7341;
        VarianceQtyInKG: Decimal;
        VarianceQtyInPCS: Decimal;
        VarianceQtyInKGTotal: Decimal;
        VarianceQtyInPCSTotal: Decimal;
        GRNQtyPCSTotal: Decimal;
        RecPH: Record 38;
        POQtyKGTotal: Decimal;
        InvoiceNo: Code[50];
        POQtyPCSTotal: Decimal;
        UOM: Code[10];
        TotQtyQtyKg: Decimal;
        PostedInvtPutAwayLine: Record 7341;
        TotQtyPCS: Decimal;
        ItemRec: Record 27;
        UOMRec: Record 5404;
        RecReasoCode: Record 231;
        ReasonDes: Text[50];

        ManuDate: Date;
        expirationDate: Date;

}

