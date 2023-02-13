report 50021 "Transfer Delivery Challan"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Transfer Delivery Challan.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(TransferOrderNo_TransferShipmentHeader; "Transfer Shipment Header"."Transfer Order No.")
            {
            }
            column(SealNo_TransferShipmentHeader; "Transfer Shipment Header"."Seal No.")
            {
            }
            column(EWayBillNo_TransferShipmentHeader; "Transfer Shipment Header"."E-Way Bill No.")
            {
            }
            column(TransportMethod_TransferShipmentHeader; "Transfer Shipment Header"."Transport Method")
            {
            }
            column(EWayBillDate_TransferShipmentHeader; "Transfer Shipment Header"."E-Way Bill Date")
            {
            }
            column(TransfertoContact_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Contact")
            {
            }
            column(TransfertoName_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Name")
            {
            }
            column(TransfertoName2_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Name 2")
            {
            }
            column(TransfertoAddress_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Address")
            {
            }
            column(TransfertoAddress2_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Address 2")
            {
            }
            column(TransfertoPostCode_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Post Code")
            {
            }
            column(TransfertoCity_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to City")
            {
            }
            column(TransfertoCounty_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to County")
            {
            }
            column(TrsftoCountryRegionCode_TransferShipmentHeader; "Transfer Shipment Header"."Trsf.-to Country/Region Code")
            {
            }
            column(TransferfromContact_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Contact")
            {
            }
            column(TransferfromName_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Name")
            {
            }
            column(TransferfromName2_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Name 2")
            {
            }
            column(TransferfromAddress_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Address")
            {
            }
            column(TransferfromAddress2_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Address 2")
            {
            }
            column(TransferfromPostCode_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Post Code")
            {
            }
            column(TransferfromCity_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from City")
            {
            }
            column(TransferfromCounty_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from County")
            {
            }
            column(TrsffromCountryRegionCode_TransferShipmentHeader; "Transfer Shipment Header"."Trsf.-from Country/Region Code")
            {
            }
            column(LRRRNo_TransferShipmentHeader; "Transfer Shipment Header"."LR/RR No.")
            {
            }
            column(LRRRDate_TransferShipmentHeader; "Transfer Shipment Header"."LR/RR Date")
            {
            }
            column(VehicleNo_TransferShipmentHeader; "Transfer Shipment Header"."Vehicle No.")
            {
            }
            column(ModeofTransport_TransferShipmentHeader; "Transfer Shipment Header"."Mode of Transport")
            {
            }
            column(TransfertoCode_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-to Code")
            {
            }
            column(TransferfromCode_TransferShipmentHeader; "Transfer Shipment Header"."Transfer-from Code")
            {
            }
            column(No_TransferShipmentHeader; "Transfer Shipment Header"."No.")
            {
            }
            column(TransferOrderDate_TransferShipmentHeader; "Transfer Shipment Header"."Transfer Order Date")
            {
            }
            column(PostingDate_TransferShipmentHeader; "Transfer Shipment Header"."Posting Date")
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(PageCaption; PageCaption)
            {
            }
            column(CompName; CompanyInfo.Name)
            {
            }
            column(CompName2; CompanyInfo."Name 2")
            {
            }
            column(CompAddres; CompanyInfo.Address)
            {
            }
            column(CompAddres2; CompanyInfo."Address 2")
            {
            }
            column(CompCity; CompanyInfo.City)
            {
            }
            column(CompPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompCountry; CompanyInfo.County)
            {
            }
            column(CustStatename; CustStatename)
            {
            }
            column(CustStatecode; CustStatecode)
            {
            }
            column(LocName; LocName)
            {
            }
            column(FromStateName; FromStateName)
            {
            }
            column(ToStateName; ToStateName)
            {
            }
            column(FromCode; FromCode)
            {
            }
            column(ToCode; ToCode)
            {
            }
            column(FromPanCard; FromPanCard)
            {
            }
            column(ToPanCard; ToPanCard)
            {
            }
            column(FromGSTNo; FromGSTNo)
            {
            }
            column(ToGSTNo; ToGSTNo)
            {
            }
            column(FromPhoneNo; FromPhoneNo)
            {
            }
            column(FromFssialNo; FromFssialNo)
            {
            }
            column(FromEmailId; FromEmailId)
            {
            }
            column(ToPhoneNo; ToPhoneNo)
            {
            }
            column(Batch; Batch)
            {
            }
            column(EXPDate; EXPDate)
            {
            }
            column(MFGDate; MFGDate)
            {
            }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Transfer Shipment Header";
                column(ConversionUOM_TransferShipmentLine; "Transfer Shipment Line"."Conversion UOM")
                {
                }
                column(CustomerNo_TransferShipmentLine; "Transfer Shipment Line"."Customer No.")
                {
                }
                column(CustomerName_TransferShipmentLine; "Transfer Shipment Line"."Customer Name")
                {
                }
                column(CustomerLicenseNo_TransferShipmentLine; "Transfer Shipment Line"."Customer License No.")
                {
                }
                column(CustomerLicenseName_TransferShipmentLine; "Transfer Shipment Line"."Customer License Name")
                {
                }
                column(CustomerLicenseDate_TransferShipmentLine; "Transfer Shipment Line"."Customer License Date")
                {
                }
                column(ConversionQty_TransferShipmentLine; "Transfer Shipment Line"."Conversion Qty")
                {
                }
                column(UnitPrice_TransferShipmentLine; "Transfer Shipment Line"."Unit Price")
                {
                }
                column(Amount_TransferShipmentLine; "Transfer Shipment Line".Amount)
                {
                }
                column(DocumentNo_TransferShipmentLine; "Transfer Shipment Line"."Document No.")
                {
                }
                column(ItemNo_TransferShipmentLine; "Transfer Shipment Line"."Item No.")
                {
                }
                column(Quantity_TransferShipmentLine; "Transfer Shipment Line".Quantity)
                {
                }
                column(UnitofMeasure_TransferShipmentLine; "Transfer Shipment Line"."Unit of Measure")
                {
                }
                column(Description_TransferShipmentLine; "Transfer Shipment Line".Description)
                {
                }
                column(HSNSACCode_TransferShipmentLine; "Transfer Shipment Line"."HSN/SAC Code")
                {
                }
                column(SlNo; SlNo)
                {
                }
                column(CGST; CGSTAmt)
                {
                }
                column(SGST; SGSTAmt)
                {
                }
                column(IGST; IGSTAmt)
                {
                }
                column(CGSTRate; CGSTRate)
                {
                }
                column(IGSTRate; IGSTRate)
                {
                }
                column(AmountinWords1; AmountinWords[1])
                {
                }
                column(AmountinWords11; AmountinWords1[1])
                {
                }
                column(QtyPCS; QtyPCS)
                {
                }
                column(QtyKG; QtyKG)
                {
                }
                column(RecItem; RecItem."Storage Temperature")
                {

                }

                trigger OnAfterGetRecord();
                begin
                    SlNo += 1;
                    //GrandTotal :=0;
                    IF RecItem.Get("Transfer Shipment Line"."Item No.") then;

                    //----

                    CGSTAmt := 0;
                    SGSTAmt := 0;
                    IGSTAmt := 0;
                    CGSTRate := 0;
                    //SGSTRate :=0;
                    IGSTRate := 0;
                    TotalCGST := 0;
                    TotalSGST := 0;
                    TotalIGST := 0;

                    //Total += "Sales Line"."Line Amount" * "Sales Line".Quantity;

                    IF (FromStateCode = ToStateCode) THEN BEGIN
                        CGSTRate := 0;//"Transfer Shipment Line"."GST %"/2; //PCPL/MIG/NSW
                        CGSTAmt := 0;//"Transfer Shipment Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                        SGSTAmt := 0;//"Transfer Shipment Line"."Total GST Amount" /2; //PCPL/MIG/NSW
                                     //MESSAGE('%1  %2',CGSTAmt,SGSTAmt);
                    END
                    ELSE
                        IF (FromStateCode <> ToStateCode) THEN BEGIN
                            IGSTRate := 0;//"Transfer Shipment Line"."GST %"; //PCPL/MIG/NSW
                            IGSTAmt := 0;//"Transfer Shipment Line"."Total GST Amount"; //PCPL/MIG/NSW
                        END;

                    TotalCGST += CGSTAmt;
                    TotalSGST += SGSTAmt;
                    TotalIGST += IGSTAmt;

                    TotalAmount += ("Transfer Shipment Line".Quantity * "Transfer Shipment Line"."Unit Price");
                    GrandTotal += TotalSGST + TotalCGST + TotalIGST;

                    repCheck.InitTextVariable;
                    repCheck.FormatNoText(AmountinWords, ROUND(TotalAmount), '');

                    repCheck1.InitTextVariable;
                    repCheck1.FormatNoText(AmountinWords1, GrandTotal, '');
                    //----

                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Document No.", "Transfer Shipment Line"."Document No.");
                    RecILE.SETRANGE(RecILE."Document Line No.", "Transfer Shipment Line"."Line No.");
                    IF RecILE.FINDSET THEN
                        REPEAT
                            Batch := RecILE."Lot No.";
                            EXPDate := RecILE."Expiration Date";
                            MFGDate := RecILE."Warranty Date";
                        UNTIL RecILE.NEXT = 0;

                    QtyPCS := 0;
                    QtyKG := 0;
                    /*IF ("Transfer Shipment Line"."Unit of Measure Code" = 'PCS') THEN BEGIN
                           QtyPCS := "Transfer Shipment Line".Quantity;
                           QtyKG := "Transfer Shipment Line"."Conversion Qty";
                    END ELSE IF ("Transfer Shipment Line"."Unit of Measure Code" = 'KG') THEN BEGIN
                           QtyKG := "Transfer Shipment Line"."Conversion Qty";
                           QtyPCS := "Transfer Shipment Line".Quantity;
                    END;
                    */

                    IF "Transfer Shipment Line".Quantity <> 0 THEN
                        QtyPCS := "Transfer Shipment Line"."Conversion Qty"
                    ELSE
                        QtyPCS := 0;

                end;

                trigger OnPreDataItem();
                begin
                    //NoOfRecords := "Sales Invoice Line".COUNT;
                    SlNo := 0;
                end;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
            }

            trigger OnAfterGetRecord();
            begin


                RecLoc1.RESET;
                IF RecLoc1.GET("Transfer Shipment Header"."Transfer-from Code") THEN BEGIN
                    FromStateCode := RecLoc1."State Code";
                    FromGSTNo := RecLoc1."GST Registration No.";
                    FromPhoneNo := RecLoc1."Phone No.";
                    FromPanCard := RecLoc1."P.A.N No";
                    FromFssialNo := RecLoc1."FSSAI No";
                    FromEmailId := RecLoc1."E-Mail";

                END;

                RecLoc2.RESET;
                IF RecLoc2.GET("Transfer Shipment Header"."Transfer-to Code") THEN BEGIN
                    ToStateCode := RecLoc2."State Code";
                    ToGSTNo := RecLoc2."GST Registration No.";
                    ToPhoneNo := RecLoc2."Phone No.";
                    ToPanCard := RecLoc2."P.A.N No";
                END;

                IF RecState1.GET(FromStateCode) THEN BEGIN
                    FromStateName := RecState1.Description;
                    FromCode := RecState1."State Code (GST Reg. No.)";
                END;

                IF RecState2.GET(ToStateCode) THEN BEGIN
                    ToStateName := RecState2.Description;
                    ToCode := RecState2."State Code (GST Reg. No.)";
                END;
            end;

            trigger OnPreDataItem();
            begin
                // FormatAddr.SalesHeaderShipTo(CustAddr,"Sales Header");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Functions)
                {
                    field("No Of Copies"; NoOfCopies)
                    {
                        Visible = false;
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

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        //FormatAddr.Company(CompanyAddr,CompanyInfo);
    end;

    var
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutPutNo: Integer;
        TEXT001: Label 'Original';
        COPYTEXT: Text;
        TEXT002: Label 'Duplicate';
        TEXT003: Label 'Triplicate';
        TEXT004: Label 'Quadraplicate';
        PageCaption: Label 'Page %1 of %2';
        NoOfRows: Integer;
        NoOfRecords: Integer;
        recCust: Record 18;
        repCheck: Report 1401;
        AmountinWords: array[5] of Text[250];
        TotalAmount: Decimal;
        recSalesLine: Record 37;
        TransferShipLine: Record 5745;
        SlNo: Integer;
        RecSalesInvLine: Record 113;
        Reclocation: Record 14;
        RecGSTSetup: Record "GST Setup";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTRate: Decimal;
        IGSTRate: Decimal;
        GrandTotal: Decimal;
        LocName: Text[100];
        LocAddr1: Text[200];
        LocAddr2: Text[200];
        LocCity: Text[20];
        LocPhone: Text[15];
        LocEmail: Text[30];
        LocCountry: Text[10];
        LocGSTNo: Code[15];
        RecCust1: Record 18;
        CustStatecode: Code[10];
        CustStatename: Text[20];
        RecState1: Record State;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        custname: Text[100];
        custaddr: Text[200];
        custaddr1: Text[200];
        custcity: Text[20];
        custcountry: Text[20];
        custphone: Code[20];
        custpincode: Code[20];
        custgstno: Code[15];
        custfssaino: Code[20];
        custemail: Text[50];
        custpersonname: Text[100];
        custpancard: Code[20];
        repCheck1: Report 1401;
        AmountinWords1: array[5] of Text[250];
        Intrastate: Text[30];
        Interstate: Text[30];
        FromStateCode: Code[20];
        ToStateCode: Code[20];
        RecLoc1: Record 14;
        RecLoc2: Record 14;
        FromGSTNo: Code[15];
        ToGSTNo: Code[15];
        FromPhoneNo: Text[30];
        ToPhoneNo: Text[30];
        FromStateName: Text[20];
        ToStateName: Text[20];
        FromCode: Code[10];
        ToCode: Code[10];
        RecState2: Record State;
        FromPanCard: Code[20];
        ToPanCard: Code[20];
        FromFssialNo: Code[20];
        FromEmailId: Text[50];
        RecILE: Record 32;
        Batch: Code[20];
        MFGDate: Date;
        EXPDate: Date;
        QtyPCS: Decimal;
        QtyKG: Decimal;
        FromCINNo: Code[20];
        ToCINNo: Code[20];
        RecItem: Record 27;
}

