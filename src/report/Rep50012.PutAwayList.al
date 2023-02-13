report 50012 "PutAway List"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/PutAway List.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            RequestFilterFields = "No.";
            column(SourceNo_WarehouseActivityHeader; "Warehouse Activity Header"."Source No.")
            {
            }
            column(No_WarehouseActivityHeader; "Warehouse Activity Header"."No.")
            {
            }
            column(PostingDate_WarehouseActivityHeader; "Warehouse Activity Header"."Posting Date")
            {
            }
            column(ExternalDocumentNo_WarehouseActivityHeader; "Warehouse Activity Header"."External Document No.")
            {
            }
            column(ExpectedReceiptDate_WarehouseActivityHeader; "Warehouse Activity Header"."Expected Receipt Date")
            {
            }
            column(Comp_Name; RecCompInfo.Name)
            {
            }
            column(RecCompInfo_Address; RecCompInfo.Address)
            {
            }
            column(RecCompInfo_City; RecCompInfo.City)
            {
            }
            column(RecCompInfo_County; RecCompInfo.County)
            {
            }
            column(RecCompInfo_Post_Code; RecCompInfo."Post Code")
            {
            }
            column(RecCompInfo_Phone_No; RecCompInfo."Phone No.")
            {
            }
            column(RecCompInfo_Picture; RecCompInfo.Picture)
            {
            }
            column(VendorOrderNo; VendorOrderNo)
            {
            }
            column(OrderDate; OrderDate)
            {
            }
            column(SourceDate; SourceDate)
            {
            }
            dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(ConversionQty_WarehouseActivityLine; "Warehouse Activity Line"."Conversion Qty")
                {
                }
                column(LotNo_WarehouseActivityLine; "Warehouse Activity Line"."Lot No.")
                {
                }
                column(ExpirationDate_WarehouseActivityLine; "Warehouse Activity Line"."Expiration Date")
                {
                }
                column(ManufacturingDate_WarehouseActivityLine; "Warehouse Activity Line"."Manufacturing Date")
                {
                }
                column(No_WarehouseActivityLine; "Warehouse Activity Line"."No.")
                {
                }
                column(ItemNo_WarehouseActivityLine; "Warehouse Activity Line"."Item No.")
                {
                }
                column(UnitofMeasureCode_WarehouseActivityLine; "Warehouse Activity Line"."Unit of Measure Code")
                {
                }
                column(Description_WarehouseActivityLine; "Warehouse Activity Line".Description)
                {
                }
                column(Quantity_WarehouseActivityLine; "Warehouse Activity Line".Quantity)
                {
                }
                column(SrNo; SrNo)
                {
                }
                column(QtyPCS; QtyPCS)
                {
                }
                column(QtyKG; QtyKG)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    SrNo += 1;

                    QtyPCS := 0;
                    QtyKG := 0;
                    IF ("Warehouse Activity Line"."Unit of Measure Code" = 'PCS') THEN BEGIN
                        QtyPCS := "Warehouse Activity Line".Quantity;
                        QtyKG := "Warehouse Activity Line"."Conversion Qty";
                    END ELSE
                        IF ("Warehouse Activity Line"."Unit of Measure Code" = 'KG') THEN BEGIN
                            QtyKG := "Warehouse Activity Line"."Conversion Qty";
                            QtyPCS := "Warehouse Activity Line".Quantity;
                        END;
                end;

                trigger OnPreDataItem();
                begin
                    SrNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Warehouse Activity Header"."Source No.");
                IF RecPH.FINDFIRST THEN BEGIN
                    VendorOrderNo := RecPH."Vendor Order No.";
                    OrderDate := RecPH."Order Date";
                    SourceDate := RecPH."Posting Date";
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

    trigger OnInitReport();
    begin
        RecCompInfo.GET;
        RecCompInfo.CALCFIELDS(Picture);
    end;

    var
        RecCompInfo: Record 79;
        SrNo: Integer;
        QtyPCS: Decimal;
        QtyKG: Decimal;
        RecUOM: Record "Item Unit of Measure";
        RecPH: Record 38;
        VendorOrderNo: Code[20];
        OrderDate: Date;
        SourceDate: Date;
}

