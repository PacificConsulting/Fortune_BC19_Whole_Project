report 50013 "Sales Register INV & CR-Pre"
{
    // version To be deleted

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Register INV & CR-Pre.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Location Code", "Salesperson Code", "No.";
            column(Document_Type; Document_Type)
            {
            }
            column(Document_Date; "Sales Invoice Header"."Document Date")
            {
            }
            column(Sales_Person; SalesPersonName)
            {
            }
            column(Customer_Name; "Sales Invoice Header"."Bill-to Name")
            {
            }
            column(Customer_Group; "Sales Invoice Header"."Customer Price Group")
            {
            }
            column(Customer_Business_Format; BFOName)
            {
            }
            column(Customer_Posting_Group; "Sales Invoice Header"."Customer Posting Group")
            {
            }
            column(Gen_Bus_Posting_Group; "Sales Invoice Header"."Gen. Bus. Posting Group")
            {
            }
            column(Vertical_Sub_Category; "Sales Invoice Header"."Vertical Sub Category")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(<> 0));
                column(CustomerPriceGroup_SalesInvoiceLine; "Sales Invoice Line"."Customer Price Group")
                {
                }
                column(Sr_No; Sr_No)
                {
                }
                column(Document_No; "Sales Invoice Line"."Document No.")
                {
                }
                column(Item_Code; "Sales Invoice Line"."No.")
                {
                }
                column(Item_Name; "Sales Invoice Line".Description)
                {
                }
                column(Product_Type; "Sales Invoice Line".Type)
                {
                }
                column(Item_Category_Code; "Sales Invoice Line"."Item Category Code")
                {
                }
                column(Location_Code; "Sales Invoice Line"."Location Code")
                {
                }
                column(Product_Group_Code; '')//"Sales Invoice Line"."Product Group Code")
                {
                }
                column(Quantity; "Sales Invoice Line".Quantity)
                {
                }
                column(Price_Per_KG; "Sales Invoice Line"."Unit Price")
                {
                }
                column(Base_Value; "Sales Invoice Line"."Line Amount")
                {
                }
                column(Discount; "Sales Invoice Line"."Line Discount Amount")
                {
                }
                column(Invoice_Value; "Sales Invoice Line".Amount)
                {
                }
                column(CGST; CGST)
                {
                }
                column(SGST; SGST)
                {
                }
                column(IGST; IGST)
                {
                }
                column(SalesCategoty; SalesCategoty)
                {
                }
                column(BaseValue; BaseValue)
                {
                }
                column(TotalBaseValue; TotalBaseValue)
                {
                }
                column(InvDicAmt; "Sales Invoice Line"."Inv. Discount Amount")
                {
                }

                trigger OnAfterGetRecord();
                begin


                    Sr_No += 1;

                    CLEAR(BaseValue);

                    CGST := 0;
                    SGST := 0;
                    IGST := 0;
                    Rate := 0;
                    Rate1 := 0;
                    /*
                    RecGSTSetup.RESET;
                    RecGSTSetup.SETRANGE(RecGSTSetup."GST Group Code","Sales Invoice Line"."GST Group Code");
                    RecGSTSetup.SETRANGE(RecGSTSetup."GST State Code","Sales Invoice Header"."GST Bill-to State Code");
                    RecGSTSetup.SETRANGE(RecGSTSetup."GST Jurisdiction Type","Sales Invoice Line"."GST Jurisdiction Type");
                    IF RecGSTSetup.FINDSET THEN
                       REPEAT
                         IF (RecGSTSetup."GST Jurisdiction Type" =RecGSTSetup."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                            Rate := RecGSTSetup."GST Component %";
                            CGST := "Sales Invoice Line"."GST Base Amount" * (RecGSTSetup."GST Component %" / 100);
                            SGST := "Sales Invoice Line"."GST Base Amount" * (RecGSTSetup."GST Component %" / 100);
                         END
                         ELSE IF (RecGSTSetup."GST Jurisdiction Type" =RecGSTSetup."GST Jurisdiction Type"::Interstate) THEN BEGIN
                           Rate1 := RecGSTSetup."GST Component %";
                           IGST := "Sales Invoice Line"."GST Base Amount" * (RecGSTSetup."GST Component %" / 100);
                         END;
                       //MESSAGE('%1',RecGSTSetup."GST Jurisdiction Type");
                       UNTIL RecGSTSetup.NEXT=0;
                       */

                    //"Sales Invoice Line".RESET;
                    IF "Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        Rate := 0;//"Sales Invoice Line"."GST %" / 2; //PCPL/MIG/NSW
                        CGST := 0;//"Sales Invoice Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                        SGST := 0;// "Sales Invoice Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                    END
                    ELSE
                        IF "Sales Invoice Line"."GST Jurisdiction Type" = "Sales Invoice Line"."GST Jurisdiction Type"::Interstate THEN BEGIN
                            Rate1 := 0;//"Sales Invoice Line"."GST %"; //PCPL/MIG/NSW
                            IGST := 0;//"Sales Invoice Line"."Total GST Amount"; //PCPL/MIG/NSW
                        END;

                    IF RecItem.GET("Sales Invoice Line"."No.") THEN
                        SalesCategoty := RecItem."Sales Category";

                    BaseValue := "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    TotalBaseValue := TotalBaseValue + BaseValue;

                end;

                trigger OnPreDataItem();
                begin
                    Sr_No := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(BFOName);
                CLEAR(SalesPersonName);
                RecSP.RESET;
                IF RecSP.GET("Sales Invoice Header"."Salesperson Code") THEN
                    SalesPersonName := RecSP.Name;

                RecCust.RESET;
                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN
                    BFOName := RecCust."Business Format / Outlet Name";
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
                    "Sales Invoice Header".SETFILTER("Sales Invoice Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Invoice Header".SETRANGE("Sales Invoice Header"."Posting Date", 99990101D, AsOnDate);

                /*
                IF Document_Type<>Document_Type::" " THEN
                  "Sales Invoice Header".SETRANGE("No.",'','');
                */
                IF Document_Type = Document_Type::"Credit Note" THEN
                    CurrReport.BREAK;

            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Location Code", "Salesperson Code", "No.";
            column(Document_Type1; Document_Type)
            {
            }
            column(Document_Date1; "Sales Cr.Memo Header"."Document Date")
            {
            }
            column(Sales_Person1; SalesPersonName1)
            {
            }
            column(Customer_Name1; "Sales Cr.Memo Header"."Bill-to Name")
            {
            }
            column(Customer_Business_Format1; BFOName1)
            {
            }
            column(Customer_Posting_Group1; "Sales Cr.Memo Header"."Customer Posting Group")
            {
            }
            column(General_Business_Posting_Group1; "Sales Cr.Memo Header"."Gen. Bus. Posting Group")
            {
            }
            column(Vertical_SubCategory1; "Sales Cr.Memo Header"."Vertical Sub Category")
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(CustomerPriceGroup_SalesCrMemoLine; "Sales Cr.Memo Line"."Customer Price Group")
                {
                }
                column(Sr_No1; Sr_No1)
                {
                }
                column(Document_No1; "Sales Cr.Memo Line"."Document No.")
                {
                }
                column(Branch1; "Sales Cr.Memo Line"."Shortcut Dimension 1 Code")
                {
                }
                column(Item_Code1; "Sales Cr.Memo Line"."No.")
                {
                }
                column(Item_Name1; "Sales Cr.Memo Line".Description)
                {
                }
                column(Product_Type1; "Sales Cr.Memo Line".Type)
                {
                }
                column(ItemCategoryCode1; "Sales Cr.Memo Line"."Item Category Code")
                {
                }
                column(ProductGroupCode1; '')//"Sales Cr.Memo Line"."Product Group Code") //PCPL/MIG/NSW
                {
                }
                column(Quantity1; "Sales Cr.Memo Line".Quantity)
                {
                }
                column(CGST1; CGST1)
                {
                }
                column(SGST1; SGST1)
                {
                }
                column(IGST1; IGST1)
                {
                }
                column(Unit_Price; "Sales Cr.Memo Line"."Unit Price")
                {
                }
                column(S_C_Base_Value; "Sales Cr.Memo Line"."Line Amount")
                {
                }
                column(Discount1; "Sales Cr.Memo Line"."Line Discount Amount")
                {
                }
                column(Invoice_Value1; "Sales Cr.Memo Line".Amount)
                {
                }
                column(SalesCategoty1; SalesCategoty1)
                {
                }
                column(BaseValue1; BaseValue1)
                {
                }
                column(TotalBaseValue1; TotalBaseValue1)
                {
                }
                column(InvDicAmt1; "Sales Cr.Memo Line"."Inv. Discount Amount")
                {
                }

                trigger OnAfterGetRecord();
                begin

                    Sr_No1 += 1;

                    CLEAR(BaseValue1);

                    CGST1 := 0;
                    SGST1 := 0;
                    IGST1 := 0;
                    Rate01 := 0;
                    Rate101 := 0;

                    /*
                    RecGSTSetup1.RESET;
                    RecLocation1.RESET;
                    
                    IF RecLocation1.GET("Sales Cr.Memo Header"."Location Code") THEN
                       GST_Location_Code1 := RecLocation1."State Code";
                    
                    
                    IF RecCust.GET("Sales Cr.Memo Header"."Bill-to Customer No.") THEN
                       GST_Bill_Code1 := RecCust."State Code";
                    
                    
                     IF GST_Bill_Code1 = GST_Location_Code1 THEN BEGIN
                          RecGSTSetup1.RESET;
                          RecGSTSetup1.SETRANGE(RecGSTSetup1."GST Group Code","Sales Cr.Memo Line"."GST Group Code");
                          RecGSTSetup1.SETFILTER(RecGSTSetup1."GST Jurisdiction Type",'=%1',RecGSTSetup1."GST Jurisdiction Type"::Intrastate);
                          IF RecGSTSetup1.FINDSET THEN
                             REPEAT
                                Rate01 :=RecGSTSetup1."GST Component %";
                                CGST1 := "Sales Cr.Memo Line"."GST Base Amount" * (RecGSTSetup1."GST Component %" / 100 );
                                SGST1 := "Sales Cr.Memo Line"."GST Base Amount" * (RecGSTSetup1."GST Component %" / 100 );
                             UNTIL RecGSTSetup1.NEXT=0;
                        END
                        ELSE IF GST_Bill_Code1 <> GST_Location_Code1 THEN BEGIN
                          RecGSTSetup1.RESET;
                          RecGSTSetup1.SETRANGE(RecGSTSetup1."GST Group Code","Sales Cr.Memo Line"."GST Group Code");
                          RecGSTSetup1.SETFILTER(RecGSTSetup1."GST Jurisdiction Type",'=%1',RecGSTSetup1."GST Jurisdiction Type"::Interstate);
                          IF RecGSTSetup1.FINDSET THEN
                             REPEAT
                                Rate101 := RecGSTSetup1."GST Component %";
                                IGST1 := "Sales Cr.Memo Line"."GST Base Amount" * (RecGSTSetup1."GST Component %" / 100);
                    
                             UNTIL RecGSTSetup1.NEXT=0;
                         END;
                    */

                    IF "Sales Cr.Memo Line"."GST Jurisdiction Type" = "Sales Cr.Memo Line"."GST Jurisdiction Type"::Intrastate THEN BEGIN
                        Rate01 := 0;//"Sales Cr.Memo Line"."GST %" / 2; //PCPL/MIG/NSW
                        CGST1 := 0;//"Sales Cr.Memo Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                        SGST1 := 0;// "Sales Cr.Memo Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                    END
                    ELSE
                        IF "Sales Cr.Memo Line"."GST Jurisdiction Type" = "Sales Cr.Memo Line"."GST Jurisdiction Type"::Interstate THEN BEGIN
                            Rate101 := 0;// "Sales Cr.Memo Line"."GST %"; //PCPL/MIG/NSW
                            IGST1 := 0;//"Sales Cr.Memo Line"."Total GST Amount"; //PCPL/MIG/NSW
                        END;

                    IF RecItem.GET("Sales Cr.Memo Line"."No.") THEN
                        SalesCategoty1 := RecItem."Sales Category";


                    BaseValue1 := "Sales Cr.Memo Line".Quantity * "Sales Cr.Memo Line"."Unit Price";
                    TotalBaseValue1 := TotalBaseValue1 + BaseValue1;

                end;

                trigger OnPreDataItem();
                begin
                    Sr_No1 := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CLEAR(BFOName1);
                CLEAR(SalesPersonName1);
                RecSP1.RESET;
                IF RecSP1.GET("Sales Cr.Memo Header"."Salesperson Code") THEN
                    SalesPersonName1 := RecSP1.Name;

                RecCust.RESET;
                IF RecCust.GET("Sales Invoice Header"."Sell-to Customer No.") THEN
                    BFOName1 := RecCust."Business Format / Outlet Name";
            end;

            trigger OnPreDataItem();
            begin

                IF LocCodeText <> '' THEN
                    "Sales Cr.Memo Header".SETFILTER("Sales Cr.Memo Header"."Location Code", LocCodeText);
                //CCIT-PRI-280318

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."Posting Date", 99990101D, AsOnDate);
                IF Document_Type = Document_Type::Invoice THEN
                    CurrReport.BREAK;
                /*
                IF Document_Type <> Document_Type::" " THEN
                  "Sales Cr.Memo Header".SETRANGE("Sales Cr.Memo Header"."No.",'','');
                */

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
                group("From Date - To Date Filter")
                {
                    field("From Date"; From_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                    field("To Date"; To_Date)
                    {

                        trigger OnValidate();
                        begin
                            IF (AsOnDate <> 0D) THEN BEGIN
                                From_Date := 0D;
                                To_Date := 0D;
                                MESSAGE('As On Date allready Entered...');
                            END;
                        end;
                    }
                }
                group("As On Date Filter")
                {
                    field("As On Date"; AsOnDate)
                    {

                        trigger OnValidate();
                        begin
                            IF (From_Date <> 0D) AND (To_Date <> 0D) THEN BEGIN
                                AsOnDate := 0D;
                                MESSAGE('From Date - To Date allready Entered...');
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

    trigger OnPreReport();
    begin
        CLEAR(TotalBaseValue);
        CLEAR(TotalBaseValue1);
    end;

    var
        Sr_No: Integer;
        Location_Code: Text[30];
        SalesPerson: Text[30];
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        Rate: Decimal;
        Rate1: Decimal;
        RecGSTSetup: Record "GST Setup";
        Document_Type: Option " ",Invoice,"Credit Note";
        Sr_No1: Integer;
        CGST1: Decimal;
        SGST1: Decimal;
        IGST1: Decimal;
        Rate01: Decimal;
        Rate101: Decimal;
        RecGSTSetup1: Record "GST Setup";
        RecLocation1: Record 14;
        GST_Location_Code1: Code[20];
        RecCust: Record 18;
        GST_Bill_Code1: Code[20];
        RecItem: Record 27;
        SalesCategoty: Code[20];
        SalesCategoty1: Code[20];
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        RecSP: Record 13;
        SalesPersonName: Text[50];
        RecSP1: Record 13;
        SalesPersonName1: Text[50];
        BaseValue: Decimal;
        TotalBaseValue: Decimal;
        BaseValue1: Decimal;
        TotalBaseValue1: Decimal;
        BFOName: Text[100];
        BFOName1: Text[100];
}

