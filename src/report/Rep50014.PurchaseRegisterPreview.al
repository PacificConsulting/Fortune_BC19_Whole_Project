report 50014 "Purchase Register-Preview"
{
    // version CCIT-Fortune

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Purchase Register-Preview.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.", "Location Code";
            column(Vendor_Name; "Purch. Inv. Header"."Buy-from Vendor Name")
            {
            }
            column(PO_No; "Purch. Inv. Header"."Order No.")
            {
            }
            column(PO_Date; "Purch. Inv. Header"."Order Date")
            {
            }
            column(Vendor_Invoice_No; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(Document_Type; Document_Type)
            {
            }
            column(Document_Date; "Purch. Inv. Header"."Document Date")
            {
            }
            column(PurchInvExchRate; "Purch. Inv. Header"."Currency Factor")
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Sr_No; Sr_No)
                {
                }
                column(Document_No; "Purch. Inv. Line"."Document No.")
                {
                }
                column(Service_Product; "Purch. Inv. Line".Type)
                {
                }
                column(GRN_No; "Purch. Inv. Line"."Receipt No.")
                {
                }
                column(Branch; "Purch. Inv. Line"."Shortcut Dimension 1 Code")
                {
                }
                column(Item_Name; "Purch. Inv. Line".Description)
                {
                }
                column(Item_Code; "Purch. Inv. Line"."No.")
                {
                }
                column(Gen_Prod_Post_Group; "Purch. Inv. Line"."Gen. Prod. Posting Group")
                {
                }
                column(Item_Category_Code; "Purch. Inv. Line"."Item Category Code")
                {
                }
                column(Product_Group_Code; '')//"Purch. Inv. Line"."Product Group Code")
                {
                }
                column(Quantity; "Purch. Inv. Line".Quantity)
                {
                }
                column(Discount; "Purch. Inv. Line"."Line Discount %")
                {
                }
                column(InvoiceValueINR; "Purch. Inv. Line".Amount)
                {
                }
                column(Import_Local; "Purch. Inv. Line"."Gen. Bus. Posting Group")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Sr_No += 1;
                end;

                trigger OnPreDataItem();
                begin
                    Sr_No := 0;
                end;
            }

            trigger OnPreDataItem();
            begin
                //CCIT-PRI-280318
                RecUserBranch.RESET;
                RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
                IF RecUserBranch.FINDFIRST THEN
                    REPEAT
                        LocCode := LocCode + '|' + RecUserBranch."Location Code";
                    UNTIL RecUserBranch.NEXT = 0;
                LocCodetext := DELCHR(LocCode, '<', '|');

                IF LocCodetext <> '' THEN
                    "Purch. Inv. Header".SETFILTER("Purch. Inv. Header"."Location Code", LocCodetext);
                //CCIT-PRI-280318

                IF Document_Type <> Document_Type::Invoice THEN
                    "Purch. Inv. Header".SETRANGE("No.", '', '');

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Inv. Header".SETRANGE("Purch. Inv. Header"."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Inv. Header".SETRANGE("Purch. Inv. Header"."Posting Date", 99990101D, AsOnDate);
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "No.", "Location Code";
            column(Vendor_Name1; "Purch. Cr. Memo Hdr."."Buy-from Vendor Name")
            {
            }
            column(Vendor_Invoice_No1; "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.")
            {
            }
            column(Document_Type1; Document_Type)
            {
            }
            column(Document_Date1; "Purch. Cr. Memo Hdr."."Document Date")
            {
            }
            column(PurchInvExchRate1; "Purch. Cr. Memo Hdr."."Currency Factor")
            {
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Sr_No1; Sr_No1)
                {
                }
                column(Document_No1; "Purch. Cr. Memo Line"."Document No.")
                {
                }
                column(Service_Product1; "Purch. Cr. Memo Line".Type)
                {
                }
                column(Branch1; "Purch. Cr. Memo Line"."Shortcut Dimension 1 Code")
                {
                }
                column(Item_Name1; "Purch. Cr. Memo Line".Description)
                {
                }
                column(Item_Code1; "Purch. Cr. Memo Line"."No.")
                {
                }
                column(Gen_Prod_Post_Group1; "Purch. Cr. Memo Line"."Gen. Prod. Posting Group")
                {
                }
                column(Item_Category_Code1; "Purch. Cr. Memo Line"."Item Category Code")
                {
                }
                column(Product_Group_Code1; '')//"Purch. Cr. Memo Line"."Product Group Code")
                {
                }
                column(Quantity1; "Purch. Cr. Memo Line".Quantity)
                {
                }
                column(Discount1; "Purch. Cr. Memo Line"."Line Discount %")
                {
                }
                column(InvoiceValueINR1; "Purch. Cr. Memo Line".Amount)
                {
                }
                column(Import_Local1; "Purch. Cr. Memo Line"."Gen. Bus. Posting Group")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Sr_No1 += 1;
                end;

                trigger OnPreDataItem();
                begin
                    Sr_No1 := 0;
                end;
            }

            trigger OnPreDataItem();
            begin
                IF Document_Type <> Document_Type::"Credit Note" THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("No.", '', '');

                IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                    "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", From_Date, To_Date)
                ELSE
                    IF (AsOnDate <> 0D) THEN
                        "Purch. Cr. Memo Hdr.".SETRANGE("Purch. Cr. Memo Hdr."."Posting Date", 99990101D, AsOnDate);

                //CCIT-PRI-280318
                IF LocCodetext <> '' THEN
                    "Purch. Cr. Memo Hdr.".SETFILTER("Purch. Cr. Memo Hdr."."Location Code", LocCodetext);
                //CCIT-PRI-280318
            end;
        }
    }

    requestpage
    {

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

    var
        Sr_No: Integer;
        Sr_No1: Integer;
        Document_Type: Option " ",Invoice,"Credit Note";
        From_Date: Date;
        To_Date: Date;
        AsOnDate: Date;
        RecUserBranch: Record 50029;
        LocCode: Code[1024];
        LocCodetext: Text[1024];
}

