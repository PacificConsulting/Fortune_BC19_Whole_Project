report 50053 "Purchase Debit Note GL"
{
    // version CCIT-JAGA

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Purchase Debit Note GL.rdl';

    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "No.";
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CompInfo_Address; CompInfo.Address)
            {
            }
            column(CompInfo_Address2; CompInfo."Address 2")
            {
            }
            column(CompInfo_City; CompInfo.City)
            {
            }
            column(CompInfoPostCode; CompInfo."Post Code")
            {
            }
            column(CompInfo_PhoneNo; CompInfo."Phone No.")
            {
            }
            column(CompInfo_FaxNo; CompInfo."Fax No.")
            {
            }
            column(CountryName; CountryName)
            {
            }
            column(No_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."No.")
            {
            }
            column(PostingDate_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Posting Date")
            {
            }
            column(VendorCrMemoNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.")
            {
            }
            column(DocumentDate_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Document Date")
            {
            }
            column(LocName; LocName)
            {
            }
            column(LocAdd; LocAdd)
            {
            }
            column(LocAdd2; LocAdd2)
            {
            }
            column(LocCity; LocCity)
            {
            }
            column(LocPIN; LocPIN)
            {
            }
            column(LocGST; LocGST)
            {
            }
            column(LocPAN; LocPAN)
            {
            }
            column(LocCIN; LocCIN)
            {
            }
            column(LocContPerson; LocContPerson)
            {
            }
            column(LocPhoneNo; LocPhoneNo)
            {
            }
            column(VendAdd; VendAdd)
            {
            }
            column(VendAdd2; VendAdd2)
            {
            }
            column(VendCity; VendCity)
            {
            }
            column(VendPIN; VendPIN)
            {
            }
            column(VendGST; VendGST)
            {
            }
            column(VendPAN; VendPAN)
            {
            }
            column(VendCIN; VendCIN)
            {
            }
            column(VendContPerson; VendContPerson)
            {
            }
            column(VendPhoneNo; VendPhoneNo)
            {
            }
            column(VendName; VendName)
            {

            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(Comment_PurchCommentLine; "Purch. Comment Line".Comment)
                {
                }


                trigger OnAfterGetRecord();
                begin
                    /*
                    RecPCMH.RESET;
                    RecPCMH.SETRANGE(RecPCMH."No.","No.");
                    IF RecPCMH.FINDFIRST THEN BEGIN
                      //Comment :=
                    END;
                    
                    MESSAGE('%1 %2',"Purch. Comment Line"."No.","Purch. Comment Line".Comment);
                    */

                end;
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Type = CONST("G/L Account"));

                column(Sr_No; Sr_No)
                {
                }
                column(ReturnReasonCode_PurchCrMemoLine; "Purch. Cr. Memo Line"."Return Reason Code")
                {
                }
                column(LineAmount_PurchCrMemoLine; "Purch. Cr. Memo Line"."Line Amount")
                {
                }
                column(CGSTAmt; CGSTAmt)
                {
                }
                column(IGSTAmt; IGSTAmt)
                {
                }
                column(Description; Description)
                {

                }

                trigger OnAfterGetRecord();
                begin
                    Sr_No += 1;


                    // IF ("Purch. Cr. Memo Line"."GST Jurisdiction Type" = "Purch. Cr. Memo Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                    //     CGSTRate := 0;//"Purch. Cr. Memo Line"."GST %"/2; Purch. Cr. Memo Line
                    //     CGSTAmt := 0;//"Purch. Cr. Memo Line"."Total GST Amount"/2;
                    // END
                    // ELSE
                    //     IF ("Purch. Cr. Memo Line"."GST Jurisdiction Type" = "Purch. Cr. Memo Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
                    //         IGSTRate := 0;//"Purch. Cr. Memo Line"."GST %";
                    //         IGSTAmt := 0;//"Purch. Cr. Memo Line"."Total GST Amount";
                    //     END;


                    CGSTAmt := 0;
                    //SGSTAmt := 0;
                    IGSTAmt := 0;
                    CGSTRate := 0;
                    IGSTRate := 0;
                    //<<PCPL/MIG/NSW New Code for GST Calculation
                    //>>PCPL/BPPL/010
                    //>>PCPL/BPPL/010
                    GLE.RESET;
                    GLE.SETRANGE(GLE."Document No.", "Purch. Cr. Memo Line"."Document No.");
                    GLE.SETRANGE(GLE."Transaction Type", GLE."Transaction Type"::Purchase);
                    GLE.SETRANGE("Document Line No.", "Purch. Cr. Memo Line"."Line No.");
                    IF GLE.FindSet THEN
                        repeat
                            IF GLE."GST Component Code" = 'CGST' THEN BEGIN
                                //CGST := ABS(GLE."GST Amount") / 2;
                                CGSTAmt := ABS(GLE."GST Amount");
                                CGSTRate := (GLE."GST %");
                            END
                            ELSE
                                IF GLE."GST Component Code" = 'IGST' THEN BEGIN
                                    IGSTAmt := ABS(GLE."GST Amount");
                                    IGSTRate := GLE."GST %";
                                END
                                ELSE
                                    IF GLE."GST Component Code" = 'SGST' THEN BEGIN
                                        // SGST := ABS(GLE."GST Amount") / 2;
                                        //     SGST := ABS(GLE."GST Amount");
                                        //   Rate := (GLE."GST %");
                                    END;
                        until GLE.Next = 0;

                end;

                trigger OnPreDataItem();
                begin
                    Sr_No := 0;
                end;
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(ItemDescription_ItemLedgerEntry; "Item Ledger Entry"."Item Description")
                {
                }
                column(UnitofMeasureCode_ItemLedgerEntry; '')//"Item Ledger Entry"."Unit of Measure Code")
                {
                }
                column(Quantity_ItemLedgerEntry; ABS("Item Ledger Entry".Quantity))
                {
                }
                column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
                {
                }
                column(ExpirationDate_ItemLedgerEntry; "Item Ledger Entry"."Expiration Date")
                {
                }
                column(ManufacturingDate_ItemLedgerEntry; "Item Ledger Entry"."Manufacturing Date")
                {
                }
                column(HSN_SAC; HSN_SAC)
                {
                }
                column(UnitCost; UnitCost)
                {
                }
                column(TotalValue; TotalValue)
                {
                }
                column(TotalValueAftDiscount; TotalValueAftDiscount)
                {
                }


                trigger OnAfterGetRecord();
                begin
                    /*
                    Sr_No += 1;
                    RecPCML.RESET;
                    RecPCML.SETRANGE(RecPCML."No.","Item No.");
                    IF RecPCML.FINDFIRST THEN BEGIN
                      HSN_SAC := RecPCML."HSN/SAC Code";
                      UnitCost := RecPCML."Unit Cost";
                      DiscountPercent := RecPCML."Line Discount %";
                      GSTJurType := FORMAT(RecPCML."GST Jurisdiction Type");
                    END;


                    TotalValue := ABS("Item Ledger Entry".Quantity*UnitCost);
                    DiscountValue := TotalValue*(DiscountPercent/100);
                    TotalValueAftDiscount := TotalValue - DiscountValue;

                    RecPCML1.RESET;
                    RecPCML1.SETRANGE(RecPCML1."No.","Item No.");
                    IF RecPCML1.FINDFIRST THEN
                      REPEAT
                        IF GSTJurType = 'Intrastate' THEN BEGIN
                          CGSTRate := RecPCML1."GST %"/2;
                          CGSTAmt := TotalValueAftDiscount*(CGSTRate/100);
                        END
                        ELSE IF GSTJurType = 'Interstate' THEN BEGIN
                          IGSTRate := RecPCML1."GST %";
                          IGSTAmt := TotalValueAftDiscount*(IGSTRate/100);
                        END;
                      UNTIL RecPCML1.NEXT=0;
                    */

                end;

                trigger OnPreDataItem();
                begin
                    CLEAR(HSN_SAC);
                    CLEAR(UnitCost);
                    CLEAR(TotalValue);
                    CLEAR(DiscountPercent);
                    CLEAR(DiscountValue);
                    CLEAR(TotalValueAftDiscount);
                    CLEAR(CGSTRate);
                    CLEAR(CGSTAmt);
                    CLEAR(IGSTRate);
                    CLEAR(IGSTAmt);

                    //Sr_No := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecCountry.GET(CompInfo."Country/Region Code") THEN
                    CountryName := RecCountry.Name;

                IF RecLocation.GET("Location Code") THEN BEGIN
                    LocName := RecLocation.Name;
                    LocAdd := RecLocation.Address;
                    LocAdd2 := RecLocation."Address 2";
                    LocCity := RecLocation.City;
                    LocPIN := RecLocation."Post Code";
                    LocGST := RecLocation."GST Registration No.";
                    LocPAN := CompInfo."P.A.N. No.";
                    LocCIN := CompInfo."CIN No.";
                    LocContPerson := RecLocation.Contact;
                    LocPhoneNo := RecLocation."Phone No.";
                END;

                IF RecVend.GET("Purch. Cr. Memo Hdr."."Buy-from Vendor No.") THEN BEGIN
                    VendName := RecVend.Name;
                    VendAdd := RecVend.Address;
                    VendAdd2 := RecVend."Address 2";
                    VendCity := RecVend.City;
                    VendPIN := RecVend."Post Code";
                    VendGST := RecVend."GST Registration No.";
                    VendPAN := RecVend."P.A.N. No.";
                    //VendCIN := RecVend."CIN No.";
                    VendContPerson := RecVend.Contact;
                    VendPhoneNo := RecVend."Phone No.";
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
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        Sr_No: Integer;
        CompInfo: Record 79;
        RecPCML: Record 125;
        HSN_SAC: Code[8];
        UnitCost: Decimal;
        TotalValue: Decimal;
        RecCountry: Record 9;
        CountryName: Text[50];
        DiscountPercent: Decimal;
        DiscountValue: Decimal;
        TotalValueAftDiscount: Decimal;
        RecPCML1: Record 125;
        GSTJurType: Text[15];
        CGSTRate: Decimal;
        CGSTAmt: Decimal;
        IGSTRate: Decimal;
        IGSTAmt: Decimal;
        RecLocation: Record 14;
        LocName: Text[50];
        LocAdd: Text[50];
        LocAdd2: Text[50];
        LocCity: Text[30];
        LocPIN: Code[20];
        LocGST: Code[15];
        LocPAN: Code[15];
        LocCIN: Code[25];
        LocContPerson: Text[50];
        LocPhoneNo: Text[30];
        RecVend: Record 23;
        VendName: Text[50];
        VendAdd: Text[50];
        VendAdd2: Text[50];
        VendCity: Text[30];
        VendPIN: Code[20];
        VendGST: Code[15];
        VendPAN: Code[15];
        VendCIN: Code[25];
        VendContPerson: Text[50];
        VendPhoneNo: Text[30];
        GLE: Record "Detailed GST Ledger Entry";
}

