report 50069 "OpenSales & Transfer List-Pre"
{
    // version CCIT-JAGA

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/OpenSales & Transfer List-Pre.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "Sell-to Customer No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Location Code", "Salesperson Code";
            column(LastDateAndTime_SalesHeader; "Sales Header"."Last Date And Time")
            {
            }
            column(Document_Type; Document_Type)
            {
            }
            column(Today; TODAY)
            {
            }
            column(LocationCode_SalesHeader; "Sales Header"."Location Code")
            {
            }
            column(BilltoName_SalesHeader; "Sales Header"."Bill-to Name")
            {
            }
            column(CustomerPriceGroup_SalesHeader; "Sales Header"."Customer Price Group")
            {
            }
            column(CustOutletArea; CustomerBusinessFormat)
            {
            }
            column(KAM; KAM)
            {
            }
            column(Cust_PO_SO_No; "Sales Header"."External Document No.")
            {
            }
            column(Cust_PO_SO_Date; "Sales Header"."Order Date")
            {
            }
            column(CRDD_Date; "Sales Header"."Promised Delivery Date")
            {
            }
            column(DaysPendingFor; DaysPendingFor)
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            column(DocumentDate_SalesHeader; "Sales Header"."Document Date")
            {
            }
            column(SalesCategory; SalesCategory)
            {
            }
            column(GenProdPostingGroup_SalesLine; GenProdPosGrp)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          "Outstanding Quantity" = FILTER(<> 0),
                                          Type = FILTER(<> 'G/L Account'));
                column(SL_ItemNo; "Sales Line"."No.")
                {
                }
                column(StorageCategory; StorageCategory)
                {
                }
                column(CustomerPriceGroup_SalesLine; "Sales Line"."Customer Price Group")
                {
                }
                column(ConversionQty_SalesLine; ROUND("Sales Line"."Conversion Qty", 1, '='))
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(Pending_Qty_KG; "Sales Line"."Outstanding Quantity")
                {
                }
                column(Pending_Qty_PC; Pending_Qty_PC)
                {
                }
                column(PendingOrderValue; "Sales Line"."Unit Price" * "Sales Line"."Outstanding Quantity")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
                {
                }
                column(ReasonCode_SalesLine; ReasonDes)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //CCIT-JAGA  07/12/2018
                    CLEAR(ReasonDes);
                    IF RecReasonCode.GET("Sales Line"."Reason Code") THEN
                        ReasonDes := RecReasonCode.Description;
                    //CCIT-JAGA  07/12/2018

                    IF NOT (Document_Type = Document_Type::"Open Sales") THEN
                        CurrReport.SKIP;

                    IF ("Sales Line"."No." = '') THEN
                        CurrReport.SKIP;

                    Sr_No += 1;

                    CLEAR(Pending_Qty_PC);

                    CLEAR(SalesCategory);
                    CLEAR(StorageCategory);
                    CLEAR(GenProdPosGrp);

                    RecItem.RESET;
                    IF RecItem.GET("Sales Line"."No.") THEN BEGIN
                        //BrandName := RecItem."Brand Name";
                        SalesCategory := RecItem."Sales Category";
                        StorageCategory := FORMAT(RecItem."Storage Categories");
                        GenProdPosGrp := RecItem."Gen. Prod. Posting Group";
                        //VendorNo := RecItem."Vendor No.";
                    END;

                    //MakeExcelDataBody;

                    //Pending_Qty_PC := "Sales Line"."Outstanding Quantity"
                    IF RecItem.GET("Sales Line"."No.") THEN BEGIN
                        IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                Pending_Qty_PC := ROUND(("Sales Line"."Outstanding Quantity" / RecUOM.Weight), 1, '=');
                            END
                        END
                    END;
                end;

                trigger OnPostDataItem();
                begin
                    //MakeExcelDataBody;
                    //MESSAGE('%1',Total);
                end;
            }

            trigger OnAfterGetRecord();
            begin

                CLEAR(KAM);

                IF NOT (Document_Type = Document_Type::"Open Sales") THEN
                    CurrReport.SKIP;

                IF RecCust.GET("Sales Header"."Sell-to Customer No.") THEN BEGIN
                    CustomerBusinessFormat := RecCust."Business Format / Outlet Name";
                    //CustName := RecCust.Name;
                END;

                RecSalesPerson.RESET;
                IF RecSalesPerson.GET("Sales Header"."Salesperson Code") THEN
                    KAM := RecSalesPerson.Name;

                IF "Sales Header"."Promised Delivery Date" <> 0D THEN
                    DaysPendingFor := "Sales Header"."Promised Delivery Date" - TODAY
                //ERROR('%1 - %2 = %3 ',"Sales Header"."Requested Delivery Date",TODAY,DaysPendingFor);
            end;

            trigger OnPostDataItem();
            begin

                //IF Document_Type = Document_Type::"Open Sales" THEN

                //MakeExcelDataFooter;
            end;

            trigger OnPreDataItem();
            begin

                //CCIT-PRI-280318
                CLEAR(LocCode);
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;

                LocCodeText := DELCHR(LocCode, '<', '|');

                IF LocCodeText <> '' THEN
                    "Sales Header".SETFILTER("Sales Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Header".SETRANGE("Sales Header"."Document Date", From_Date, To_Date)
                ELSE
                    IF (ReqDate <> 0D) THEN
                        "Sales Header".SETRANGE("Sales Header"."Document Date", 99990101D, ReqDate);
            end;
        }
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            column(LastDateAndTime_TransferHeader; "Transfer Header"."Last Date And Time")
            {
            }
            column(Document_Type1; Document_Type)
            {
            }
            column(Today1; TODAY)
            {
            }
            column(TransferfromCode_TransferHeader; "Transfer Header"."Transfer-from Code")
            {
            }
            column(TransfertoCode_TransferHeader; "Transfer Header"."Transfer-to Code")
            {
            }
            column(Cust_PO_SO_No1; "Transfer Header"."External Document No.")
            {
            }
            column(Cust_PO_SO_Date1; "Transfer Header"."Order Date")
            {
            }
            column(No_TransferHeader; "Transfer Header"."No.")
            {
            }
            column(GenProdPostingGroup_TransferLine; GenProdPosGrp1)
            {
            }
            column(No_Of_Days_Pending; No_Of_Days_Pending)
            {
            }
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Quantity = FILTER(<> 0),
                                          "Outstanding Quantity" = FILTER(<> 0),
                                          "Derived From Line No." = FILTER(0));
                column(TL_ItemNo; "Transfer Line"."Item No.")
                {
                }
                column(ReasonForTO_TransferLine; "Transfer Line"."Reason For TO")
                {
                }
                column(ReasonCode_TransferLine; ReasonDes1)
                {
                }
                column(TransferFromReasonCode_TransferLine; ReasonDes1)
                {
                }
                column(CustomerName_TransferLine; "Transfer Line"."Customer Name")
                {
                }
                column(CustPriceGroup1; CustPriceGroup1)
                {
                }
                column(CustOutletArea1; CustOutletArea1)
                {
                }
                column(KAM1; KAM1)
                {
                }
                column(StorageCategory1; StorageCategory1)
                {
                }
                column(ConversionQty_TransferLine; ROUND("Transfer Line"."Conversion Qty", 1, '='))
                {
                }
                column(Quantity_TransferLine; "Transfer Line".Quantity)
                {
                }
                column(OutstandingQuantityInKG_TransferLine; Pending_Qty_PC1)
                {
                }
                column(OutstandingQuantity_TransferLine; "Transfer Line"."Outstanding Quantity")
                {
                }
                column(PendingOrderValue1; "Transfer Line"."Transfer Price" * "Transfer Line"."Outstanding Quantity")
                {
                }
                column(Description_TransferLine; "Transfer Line".Description)
                {
                }
                column(SalesCategory1; SalesCategory1)
                {
                }
                column(UnitofMeasureCode_TransferLine; "Transfer Line"."Unit of Measure Code")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //CCIT-JAGA  07/12/2018
                    CLEAR(ReasonDes1);
                    IF RecReasonCode.GET("Transfer Line"."Reason Code") THEN
                        ReasonDes1 := RecReasonCode.Description;
                    //CCIT-JAGA  07/12/2018


                    IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                        CurrReport.SKIP;
                    IF ("Transfer Line"."Item No." = '') THEN
                        CurrReport.SKIP;

                    CLEAR(Pending_Qty_PC1);

                    CLEAR(CustPriceGroup1);
                    CLEAR(CustOutletArea1);
                    CLEAR(KAM1);
                    CLEAR(SalesCategory1);
                    CLEAR(StorageCategory1);
                    CLEAR(KAMCode);

                    RecCust.RESET;
                    IF RecCust.GET("Transfer Line"."Customer No.") THEN BEGIN
                        CustPriceGroup1 := RecCust."Customer Price Group";
                        CustOutletArea1 := RecCust."Business Format / Outlet Name";
                        KAMCode := RecCust."Salesperson Code";
                    END;

                    RecSalesPerson.RESET;
                    IF RecSalesPerson.GET(KAMCode) THEN
                        KAM1 := RecSalesPerson.Name;

                    RecItem.RESET;
                    IF RecItem.GET("Transfer Line"."Item No.") THEN BEGIN
                        //BrandName := RecItem."Brand Name";
                        SalesCategory1 := RecItem."Sales Category";
                        StorageCategory1 := FORMAT(RecItem."Storage Categories");
                        //VendorNo := RecItem."Vendor No.";
                    END;

                    //OutstandingQuantityInKG_TransferLine
                    IF RecItem.GET("Transfer Line"."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem."No.", RecItem."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                Pending_Qty_PC1 := ROUND(("Transfer Line"."Outstanding Quantity" / RecUOM.Weight), 1, '=');
                            END
                        END
                    END;

                    //MakeExcelDataBody1;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                    CurrReport.SKIP;

                RecItem.RESET;
                IF RecItem.GET("Transfer Line"."Item No.") THEN BEGIN
                    GenProdPosGrp1 := RecItem."Gen. Prod. Posting Group";
                    //VendorNo := RecItem."Vendor No.";
                END;
                IF "Transfer Header"."Order Date" <> 0D THEN
                    No_Of_Days_Pending := ABS("Transfer Header"."Order Date" - TODAY)
                ELSE
                    No_Of_Days_Pending := 0;
            end;

            trigger OnPostDataItem();
            begin
                IF NOT (Document_Type = Document_Type::"Open Transfer") THEN
                    CurrReport.SKIP;

                //MakeExcelDataFooter1;
            end;

            trigger OnPreDataItem();
            begin
                CLEAR(No_Of_Days_Pending);
                //IF (ReqDate <> 0D) THEN
                //"Transfer Header".SETRANGE("Transfer Header"."Posting Date",ReqDate);
                //IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                //"Transfer Header".SETRANGE("Transfer Header"."Posting Date",From_Date,To_Date);

                //CCIT-PRI-280318
                "Transfer Header".SETFILTER("Transfer Header"."Transfer-from Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Transfer Header".SETRANGE("Transfer Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (ReqDate <> 0D) THEN
                        "Transfer Header".SETRANGE("Transfer Header"."Posting Date", 99990101D, ReqDate);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Document Type"; Document_Type)
                {
                }
                group("As On Date Filtre")
                {
                    field("As On Date"; ReqDate)
                    {

                        trigger OnValidate();
                        begin
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                                ReqDate := 0D;
                                MESSAGE('From Date - To Date Allready Entered....');
                            END;

                        end;
                    }
                }
                group("From Date - To Date Filter")
                {
                    field("From Date"; From_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (ReqDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date Allready Entered....');
                            END;
                        end;
                    }
                    field("To Date"; To_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (ReqDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date Allready Entered....');
                            END;
                        end;
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
        CompInfo.GET;
    end;

    trigger OnPostReport();
    begin
        /*
        IF Document_Type = Document_Type::"Open Sales" THEN
          CreateExcelbook
        ELSE IF Document_Type = Document_Type::"Open Transfer" THEN
          CreateExcelbook1;
        */

    end;

    var
        Document_Type: Option " ","Open Sales","Open Transfer";
        ReqDate: Date;
        ExcelBuf: Record 370 temporary;
        Sr_No: Integer;
        RecCust: Record 18;
        CompInfo: Record 79;
        CustomerBusinessFormat: Text[100];
        RecSalesPerson: Record 13;
        KAM: Text[50];
        RecItem: Record 27;
        StorageCategory: Text[10];
        SalesCategory: Text[20];
        CustOutletArea1: Text[100];
        CustPriceGroup1: Text[10];
        KAM1: Text[50];
        StorageCategory1: Text[10];
        SalesCategory1: Text[20];
        KAMCode: Code[10];
        From_Date: Date;
        To_Date: Date;
        DaysPendingFor: Integer;
        GenProdPosGrp: Code[10];
        GenProdPosGrp1: Code[10];
        Pending_Qty_PC: Decimal;
        RecUOM: Record 5404;
        Pending_Qty_PC1: Decimal;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        No_Of_Days_Pending: Integer;
        RecReasonCode: Record 231;
        ReasonDes: Text[50];
        ReasonDes1: Text[50];
        ReasonDes2: Text[50];
}

