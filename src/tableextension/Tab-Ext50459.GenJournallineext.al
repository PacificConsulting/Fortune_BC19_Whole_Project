tableextension 50459 "Gen_Journal_line_ext" extends "Gen. Journal Line"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune,CCIT-TDS

    fields
    {


        // modify("TCS Type")
        // {
        //     OptionCaptionML = ENU=' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H',ENN=' ,A,B,C,D,E,F,G,H,I,J,K,L,M,N,1H';

        //     //Unsupported feature: Change OptionString on ""TCS Type"(Field 16504)". Please convert manually.

        // }




        //Unsupported feature: CodeModification on "Amount(Field 13).OnValidate". Please convert manually.
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG-23012019
                IF "Currency Code" = '' THEN
                    TempAmtLCY := Amount
                ELSE
                    TempAmtLCY := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                          Amount, "Currency Factor"));
                //MESSAGE('1  %1',TempAmtLCY);

                IF Rec."Journal Template Name" = 'BANK PAYME' THEN
                    "Amount (LCY)" := ROUND(TempAmtLCY, 1)
                ELSE
                    "Amount (LCY)" := TempAmtLCY;

                //CCIT-SG-23012019


            end;
        }



        // field(16664; "Amount Excl. GST"; Decimal)
        // {
        //     CaptionML = ENU = 'Amount Excl. GST',
        //                 ENN = 'Amount Excl. GST';

        //     trigger OnValidate();
        //     begin
        //         IF "Amount Excl. GST" <> 0 THEN BEGIN
        //             TESTFIELD("Document Type", "Document Type"::Payment);
        //             TESTFIELD("Party Type", "Party Type"::Vendor);
        //             TESTFIELD("Party Code");
        //             //TESTFIELD("TDS Nature of Deduction");
        //             TESTFIELD(Amount);
        //             IF "GST on Advance Payment" THEN
        //                 TESTFIELD("GST on Advance Payment", FALSE);
        //             IF "Amount Excl. GST" < 0 THEN
        //                 ERROR(TDSAmtNegErr);
        //             IF "Amount Excl. GST" > Amount THEN
        //                 ERROR(TDSExcGSTGreaterErr, Amount);
        //         END;

        //         IF xRec."Service Tax Base Amount (LCY)" = "Service Tax Base Amount (LCY)" THEN BEGIN
        //             CalculateServiceTax;
        //             CalculateTDS;
        //         END;
        //     end;
        // }
        // field(16685; "TDS Adjustment"; Boolean)
        // {
        //     CaptionML = ENU = 'TDS Adjustment',
        //                 ENN = 'TDS Adjustment';
        // }
        // field(16686; "Exclude GST in TCS Base"; Boolean)
        // {
        //     CaptionML = ENU = 'Exclude GST in TCS Base',
        //                 ENN = 'Exclude GST in TCS Base';

        //     trigger OnValidate();
        //     begin
        //         CheckValidationforExclGSTTCSBase;
        //     end;
        // }
        // field(16689; "Provisional Entry"; Boolean)
        // {
        //     CaptionML = ENU = 'Provisional Entry',
        //                 ENN = 'Provisional Entry';

        //     trigger OnValidate();
        //     var
        //         LineCnt: Integer;
        //     begin
        //         TESTFIELD("GST Group Code", '');
        //         TESTFIELD("Document Type", "Document Type"::Invoice);
        //         TESTFIELD("Account Type", "Account Type"::"G/L Account");
        //         TESTFIELD("Account No.");
        //         TESTFIELD("Bal. Account Type", "Bal. Account Type"::"G/L Account");
        //         TESTFIELD("Bal. Account No.");
        //         TESTFIELD("Party Code");
        //         TESTFIELD("Party Type", "Party Type"::Vendor);
        //         TESTFIELD("TDS Nature of Deduction");
        //         IF Amount >= 0 THEN
        //             ERROR(AmtPositiveErr);
        //         LineCnt := GSTManagement.GetTotalDocLines(Rec);
        //         IF LineCnt > 1 THEN
        //             ERROR(ProvEntryMultiLineErr);
        //     end;
        // }
        // field(16692; "Sales Amount"; Decimal)
        // {
        //     CaptionML = ENU = 'Sales Amount',
        //                 ENN = 'Sales Amount';
        //     Editable = false;
        // }
        field(50000; "RTGS/NEFT"; Option)
        {
            OptionMembers = " ",RTGS,NEFT;
        }
        field(50021; "Vertical Category"; Code[50])
        {
            Description = 'CCIT';
            TableRelation = "Vertical Category";
        }
        field(50022; "Vertical Sub Category"; Code[50])
        {
            Description = 'CCIT';
            TableRelation = "Vertical Sub Category".Code WHERE("Vertical Category Code" = FIELD("Vertical Category"));
        }
        field(50023; "Outlet Area"; Text[30])
        {
            Description = 'CCIT';
        }
        field(50025; "Business Format / Outlet Name"; Text[100])
        {
            Description = 'CCIT';
        }
        field(50030; Weight; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50053; "Advanced Payment"; Boolean)
        {
            Description = 'CCIT';
        }
        field(50054; Shipment; Boolean)
        {
            Description = 'CCIT';
        }
        field(50055; "Purchase Order Reference No."; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(50058; "Bill of Entry No"; Text[30])
        {
            CaptionML = ENU = 'Bill of Entry Value',
                        ENN = 'Bill of Entry Value';
            Description = 'CCIT_kj_10052021';
            Editable = false;
        }
    }



    var
        CompanyInfo: Record 79;
        Location: Record 14;
        Location2: Record 14;
        LocationARNNo: Code[15];
        GSTComponent: Record 18202;
        CustLedgerEntry: Record 21;
        // STReverseChargeSetup : Record "16461";
        CalculatedTDSAmt: Decimal;
        CalculatedSurchargeAmt: Decimal;
        SurchargeBase: Decimal;
        WorkTaxBaseAmt: Decimal;
        Customer: Record 18;
        TCSEntry: Record "TCS Entry";
        CustLedgEntry: Record 21;
        //DateFilterCalc : Codeunit "358";
        AppliedAmountDoc: Decimal;
        //TempAmtLCY : Decimal;
        ReferenceNoTxtErr: TextConst ENU = 'Reference Invoice No is required where Invoice Type is Debit Note and Supplementary.', ENN = 'Reference Invoice No is required where Invoice Type is Debit Note and Supplementary.';
        FinChargeMemoAppliestoDocTypeErr: TextConst ENU = 'You cannot select GST on Advance Payment if Applies to Doc Type is Fin Charge Memo.', ENN = 'You cannot select GST on Advance Payment if Applies to Doc Type is Fin Charge Memo.';
        TDSAmtNegErr: TextConst ENU = 'Amount must be positive.', ENN = 'Amount must be positive.';
        TDSExcGSTGreaterErr: TextConst Comment = '%1 = Amount', ENU = 'Amount Excl. GST must not be greater than Amount %1.', ENN = 'Amount Excl. GST must not be greater than Amount %1.';
        AmtLessThanTDSAmtErr: TextConst Comment = '%1 = Amount Excl. GST', ENU = 'Amount must not be less than Amount Excl. GST %1.', ENN = 'Amount must not be less than Amount Excl. GST %1.';
        TDSNatureOfDeductionErr: TextConst ENU = 'TDS Nature of Deduction must be same in both documents.', ENN = 'TDS Nature of Deduction must be same in both documents.';
        TCSNatureOfCollectionErr: TextConst ENU = 'TCS Nature of Collection must be same in both documents.', ENN = 'TCS Nature of Collection must be same in both documents.';
        DiffTDSNatureOfDedErr: TextConst Comment = '%1 = Applied Entry No,%2 = Document Type , %3 = Document No', ENU = 'TDS Nature of Deduction must be same in Applied Entry No. %1 and Document Type %2, Document No %3.', ENN = 'TDS Nature of Deduction must be same in Applied Entry No. %1 and Document Type %2, Document No %3.';
        DiffTCSNatureOfCollErr: TextConst Comment = '%1 = Payment Entry No,%2 = Document Type , %3 = Document No', ENU = 'TCS Nature of Collection must be same in Applied Entry No. %1 and Document Type %2, Document No %3.', ENN = 'TCS Nature of Collection must be same in Applied Entry No. %1 and Document Type %2, Document No %3.';
        GSTTDSTaxTypeErr: TextConst ENU = 'CESS Component is not applicable for GST TDS Credit or GST TCS Credit Tax Type.', ENN = 'CESS Component is not applicable for GST TDS Credit or GST TCS Credit Tax Type.';
        GSTType: Option " ",TDS,TCS;
        LocationCodeErr: TextConst ENU = 'Please specify the Location Code or Location GST Registration No for the selected document.', ENN = 'Please specify the Location Code or Location GST Registration No for the selected document.';
        CompGSTRegNoARNNoErr: TextConst ENU = 'Company Information must have either GST Registration No or ARN No.', ENN = 'Company Information must have either GST Registration No or ARN No.';
        LocGSTRegNoARNNoErr: TextConst ENU = 'Location must have either GST Registration No or Location ARN No.', ENN = 'Location must have either GST Registration No or Location ARN No.';
        CompanyGSTRegNoErr: TextConst ENU = 'Please specify GST Registration No in Company Information.', ENN = 'Please specify GST Registration No in Company Information.';
        GSTTDSTCSAmtGreaterErr: TextConst Comment = '%1 = GST TDS/TCS Base Amount', ENU = 'GST TDS/TCS Base Amount must not be greater than Amount %1.', ENN = 'GST TDS/TCS Base Amount must not be greater than Amount %1.';
        GSTTDSTCSAmtPostiveErr: TextConst ENU = 'GST TDS/TCS Base Amount must be positive.', ENN = 'GST TDS/TCS Base Amount must be positive.';
        GSTTDSTCSAmtNegativeErr: TextConst ENU = 'GST TDS/TCS Base Amount must be negative.', ENN = 'GST TDS/TCS Base Amount must be negative.';
        AmtLessthanGSTTDSTCSErr: TextConst ENU = 'Amount must be greater than GST TDS/TCS Base Amount.', ENN = 'Amount must be greater than GST TDS/TCS Base Amount.';
        POSasVendorErr: TextConst Comment = '%1 = Field Name', ENU = 'POS as Vendor State is only applicable for Registered vendor, current vendor is %1.', ENN = 'POS as Vendor State is only applicable for Registered vendor, current vendor is %1.';
        CurrencyCodePOSErr: TextConst Comment = '%1 = Field Name', ENU = 'Currency code should be blank for POS as Vendor State, current value is %1.', ENN = 'Currency code should be blank for POS as Vendor State, current value is %1.';
        POSasVendErr: TextConst Comment = '%1 = Field Name', ENU = 'POS as Vendor State is only applicable for Registered Vendor.', ENN = 'POS as Vendor State is only applicable for Registered Vendor.';
        POSasAccountTypeErr: TextConst ENU = 'POS as Vendor State is only applicable for Purchase Document Type where Invoice or Credit Memo.', ENN = 'POS as Vendor State is only applicable for Purchase Document Type where Invoice or Credit Memo.';
        ReferenceInvoiceErr: TextConst ENU = 'Document is attached with Reference Invoice No. Please delete attached Reference Invoice No.', ENN = 'Document is attached with Reference Invoice No. Please delete attached Reference Invoice No.';
        IsChargeGLEntry: Boolean;
        ExcludeGSTDocTypeErr: TextConst ENU = 'Exclude GST in TCS Base is allowed only for Document Type Invoice and Credit Memo.', ENN = 'Exclude GST in TCS Base is allowed only for Document Type Invoice and Credit Memo.';
        ExcludeGSTTCSBlankErr: TextConst ENU = 'GST Group Code and TCS Nature of Collection are required for selecting Exclude GST in TCS Base field in transaction.', ENN = 'GST Group Code and TCS Nature of Collection are required for selecting Exclude GST in TCS Base field in transaction.';
        ProvEntryMultiLineErr: TextConst ENU = 'Multi Line transactions are not allowed for Provisional Entries.', ENN = 'Multi Line transactions are not allowed for Provisional Entries.';
        AmtPositiveErr: TextConst ENU = 'Amount must be negative.', ENN = 'Amount must be negative.';
        ProvisionalEntryAppliedErr: TextConst Comment = '%1 = Document No', ENU = 'Provisional Entry is already applied against Document No. %1, you must unapply the provisional entry first.', ENN = 'Provisional Entry is already applied against Document No. %1, you must unapply the provisional entry first.';
        GSTUnregisteredNotAppErr: TextConst ENU = 'GST is not applicable for Unregistered Vendors.', ENN = 'GST is not applicable for Unregistered Vendors.';
        GSTPlaceOfSuppErr: TextConst ENU = 'You can not select POS Out Of India field on header if GST Place of Supply is Location Address.', ENN = 'You can not select POS Out Of India field on header if GST Place of Supply is Location Address.';
        POSLineErr: TextConst ENU = 'Please select POS Out Of India field only on header line.', ENN = 'Please select POS Out Of India field only on header line.';
        WithoutBillOfEntryErr: TextConst ENU = 'Without Bill of entry is not allowed for GST Vendor Type SEZ where Document Type is Credit Memo.', ENN = 'Without Bill of entry is not allowed for GST Vendor Type SEZ where Document Type is Credit Memo.';
        TCSThrldErr: TextConst ENU = 'Advance Payment with TCS Calculation on Over & Above Threshold Amount is not allowed.', ENN = 'Advance Payment with TCS Calculation on Over & Above Threshold Amount is not allowed.';
        TDS_BaseAmt1: Decimal;
        TDS_BaseAmt2: Decimal;
        RecTDSEntry: Record "TDS Entry";
        RecTDSEntry1: Record "TDS Entry";
        Total_TDS_BaseAmt: Decimal;
        RecPuchAndPayable: Record 312;
        RecVend: Record 23;
        Vend_PAN_No: Code[20];
        TempAmtLCY: Decimal;
}

