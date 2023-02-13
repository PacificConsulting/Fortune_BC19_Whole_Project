report 50025 "Sales Order Archaive"
{
    // version CCIT-JAGA

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Sales Order Archaive.rdl';
    ApplicationArea = ALL;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Sales Header Archive"; "Sales Header Archive")
        {
            DataItemTableView = SORTING("Document Type", "No.", "Doc. No. Occurrence", "Version No.")
                                ORDER(Ascending)
                                WHERE("Version No." = CONST(1));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(MinimumShelfLife_SalesHeader; "Sales Header Archive"."Minimum Shelf Life %")
            {
            }
            column(VerticalCategory_SalesHeader; "Sales Header Archive"."Vertical Category")
            {
            }
            column(PaymentTermsCode_SalesHeader; "Sales Header Archive"."Payment Terms Code")
            {
            }
            column(Structure_SalesHeader; "Sales Header Archive"."Payment Terms Code")
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header Archive"."Sell-to Customer No.")
            {
            }
            column(No_SalesHeader; "Sales Header Archive"."No.")
            {
            }
            column(PostingDate_SalesHeader; "Sales Header Archive"."Posting Date")
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
            column(GrandTotal; GrandTotal)
            {
            }
            column(Total1; Total1)
            {
            }
            column(Total; Total)
            {
            }
            column(ExtDocNo; "Sales Header Archive"."External Document No.")
            {
            }
            dataitem("Sales Line Archive"; "Sales Line Archive")
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                column(ConversionUOM_SalesLine; "Sales Line Archive"."Conversion UOM")
                {
                }
                column(ConversionQty_SalesLine; "Sales Line Archive"."Conversion Qty")
                {
                }
                column(LineDiscountAmount_SalesLine; "Sales Line Archive"."Line Discount Amount")
                {
                }
                column(GSTJurisdictionType_SalesLine; "Sales Line Archive"."GST Jurisdiction Type")
                {
                }
                column(UnitPrice_SalesLine; "Sales Line Archive"."Unit Price")
                {
                }
                column(LineAmount_SalesLine; "Sales Line Archive"."Line Amount")
                {
                }
                column(LineDiscount_SalesLine; "Sales Line Archive"."Line Discount %")
                {
                }
                column(HSNSACCode_SalesLine; "Sales Line Archive"."HSN/SAC Code")
                {
                }
                column(No_SalesLine; "Sales Line Archive"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line Archive".Description)
                {
                }
                column(UnitofMeasure_SalesLine; "Sales Line Archive"."Unit of Measure")
                {
                }
                column(Quantity_SalesLine; "Sales Line Archive".Quantity)
                {
                }
                column(Amount_SalesLine; "Sales Line Archive".Amount)
                {
                }
                column(SrNo; SrNo)
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
                    SrNo += 1;

                    CLEAR(Lotno);
                    CLEAR(EXPDate);
                    CLEAR(MFGDate);

                    SOQtyPCS := 0;
                    SOQtyKG := 0;
                    IF ("Sales Line Archive"."Unit of Measure Code" = 'PCS') THEN BEGIN
                        SOQtyPCS := "Sales Line Archive".Quantity;
                        SOQtyKG := "Sales Line Archive"."Conversion Qty";
                    END ELSE
                        IF ("Sales Line Archive"."Unit of Measure Code" = 'KG') THEN BEGIN
                            SOQtyKG := "Sales Line Archive"."Conversion Qty";
                            SOQtyPCS := "Sales Line Archive".Quantity;
                        END;


                    //----
                    CGSTAmt := 0;
                    SGSTAmt := 0;
                    IGSTAmt := 0;
                    CGSTRate := 0;
                    //SGSTRate :=0;


                    Total += "Sales Line Archive"."Unit Price" * "Sales Line Archive".Quantity;

                    IF ("Sales Line Archive"."GST Jurisdiction Type" = "Sales Line Archive"."GST Jurisdiction Type"::Intrastate) THEN BEGIN
                        CGSTRate := 0;//"Sales Line Archive"."GST %"/2; //PCPL/MIG/NSW
                        CGSTAmt := 0;//"Sales Line Archive"."Total GST Amount" / 2; //PCPL/MIG/NSW
                        SGSTAmt := 0;// "Sales Line Archive"."Total GST Amount" /2; //PCPL/MIG/NSW
                                     //MESSAGE('%1  %2',CGSTAmt,SGSTAmt);
                    END
                    ELSE
                        IF ("Sales Line Archive"."GST Jurisdiction Type" = "Sales Line Archive"."GST Jurisdiction Type"::Interstate) THEN BEGIN

                            IGSTRate := 0;// "Sales Line Archive"."GST %"; //PCPL/MIG/NSW
                            IGSTAmt := 0;//"Sales Line Archive"."Total GST Amount";//PCPL/MIG/NSW
                        END;

                    CGSTTotal += CGSTAmt;
                    SGSTTotal += SGSTAmt;
                    IGSTTotal += IGSTAmt;

                    Total1 := Total + CGSTTotal + SGSTTotal + IGSTTotal;


                    recCheck.InitTextVariable;
                    recCheck.FormatNoText(AmountInWords, Total1, '');
                    //----
                    RecResEntry.RESET;
                    RecResEntry.SETRANGE(RecResEntry."Source ID", "Sales Line Archive"."Document No.");
                    RecResEntry.SETRANGE(RecResEntry."Source Ref. No.", "Sales Line Archive"."Line No.");
                    IF RecResEntry.FINDFIRST THEN
                        REPEAT
                            Lotno := RecResEntry."Lot No.";
                            EXPDate := RecResEntry."Expiration Date";
                            MFGDate := RecResEntry."Manufacturing Date";
                        UNTIL RecILE.NEXT = 0;
                end;

                trigger OnPreDataItem();
                begin
                    SrNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF RecCust.GET("Sales Header Archive"."Sell-to Customer No.") THEN BEGIN
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

                RecState.RESET;
                IF RecState.GET(Cust_StateCode) THEN
                    Cust_StateName := RecState.Description;
                StateCode := RecState."State Code (GST Reg. No.)";
            end;

            trigger OnPreDataItem();
            begin

                GrandTotal := 0;
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

    trigger OnPreReport();
    begin
        IGSTRate := 0;
        CGSTTotal := 0;
        SGSTTotal := 0;
        IGSTTotal := 0;
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
}

