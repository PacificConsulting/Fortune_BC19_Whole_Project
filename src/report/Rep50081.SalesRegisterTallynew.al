report 50081 "Sales Register - Tally new"
{
    // version RDK in use

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Register - Tally new.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Rec_Location; Location)
        {
            DataItemTableView = SORTING(Code)
                                WHERE("Use As In-Transit" = FILTER(false));
            RequestFilterFields = "Code";
            dataitem("Customer Posting Group"; "Customer Posting Group")
            {
                DataItemTableView = SORTING(Code)
                                    ORDER(Ascending);
                RequestFilterFields = "Code";
                column(CustPostingCode; "Customer Posting Group".Code)
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(Name; RecComp.Name)
                {
                }
                column(Address; RecComp.Address)
                {
                }
                column(Address2; RecComp."Address 2")
                {
                }
                column(City; RecComp.City)
                {
                }
                column(PhoneNo; RecComp."Phone No.")
                {
                }
                column(StateCode; '')//RecComp.State) //PCPL/MIG/NSW Filed not Exist in BC18
                {
                }
                column(PostCode; RecComp."Post Code")
                {
                }
                column(StateDes; State)
                {
                }
                column(From_Date; From_Date)
                {
                }
                column(To_Date; To_Date)
                {
                }
                column(FSSAI_No; RecLoc."FSSAI No")
                {
                }
                column(FASSILicenseNo; FASSILicenseNo)
                {
                }
                column(Loc_Code; Loc_Code)
                {
                }
                column(CompanyAddr1; CompanyAddr)
                {
                }
                column(LicenseNo; LicenseNo)
                {
                }
                column(CompanyAddr2; CompanyAddr)
                {
                }
                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    DataItemLink = "Customer Posting Group" = FIELD(Code);
                    DataItemTableView = SORTING("Customer Posting Group", "Posting Date")
                                        ORDER(Ascending);
                    column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
                    {
                    }
                    column(CustomerPostingGroup_SalesInvoiceHeader; "Sales Invoice Header"."Customer Posting Group")
                    {
                    }
                    column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
                    {
                    }
                    column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        //CCIT-JP-020419
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date);

                        IF Loc_Code <> '' THEN
                            "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Location Code", Loc_Code);

                        IF Cust_Group <> '' THEN
                            "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Customer Posting Group", Cust_Group);


                        //CCIT-JP-020419
                        RecSalesInvLine.RESET;
                        RecSalesInvLine.SETRANGE(RecSalesInvLine."Document No.", "Sales Invoice Header"."No.");
                        RecSalesInvLine.SETFILTER(RecSalesInvLine.Type, '%1', RecSalesInvLine.Type::Item);

                        IF RecSalesInvLine.FINDFIRST THEN
                            REPEAT
                                CLEAR(Name);
                                CLEAR(OutLateName);
                                RecCust.RESET;
                                RecCust.SETRANGE("No.", RecSalesInvLine."Sell-to Customer No.");
                                IF RecCust.FINDFIRST THEN BEGIN
                                    Name := RecCust.Name;
                                    OutLateName := RecCust."Business Format / Outlet Name";
                                END;



                                RecBuffer.RESET;
                                RecBuffer.SETFILTER(RecBuffer."Document No.", RecSalesInvLine."Document No.");
                                RecBuffer.SETRANGE(RecBuffer."Line No", RecSalesInvLine."Line No.");
                                IF NOT RecBuffer.FINDFIRST THEN BEGIN
                                    RecBuffer.INIT;
                                    RecBuffer."Document No." := RecSalesInvLine."Document No.";
                                    RecBuffer."Document Type" := RecBuffer."Document Type"::Invoice;
                                    RecBuffer."Line No" := RecSalesInvLine."Line No.";
                                    RecBuffer."Posting Date" := RecSalesInvLine."Posting Date";
                                    RecBuffer."Item No" := RecSalesInvLine."No.";
                                    RecBuffer.Description := RecSalesInvLine.Description;
                                    RecBuffer."Customer No." := RecSalesInvLine."Sell-to Customer No.";
                                    RecBuffer."Customer Name" := Name;
                                    RecBuffer.Quantity := RecSalesInvLine.Quantity;
                                    RecBuffer."Unit Price" := RecSalesInvLine."Unit Price";
                                    RecBuffer."Customer Posting Group" := "Sales Invoice Header"."Customer Posting Group";
                                    RecBuffer.Brand := OutLateName;
                                    /* //PCPL/MIG/NSW Filed not Exist in BC18
                                    IF RecSalesInvLine."Amount To Customer" = 0 THEN
                                      BEGIN
                                        RecBuffer."Amount To Customer" := RecSalesInvLine.Quantity * RecSalesInvLine."Unit Price";
                                      END
                                    ELSE
                                      BEGIN
                                        */
                                    //PCPL/MIG/NSW Filed not Exist in BC18
                                    //RecBuffer."Amount To Customer" := RecSalesInvLine."Amount To Customer";
                                    RecBuffer."Amount To Customer" := RecSalesInvLine."Line Amount";
                                    RecBuffer."Charge To Customer" := 0;//RecSalesInvLine."Charges To Customer"; //PCPL/MIG/NSW Filed not Exist in BC18
                                                                        //END;
                                    RecBuffer."Location Code" := RecSalesInvLine."Location Code";
                                    RecBuffer."Unit Of Measure Code" := RecSalesInvLine."Unit of Measure Code";

                                    //CCIT-JP-040419
                                    IF RecLoc.GET(RecBuffer."Location Code") THEN BEGIN
                                        RecBuffer."FASSI No." := RecLoc."FSSAI No";
                                        RecBuffer.Name := RecLoc.Name;
                                        RecBuffer.Name2 := RecLoc."Name 2";
                                        RecBuffer.Address := RecLoc.Address;
                                        RecBuffer.Address2 := RecLoc."Address 2";
                                        RecBuffer."Phone No." := RecLoc."Phone No.";
                                        RecBuffer."Phone No.2" := RecLoc."Phone No. 2";
                                        RecBuffer.City := RecLoc.City;
                                        RecBuffer."Post Code" := RecLoc."Post Code";
                                    END;

                                    RecStae.RESET;
                                    RecStae.SETRANGE(RecStae.Code, RecLoc."State Code");
                                    IF RecStae.FINDFIRST THEN
                                        RecBuffer.State := RecStae.Description;

                                    RecBuffer.INSERT;
                                END;
                            UNTIL RecSalesInvLine.NEXT = 0;
                        //CCIT-JP-040419
                    end;

                    trigger OnPreDataItem();
                    begin
                        //CCIT-JP-020419
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date);

                        IF Loc_Code <> '' THEN
                            "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Location Code", Loc_Code);

                        //CCIT-JP-020419
                    end;
                }
                dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
                {
                    DataItemLink = "Customer Posting Group" = FIELD(Code);
                    DataItemLinkReference = "Customer Posting Group";
                    DataItemTableView = SORTING("Customer Posting Group", "Posting Date")
                                        ORDER(Ascending);
                    column(PostingDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Posting Date")
                    {
                    }
                    column(SelltoCustomerNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Sell-to Customer No.")
                    {
                    }
                    column(CustomerPostingGroup_SalesCrMemoHeader; "Sales Cr.Memo Header"."Customer Posting Group")
                    {
                    }
                    column(No_SalesCrMemoHeader; "Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(ReasonCode_SalesCrMemoHeader; "Sales Cr.Memo Header"."Reason Code")
                    {
                    }
                    column(LocationCode; "Sales Invoice Header"."Location Code")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        //CCIT-JP-020419
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", From_Date, To_Date);

                        IF Loc_Code <> '' THEN
                            "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Location Code", Loc_Code);

                        IF Cust_Group <> '' THEN
                            "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Customer Posting Group", Cust_Group);

                        //CCIT-JP-020419
                        RecSalesCrLine.RESET;
                        RecSalesCrLine.SETRANGE(RecSalesCrLine."Document No.", "Sales Cr.Memo Header"."No.");
                        RecSalesCrLine.SETRANGE(RecSalesCrLine.Type, RecSalesCrLine.Type::Item);
                        IF RecSalesCrLine.FINDFIRST THEN
                            REPEAT
                                CLEAR(CRName);
                                CLEAR(CROutLateName);
                                RecCust1.RESET;
                                RecCust1.SETRANGE("No.", RecSalesCrLine."Sell-to Customer No.");
                                IF RecCust1.FINDFIRST THEN BEGIN
                                    CRName := RecCust1.Name;
                                    CROutLateName := RecCust1."Business Format / Outlet Name";
                                END;


                                RecBuffer1.RESET;
                                RecBuffer1.SETRANGE(RecBuffer1."Document No.", RecSalesCrLine."Document No.");
                                RecBuffer1.SETFILTER(RecBuffer1."Line No", '%1', RecSalesCrLine."Line No.");
                                IF NOT RecBuffer1.FINDFIRST THEN BEGIN
                                    RecBuffer1.INIT;
                                    RecBuffer1."Document No." := RecSalesCrLine."Document No.";
                                    RecBuffer1."Document Type" := RecBuffer1."Document Type"::Credit;
                                    RecBuffer1."Line No" := RecSalesCrLine."Line No.";
                                    RecBuffer1."Posting Date" := RecSalesCrLine."Posting Date";
                                    RecBuffer1."Item No" := RecSalesCrLine."No.";
                                    RecBuffer1.Description := RecSalesCrLine.Description;
                                    RecBuffer1."Customer No." := RecSalesCrLine."Sell-to Customer No.";
                                    RecBuffer1."Customer Name" := CRName;
                                    RecBuffer1.Quantity := RecSalesCrLine.Quantity;
                                    RecBuffer1."Unit Price" := RecSalesCrLine."Unit Price";
                                    RecBuffer1."Customer Posting Group" := "Sales Cr.Memo Header"."Customer Posting Group";
                                    RecBuffer1.Brand := CROutLateName;
                                    //RecBuffer1."Amount To Customer" := RecSalesCrLine."Amount To Customer";
                                    RecBuffer1."Amount To Customer" := RecSalesCrLine."Line Amount";
                                    RecBuffer1."Charge To Customer" := 0;//RecSalesCrLine."Charges To Customer"; //PCPL/MIG/NSW Filed not Exist in BC18
                                    RecBuffer1."Location Code" := RecSalesCrLine."Location Code";
                                    // rdk 091019 -
                                    IF RecSalesCrLine."Reason Code" <> '' THEN
                                        //IF RecReasonCode.GET(RecSalesCrLine."Reason Code") THEN
                                        //  RecBuffer1.Narration :=RecReasonCode.Description
                                        RecBuffer1.Narration := RecSalesCrLine."Reason Code"
                                    ELSE
                                        IF RecSalesCrLine."Return Reason Code" <> '' THEN
                                            //IF RecRetReasonCode.GET(RecSalesCrLine."Return Reason Code") THEN
                                            //RecBuffer1.Narration := RecRetReasonCode.Description;
                                            RecBuffer1.Narration := RecSalesCrLine."Return Reason Code";
                                    // rdk 091019 +

                                    //RecBuffer1.Narration := "Sales Cr.Memo Header"."Reason Code" ; // original line commented rdk 091019
                                    RecBuffer1."Unit Of Measure Code" := RecSalesCrLine."Unit of Measure Code";

                                    //CCIT-JP-040419
                                    IF RecLoc.GET(RecBuffer1."Location Code") THEN BEGIN
                                        RecBuffer1."FASSI No." := RecLoc."FSSAI No";
                                        RecBuffer1.Name := RecLoc1.Name;
                                        RecBuffer1.Name2 := RecLoc1."Name 2";
                                        RecBuffer1.Address := RecLoc1.Address;
                                        RecBuffer1.Address2 := RecLoc1."Address 2";
                                        RecBuffer1."Phone No." := RecLoc1."Phone No.";
                                        RecBuffer1."Phone No.2" := RecLoc1."Phone No. 2";
                                        RecBuffer1.City := RecLoc1.City;
                                        RecBuffer1."Post Code" := RecLoc1."Post Code";
                                    END;

                                    RecStae1.RESET;
                                    RecStae1.SETRANGE(RecStae1.Code, RecLoc."State Code");
                                    IF RecStae1.FINDFIRST THEN
                                        RecBuffer1.State := RecStae1.Description;


                                    RecBuffer1.INSERT;
                                END;
                            UNTIL RecSalesCrLine.NEXT = 0;
                        //CCIT-JP-040419
                    end;

                    trigger OnPreDataItem();
                    begin
                        //CCIT-JP-020419
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", From_Date, To_Date);

                        IF Loc_Code <> '' THEN
                            "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Location Code", Loc_Code);

                        //CCIT-JP-020419
                    end;
                }
                dataitem("Buffer table Inv-Credit"; "Buffer table Inv-Credit")
                {
                    DataItemLink = "Customer Posting Group" = FIELD(Code);
                    DataItemTableView = SORTING("Document No.", "Document Type", "Line No", "Customer Posting Group", "Location Code")
                                        WHERE(Quantity = FILTER(<> 0));
                    column(DocumentNo_BuffertableInvCredit; "Buffer table Inv-Credit"."Document No.")
                    {
                    }
                    column(DocumentType_BuffertableInvCredit; "Buffer table Inv-Credit"."Document Type")
                    {
                    }
                    column(FASSINo_BuffertableInvCredit; "Buffer table Inv-Credit"."FASSI No.")
                    {
                    }
                    column(LineNo_BuffertableInvCredit; "Buffer table Inv-Credit"."Line No")
                    {
                    }
                    column(ItemNo_BuffertableInvCredit; "Buffer table Inv-Credit"."Item No")
                    {
                    }
                    column(Description_BuffertableInvCredit; "Buffer table Inv-Credit".Description)
                    {
                    }
                    column(PostingDate_BuffertableInvCredit; "Buffer table Inv-Credit"."Posting Date")
                    {
                    }
                    column(CustomerNo_BuffertableInvCredit; "Buffer table Inv-Credit"."Customer No.")
                    {
                    }
                    column(CustomerName_BuffertableInvCredit; "Buffer table Inv-Credit"."Customer Name")
                    {
                    }
                    column(Brand_BuffertableInvCredit; "Buffer table Inv-Credit".Brand)
                    {
                    }
                    column(Quantity_BuffertableInvCredit; "Buffer table Inv-Credit".Quantity)
                    {
                    }
                    column(UnitPrice_BuffertableInvCredit; "Buffer table Inv-Credit"."Unit Price")
                    {
                    }
                    column(CustomerPostingGroup_BuffertableInvCredit; "Buffer table Inv-Credit"."Customer Posting Group")
                    {
                    }
                    column(LocationCode_BuffertableInvCredit; "Buffer table Inv-Credit"."Location Code")
                    {
                    }
                    column(Address_BuffertableInvCredit; "Buffer table Inv-Credit".Address)
                    {
                    }
                    column(Address2_BuffertableInvCredit; "Buffer table Inv-Credit".Address2)
                    {
                    }
                    column(Name_BuffertableInvCredit; "Buffer table Inv-Credit".Name)
                    {
                    }
                    column(Name2_BuffertableInvCredit; "Buffer table Inv-Credit".Name2)
                    {
                    }
                    column(PhoneNo_BuffertableInvCredit; "Buffer table Inv-Credit"."Phone No.")
                    {
                    }
                    column(PhoneNo2_BuffertableInvCredit; "Buffer table Inv-Credit"."Phone No.2")
                    {
                    }
                    column(City_BuffertableInvCredit; "Buffer table Inv-Credit".City)
                    {
                    }
                    column(CompName; RecComp.Name)
                    {
                    }
                    column(CompAddress; RecComp.Address)
                    {
                    }
                    column(CompAddress2; RecComp."Address 2")
                    {
                    }
                    column(CompCity; RecComp.City)
                    {
                    }
                    column(CompPhoneNo; RecComp."Phone No.")
                    {
                    }
                    column(CompState; '')//RecComp.State)
                    {
                    }
                    column(CompPostCode; RecComp."Post Code")
                    {
                    }
                    column(GrossTotal; GrossTotal)
                    {
                    }
                    column(GrandTotal; GrandTotal)
                    {
                    }
                    column(CRTotal; CRTotal)
                    {
                    }
                    column(INVTotal; INVTotal)
                    {
                    }
                    column(AmountToCustomer_BuffertableInvCredit; "Buffer table Inv-Credit"."Amount To Customer")
                    {
                    }
                    column(ChargeToCustomer_BuffertableInvCredit; "Buffer table Inv-Credit"."Charge To Customer")
                    {
                    }
                    column(Narration_BuffertableInvCredit; "Buffer table Inv-Credit".Narration)
                    {
                    }
                    column(UnitOfMeasureCode_BuffertableInvCredit; "Buffer table Inv-Credit"."Unit Of Measure Code")
                    {
                    }
                    column(Qty; Qty)
                    {
                    }
                    column(UnitPrice; UnitPrice)
                    {
                    }
                    column(PostCode_BuffertableInvCredit; "Buffer table Inv-Credit"."Post Code")
                    {
                    }
                    column(State_BuffertableInvCredit; "Buffer table Inv-Credit".State)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        CLEAR(CRTotal);
                        BufferCredit.RESET;

                        //CCIT-JP-020419
                        IF Loc_Code <> '' THEN
                            BufferCredit.SETRANGE(BufferCredit."Location Code", Loc_Code);
                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            BufferCredit.SETRANGE(BufferCredit."Posting Date", From_Date, To_Date);
                        IF Cust_Group <> '' THEN
                            BufferCredit.SETRANGE(BufferCredit."Customer Posting Group", Cust_Group)
                        ELSE
                            BufferCredit.SETRANGE("Customer Posting Group", "Buffer table Inv-Credit"."Customer Posting Group"); //rdk 270619

                        //CCIT-JP-020419

                        /*
                        // rdk
                        BufferCredit.SETRANGE(BufferCredit."Location Code",Loc_Code);
                        BufferCredit.SETRANGE(BufferCredit."Posting Date",From_Date,To_Date);
                        BufferCredit.SETRANGE("Customer Posting Group","Buffer table Inv-Credit"."Customer Posting Group");
                        //rdk 270619
                        */

                        BufferCredit.SETRANGE(BufferCredit."Document Type", BufferCredit."Document Type"::Credit);

                        IF BufferCredit.FINDFIRST THEN
                            REPEAT
                                CRTotal += BufferCredit."Amount To Customer" + BufferCredit."Charge To Customer";
                            UNTIL BufferCredit.NEXT = 0;

                        CLEAR(INVTotal);
                        BufferInvoice.RESET;
                        BufferInvoice.SETRANGE(BufferInvoice."Location Code", Loc_Code);
                        BufferInvoice.SETRANGE(BufferInvoice."Posting Date", From_Date, To_Date);
                        BufferInvoice.SETRANGE(BufferInvoice."Document Type", BufferInvoice."Document Type"::Invoice);
                        BufferInvoice.SETRANGE(BufferInvoice."Customer Posting Group", "Buffer table Inv-Credit"."Customer Posting Group");

                        IF BufferInvoice.FINDFIRST THEN
                            REPEAT
                                INVTotal += BufferInvoice."Amount To Customer" + BufferInvoice."Charge To Customer";
                            UNTIL BufferInvoice.NEXT = 0;

                        GrossTotal := "Buffer table Inv-Credit"."Amount To Customer" + "Buffer table Inv-Credit"."Charge To Customer";

                        GrandTotal := ABS(ABS(INVTotal) - ABS(CRTotal));
                        //CCIT-JP-040419
                        Qty := ROUND("Buffer table Inv-Credit".Quantity, 0.001, '>');

                        UnitPrice := ROUND("Buffer table Inv-Credit"."Unit Price", 0.001, '>');
                        //CCIT-JP-040419

                    end;

                    trigger OnPreDataItem();
                    begin


                        //CCIT-JP-020419
                        CLEAR(GrandTotal);
                        IF Loc_Code <> '' THEN
                            "Buffer table Inv-Credit".SETRANGE("Buffer table Inv-Credit"."Location Code", Loc_Code);

                        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                            "Buffer table Inv-Credit".SETRANGE("Buffer table Inv-Credit"."Posting Date", From_Date, To_Date);

                        //CCIT-JP-020419
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    IF PrintOnlyOnePerPage THEN
                        PageGroupNo := PageGroupNo + 1;
                end;

                trigger OnPreDataItem();
                begin
                    PageGroupNo := 1;
                    CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                    RecComp.GET();
                end;
            }

            trigger OnAfterGetRecord();
            begin
                Loc_Code := Rec_Location.Code;
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
                field(Loc_Code; Loc_Code)
                {
                    Caption = 'Location';
                    TableRelation = Location.Code;
                    Visible = false;
                }
                field(From_Date; From_Date)
                {
                    Caption = 'From_Date';
                }
                field(To_Date; To_Date)
                {
                    Caption = 'To_Date';
                }
                field(NewPageperCustomer; PrintOnlyOnePerPage)
                {
                    CaptionML = ENU = 'New Page per Customer Posting Group',
                                ENN = 'New Page per Customer';
                    Editable = false;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            PrintOnlyOnePerPage := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        RecBufferNew.DELETEALL;
    end;

    var
        Loc_Code: Code[10];
        From_Date: Date;
        To_Date: Date;
        RecComp: Record 79;
        RecCust: Record 18;
        Name: Text;
        OutLateName: Text;
        Rate: Decimal;
        RecSIL: Record 113;
        Des: Text;
        RecCust1: Record 18;
        CRName: Text;
        CROutLateName: Text;
        GrossTotal: Decimal;
        GrossTotalCr: Decimal;
        INVQTY: Decimal;
        CRQTY: Decimal;
        Cust_Group: Code[10];
        RecLoc: Record 14;
        FASSILicenseNo: Code[25];
        CustomerPostingGroup: Record 92;
        sales: Code[10];
        PageGroupNo: Integer;
        PrintOnlyOnePerPage: Boolean;
        RecBuffer: Record 50033;
        RecSalesInvLine: Record 113;
        RecSalesCrLine: Record 115;
        RecBuffer1: Record 50033;
        PrintAmountsInLCY: Boolean;
        CRTotal: Decimal;
        INVTotal: Decimal;
        GrandTotal: Decimal;
        BufferCredit: Record 50033;
        BufferInvoice: Record 50033;
        CompanyAddr: Text;
        LicenseNo: Code[25];
        RecBufferNew: Record 50033;
        Qty: Decimal;
        UnitPrice: Decimal;
        RecStae: Record State;
        State: Text[50];
        LocName: Text[50];
        LocName2: Text[30];
        LocAddress: Text[50];
        LocAddress2: Text[50];
        LocPhoneNo: Text[30];
        LocPhoneNo2: Text[30];
        LocCity: Text[30];
        RecLoc1: Record 14;
        CrLocName: Text[50];
        CrLocName2: Text[50];
        CrLocAddress: Text[50];
        CrLocAddress2: Text[50];
        CrLocCity: Text[50];
        CrLocPhoneNo: Text[50];
        CrLocPhoneNo2: Text[50];
        CrLicenseNo: Code[25];
        LocPostCode: Code[20];
        CrPostCode: Code[20];
        RecStae1: Record State;
        RecReasonCode: Record 231;
        RecRetReasonCode: Record 6635;

    procedure InitializeRequest(ShowAmountInLCY: Boolean; SetPrintOnlyOnePerPage: Boolean; SetExcludeBalanceOnly: Boolean);
    begin
        PrintOnlyOnePerPage := SetPrintOnlyOnePerPage;
        PrintAmountsInLCY := ShowAmountInLCY;
    end;
}

