report 50056 "Transfer Goods Receipt Note"
{
    // version CCIT-Harshal

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Transfer Goods Receipt Note.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Location; Location)
        {
            DataItemTableView = WHERE(Loc_Intra = CONST(false),
                                      "Use As In-Transit" = CONST(false));
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = FIELD(Code);
                RequestFilterFields = "Document No.";
                column(SrNo; SrNo)
                {
                }
                column(ItemCode_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
                {
                }
                column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item Description")
                {
                }
                column(ActualBatch_ItemLedgerEntry; "Item Ledger Entry"."Actual Batch")
                {
                }
                column(ActualMFGDate_ItemLedgerEntry; "Item Ledger Entry"."Actual MFG Date")
                {
                }
                column(ActualEXPDate_ItemLedgerEntry; "Item Ledger Entry"."Actual EXP Date")
                {
                }
                column(ActualBatchPCS_ItemLedgerEntry; "Item Ledger Entry"."Actual Batch PCS")
                {
                }
                column(ActualBatchKGS_ItemLedgerEntry; "Item Ledger Entry"."Actual Batch KGS")
                {
                }
                column(Return_Reason_Code; "Return Reason Code")
                {

                }

                column(BTO_batch; BTO_batch)
                {
                }
                column(BTO_MFG; BTO_MFG)
                {
                }
                column(BTO_EXP; BTO_EXP)
                {
                }
                column(BTO_PCS; BTO_PCS)
                {
                }
                column(BTO_KG; BTO_KG)
                {
                }
                column(GRN_KGS; GRN_KGS)
                {
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                }
                column(BTO_KG1; BTO_KG1)
                {
                }
                column(TSHBTO_No; TSHBTO_No)
                {
                }
                column(QtyNSinPCS; QtyNSinPCS)
                {
                }
                column(QtyNSinKGS; QtyNSinKGS)
                {
                }
                column(QtyNSinPCS1; QtyNSinPCS1)
                {
                }
                column(QtyNSinKGS1; QtyNSinKGS1)
                {
                }
                column(GRN_PCS0; GRN_PCS0)
                {
                }
                column(GRN_PCS1; GRN_PCS1)
                {
                }
                dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
                {
                    DataItemLink = "No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No.");
                    column(No_TransferReceiptHeader; "Transfer Receipt Header"."No.")
                    {
                    }
                    column(TransferfromCode_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Code")
                    {
                    }
                    column(TransferfromName_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Name")
                    {
                    }
                    column(TransferfromName2_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Name 2")
                    {
                    }
                    column(TransferfromAddress_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Address")
                    {
                    }
                    column(TransferfromAddress2_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Address 2")
                    {
                    }
                    column(TransferfromPostCode_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from Post Code")
                    {
                    }
                    column(TransferfromCity_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-from City")
                    {
                    }
                    column(TransfertoCode_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Code")
                    {
                    }
                    column(TransfertoName_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Name")
                    {
                    }
                    column(TransfertoName2_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Name 2")
                    {
                    }
                    column(TransfertoAddress_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Address")
                    {
                    }
                    column(TransfertoAddress2_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Address 2")
                    {
                    }
                    column(TransfertoPostCode_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to Post Code")
                    {
                    }
                    column(TransfertoCity_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to City")
                    {
                    }
                    column(TransfertoCounty_TransferReceiptHeader; "Transfer Receipt Header"."Transfer-to County")
                    {
                    }
                    column(TransferOrderDate_TransferReceiptHeader; "Transfer Receipt Header"."Transfer Order Date")
                    {
                    }
                    column(PostingDate_TransferReceiptHeader; "Transfer Receipt Header"."Posting Date")
                    {
                    }
                    column(TransferOrderNo_TransferReceiptHeader; "Transfer Receipt Header"."Transfer Order No.")
                    {
                    }
                    column(VendorInvoiceNo_TransferReceiptHeader; "Transfer Receipt Header"."Vendor Invoice No.")
                    {
                    }
                    column(GRNNumber; GRNNumber)
                    {
                    }
                    column(GRNDate; GRNDate)
                    {
                    }
                    column(LR_PR_No; LR_PR_No)
                    {
                    }
                    column(LRRRDate_TransferReceiptHeader; LR_PR_Date)
                    {
                    }
                    column(VehicleNo_TransferReceiptHeader; Vehicle_No)
                    {
                    }
                    column(ModeofTransport_TransferReceiptHeader; ModeOfTransport)
                    {
                    }
                    column(LicenseNo_TransferReceiptHeader; "Transfer Receipt Header"."License No.")
                    {
                    }
                    column(BLDate_TransferReceiptHeader; "Transfer Receipt Header"."BL Date")
                    {
                    }
                    column(Transport_Vendor; Transport_Vendor)
                    {
                    }
                    column(SealNo_TransferReceiptHeader; Seal_No)
                    {
                    }
                    column(LoadType_TransferReceiptHeader; "Transfer Receipt Header"."Load Type")
                    {
                    }
                    column(Comp_Picture; RecCompInfo.Picture)
                    {
                    }
                    column(BTO_Date; BTO_Date)
                    {
                    }
                    column(BTO_No; BTO_No)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        RecTRH.RESET;
                        RecTRH.SETRANGE(RecTRH."No.", "Item Ledger Entry"."Document No.");
                        IF RecTRH.FINDFIRST THEN BEGIN
                            GRNNumber := RecTRH."No.";
                            GRNDate := RecTRH."Posting Date";
                            FromLocation := RecTRH."Transfer-from Code";
                            TOLocation := RecTRH."Transfer-to Code";
                            LR_PR_No := RecTRH."LR/RR No.";
                            LR_PR_Date := RecTRH."LR/RR Date";
                            Vehicle_No := RecTRH."Vehicle No.";
                            ModeOfTransport := RecTRH."Mode of Transport";
                            Seal_No := RecTRH."Seal No.";
                            Transport_Vendor := RecTRH."Transport Vendor";
                            BTO_No := RecTRH."No.";
                            BTO_Date := RecTRH."Posting Date";
                            TONumber := RecTRH."Transfer Order No.";
                            TODate := RecTRH."Transfer Order Date";
                        END;

                        //MESSAGE('%1...%2...%3...%4',LR_PR_No,LR_PR_Date,Vehicle_No,ModeOfTransport);
                    end;

                    trigger OnPreDataItem();
                    begin

                        CLEAR(LR_PR_No);
                        CLEAR(LR_PR_Date);
                        CLEAR(Vehicle_No);
                        CLEAR(ModeOfTransport);
                        CLEAR(Seal_No);
                        CLEAR(Transport_Vendor);
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    SrNo += 1;

                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Order No.", "Item Ledger Entry"."Order No.");
                    RecILE.SETRANGE(RecILE."Lot No.", "Item Ledger Entry"."Lot No.");
                    RecILE.SETRANGE(RecILE."Item No.", "Item Ledger Entry"."Item No.");
                    RecILE.SETRANGE(RecILE."Document Type", RecILE."Document Type"::"Transfer Shipment");
                    IF RecILE.FINDFIRST THEN BEGIN
                        BTO_batch := RecILE."Lot No.";
                        BTO_MFG := RecILE."Warranty Date";
                        BTO_EXP := RecILE."Expiration Date";
                        BTO_KG := RecILE.Quantity;
                        BTO_KG1 := ABS(BTO_KG);
                        TSHBTO_No := RecILE."Document No."

                    END;


                    IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                QtyNSinPCS := BTO_KG / RecUOM.Weight;
                                //MESSAGE('%1',QtyNSinPCS);
                                QtyNSinPCS1 := ABS(QtyNSinPCS);
                            END
                        END
                    END;

                    IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                QtyNSinKGS := "Item Ledger Entry".Quantity / RecUOM.Weight;
                                QtyNSinKGS1 := ABS(QtyNSinKGS);
                            END;
                        END;
                    END;


                    /*RecTSH.GET
                    Transfer Shipment.SETFILTER(RecTSH."No.","Item Ledger Entry"."Document No.");
                    IF RecTSH.FINDFIRST THEN
                      TSHBTO_No := RecTSH."No.";
                      */




                    /*RecTSL.RESET;
                    RecTSL.SETRANGE(RecTSL."Transfer Order No.","Order No.");
                    //RecTSL.SETRANGE(RecTSL."License No.","Line No.");
                    RecTSL.SETRANGE(RecTSL."Item No.","Item No.");
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Document Type","Item Ledger Entry"."Document Type"::"Transfer Shipment");
                    //RecILE.SETFILTER(RecILE."Remaining Quantity",'<>%1',0);
                    
                    IF RecTSL.FINDSET THEN BEGIN
                         BTO_batch := "Item Ledger Entry"."Lot No.";
                         BTO_MFG := "Item Ledger Entry"."Manufacturing Date";
                         BTO_EXP := "Item Ledger Entry"."Expiration Date";
                         BTO_KG := RecILE.Quantity;
                        // BTO_PCS := RecILE."Conversion Qty";
                     END;
                     */

                    //RecItem2.RESET;
                    IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN
                        Item_Desc := RecItem2.Description;

                    /*
                    BTO_KG :=0;
                    BTO_KG1 :=0;
                    BTO_PCS :=0;
                    BTO_PCS1:=0;
                    
                    
                    IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Transfer Shipment" THEN BEGIN
                      BTO_KG := "Item Ledger Entry".Quantity;
                        IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                           IF RecUOM.GET(RecItem2."No.",RecItem2."Base Unit of Measure") THEN BEGIN
                              IF (RecUOM.Weight <> 0) THEN BEGIN
                               BTO_PCS := BTO_KG / RecUOM.Weight;
                              END
                           END
                        END;
                    END;
                    IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Transfer Receipt" THEN BEGIN
                      BTO_KG1 := "Item Ledger Entry".Quantity;
                      IF RecItem2.GET("Item Ledger Entry"."Item No.") THEN BEGIN
                           IF RecUOM.GET(RecItem2."No.",RecItem2."Base Unit of Measure") THEN BEGIN
                              IF (RecUOM.Weight <> 0) THEN BEGIN
                               BTO_PCS1 := BTO_KG1 / RecUOM.Weight;
                              END
                           END
                        END;
                    END;
                    */

                end;

                trigger OnPreDataItem();
                begin
                    "Item Ledger Entry".SETRANGE("Item Ledger Entry"."Document Type", "Item Ledger Entry"."Document Type"::"Transfer Receipt");
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

    labels
    {
    }

    trigger OnPreReport();
    begin
        RecCompInfo.GET;
        RecCompInfo.CALCFIELDS(Picture);
    end;

    var
        RecCompInfo: Record 79;
        RecTRH: Record 5746;
        SrNo: Integer;
        RecILE: Record 32;
        RecTRL: Record 5747;
        RecTSL: Record 5745;
        BTO_batch: Code[20];
        BTO_MFG: Date;
        BTO_EXP: Date;
        BTO_PCS: Decimal;
        BTO_KG: Decimal;
        BTO_PCS1: Decimal;
        BTO_KG1: Decimal;
        Item_Desc: Text[50];
        RecTSH: Record 5744;
        ModeOfTransport: Text[15];
        Vehicle_No: Code[20];
        LR_PR_No: Code[20];
        LR_PR_Date: Date;
        Seal_No: Code[20];
        Transport_Vendor: Text[50];
        BTO_No: Code[20];
        BTO_Date: Date;
        GRNNumber: Code[20];
        GRNDate: Date;
        FromLocation: Code[10];
        TOLocation: Code[10];
        TONumber: Code[20];
        TODate: Date;
        RecItem2: Record 27;
        RecLoc: Record 14;
        RecLocShipTo: Record 14;
        ShipTocode: Code[10];
        GRN_KGS: Decimal;
        GRN_PCS: Decimal;
        TSHBTO_No: Code[20];
        RecUOM: Record 5404;
        QtyNSinPCS: Decimal;
        QtyNSinKGS: Decimal;
        QtyNSinPCS1: Decimal;
        QtyNSinKGS1: Decimal;
        GRN_PCS0: Decimal;
        GRN_PCS1: Decimal;
}

