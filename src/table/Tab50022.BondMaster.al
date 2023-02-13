table 50022 "Bond Master"
{
    // version CCIT-Fortune

    DrillDownPageID = 50023;
    LookupPageID = 50023;

    fields
    {
        field(1; "Supplier Name"; Text[50])
        {
        }
        field(2; "Data Logger"; Code[10])
        {
        }
        field(3; "Supplier PO No."; Code[20])
        {
        }
        field(4; "Freight Type"; Code[10])
        {
        }
        field(5; "Container Type"; Option)
        {
            OptionMembers = " ","20ft","40ft";
        }
        field(6; "Container No."; Code[20])
        {
        }
        field(7; "Seal No"; Code[20])
        {
        }
        field(8; "Mode of Transport"; Code[10])
        {
        }
        field(9; CHA; Code[10])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF RecVendor.GET(CHA) THEN
                    "CHA Name" := RecVendor.Name;
            end;
        }
        field(10; "CHA Job No."; Code[20])
        {
        }
        field(11; "BL/AWB No."; Code[20])
        {
        }
        field(12; "BL Date"; Date)
        {
        }
        field(13; "Actual Departure Date"; Date)
        {
        }
        field(14; "In-Bond Bill of Entry No."; Code[20])
        {
        }
        field(15; "In-Bond BOE Date"; Date)
        {
        }
        field(16; "Bond Number"; Code[20])
        {
        }
        field(17; "Bond Sr.No."; Code[20])
        {
        }
        field(18; "Bond Date"; Date)
        {
        }
        field(19; "Product Sr. No as per BE"; Code[20])
        {
        }
        field(20; "Supplier Invoice No."; Code[100])
        {
        }
        field(21; "Supplier Invoice Sr.No."; Code[20])
        {
        }
        field(22; "Supplier Invoice Date"; Date)
        {
        }
        field(23; "Product Name"; Text[50])
        {
        }
        field(24; "Inbond Qty"; Decimal)
        {
        }
        field(25; "Gross Weight"; Decimal)
        {
        }
        field(26; "Net Weight"; Decimal)
        {
        }
        field(27; "Total Transit Day"; Integer)
        {
        }
        field(28; "Shipment Arrival at Port Date"; Date)
        {

            trigger OnValidate();
            begin
                "Actual Transit Days" := "Shipment Arrival at Port Date" - "Actual Departure Date";
            end;
        }
        field(29; "Date Of Shipment Move. at CFS"; Date)
        {
        }
        field(30; "Name of CFS"; Text[50])
        {
        }
        field(31; "Date of Move. from CFS Bond"; Date)
        {

            trigger OnValidate();
            begin
                "No. of Days Move. CFS to Bond" := "Date of Move. from CFS Bond" - "Date Of Shipment Move. at CFS";
            end;
        }
        field(32; "No. of Days Move. CFS to Bond"; Decimal)
        {
        }
        field(33; "Date of FSSAI Appointment"; Date)
        {
        }
        field(34; "FSSAI Report Date"; Date)
        {
        }
        field(35; "FSSAI Sample Withdrawal Date"; Date)
        {
        }
        field(36; "No. of Days Approval for FSSAI"; Decimal)
        {
        }
        field(37; "GRN Start Date"; Date)
        {
        }
        field(38; "GRN Completion Date"; Date)
        {

            trigger OnValidate();
            begin
                "No. of Days to Complete GRN" := "GRN Completion Date" - "GRN Start Date";
            end;
        }
        field(39; "GRN No."; Code[20])
        {
        }
        field(40; "GRN Date"; Date)
        {
        }
        field(41; "No. of Days to Complete GRN"; Decimal)
        {
        }
        field(42; "GRN Quantity"; Decimal)
        {
        }
        field(43; "Exbond Qty in KG"; Decimal)
        {
        }
        field(44; "Exbond Qty in Case"; Decimal)
        {
        }
        field(45; "Case No. As per SKU"; Code[20])
        {
        }
        field(46; "Type of Job"; Option)
        {
            OptionMembers = " ","Duty Paid","Bond to Bond","Duty Free";
        }
        field(47; "DFIA Name"; Text[50])
        {
        }
        field(48; "DFIA Number"; Code[20])
        {
        }
        field(49; "DFIA Date"; Date)
        {
        }
        field(50; "MEIS Name"; Text[50])
        {
        }
        field(51; "MEIS Number"; Code[20])
        {
        }
        field(52; "MEIS Date"; Date)
        {
        }
        field(53; "Customer wise"; Code[20])
        {
        }
        field(54; "Duty Free License No."; Code[20])
        {
        }
        field(55; "Duty Free License Date"; Date)
        {
        }
        field(56; "License Name(Name on Lic.)"; Text[50])
        {
        }
        field(57; "Buyer Name"; Text[50])
        {
        }
        field(58; "Ex-bond Order No."; Code[20])
        {
        }
        field(59; "Ex-bond Order Date"; Date)
        {
        }
        field(60; "CHA Name"; Text[50])
        {
        }
        field(61; "Ex-bond BOE No."; Code[20])
        {
        }
        field(62; "Ex-bond BOE Date"; Date)
        {
        }
        field(63; "Ex-bond Doc. Handover Date"; Date)
        {
        }
        field(64; "Ex-bond Completion Date"; Date)
        {
        }
        field(65; "No. of Days taken For Exbond"; Decimal)
        {
        }
        field(66; "Ex-bond BOE No.1"; Code[20])
        {
        }
        field(67; "Ex-bond BOE Date 1"; Date)
        {
        }
        field(68; "Ex-bond BOE No.2"; Code[20])
        {
        }
        field(69; "Ex-bond BOE Date 2"; Date)
        {
        }
        field(70; "Ex-bond BOE No.3"; Code[20])
        {
        }
        field(71; "Ex-bond BOE Date 3"; Date)
        {
        }
        field(72; "Ex-bond BOE No.4"; Code[20])
        {
        }
        field(73; "Ex-bond BOE Date 4"; Date)
        {
        }
        field(74; "Ex-bond BOE No.5"; Code[20])
        {
        }
        field(75; "Ex-bond BOE Date 5"; Date)
        {
        }
        field(76; "Ex-bond BOE No.6"; Code[20])
        {
        }
        field(77; "Ex-bond BOE Date 6"; Date)
        {
        }
        field(78; "Ex-bond BOE No.7"; Code[20])
        {
        }
        field(79; "Ex-bond BOE Date 7"; Date)
        {
        }
        field(80; "Ex-bond BOE No.8"; Code[20])
        {
        }
        field(81; "Ex-bond BOE Date 8"; Date)
        {
        }
        field(82; "Ex-bond BOE No.9"; Code[20])
        {
        }
        field(83; "Ex-bond BOE Date 9"; Date)
        {
        }
        field(84; "Supplier No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF RecVendor.GET("Supplier No.") THEN
                    "Supplier Name" := RecVendor.Name;
            end;
        }
        field(85; "Bond No. Series"; Code[20])
        {

            trigger OnValidate();
            begin

                IF "Bond No. Series" <> xRec."Bond No. Series" THEN BEGIN
                    SalesAndReceivableSetup.GET;
                    NoSeriesMgt.TestManual(SalesAndReceivableSetup."Bond Nos.");
                    // "No. Series" := '';
                END;
            end;
        }
        field(86; "Bond Value"; Decimal)
        {
        }
        field(87; "Utilized Bond Value"; Decimal)
        {
        }
        field(88; "FSSAI ICA No."; Code[20])
        {
        }
        field(89; "Purchase Order No."; Code[20])
        {
            TableRelation = "Purchase Header"."No.";

            trigger OnValidate();
            begin
                //CCIT-SG
                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Purchase Order No.");
                IF RecPH.FINDFIRST THEN BEGIN
                    "Mode of Transport" := RecPH."Transport Method";
                    "BL/AWB No." := RecPH."BL/AWB No.";
                    "BL Date" := RecPH."BL Date";
                    //CCIT_kj_Transfer from Header to Bond_22-4-21+++
                    "Supplier No." := RecPH."Buy-from Vendor No.";
                    "Supplier Name" := RecPH."Buy-from Vendor Name";
                    "Currency Code" := RecPH."Currency Code";
                    "Container No." := RecPH."Container Number";
                    "Supplier PO No." := RecPH."Vendor Order No.";
                    // "Container Type" :=
                    //CCIT_kj_Transfer from Header to Bond_22-4-21+++
                    //CCIT-20042021
                    RecCurrExtRate.RESET;
                    RecCurrExtRate.SETRANGE(RecCurrExtRate."Currency Code", RecPH."Currency Code");
                    RecCurrExtRate.SETFILTER(RecCurrExtRate."Starting Date", '<=%1', TODAY);
                    RecCurrExtRate.SETFILTER(RecCurrExtRate."End Date", '>=%1', TODAY);
                    IF RecCurrExtRate.FINDFIRST THEN
                        "Exchange Rate" := RecCurrExtRate."Relational Exch. Rate Amount"
                    ELSE
                        "Exchange Rate" := 0;
                    //CCIT-20042021
                END;
                //CCIT-SG
            end;
        }
        field(90; "Supplier Invoice No.1"; Code[20])
        {
        }
        field(91; "Supplier Invoice Sr.No.1"; Code[20])
        {
        }
        field(92; "Supplier Invoice Date 1"; Date)
        {
        }
        field(93; "Gross Weight 1"; Decimal)
        {
        }
        field(94; "Net Weight 1"; Decimal)
        {
        }
        field(95; "Supplier Invoice No.2"; Code[20])
        {
        }
        field(96; "Supplier Invoice Sr.No.2"; Code[20])
        {
        }
        field(97; "Supplier Invoice Date 2"; Date)
        {
        }
        field(98; "Gross Weight 2"; Decimal)
        {
        }
        field(99; "Net Weight 2"; Decimal)
        {
        }
        field(100; "Supplier Invoice No.3"; Code[20])
        {
        }
        field(101; "Supplier Invoice Sr.No.3"; Code[20])
        {
        }
        field(102; "Supplier Invoice Date 3"; Date)
        {
        }
        field(103; "Gross Weight 3"; Decimal)
        {
        }
        field(104; "Net Weight 3"; Decimal)
        {
        }
        field(105; "Supplier Invoice No.4"; Code[20])
        {
        }
        field(106; "Supplier Invoice Sr.No.4"; Code[20])
        {
        }
        field(107; "Supplier Invoice Date 4"; Date)
        {
        }
        field(108; "Gross Weight 4"; Decimal)
        {
        }
        field(109; "Net Weight 4"; Decimal)
        {
        }
        field(110; "Actual Transit Days"; Decimal)
        {
        }
        field(111; "Ex-Bond Done"; Boolean)
        {
            Description = 'rdk 230919';
        }
        field(112; "In-Bond BOE Value"; Decimal)
        {
        }
        field(113; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code',
                        ENN = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                /*IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                  TESTFIELD(Status,Status::Open);
                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                  UpdateCurrencyFactor
                ELSE
                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor;
                    IF PurchLinesExist THEN
                      IF CONFIRM(ChangeCurrencyQst,FALSE,FIELDCAPTION("Currency Code")) THEN BEGIN
                        SetHideValidationDialog(TRUE);
                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                        SetHideValidationDialog(FALSE);
                      END ELSE
                        ERROR(Text018,FIELDCAPTION("Currency Code"));
                  END ELSE
                    IF "Currency Code" <> '' THEN BEGIN
                      UpdateCurrencyFactor;
                      IF "Currency Factor" <> xRec."Currency Factor" THEN
                        ConfirmUpdateCurrencyFactor;
                    END;
                */

            end;
        }
        field(114; "Exchange Rate"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Bond No. Series") //PCPL/MIG/NSW , "In-Bond Bill of Entry No." Key remove Code is wrong for that Table even 2016 Also Bug
        {
            Clustered = true;
        }


    }

    fieldgroups
    {
    }

    var
        RecVendor: Record 23;
        SalesAndReceivableSetup: Record 311;
        NoSeriesMgt: Codeunit 396;
        RecPH: Record 38;
        RecCurrExtRate: Record 330;

    procedure AssistEdit(OldBONDNO: Record 50022): Boolean;
    var
        BONDNO: Record 50022;
    begin
        WITH BONDNO DO BEGIN
            COPY(Rec);
            SalesAndReceivableSetup.GET;
            //TestNoSeries;
            IF NoSeriesMgt.SelectSeries(SalesAndReceivableSetup."Bond Nos.", OldBONDNO."Bond No. Series", "Bond No. Series") THEN BEGIN

                NoSeriesMgt.SetSeries("Bond No. Series");
                // IF SalesHeader2.GET("Document Type","No.") THEN
                //  ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
                Rec := BONDNO;
                EXIT(TRUE);
            END;
        END;
    end;
}

