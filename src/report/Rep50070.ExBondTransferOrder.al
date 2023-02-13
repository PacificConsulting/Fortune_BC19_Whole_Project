report 50070 "Ex-Bond Transfer Order"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Ex-Bond Transfer Order.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            RequestFilterFields = "No.";
            column(CustomerLicensename_TransferHeader; "Transfer Header"."Customer License name")
            {
            }
            column(CustomerLicenseNo_TransferHeader; "Transfer Header"."Customer License No.")
            {
            }
            column(BondNumber_TransferHeader; "Transfer Header"."Bond Number")
            {
            }
            column(BondDate_TransferHeader; "Transfer Header"."Bond Date")
            {
            }
            column(No_TransferHeader; "Transfer Header"."No.")
            {
            }
            column(TransferfromCode_TransferHeader; "Transfer Header"."Transfer-from Code")
            {
            }
            column(TransferfromName_TransferHeader; "Transfer Header"."Transfer-from Name")
            {
            }
            column(TransferfromName2_TransferHeader; "Transfer Header"."Transfer-from Name 2")
            {
            }
            column(TransferfromAddress_TransferHeader; "Transfer Header"."Transfer-from Address")
            {
            }
            column(TransferfromAddress2_TransferHeader; "Transfer Header"."Transfer-from Address 2")
            {
            }
            column(TransferfromPostCode_TransferHeader; "Transfer Header"."Transfer-from Post Code")
            {
            }
            column(TransferfromCity_TransferHeader; "Transfer Header"."Transfer-from City")
            {
            }
            column(TransferfromCounty_TransferHeader; "Transfer Header"."Transfer-from County")
            {
            }
            column(TrsffromCountryRegionCode_TransferHeader; "Transfer Header"."Trsf.-from Country/Region Code")
            {
            }
            column(DFLicenseType_TransferHeader; "Transfer Header"."DF License Type")
            {
            }
            column(DFLicenseDate_TransferHeader; "Transfer Header"."DF License Date")
            {
            }
            column(CHAName_TransferHeader; "Transfer Header"."CHA Name")
            {
            }
            column(ExBondOrderNo_TransferHeader; "Transfer Header"."Ex Bond Order No.")
            {
            }
            column(ExBondOrderDate_TransferHeader; "Transfer Header"."Ex Bond Order Date")
            {
            }
            column(SuppilerPONo_TransferHeader; "Transfer Header"."Supplier PO No.")
            {
            }
            column(SupplierPODate_TransferHeader; "Transfer Header"."Supplier PO Date")
            {
            }
            column(SupplierName_TransferHeader; "Transfer Header"."Supplier Name")
            {
            }
            column(CHAContactPerson_TransferHeader; "Transfer Header"."CHA Contact Person")
            {
            }
            column(TransfertoCode_TransferHeader; "Transfer Header"."Transfer-to Code")
            {
            }
            column(TransfertoName_TransferHeader; "Transfer Header"."Transfer-to Name")
            {
            }
            column(ExternalDocumentNo_TransferHeader; "Transfer Header"."External Document No.")
            {
            }
            column(TransfertoName2_TransferHeader; "Transfer Header"."Transfer-to Name 2")
            {
            }
            column(TransfertoAddress_TransferHeader; "Transfer Header"."Transfer-to Address")
            {
            }
            column(TransfertoAddress2_TransferHeader; "Transfer Header"."Transfer-to Address 2")
            {
            }
            column(TransfertoPostCode_TransferHeader; "Transfer Header"."Transfer-to Post Code")
            {
            }
            column(TransfertoCity_TransferHeader; "Transfer Header"."Transfer-to City")
            {
            }
            column(TransfertoCounty_TransferHeader; "Transfer Header"."Transfer-to County")
            {
            }
            column(PostingDate_TransferHeader; "Transfer Header"."Posting Date")
            {
            }
            column(TransferfromContact_TransferHeader; "Transfer Header"."Transfer-from Contact")
            {
            }
            column(TransfertoContact_TransferHeader; "Transfer Header"."Transfer-to Contact")
            {
            }
            column(LicenseNo_TransferHeader; "Transfer Header"."License No.")
            {
            }
            column(InBondBillofEntryNo_TransferHeader; "Transfer Header"."In-Bond Bill of Entry No.")
            {
            }
            column(InBondBOEDate_TransferHeader; "Transfer Header"."In-Bond BOE Date")
            {
            }
            column(ExbondBOENo_TransferHeader; "Transfer Header"."Ex-bond BOE No.")
            {
            }
            column(ExbondBOEDate_TransferHeader; "Transfer Header"."Ex-bond BOE Date")
            {
            }
            column(CompPicture; RecCompInfo.Picture)
            {
            }
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(SrNo; SrNo)
                {
                }
                column(Amount_TransferLine; "Transfer Line".Amount)
                {
                }
                column(DocumentNo_TransferLine; "Transfer Line"."Document No.")
                {
                }
                column(ItemNo_TransferLine; "Transfer Line"."Item No.")
                {
                }
                column(Quantity_TransferLine; "Transfer Line".Quantity)
                {
                }
                column(ProductSRNoBE_TransferLine; "Transfer Line"."Product SR No.BE")
                {
                }
                column(InvoiceSRNoBE_TransferLine; "Transfer Line"."Invoice SR No.BE")
                {
                }
                column(BoxCaseNo_TransferLine; "Transfer Line"."Box/Case No.")
                {
                }
                column(UnitofMeasure_TransferLine; "Transfer Line"."Unit of Measure")
                {
                }
                column(UOM; UOM)
                {
                }
                column(Description_TransferLine; "Transfer Line".Description)
                {
                }
                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemLink = "Item No." = FIELD("Item No."),
                                   "Source ID" = FIELD("Document No.");
                    DataItemTableView = WHERE("Source Subtype" = CONST(0));
                    column(QuantityBase_ReservationEntry; "Reservation Entry"."Quantity (Base)")
                    {
                    }
                    column(LotNo_ReservationEntry; "Reservation Entry"."Lot No.")
                    {
                    }
                    column(MFG_Date; MFG_Date)
                    {
                    }
                    column(EXP_Date; EXP_Date)
                    {
                    }
                    column(Ex_Bond_Qty_PCS; "Ex Bond Qty PCS")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin

                        RecILE.RESET;
                        RecILE.SETRANGE(RecILE."Lot No.", "Reservation Entry"."Lot No.");
                        IF RecILE.FINDFIRST THEN BEGIN
                            MFG_Date := RecILE."Manufacturing Date";
                            EXP_Date := RecILE."Expiration Date";
                        END;

                        IF RecItem2.GET("Reservation Entry"."Item No.") THEN BEGIN
                            IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                IF (RecUOM.Weight <> 0) THEN BEGIN
                                    "Ex Bond Qty PCS" := "Reservation Entry"."Quantity (Base)" / RecUOM.Weight;
                                END
                            END
                        END;
                    end;

                    trigger OnPreDataItem();
                    begin
                        MFG_Date := 0D;
                        EXP_Date := 0D;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    SrNo += 1;
                    IF RecItem.GET("Transfer Line"."Item No.") THEN
                        UOM := RecItem."Base Unit of Measure";
                end;

                trigger OnPreDataItem();
                begin
                    SrNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF ("Transfer Header"."Transfer-from Code" <> 'JWL BOND') THEN
                    ERROR('This Report is only for JWL Bond Location');
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

    trigger OnInitReport();
    begin
        RecCompInfo.RESET;
        RecCompInfo.GET;
        RecCompInfo.CALCFIELDS(Picture);


    end;

    var
        RecCompInfo: Record 79;
        SrNo: Integer;
        RecILE: Record 32;
        MFG_Date: Date;
        EXP_Date: Date;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        "Ex Bond Qty PCS": Decimal;
        UOM: Text[10];
        RecItem: Record 27;
}

