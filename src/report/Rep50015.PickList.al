report 50015 "Pick List"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Pick List.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            RequestFilterFields = "No.";
            column(LocationCode_WarehouseActivityHeader; "Warehouse Activity Header"."Location Code")
            {
            }
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
            column(From_Loc; From_Loc)
            {
            }
            column(To_Loc; To_Loc)
            {
            }
            column(Addr_From_Loc; Addr_From_Loc)
            {
            }
            column(Addr1_From_Loc; Addr1_From_Loc)
            {
            }
            column(OrderDate1; OrderDate1)
            {
            }
            column(Cust_PO_SO_No; Cust_PO_SO_No)
            {
            }
            column(Cust_PO_SO_Date; Cust_PO_SO_Date)
            {
            }
            column(CRDD; CRDD)
            {
            }
            column(Shelflife; Shelflife)
            {
            }
            column(Cust_Name; Cust_Name)
            {
            }
            column(Cust_Addrs; Cust_Addrs)
            {
            }
            column(Cust_Addrs2; Cust_Addrs2)
            {
            }
            column(Cust_City; Cust_City)
            {
            }
            column(RouteDay; RouteDay)
            {
            }
            column(Loc_Name; Loc_Name)
            {
            }
            column(Loc_Addrs; Loc_Addrs)
            {
            }
            column(Loc_Addrs2; Loc_Addrs2)
            {
            }
            column(Loc_City; Loc_City)
            {
            }



            dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(QtytoHandle_WarehouseActivityLine; "Warehouse Activity Line"."Qty. to Handle")
                {
                }
                column(ConversionQtyToHandle_WarehouseActivityLine; "Warehouse Activity Line"."Conversion Qty To Handle")
                {
                }
                column(TOQtyInPCS_WarehouseActivityLine; "Warehouse Activity Line"."TO Qty. In PCS")
                {
                }
                column(TOQtyInKG_WarehouseActivityLine; "Warehouse Activity Line"."TO Qty. In KG")
                {
                }
                column(FillRate_WarehouseActivityLine; "Warehouse Activity Line"."Fill Rate %")
                {
                }
                column(ReasonCode_WarehouseActivityLine; ReasonDes)
                {
                }
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
                column(StorageType; StorageType)
                {
                }
                column(OrderQtyKG; OrderQtyKG)
                {
                }
                column(OrderQtyPCS; OrderQtyPCS)
                {
                }
                column(ManfDate; ManfDate)
                {
                }


                trigger OnAfterGetRecord();
                begin
                    SrNo += 1;

                    //CCIT-JAGA 07/12/2018
                    CLEAR(ReasonDes);
                    IF RecReasonCode.GET("Warehouse Activity Line"."Reason Code") THEN
                        ReasonDes := RecReasonCode.Description;
                    //CCIT-JAGA 07/12/2018

                    IF RecItem.GET("Warehouse Activity Line"."Item No.") THEN
                        StorageType := FORMAT(RecItem."Storage Categories");

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

                    IF ("Warehouse Activity Line"."TO Qty. In KG" = 0) AND ("Warehouse Activity Line"."TO Qty. In PCS" = 0) THEN BEGIN
                        OrderQtyKG := "Warehouse Activity Line".Quantity;
                        OrderQtyPCS := "Warehouse Activity Line"."Conversion Qty";
                    END
                    ELSE BEGIN
                        OrderQtyKG := "Warehouse Activity Line"."TO Qty. In PCS";
                        OrderQtyPCS := "Warehouse Activity Line"."TO Qty. In KG";
                    END;
                    // Message('Man Date');
                    RecILE.Reset();
                    RecILE.SetRange("Item No.", "Item No.");
                    RecILE.SetRange("Lot No.", "Lot No.");
                    if RecILE.FindFirst() then begin
                        ManfDate := RecILE."Warranty Date";

                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SrNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecCust.GET("Warehouse Activity Header"."Destination No.") THEN BEGIN
                    Cust_Name := RecCust.Name;
                    Cust_Addrs := RecCust.Address;
                    Cust_Addrs2 := RecCust."Address 2";
                    Cust_City := RecCust.City;
                END;

                IF RecLoc.GET("Warehouse Activity Header"."Destination No.") THEN BEGIN
                    Loc_Name := RecLoc.Name;
                    Loc_Addrs := RecLoc.Address;
                    Loc_Addrs2 := RecLoc."Address 2";
                    Loc_City := RecLoc.City;
                END;


                IF "Warehouse Activity Header"."Source Document" = "Warehouse Activity Header"."Source Document"::"Sales Order" THEN BEGIN
                    RecSH.RESET;
                    RecSH.SETRANGE(RecSH."No.", "Warehouse Activity Header"."Source No.");
                    IF RecSH.FINDFIRST THEN BEGIN
                        //VendorOrderNo := RecTH."Vendor Order No.";
                        //OrderDate := RecTH."Order Date";
                        SourceDate := RecSH."Posting Date";
                        From_Loc := RecSH."Location Code";
                        //To_Loc := RecSH."Transfer-to Code";
                        OrderDate1 := RecSH."Posting Date";
                        Cust_PO_SO_Date := RecSH."Order Date";
                        Cust_PO_SO_No := RecSH."External Document No.";
                        CRDD := RecSH."Promised Delivery Date";
                        IF RecCust.GET(RecSH."Sell-to Customer No.") THEN BEGIN
                            Shelflife := RecCust."Minimum Shelf Life %";
                            //Cust_Name := RecCust.Name;
                            //Cust_Addrs := RecCust.Address+','+RecCust."Address 2";
                            IF RecCust.Sunday = TRUE THEN
                                Sun := 'Sunday';
                            IF RecCust.Monday = TRUE THEN
                                Mon := 'Monday';
                            IF RecCust.Tuesday = TRUE THEN
                                Tue := 'Tuesday';
                            IF RecCust.Wednesday = TRUE THEN
                                Wed := 'Wednesday';
                            IF RecCust.Thursday = TRUE THEN
                                Tha := 'Thursday';
                            IF RecCust.Friday = TRUE THEN
                                Fri := 'Friday';
                            IF RecCust.Saturday = TRUE THEN
                                Sat := 'Saturday';
                        END;
                        RouteDay := Sun + '  ' + Mon + '  ' + Tue + '  ' + Wed + '  ' + Tha + '  ' + Fri + '  ' + Sat;
                    END;
                END
                ELSE BEGIN
                    RecTH.RESET;
                    RecTH.SETRANGE(RecTH."No.", "Warehouse Activity Header"."Source No.");
                    IF RecTH.FINDFIRST THEN BEGIN
                        //VendorOrderNo := RecTH."Vendor Order No.";
                        //OrderDate := RecTH."Order Date";
                        SourceDate := RecTH."Posting Date";
                        From_Loc := RecTH."Transfer-from Code";
                        To_Loc := RecTH."Transfer-to Code";
                        OrderDate1 := RecTH."Order Date";
                        Cust_PO_SO_Date := RecTH."Customer PO/SO Date";
                        Cust_PO_SO_No := RecTH."External Document No.";
                    END;
                END;

                IF RecLoc.GET(From_Loc) THEN BEGIN
                    Addr_From_Loc := RecLoc.Address;
                    Addr1_From_Loc := RecLoc."Address 2";

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
        Loc_City: Text[30];
        Loc_Addrs2: Text[50];
        Cust_Addrs2: Text[50];
        Cust_City: Text[30];
        Loc_Addrs: Text[50];
        Loc_Name: Text[50];
        RecCompInfo: Record 79;
        SrNo: Integer;
        QtyPCS: Decimal;
        QtyKG: Decimal;
        RecUOM: Record 5404;
        RecTH: Record 5740;
        VendorOrderNo: Code[20];
        OrderDate: Date;
        SourceDate: Date;
        RecItem: Record 27;
        StorageType: Code[20];
        From_Loc: Code[10];
        To_Loc: Code[10];
        Addr_From_Loc: Text[100];
        Addr1_From_Loc: Text[100];
        RecLoc: Record 14;
        OrderDate1: Date;
        Cust_PO_SO_No: Code[20];
        Cust_PO_SO_Date: Date;
        OrderQtyKG: Decimal;
        OrderQtyPCS: Decimal;
        RecSH: Record 36;
        CRDD: Date;
        RouteDay: Text[100];
        Shelflife: Decimal;
        RecCust: Record 18;
        Cust_Name: Text[50];
        Cust_Addrs: Text[200];
        Sun: Text[10];
        Mon: Text[10];
        Tue: Text[10];
        Wed: Text[10];
        Tha: Text[10];
        Fri: Text[10];
        Sat: Text[10];
        RecReasonCode: Record 231;
        ReasonDes: Text[50];
        RecILE: Record 32;
        ManfDate: Date;



}

