report 50008 "Sales Order"
{
    // version CCIT-Fortune-SG

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Order.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(MinimumShelfLife_SalesHeader; "Sales Header"."Minimum Shelf Life %")
            {
            }
            column(CRDD_Date; "Sales Header"."Promised Delivery Date")
            {
            }
            column(VerticalCategory_SalesHeader; "Sales Header"."Vertical Category")
            {
            }
            column(PaymentTermsCode_SalesHeader; "Sales Header"."Payment Terms Code")
            {
            }
            column(Structure_SalesHeader; '')//"Sales Header".Structure)
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            column(PostingDate_SalesHeader; "Sales Header"."Posting Date")
            {
            }
            column(Loc_PhoneNo; Loc_PhoneNo)
            {
            }
            column(Loc_FSSAI_Lic_No; Loc_FSSAI_Lic_No)
            {
            }
            column(Loc_GSTNo; Loc_GSTNo)
            {
            }
            column(Comp_Name; RecCompInfo.Name)
            {
            }
            column(Comp_Addr; RecCompInfo.Address)
            {
            }
            column(Comp_City; RecCompInfo.City)
            {
            }
            column(Loc_Email; Loc_Email)
            {
            }
            column(Comp_PhoneNo; RecCompInfo."Phone No.")
            {
            }
            column(Comp_Fax; RecCompInfo."Fax No.")
            {
            }
            column(Comp_Picture; RecCompInfo.Picture)
            {
            }
            column(Comp_PostCode; RecCompInfo."Post Code")
            {
            }
            column(Comp_Country; RecCompInfo.County)
            {
            }
            column(Comp_Email; RecCompInfo."E-Mail")
            {
            }
            column(Comp_GSTNo; RecCompInfo."GST Registration No.")
            {
            }
            column(Comp_ServiceTaxNo; '')//RecCompInfo."Service Tax Registration No.")
            {
            }
            column(Comp_PANNo; RecCompInfo."P.A.N. No.")
            {
            }
            column(Cust_Name; Cust_Name)
            {
            }
            column(Cust_Addr; Cust_Addr)
            {
            }
            column(Cust_City; Cust_City)
            {
            }
            column(Cust_Country; Cust_Country)
            {
            }
            column(Cust_PostCode; Cust_PostCode)
            {
            }
            column(Cust_Phoneno; Cust_Phoneno)
            {
            }
            column(Cust_Email; Cust_Email)
            {
            }
            column(Cust_GSTNo; Cust_GSTNo)
            {
            }
            column(Cust_StateName; Cust_StateName)
            {
            }
            column(Cust_StateCode; Cust_StateCode)
            {
            }
            column(Cust_PANCARD; Cust_PANCARD)
            {
            }
            column(Cust_ContactPerson; Cust_ContactPerson)
            {
            }
            column(Cust_FSSAI_Lic_No; Cust_FSSAI_Lic_No)
            {
            }
            column(StateCode; StateCode)
            {
            }
            column(AmountInWords; AmountInWords[1])
            {
            }
            column(CGSTAmt; CGSTAmt)
            {
            }
            column(SGSTAmt; SGSTAmt)
            {
            }
            column(IGSTAmt; IGSTAmt)
            {
            }
            column(CGSTTotal; CGSTTotal)
            {
            }
            column(SGSTTotal; SGSTTotal)
            {
            }
            column(IGSTTotal; IGSTTotal)
            {
            }
            column(GrandTotal; GrandTotal)
            {
            }
            column(Total1; Total1)
            {
            }
            column(Total; Total)
            {
            }
            column(ExtDocNo; "Sales Header"."External Document No.")
            {
            }
            column(Total11; Total11)
            {
            }
            column(InvoiceDiscountValue_SalesHeader; "Sales Header"."Invoice Discount Value")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                column(ConversionUOM_SalesLine; "Sales Line"."Conversion UOM")
                {
                }
                column(ConversionQty_SalesLine; "Sales Line"."Conversion Qty")
                {
                }
                column(LineDiscountAmount_SalesLine; "Sales Line"."Line Discount Amount")
                {
                }
                column(GSTJurisdictionType_SalesLine; "Sales Line"."GST Jurisdiction Type")
                {
                }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                {
                }
                column(LineAmount_SalesLine; "Sales Line"."Line Amount")
                {
                }
                column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                {
                }
                column(HSNSACCode_SalesLine; "Sales Line"."HSN/SAC Code")
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(Amount_SalesLine; "Sales Line".Amount)
                {
                }
                column(SOQtyKG; SOQtyKG)
                {
                }
                column(SOQtyPCS; SOQtyPCS)
                {
                }
                column(Lotno; Lotno)
                {
                }
                column(MFGDate; MFGDate)
                {
                }
                column(EXPDate; EXPDate)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //SrNo += 1;

                    CLEAR(Lotno);
                    CLEAR(EXPDate);
                    CLEAR(MFGDate);

                    SOQtyPCS := 0;
                    SOQtyKG := 0;
                    IF ("Sales Line"."Unit of Measure Code" = 'PCS') THEN BEGIN
                        SOQtyPCS := "Sales Line".Quantity;
                        SOQtyKG := "Sales Line"."Conversion Qty";
                    END ELSE
                        IF ("Sales Line"."Unit of Measure Code" = 'KG') THEN BEGIN
                            SOQtyKG := "Sales Line"."Conversion Qty";
                            SOQtyPCS := "Sales Line".Quantity;
                        END;


                    //----
                    CGSTAmt := 0;
                    SGSTAmt := 0;
                    IGSTAmt := 0;
                    CGSTRate := 0;
                    //SGSTRate :=0;
                    IGSTRate := 0;
                    /*
                    CGSTTotal:=0;
                    SGSTTotal:=0;
                    IGSTTotal:=0;
                    */

                    //Total += "Sales Line"."Unit Price" * "Sales Line".Quantity;

                    IF ("Sales Line"."GST Jurisdiction Type" = "Sales Line"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                        CGSTRate := 0;//"Sales Line"."GST %"/2; //PCPL/MIG/NSW
                        CGSTAmt := 0;//"Sales Line"."Total GST Amount" / 2; //PCPL/MIG/NSW
                        SGSTAmt := 0;//"Sales Line"."Total GST Amount" /2; //PCPL/MIG/NSW
                                     //MESSAGE('%1  %2',CGSTAmt,SGSTAmt);
                    END
                    ELSE
                        IF ("Sales Line"."GST Jurisdiction Type" = "Sales Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN

                            IGSTRate := 0;//"Sales Line"."GST %"; //PCPL/MIG/NSW
                            IGSTAmt := 0;//"Sales Line"."Total GST Amount"; //PCPL/MIG/NSW
                        END;

                    CGSTTotal += CGSTAmt;
                    SGSTTotal += SGSTAmt;
                    IGSTTotal += IGSTAmt;

                    Total1 := CGSTTotal + SGSTTotal + IGSTTotal;
                    //Total1 :=Total + CGSTTotal + SGSTTotal + IGSTTotal;
                    //MESSAGE('%1 %2 %3 %4 %5 %6',"Sales Line".Description,"Sales Line"."Unit Price","Sales Line".Quantity,Total1,CGSTTotal,SGSTTotal,IGSTTotal);
                    /*
                    recCheck.InitTextVariable;
                    recCheck.FormatNoText(AmountInWords,ROUND(Total1),'');
                    */
                    //----
                    RecResEntry.RESET;
                    RecResEntry.SETRANGE(RecResEntry."Source ID", "Sales Line"."Document No.");
                    RecResEntry.SETRANGE(RecResEntry."Source Ref. No.", "Sales Line"."Line No.");
                    IF RecResEntry.FINDFIRST THEN
                        REPEAT
                            Lotno := RecResEntry."Lot No.";
                            //MESSAGE('%1',Lotno);
                            //EXPDate := RecResEntry."Expiration Date";
                            //MFGDate := RecResEntry."Manufacturing Date";
                            RecTrackingSpec.RESET;
                            RecTrackingSpec.SETRANGE(RecTrackingSpec."Lot No.", Lotno);
                            IF RecTrackingSpec.FINDFIRST THEN BEGIN
                                EXPDate := RecTrackingSpec."Expiration Date";
                                MFGDate := RecTrackingSpec."Manufacturing Date";
                            END;
                        UNTIL RecResEntry.NEXT = 0;

                end;

                trigger OnPreDataItem();
                begin
                    SrNo := 0;
                end;
            }
            dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
            {
                DataItemLink = "Source No." = FIELD("No.");
                column(SrNo; SrNo)
                {
                }
                column(Description_WarehouseActivityLine; "Warehouse Activity Line".Description)
                {
                }
                column(LotNo_WarehouseActivityLine; "Warehouse Activity Line"."Lot No.")
                {
                }
                column(ManufacturingDate_WarehouseActivityLine; "Warehouse Activity Line"."Manufacturing Date")
                {
                }
                column(ExpirationDate_WarehouseActivityLine; "Warehouse Activity Line"."Expiration Date")
                {
                }
                column(HSN_SAC; HSN_SAC)
                {
                }
                column(Storage; Storage)
                {
                }
                column(UOM; UOM)
                {
                }
                column(Disc; Disc)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Qty_KG; "Warehouse Activity Line".Quantity)
                {
                }
                column(RateWAL; RateWAL)
                {
                }
                column(Qty_PC; Qty_PC)
                {
                }
                column(Final_Amt; Final_Amt)
                {
                }
                column(LastFinalAmt; LastFinalAmt)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    SrNo += 1;

                    RecSL.RESET;
                    RecSL.SETRANGE(RecSL."No.", "Item No.");
                    RecSL.SETRANGE(RecSL."Document No.", "Source No.");
                    IF RecSL.FINDFIRST THEN
                        HSN_SAC := RecSL."HSN/SAC Code";
                    Qty_KG := RecSL.Quantity;
                    RateWAL := RecSL."Unit Price";
                    UOM := RecSL."Unit of Measure";
                    Disc := RecSL."Line Discount %";
                    IF RecItem2.GET("Warehouse Activity Line"."Item No.") THEN BEGIN
                        IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM1.Weight <> 0) THEN BEGIN
                                Qty_PC := ROUND(("Warehouse Activity Line".Quantity / RecUOM1.Weight), 1, '=');
                                //MESSAGE('%1...%2.. %3',RecILE2."Entry No.",RecLoc.Code,LocTotalKG);
                            END
                        END
                    END;

                    Amount := "Warehouse Activity Line".Quantity * RateWAL;
                    disc_Amt := Amount * (Disc / 100);
                    Final_Amt := Amount - disc_Amt;
                    LastFinalAmt += Final_Amt;

                    RecItem.RESET;
                    IF RecItem.GET("Item No.") THEN
                        Storage := FORMAT(RecItem."Storage Categories");


                    Total11 := LastFinalAmt + Total1 - "Sales Header"."Invoice Discount Value";

                    //----
                    recCheck.InitTextVariable;
                    recCheck.FormatNoText(AmountInWords, ROUND(Total11), '');
                    //----
                end;

                trigger OnPreDataItem();
                begin
                    CLEAR(HSN_SAC);
                    CLEAR(Storage);
                    CLEAR(Qty_KG);
                    CLEAR(RateWAL);
                    CLEAR(UOM);
                    CLEAR(Disc);
                    CLEAR(Amount);
                    CLEAR(Qty_PC);
                    CLEAR(disc_Amt);
                    CLEAR(Final_Amt);
                    CLEAR(LastFinalAmt);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecCust.GET("Sales Header"."Sell-to Customer No.") THEN BEGIN
                    Cust_Name := RecCust.Name;
                    Cust_Addr := RecCust.Address;
                    Cust_City := RecCust.City;
                    Cust_Country := RecCust.County;
                    Cust_PostCode := RecCust."Post Code";
                    Cust_Phoneno := RecCust."Phone No.";
                    Cust_GSTNo := RecCust."GST Registration No.";
                    Cust_Email := RecCust."E-Mail";
                    Cust_FSSAI_Lic_No := RecCust."FSSAI License No";
                    Cust_PANCARD := RecCust."P.A.N. No.";
                    Cust_StateCode := RecCust."State Code";
                    Cust_ContactPerson := RecCust.Contact;
                END;

                RecLoc.RESET;
                IF RecLoc.GET("Sales Header"."Location Code") THEN BEGIN
                    Loc_PhoneNo := RecLoc."Phone No.";
                    Loc_FSSAI_Lic_No := RecLoc."FSSAI No";
                    Loc_GSTNo := RecLoc."GST Registration No.";
                    Loc_Email := RecLoc."E-Mail";
                END;


                RecState.RESET;
                IF RecState.GET(Cust_StateCode) THEN
                    Cust_StateName := RecState.Description;
                StateCode := RecState."State Code (GST Reg. No.)";
            end;

            trigger OnPreDataItem();
            begin
                Total := 0;
                GrandTotal := 0;
                CGSTTotal := 0;
                SGSTTotal := 0;
                IGSTTotal := 0;
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
        RecCust: Record 18;
        Cust_Name: Text[100];
        Cust_Addr: Text[200];
        Cust_City: Text[20];
        Cust_Country: Text[20];
        Cust_PostCode: Code[20];
        Cust_Phoneno: Code[20];
        Cust_Email: Text[100];
        Cust_GSTNo: Code[15];
        Cust_StateName: Text[20];
        Cust_StateCode: Code[10];
        Cust_PANCARD: Code[20];
        Cust_ContactPerson: Text[100];
        Cust_FSSAI_Lic_No: Code[20];
        SrNo: Integer;
        RecState: Record State;
        StateCode: Code[20];
        AmountInWords: array[2] of Text[200];
        recCheck: Report 1401;
        Total: Decimal;
        SetUpGSTRec: Record "GST Setup";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTTotal: Decimal;
        SGSTTotal: Decimal;
        IGSTTotal: Decimal;
        Total1: Decimal;
        GrandTotal: Decimal;
        CGSTRate: Decimal;
        IGSTRate: Decimal;
        RecGSTSetup: Record "GST Setup";
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        Rate: Decimal;
        Rate1: Decimal;
        SOQtyPCS: Decimal;
        SOQtyKG: Decimal;
        RecILE: Record 32;
        Lotno: Code[20];
        MFGDate: Date;
        EXPDate: Date;
        RecResEntry: Record 337;
        RecTrackingSpec: Record 336;
        RecSL: Record 37;
        HSN_SAC: Code[8];
        RecItem: Record 27;
        Storage: Text[10];
        Qty_KG: Decimal;
        RateWAL: Decimal;
        UOM: Text[10];
        Disc: Decimal;
        Amount: Decimal;
        RecItem2: Record 27;
        RecUOM1: Record 5404;
        Qty_PC: Decimal;
        disc_Amt: Decimal;
        Final_Amt: Decimal;
        LastFinalAmt: Decimal;
        Total11: Decimal;
        RecLoc: Record 14;
        Loc_PhoneNo: Text[30];
        Loc_FSSAI_Lic_No: Code[20];
        Loc_GSTNo: Code[15];
        Loc_Email: Text[100];
}

