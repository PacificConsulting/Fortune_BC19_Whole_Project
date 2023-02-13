report 50041 "GSTR-1 File Format Updated"
{
    // version NAVIN9.00.00.49326
    //PCPL/MIG/NSW Filed not Exist in BC18 Lots of field not Available
    /*
        CaptionML = ENU = 'GSTR-1 File Format',
                    ENN = 'GSTR-1 File Format';
        EnableHyperlinks = false;
        ProcessingOnly = true;
        UseRequestPage = true;

        dataset
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));

                trigger OnAfterGetRecord();
                begin
                    CASE FileFormat OF
                        FileFormat::" ":
                            ERROR(FileformatErr);
                        FileFormat::B2B:
                            BEGIN
                                MakeExcelBodyB2B;
                                ExcelBuffer.OnlyCreateBook(B2BTxt, B2BTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::B2CL:
                            BEGIN
                                MakeExcelBodyB2CL;
                                ExcelBuffer.OnlyCreateBook(B2CLTxt, B2CLTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::B2CS:
                            BEGIN
                                MakeExcelBodyB2CS;
                                ExcelBuffer.OnlyCreateBook(B2CSTxt, B2CSTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::AT:
                            BEGIN
                                MakeExcelBodyAT;
                                ExcelBuffer.OnlyCreateBook(ATTxt, ATTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::ATADJ:
                            ERROR(ATADJErr);
                        FileFormat::CDNR:
                            BEGIN
                                MakeExcelBodyCDNR;
                                ExcelBuffer.OnlyCreateBook(CDNRTxt, CDNRTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::CDNUR:
                            BEGIN
                                MakeExcelBodyCDNUR;
                                ExcelBuffer.OnlyCreateBook(CDNURTxt, CDNURTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::EXP:
                            BEGIN
                                MakeExcelBodyEXP;
                                ExcelBuffer.OnlyCreateBook(EXPTxt, EXPTxt, COMPANYNAME, USERID, FALSE);
                            END;
                        FileFormat::HSN:
                            BEGIN
                                MakeExcelBodyHSN;
                                ExcelBuffer.OnlyCreateBook(HSNTxt, HSNTxt, COMPANYNAME, USERID, FALSE);
                            END;
                    END;
                end;

                trigger OnPreDataItem();
                begin
                    ExcelBuffer.DELETEALL;
                end;
            }
        }

        requestpage
        {

            layout
            {
                area(content)
                {
                    group(Options)
                    {
                        CaptionML = ENU = 'Options',
                                    ENN = 'Options';
                        field(GSTIN; GSTIN)
                        {
                            CaptionML = ENU = 'GSTIN of the location',
                                        ENN = 'GSTIN of the location';
                            TableRelation = "GST Registration Nos.".Code;
                        }
                        field(Date; Date)
                        {
                            CaptionML = ENU = 'Date',
                                        ENN = 'Date';

                            trigger OnValidate();
                            begin
                                Month := DATE2DMY(Date, 2);
                                Year := DATE2DMY(Date, 3);
                            end;
                        }
                        field(FileFormat; FileFormat)
                        {
                            CaptionML = ENU = 'File Format',
                                        ENN = 'File Format';
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

        trigger OnPostReport();
        begin
            ExcelBuffer.OnlyOpenExcel;
        end;

        var
            ExcelBuffer: Record 370 temporary;
            GSTIN: Code[15];
            Date: Date;
            Month: Integer;
            Year: Integer;
            CESSAmount: Decimal;
            B2BTxt: TextConst ENU = 'b2b', ENN = 'b2b';
            B2CLTxt: TextConst ENU = 'b2cl', ENN = 'b2cl';
            B2CSTxt: TextConst ENU = 'b2cs', ENN = 'b2cs';
            CDNRTxt: TextConst ENU = 'cdnr', ENN = 'cdnr';
            CDNURTxt: TextConst ENU = 'cdnur', ENN = 'cdnur';
            ATTxt: TextConst ENU = 'at', ENN = 'at';
            EXPTxt: TextConst ENU = 'exp', ENN = 'exp';
            HSNTxt: TextConst ENU = 'hsn', ENN = 'hsn';
            GSTINUINTxt: TextConst ENU = 'GSTIN/UIN of Recipient', ENN = 'GSTIN/UIN of Recipient';
            InvoiceNoTxt: TextConst ENU = 'Invoice Number', ENN = 'Invoice Number';
            InvoiceDateTxt: TextConst ENU = 'Invoice Date', ENN = 'Invoice Date';
            InvoiceValueTxt: TextConst ENU = 'Invoice Value', ENN = 'Invoice Value';
            PlaceOfSupplyTxt: TextConst ENU = 'Place Of Supply', ENN = 'Place Of Supply';
            ReverseChargeTxt: TextConst ENU = 'Reverse Charge', ENN = 'Reverse Charge';
            ECommGSTINTxt: TextConst ENU = 'E-Commerce GSTIN', ENN = 'E-Commerce GSTIN';
            HSNSACofSupplyTxt: TextConst ENU = 'HSN/SAC of Supply', ENN = 'HSN/SAC of Supply';
            TaxableValueTxt: TextConst ENU = 'Taxable Value', ENN = 'Taxable Value';
            IGSTAmountTxt: TextConst ENU = 'IGST Amount', ENN = 'IGST Amount';
            CGSTAmountTxt: TextConst ENU = 'CGST Amount', ENN = 'CGST Amount';
            SGSTAmountTxt: TextConst ENU = 'SGST Amount', ENN = 'SGST Amount';
            CESSAmountTxt: TextConst ENU = 'CESS Amount', ENN = 'CESS Amount';
            TypeTxt: TextConst ENU = 'Type', ENN = 'Type';
            DocumentTypeTxt: TextConst ENU = 'Document Type', ENN = 'Document Type';
            ReasonForIssuingNoteTxt: TextConst ENU = 'Reason For Issuing document', ENN = 'Reason For Issuing document';
            DebitNoteNoTxt: TextConst ENU = 'Note/Refund Voucher Number', ENN = 'Note/Refund Voucher Number';
            DebitNoteDateTxt: TextConst ENU = 'Note/Refund Voucher Date', ENN = 'Note/Refund Voucher Date';
            OtherECommTxt: TextConst ENU = 'oe', ENN = 'oe';
            ExportTypeTxt: TextConst ENU = 'Export Type', ENN = 'Export Type';
            PortCodeTxt: TextConst ENU = 'Port Code', ENN = 'Port Code';
            ShipBillNoTxt: TextConst ENU = 'Shipping Bill Number', ENN = 'Shipping Bill Number';
            ShipBillDateTxt: TextConst ENU = 'Shipping Bill Date', ENN = 'Shipping Bill Date';
            WOPAYTxt: TextConst ENU = 'wopay', ENN = 'wopay';
            WPAYTxt: TextConst ENU = 'wpay', ENN = 'wpay';
            OriginalInvNoTxt: TextConst ENU = 'Invoice/Advance Receipt Number', ENN = 'Invoice/Advance Receipt Number';
            OriginalInvDateTxt: TextConst ENU = 'Invoice/Advance Receipt date', ENN = 'Invoice/Advance Receipt date';
            InvoiceTypeTxt: TextConst ENU = 'Invoice Type', ENN = 'Invoice Type';
            RateTxt: TextConst ENU = 'Rate', ENN = 'Rate';
            RegularTxt: TextConst ENU = 'Regular', ENN = 'Regular';
            EXPWOPayTxt: TextConst ENU = 'expwop', ENN = 'expwop';
            EXPWPayTxt: TextConst ENU = 'expwp', ENN = 'expwp';
            DeemedExportTxt: TextConst ENU = 'Deemed Export', ENN = 'Deemed Export';
            RefundVoucherValueTxt: TextConst ENU = 'Note/Refund Voucher Value', ENN = 'Note/Refund Voucher Value';
            PreGSTTxt: TextConst ENU = 'Pre GST', ENN = 'Pre GST';
            URTypeTxt: TextConst ENU = 'UR Type', ENN = 'UR Type';
            GrossAdvanceRcvdTxt: TextConst ENU = 'Gross Advance Received', ENN = 'Gross Advance Received';
            TotalBaseAmount: Decimal;
            TotalGSTAmount: Decimal;
            CESSAmountApp: Decimal;
            TotalBaseAmountApp: Decimal;
            GSTPer: Decimal;
            FileFormat: Option " ",B2B,B2CL,B2CS,EXP,CDNUR,CDNR,ATADJ,AT,HSN;
            FileformatErr: TextConst ENU = 'You must select GSTR File Format.', ENN = 'You must select GSTR File Format.';
            DescTxt: TextConst ENU = 'Desciption Text', ENN = 'Desciption Text';
            TotalQtyTxt: TextConst ENU = 'Total Quantity', ENN = 'Total Quantity';
            TotalValTxt: TextConst ENU = 'Total Value', ENN = 'Total Value';
            UQCTxt: TextConst ENU = 'uqc', ENN = 'uqc';
            CompReportView: Option " ",CGST,"SGST / UTGST",IGST,CESS;
            HSNSGSTAmt: Decimal;
            HSNCGSTAmt: Decimal;
            HSNIGSTAmt: Decimal;
            HSNCessAmt: Decimal;
            HSNQty: Decimal;
            GSTBaseAmount: Decimal;
            ATADJErr: TextConst ENU = 'This feature will be available in the next release.', ENN = 'This feature will be available in the next release.';
            RecCust: Record 18;
            RecState: Record State;
            SEZWOPayTxt: Label 'SEZ Without Pay';
            SEZWPayTxt: Label 'SEZ With Pay';

        procedure MakeExcelHeaderB2B();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ReverseChargeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyB2B();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            State: Record "13762";
            GSTComponent: Record "16405";
            DocumentNo: Code[20];
            GSTPercentage: Decimal;
        begin
            MakeExcelHeaderB2B;
            DetailedGSTLedgerEntry.SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETFILTER("Entry Type", '%1', DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2B);
            DetailedGSTLedgerEntry.SETFILTER(
              "Invoice Type", '<>%1|<>%2', DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
              DetailedGSTLedgerEntry."Invoice Type"::Supplementary);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN
                        IF (DetailedGSTLedgerEntry."GST Customer Type" IN [DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::Registered,
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development",
                                                                           DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit"])  //CCIT-PRI-Added SEZ
                        THEN BEGIN
                            CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                            ClearVariables;
                            IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Location  Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

                                    IF DetailedGSTLedgerEntry."Buyer/Seller State Code" <> '' THEN
                                        ExcelBuffer.AddColumn(
                                          State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE BEGIN
                                        //CCIT-PRI
                                        RecCust.RESET;
                                        RecCust.SETRANGE(RecCust."No.", DetailedGSTLedgerEntry."Source No.");
                                        IF RecCust.FINDFIRST THEN BEGIN
                                            RecState.RESET;
                                            RecState.SETRANGE(RecState.Code, RecCust."State Code");
                                            IF RecState.FINDFIRST THEN
                                                ExcelBuffer.AddColumn(RecState."State Code (GST Reg. No.)" + '-' + RecState.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //CCIT-PRI-150818
                                        END;
                                    END;
                                    //CCIT-PRI
                                    IF DetailedGSTLedgerEntry."Reverse Charge" THEN
                                        ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceType(DetailedGSTLedgerEntry), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '', FALSE, FALSE,
                                      FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                        END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderB2CL();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyB2CL();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            State: Record State;
            GSTComponent: Record 18202;
            CustLedgerEntry: Record 21;
            DocumentNo: Code[20];
            GSTPercentage: Decimal;
        begin
            MakeExcelHeaderB2CL;
            DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETFILTER("Entry Type", '%1', DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
            DetailedGSTLedgerEntry.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                        IF CustLedgerEntry.FINDFIRST THEN
                            CustLedgerEntry.CALCFIELDS(Amount);

                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF CustLedgerEntry.Amount >= 250000 THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderB2CS();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(TypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ECommGSTINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyB2CS();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            CustLedgerEntry: Record 21;
            GSTComponent: Record 18202;
            State: Record State;
            BuyerSellerStateCode: Code[10];
            GSTPercentage: Decimal;
            ECommCode: Code[15];
        begin
            MakeExcelHeaderB2CS;
            DetailedGSTLedgerEntry.SETCURRENTKEY(
              "Location  Reg. No.", "Document Type", "Buyer/Seller State Code", "GST %", "e-Comm. Operator GST Reg. No.");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
            DetailedGSTLedgerEntry.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF (BuyerSellerStateCode <> DetailedGSTLedgerEntry."Buyer/Seller State Code") OR
                       (GSTPercentage <> DetailedGSTLedgerEntry."GST %") OR
                       (ECommCode <> DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.")
                    THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        GetGSTPlaceWiseValues(DetailedGSTLedgerEntry);
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;

                        CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                        IF CustLedgerEntry.FINDFIRST THEN
                            CustLedgerEntry.CALCFIELDS(Amount);

                        IF ((DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate) AND
                            (CustLedgerEntry.Amount <= 250000)) OR
                           (DetailedGSTLedgerEntry."GST Jurisdiction Type" = DetailedGSTLedgerEntry."GST Jurisdiction Type"::Intrastate)
                        THEN BEGIN
                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    IF DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No." <> '' THEN
                                        ExcelBuffer.AddColumn('E', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn(UPPERCASE(OtherECommTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description,
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.", FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                END;
                        END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            BuyerSellerStateCode := DetailedGSTLedgerEntry."Buyer/Seller State Code";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                            ECommCode := DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.";
                        END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderCDNR();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(GSTINUINTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(OriginalInvNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(OriginalInvDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DebitNoteNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DebitNoteDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ReasonForIssuingNoteTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyCDNR();
        var
            DetailedGSTLedgerEntry: Record "16419";
            State: Record "13762";
            GSTComponent: Record "16405";
            DocumentNo: Code[20];
            GSTPercentage: Decimal;
        begin
            MakeExcelHeaderCDNR;
            DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETFILTER(
              "Document Type", '%1|%2|%3', DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
              DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::Refund);
            DetailedGSTLedgerEntry.SETFILTER(
              "GST Customer Type", '%1|%2', DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export",
              DetailedGSTLedgerEntry."GST Customer Type"::Registered);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                        GetComponentValues(DetailedGSTLedgerEntry);

                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                                               DetailedGSTLedgerEntry."Document Type"::Refund]) OR
                                   ((DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice) AND
                                    (DetailedGSTLedgerEntry."Invoice Type" IN [DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
                                                                               DetailedGSTLedgerEntry."Invoice Type"::Supplementary]))
                                THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Buyer/Seller Reg. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
                                                                                   DetailedGSTLedgerEntry."Document Type"::Invoice])
                                    THEN BEGIN
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    END;
                                    IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN BEGIN
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.", FALSE, '',
                                          FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                        ExcelBuffer.AddColumn(
                                          DetailedGSTLedgerEntry."Original Adv. Pmt Doc. Date", FALSE, '',
                                          FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    END;
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo" THEN
                                        ExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice THEN
                                            ExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                        ELSE
                                            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN
                                                ExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      GetReturnReasonCode(DetailedGSTLedgerEntry."Document No."), FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    IF DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Invoice,
                                                                                  DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]
                                    THEN
                                        //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
                                        ExcelBuffer.AddColumn(
                          GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
                          FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      TotalBaseAmount + TotalGSTAmount + CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    IF CheckPreGST(
                                         DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Invoice No.",
                                         DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.")
                                    THEN
                                        ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
                                    ELSE
                                        ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            DocumentNo := DetailedGSTLedgerEntry."Document No.";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderCDNUR();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(URTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DebitNoteNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DebitNoteDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DocumentTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(OriginalInvNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(OriginalInvDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ReasonForIssuingNoteTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RefundVoucherValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PreGSTTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyCDNUR();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            State: Record State;
            GSTComponent: Record 18202;
            DocumentNo: Code[20];
            GSTPercentage: Decimal;
            UnRegCustomer: Boolean;
        begin
            MakeExcelHeaderCDNUR;
            DetailedGSTLedgerEntry.SETCURRENTKEY("Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETFILTER(
              "Document Type", '%1|%2|%3', DetailedGSTLedgerEntry."Document Type"::"Credit Memo",
              DetailedGSTLedgerEntry."Document Type"::Invoice, DetailedGSTLedgerEntry."Document Type"::Refund);
            DetailedGSTLedgerEntry.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type"::Interstate);
            DetailedGSTLedgerEntry.SETFILTER(
              "GST Customer Type", '%1|%2', DetailedGSTLedgerEntry."GST Customer Type"::Export,
              DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    UnRegCustomer := FALSE;
                    IF NOT (DetailedGSTLedgerEntry."GST Without Payment of Duty" OR DetailedGSTLedgerEntry."GST Exempted Goods") THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                            CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                            ClearVariables;
                            IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Unregistered) AND
                                ((GetBaseAmount(DetailedGSTLedgerEntry) + GetGSTAmount(DetailedGSTLedgerEntry)) >= 250000) AND
                                ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                                 (DetailedGSTLedgerEntry."Invoice Type" IN [DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
                                                                            DetailedGSTLedgerEntry."Invoice Type"::Supplementary])))
                            THEN
                                UnRegCustomer := TRUE;

                            IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Refund]) OR
                               ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Export) AND
                                (DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo") OR
                                (DetailedGSTLedgerEntry."Invoice Type" IN [DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
                                                                           DetailedGSTLedgerEntry."Invoice Type"::Supplementary])) OR
                               UnRegCustomer
                            THEN BEGIN
                                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                                IF GSTComponent.FINDFIRST THEN
                                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                        MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry, State);
                            END;
                        END;
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                                GSTPercentage := DetailedGSTLedgerEntry."GST %";
                            END;
                    END ELSE BEGIN
                        IF DocumentNo <> DetailedGSTLedgerEntry."Document No." THEN BEGIN
                            CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                            ClearVariables;
                            IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            IF ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Unregistered) AND
                                ((GetBaseAmount(DetailedGSTLedgerEntry) + GetGSTAmount(DetailedGSTLedgerEntry)) >= 250000) AND
                                ((DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::"Credit Memo"]) OR
                                 (DetailedGSTLedgerEntry."Invoice Type" IN [DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
                                                                            DetailedGSTLedgerEntry."Invoice Type"::Supplementary])))
                            THEN
                                UnRegCustomer := TRUE;

                            IF (DetailedGSTLedgerEntry."Document Type" IN [DetailedGSTLedgerEntry."Document Type"::Refund]) OR
                               ((DetailedGSTLedgerEntry."GST Customer Type" = DetailedGSTLedgerEntry."GST Customer Type"::Export) AND
                                (DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo") OR
                                (DetailedGSTLedgerEntry."Invoice Type" IN [DetailedGSTLedgerEntry."Invoice Type"::"Debit Note",
                                                                           DetailedGSTLedgerEntry."Invoice Type"::Supplementary])) OR
                               UnRegCustomer
                            THEN BEGIN
                                GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                                IF GSTComponent.FINDFIRST THEN
                                    IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                        MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry, State);
                            END;
                        END;
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelBodyLinesCDNUR(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"; State: Record State);
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(
              GetURType(DetailedGSTLedgerEntry), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::"Credit Memo" THEN
                ExcelBuffer.AddColumn('C', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
            ELSE
                IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Invoice THEN
                    ExcelBuffer.AddColumn('D', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                ELSE
                    IF DetailedGSTLedgerEntry."Document Type" = DetailedGSTLedgerEntry."Document Type"::Refund THEN
                        ExcelBuffer.AddColumn('R', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."Original Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(
              DetailedGSTLedgerEntry."Original Invoice Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
            ExcelBuffer.AddColumn(
              GetReturnReasonCode(DetailedGSTLedgerEntry."Document No."), FALSE, '',
              FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(
              State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
              FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
            ExcelBuffer.AddColumn(
              GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
              FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(CESSAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
            IF CheckPreGST(
                 DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Invoice No.",
                 DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Original Adv. Pmt Doc. No.")
            THEN
                ExcelBuffer.AddColumn('Y', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number)
            ELSE
                ExcelBuffer.AddColumn('N', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        end;

        local procedure MakeExcelHeaderAT();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(PlaceOfSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(GrossAdvanceRcvdTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyAT();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            State: Record State;
            GSTComponent: Record 18202;
            CustLedgerEntry: Record 21;
            BuyerSellerStateCode: Code[10];
            GSTPercentage: Decimal;
        begin
            MakeExcelHeaderAT;
            DetailedGSTLedgerEntry.SETCURRENTKEY(
              "Location  Reg. No.", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code","GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETFILTER("Document Type", '%1', DetailedGSTLedgerEntry."Document Type"::Payment);
            DetailedGSTLedgerEntry.SETRANGE(Reversed, FALSE);
            DetailedGSTLedgerEntry.SETRANGE("GST on Advance Payment", TRUE);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF (BuyerSellerStateCode <> DetailedGSTLedgerEntry."Buyer/Seller State Code") OR
                       (GSTPercentage <> DetailedGSTLedgerEntry."GST %")
                    THEN BEGIN
                        CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                        ClearVariables;
                        //IF State.GET(DetailedGSTLedgerEntry."Buyer/Seller State Code") THEN;  //PCPL/MIG/NSW Filed Not Exist in BC

                        //GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code"); //PCPL/MIG/NSW Filed Not Exist in BC
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                GetComponentValueAdvPayment(DetailedGSTLedgerEntry);
                                GetApplicationRemAmt(DetailedGSTLedgerEntry);
                                CustLedgerEntry.SETRANGE("Transaction No.", DetailedGSTLedgerEntry."Transaction No.");
                                CustLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                                IF CustLedgerEntry.FINDFIRST THEN
                                    CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                IF TotalBaseAmount - TotalBaseAmountApp <> 0 THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    ExcelBuffer.AddColumn(
                                      State."State Code (GST Reg. No.)" + '-' + State.Description, FALSE, '',
                                      FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      TotalBaseAmount - TotalBaseAmountApp, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(CESSAmount - CESSAmountApp, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                            END;
                    END;
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                            BuyerSellerStateCode := DetailedGSTLedgerEntry."Buyer/Seller State Code";
                            GSTPercentage := DetailedGSTLedgerEntry."GST %";
                        END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderEXP();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(ExportTypeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(InvoiceValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PortCodeTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ShipBillNoTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(ShipBillDateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(RateTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyEXP();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            GSTComponent: Record 18202;
            DocumentNo: Code[20];
            GSTPercentage: Decimal;
        begin
            MakeExcelHeaderEXP;
            DetailedGSTLedgerEntry.SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Entry Type", "Document Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry.SETFILTER("GST Customer Type", '%1', DetailedGSTLedgerEntry."GST Customer Type"::Export);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF NOT (DetailedGSTLedgerEntry."GST Without Payment of Duty" OR DetailedGSTLedgerEntry."GST Exempted Goods") THEN BEGIN
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR (GSTPercentage <> DetailedGSTLedgerEntry."GST %") THEN BEGIN
                            CheckComponentReportView(DetailedGSTLedgerEntry."GST Component Code");
                            ClearVariables;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    IF GetGSTPaymentOfDuty(DetailedGSTLedgerEntry."Document No.") THEN
                                        ExcelBuffer.AddColumn(UPPERCASE(WOPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn(UPPERCASE(WPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      GetExitPoint(DetailedGSTLedgerEntry."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Bill Of Export No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Bill Of Export Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                        END;
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                                GSTPercentage := DetailedGSTLedgerEntry."GST %";
                            END;
                    END ELSE BEGIN
                        IF DocumentNo <> DetailedGSTLedgerEntry."Document No." THEN BEGIN
                            ClearVariables;
                            GetComponentValues(DetailedGSTLedgerEntry);

                            GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                            IF GSTComponent.FINDFIRST THEN
                                IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN BEGIN
                                    ExcelBuffer.NewRow;
                                    IF GetGSTPaymentOfDuty(DetailedGSTLedgerEntry."Document No.") THEN
                                        ExcelBuffer.AddColumn(UPPERCASE(WOPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                                    ELSE
                                        ExcelBuffer.AddColumn(UPPERCASE(WPAYTxt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    //CCIT-PRI- Added OrignialDocNo,OriginalDocType- Parameter
                                    ExcelBuffer.AddColumn(
                                      GetInvoiceValue(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Type", DetailedGSTLedgerEntry."Original Doc. Type", DetailedGSTLedgerEntry."Original Doc. No."),
                                      FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(
                                      GetExitPoint(DetailedGSTLedgerEntry."Document No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Bill Of Export No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                    ExcelBuffer.AddColumn(
                                      DetailedGSTLedgerEntry."Bill Of Export Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                                    ExcelBuffer.AddColumn(GSTPer, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                    ExcelBuffer.AddColumn(TotalBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                END;
                        END;
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    END;
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
        end;

        local procedure MakeExcelHeaderHSN();
        begin
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(HSNSACofSupplyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(DescTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(UPPERCASE(UQCTxt), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TotalQtyTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TotalValTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(TaxableValueTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(IGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(SGSTAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(CESSAmountTxt, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        end;

        local procedure MakeExcelBodyHSN();
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Dist. Entry";
            UnitofMeasure: Record "Unit of Measure";
            HsnSac: Record 18009;
            HSNCode: Code[8];
            UOMCode: Code[10];
        begin
            MakeExcelHeaderHSN;
            WITH DetailedGSTLedgerEntry DO BEGIN
                SETCURRENTKEY("Location  Reg. No.", "Entry Type", "Transaction Type",
                  "Document Type", "HSN/SAC Code", UOM, "Document No.", "Document Line No.", "Original Invoice No.",
                  "Item Charge Assgn. Line No.");
                SETRANGE("Location  Reg. No.", GSTIN);
                SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                SETRANGE("Entry Type", "Entry Type"::"Initial Entry");
                SETRANGE("Transaction Type", "Transaction Type"::Sales);
                SETRANGE("Document Type", "Document Type"::Invoice);
                IF FINDSET THEN
                    REPEAT
                        IF (HSNCode <> "HSN/SAC Code") OR (UOMCode <> UOM) THEN BEGIN
                            CheckComponentReportView("GST Component Code");
                            ClearHSNInfo;
                            GSTBaseAmount += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::IGST, TRUE, FALSE);
                            HSNIGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::IGST, FALSE, FALSE);
                            HSNCGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CGST, FALSE, FALSE);
                            HSNSGSTAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::"SGST / UTGST", FALSE, FALSE);
                            HSNCessAmt += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CESS, FALSE, FALSE);
                            HSNQty += GetGSTAmountComp("HSN/SAC Code", UOM, CompReportView::CESS, FALSE, TRUE);
                            ExcelBuffer.NewRow;
                            ExcelBuffer.AddColumn("HSN/SAC Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            HsnSac.GET("GST Group Code", "HSN/SAC Code");
                            ExcelBuffer.AddColumn(HsnSac.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            IF UnitofMeasure.GET(UOM) THEN;
                            ExcelBuffer.AddColumn(UnitofMeasure."GST Reporting UQC", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(-HSNQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-(GSTBaseAmount + HSNIGSTAmt + HSNCGSTAmt + HSNSGSTAmt + HSNCessAmt),
                              FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-GSTBaseAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-HSNIGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-HSNCGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-HSNSGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(-HSNCessAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        END;
                        HSNCode := "HSN/SAC Code";
                        UOMCode := UOM;
                    UNTIL NEXT = 0;
            END;
        end;

        local procedure ClearVariables();
        begin
            CESSAmount := 0;
            GSTPer := 0;
            TotalBaseAmount := 0;
            TotalGSTAmount := 0;
            CESSAmountApp := 0;
            TotalBaseAmountApp := 0;
        end;

        local procedure GetComponentValues(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry");
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            DetailedGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
            DetailedGSTLedgerEntry3: Record "Detailed GST Ledger Entry";
            GSTComponent: Record 18202;
            LineNo: Integer;
            LineNo1: Integer;
            ItemChargeLineNo: Integer;
            ItemChargeLineNoCess: Integer;
            c: Integer;
        begin
            DetailedGSTLedgerEntry1.SETCURRENTKEY("Entry Type", "Document No.", "GST %");
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF DetailedGSTLedgerEntry1.FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN
                                IF NOT DetailedGSTLedgerEntry1."Item Charge Entry" THEN BEGIN
                                    IF LineNo <> DetailedGSTLedgerEntry1."Document Line No." THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        c += 1;
                                    END;
                                    GSTPer += DetailedGSTLedgerEntry1."GST %";
                                    TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                                    LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                END ELSE BEGIN
                                    IF ItemChargeLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No." THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        c += 1;
                                    END;
                                    GSTPer += DetailedGSTLedgerEntry1."GST %";
                                    TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                                    ItemChargeLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                                END
                            ELSE BEGIN
                                GSTPer := DetailedGSTLedgerEntry1."GST %";
                                IF NOT DetailedGSTLedgerEntry1."Item Charge Entry" THEN BEGIN
                                    IF LineNo <> DetailedGSTLedgerEntry1."Document Line No." THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                                    END;
                                    LineNo := DetailedGSTLedgerEntry1."Document Line No."
                                END ELSE BEGIN
                                    TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                    TotalGSTAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                                END;
                            END;
                UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
            IF c > 1 THEN
                GSTPer := GSTPer / c;

            GSTComponent.RESET;
            GSTComponent.SETRANGE("Report View", GSTComponent."Report View"::CESS);
            IF GSTComponent.FINDSET THEN
                REPEAT
                    DetailedGSTLedgerEntry2.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
                    DetailedGSTLedgerEntry2.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                    DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
                    DetailedGSTLedgerEntry2.SETFILTER("GST Component Code", '<>%1', GSTComponent.Code);
                    IF DetailedGSTLedgerEntry2.FINDSET THEN
                        REPEAT
                            DetailedGSTLedgerEntry3.SETRANGE("Document No.", DetailedGSTLedgerEntry2."Document No.");
                            DetailedGSTLedgerEntry3.SETRANGE("Document Line No.", DetailedGSTLedgerEntry2."Document Line No.");
                            DetailedGSTLedgerEntry3.SETRANGE("GST Component Code", GSTComponent.Code);
                            IF DetailedGSTLedgerEntry3.FINDSET THEN
                                REPEAT
                                    IF NOT DetailedGSTLedgerEntry3."Item Charge Entry" THEN BEGIN
                                        IF LineNo1 <> DetailedGSTLedgerEntry2."Document Line No." THEN
                                            CESSAmount += ABS(DetailedGSTLedgerEntry3."GST Amount");
                                        LineNo1 := DetailedGSTLedgerEntry2."Document Line No.";
                                    END ELSE BEGIN
                                        IF ItemChargeLineNoCess <> DetailedGSTLedgerEntry2."Item Charge Assgn. Line No." THEN
                                            CESSAmount += ABS(DetailedGSTLedgerEntry3."GST Amount");
                                        ItemChargeLineNoCess := DetailedGSTLedgerEntry2."Item Charge Assgn. Line No.";
                                    END;
                                UNTIL DetailedGSTLedgerEntry3.NEXT = 0;
                        UNTIL DetailedGSTLedgerEntry2.NEXT = 0;
                UNTIL GSTComponent.NEXT = 0;
        end;

        procedure GetBaseAmount(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry") BaseAmount: Decimal;
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            LineNo: Integer;
        begin
            WITH DetailedGSTLedgerEntry1 DO BEGIN
                RESET;
                SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
                SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
                SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                IF FINDSET THEN
                    REPEAT
                        IF LineNo <> "Document Line No." THEN
                            BaseAmount += ABS("GST Base Amount");
                        LineNo := "Document Line No.";
                    UNTIL NEXT = 0;
            END;
            EXIT(BaseAmount);
        end;

        procedure GetGSTAmount(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry") GSTAmount: Decimal;
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
        begin
            WITH DetailedGSTLedgerEntry1 DO BEGIN
                RESET;
                SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type");
                SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
                SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
                IF FINDSET THEN
                    REPEAT
                        GSTAmount += ABS("GST Amount");
                    UNTIL NEXT = 0;
            END;
            EXIT(GSTAmount);
        end;

        local procedure GetReturnReasonCode(DocumentNo: Code[20]): Text[250];
        var
            SalesCrMemoLine: Record 115;
            ReturnReason: Record 6635;
        begin
            SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
            IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                ReturnReason.SETRANGE(Code, SalesCrMemoLine."Return Reason Code");
                IF ReturnReason.FINDFIRST THEN
                    EXIT(FORMAT(ReturnReason."GST Reporting Reason Code"));
            END;
        end;

        local procedure GetExitPoint(DocumentNo: Code[20]): Code[10];
        var
            SalesInvoiceHeader: Record 112;
        begin
            SalesInvoiceHeader.GET(DocumentNo);
            EXIT(SalesInvoiceHeader."Exit Point");
        end;

        local procedure GetApplicationRemAmt(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry");
        var
            GSTComponent: Record 18202;
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            DetailedGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
            DetailedGSTLedgerEntry3: Record "Detailed GST Ledger Entry";
            DocumentNo: Code[20];
            DocumentNo1: Code[20];
            LineNo: Integer;
        begin
            DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::Application);
            DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
            DetailedGSTLedgerEntry1.SETRANGE(UnApplied, FALSE);
            DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF DetailedGSTLedgerEntry1.FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                                THEN
                                    TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                            END ELSE BEGIN
                                IF LineNo <> DetailedGSTLedgerEntry1."Document Line No." THEN
                                    TotalBaseAmountApp += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            END;
                UNTIL DetailedGSTLedgerEntry1.NEXT = 0;

            GSTComponent.RESET;
            GSTComponent.SETRANGE("Report View", GSTComponent."Report View"::CESS);
            IF GSTComponent.FINDSET THEN
                REPEAT
                    DetailedGSTLedgerEntry.SETCURRENTKEY(
                      "Location  Reg. No.", "Posting Date", "Entry Type", "Transaction Type", "Document Type", "Buyer/Seller State Code", "GST %");
                    DetailedGSTLedgerEntry2.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
                    DetailedGSTLedgerEntry2.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                    DetailedGSTLedgerEntry2.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                    DetailedGSTLedgerEntry2.SETRANGE("Transaction Type", DetailedGSTLedgerEntry2."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry2.SETRANGE("Document Type", DetailedGSTLedgerEntry2."Document Type"::Invoice);
                    DetailedGSTLedgerEntry2.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
                    DetailedGSTLedgerEntry2.SETRANGE("GST Jurisdiction Type", DetailedGSTLedgerEntry."GST Jurisdiction Type");
                    DetailedGSTLedgerEntry2.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
                    DetailedGSTLedgerEntry2.SETFILTER("GST Component Code", '<>%1', GSTComponent.Code);
                    DetailedGSTLedgerEntry2.SETRANGE(Reversed, FALSE);
                    DetailedGSTLedgerEntry2.SETRANGE(UnApplied, FALSE);
                    IF DetailedGSTLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF DocumentNo1 <> DetailedGSTLedgerEntry2."Application Doc. No" THEN BEGIN
                                DetailedGSTLedgerEntry3.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry2."Location  Reg. No.");
                                DetailedGSTLedgerEntry3.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
                                DetailedGSTLedgerEntry3.SETRANGE("Entry Type", DetailedGSTLedgerEntry2."Entry Type"::Application);
                                DetailedGSTLedgerEntry3.SETRANGE("Application Doc. No", DetailedGSTLedgerEntry2."Application Doc. No");
                                DetailedGSTLedgerEntry3.SETRANGE(Reversed, FALSE);
                                DetailedGSTLedgerEntry3.SETRANGE(UnApplied, FALSE);
                                DetailedGSTLedgerEntry3.SETRANGE("GST Component Code", GSTComponent.Code);
                                IF DetailedGSTLedgerEntry3.FINDSET THEN
                                    REPEAT
                                        CESSAmountApp += ABS(DetailedGSTLedgerEntry3."GST Amount");
                                    UNTIL DetailedGSTLedgerEntry3.NEXT = 0;
                            END;
                            IF CESSAmountApp <> 0 THEN
                                DocumentNo1 := DetailedGSTLedgerEntry2."Application Doc. No";
                        UNTIL DetailedGSTLedgerEntry2.NEXT = 0;
                UNTIL GSTComponent.NEXT = 0;
        end;

        local procedure GetInvoiceType(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"): Text[50];
        begin
            CASE DetailedGSTLedgerEntry."GST Customer Type" OF
                DetailedGSTLedgerEntry."GST Customer Type"::Registered:
                    EXIT(RegularTxt);
                //CCIT-PRI
                DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development", DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit":
                    IF DetailedGSTLedgerEntry."GST Without Payment of Duty" THEN
                        EXIT(SEZWOPayTxt)
                    ELSE
                        EXIT(SEZWPayTxt);
                //CCIT-PRI
                DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export":
                    EXIT(DeemedExportTxt);
            END;
            IF DetailedGSTLedgerEntry."GST Vendor Type" = DetailedGSTLedgerEntry."GST Vendor Type"::Registered THEN
                EXIT(RegularTxt);
        end;

        local procedure CheckPreGST(DocType: Option " ",Payment,Invoice,"Credit Memo",,,,Refund; OriginalInvoiceNo: Code[20]; DocumentNo: Code[20]; ApplicationDocNo: Code[20]): Boolean;
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
        begin
            IF DocType = DocType::"Credit Memo" THEN BEGIN
                DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
                DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
                DetailedGSTLedgerEntry1.SETRANGE("Document No.", OriginalInvoiceNo);
                IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                    EXIT(FALSE);
                EXIT(TRUE);
            END;
            IF DocType = DocType::Invoice THEN BEGIN
                DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
                DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Invoice);
                DetailedGSTLedgerEntry1.SETRANGE("Document No.", DocumentNo);
                IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                    EXIT(FALSE);
                EXIT(TRUE);
            END;
            IF DocType = DocType::Refund THEN BEGIN
                DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry1."Entry Type"::"Initial Entry");
                DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry1."Document Type"::Payment);
                DetailedGSTLedgerEntry1.SETRANGE("Document No.", ApplicationDocNo);
                IF DetailedGSTLedgerEntry1.FINDFIRST THEN
                    EXIT(FALSE);
                EXIT(TRUE);
            END;
        end;

        local procedure GetURType(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"): Text[50];
        begin
            CASE DetailedGSTLedgerEntry."GST Customer Type" OF
                DetailedGSTLedgerEntry."GST Customer Type"::Unregistered:
                    EXIT(B2CLTxt);
                DetailedGSTLedgerEntry."GST Customer Type"::Export,
                DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export":
                    BEGIN
                        IF DetailedGSTLedgerEntry."GST Without Payment of Duty" THEN
                            EXIT(UPPERCASE(EXPWOPayTxt));
                        EXIT(UPPERCASE(EXPWPayTxt));
                    END;
            END;
        end;

        local procedure GetGSTPlaceWiseValues(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry");
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            GSTComponent: Record 18202;
            LineNo: Integer;
            c: Integer;
            DocumentNo: Code[20];
            OriginalInvoiceNo: Code[20];
            ItemChargeAssgntLineNo: Integer;
        begin
            DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry1.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry1.SETRANGE("Nature of Supply", DetailedGSTLedgerEntry."Nature of Supply"::B2C);
            DetailedGSTLedgerEntry1.SETRANGE("GST Customer Type", DetailedGSTLedgerEntry."GST Customer Type"::Unregistered);
            DetailedGSTLedgerEntry1.SETRANGE("e-Comm. Operator GST Reg. No.", DetailedGSTLedgerEntry."e-Comm. Operator GST Reg. No.");
            DetailedGSTLedgerEntry1.SETRANGE("Buyer/Seller State Code", DetailedGSTLedgerEntry."Buyer/Seller State Code");
            DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF DetailedGSTLedgerEntry1.FINDSET THEN
                REPEAT
                    IF ((DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Interstate) AND
                        (GetInvoiceValue(DetailedGSTLedgerEntry1."Document No.", DetailedGSTLedgerEntry1."Document Type", DetailedGSTLedgerEntry1."Original Doc. Type", DetailedGSTLedgerEntry1."Original Doc. No.") <= 250000)) OR
                       (DetailedGSTLedgerEntry1."GST Jurisdiction Type" = DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate)
                    THEN BEGIN
                        GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                        IF GSTComponent.FINDFIRST THEN
                            IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                                IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                                   DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                                THEN BEGIN
                                    IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                       (LineNo <> DetailedGSTLedgerEntry1."Document Line No.") OR
                                       (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                       (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                    THEN BEGIN
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                        c += 1;
                                    END;
                                    GSTPer += DetailedGSTLedgerEntry1."GST %";
                                    DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                    LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                                    OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                    ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                                END ELSE BEGIN
                                    IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                       (OriginalInvoiceNo <> DetailedGSTLedgerEntry1."Original Invoice No.") OR
                                       (ItemChargeAssgntLineNo <> DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.")
                                    THEN BEGIN
                                        GSTPer := DetailedGSTLedgerEntry1."GST %";
                                        TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                        CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    END;
                                    DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                    OriginalInvoiceNo := DetailedGSTLedgerEntry1."Original Invoice No.";
                                    ItemChargeAssgntLineNo := DetailedGSTLedgerEntry1."Item Charge Assgn. Line No.";
                                END;
                    END;
                UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
            IF c > 1 THEN
                GSTPer := GSTPer / c;
        end;

        local procedure GetComponentValueAdvPayment(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry");
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            GSTComponent: Record 18202;
            LineNo: Integer;
            DocumentNo: Code[20];
            c: Integer;
        begin
            DetailedGSTLedgerEntry1.SETRANGE("Location  Reg. No.", DetailedGSTLedgerEntry."Location  Reg. No.");
            DetailedGSTLedgerEntry1.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry1.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type");
            DetailedGSTLedgerEntry1.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type");
            DetailedGSTLedgerEntry1.SETRANGE(Reversed, FALSE);
            DetailedGSTLedgerEntry1.SETRANGE("GST on Advance Payment", TRUE);
            DetailedGSTLedgerEntry1.SETRANGE("GST %", DetailedGSTLedgerEntry."GST %");
            IF DetailedGSTLedgerEntry1.FINDSET THEN
                REPEAT
                    GSTComponent.SETRANGE(Code, DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent.FINDFIRST THEN
                        IF GSTComponent."Report View" <> GSTComponent."Report View"::CESS THEN
                            IF DetailedGSTLedgerEntry1."GST Jurisdiction Type" =
                               DetailedGSTLedgerEntry1."GST Jurisdiction Type"::Intrastate
                            THEN BEGIN
                                IF (DocumentNo <> DetailedGSTLedgerEntry1."Document No.") OR
                                   (LineNo <> DetailedGSTLedgerEntry1."Document Line No.")
                                THEN BEGIN
                                    TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                    CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                                    c += 1;
                                END;
                                GSTPer += DetailedGSTLedgerEntry1."GST %";
                                DocumentNo := DetailedGSTLedgerEntry1."Document No.";
                                LineNo := DetailedGSTLedgerEntry1."Document Line No.";
                            END ELSE BEGIN
                                GSTPer := DetailedGSTLedgerEntry1."GST %";
                                TotalBaseAmount += ABS(DetailedGSTLedgerEntry1."GST Base Amount");
                                CESSAmount += GetCessAmount(DetailedGSTLedgerEntry1);
                            END;
                UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
            IF c > 1 THEN
                GSTPer := GSTPer / c;
        end;

        local procedure GetGSTAmountComp(HSNSACCode: Code[8]; UOMCode: Code[10]; ReportView: Option; Base: Boolean; Qty: Boolean): Decimal;
        var
            GSTComponent: Record 18202;
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
            GSTAmount: Decimal;
            DocumentNo: Code[20];
            LineNo: Integer;
            OriginalInvoiceNo: Code[20];
            ItemChargesAssgnLineNo: Integer;
        begin
            DetailedGSTLedgerEntry.SETCURRENTKEY(
              "Location  Reg. No.", "Posting Date", "Entry Type", "Transaction Type", "Document Type",
              "HSN/SAC Code", UOM, "Document No.", "Document Line No.");
            DetailedGSTLedgerEntry.SETRANGE("Location  Reg. No.", GSTIN);
            DetailedGSTLedgerEntry.SETRANGE("Posting Date", DMY2DATE(1, Month, Year), CALCDATE('<1M - 1D>', DMY2DATE(1, Month, Year)));
            DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
            DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
            DetailedGSTLedgerEntry.SETRANGE("Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
            DetailedGSTLedgerEntry.SETRANGE("HSN/SAC Code", HSNSACCode);
            DetailedGSTLedgerEntry.SETRANGE(UOM, UOMCode);
            IF DetailedGSTLedgerEntry.FINDSET THEN
                REPEAT
                    IF Base OR Qty THEN BEGIN //CCIT-PRI- Added BEGIN-END
                        IF (DocumentNo <> DetailedGSTLedgerEntry."Document No.") OR
                           (LineNo <> DetailedGSTLedgerEntry."Document Line No.") OR
                           (OriginalInvoiceNo <> DetailedGSTLedgerEntry."Original Invoice No.") OR
                           (ItemChargesAssgnLineNo <> DetailedGSTLedgerEntry."Item Charge Assgn. Line No.")
                        THEN BEGIN
                            IF Base THEN
                                GSTAmount += DetailedGSTLedgerEntry."GST Base Amount"
                            ELSE
                                IF Qty THEN
                                    GSTAmount += DetailedGSTLedgerEntry.Quantity;
                        END;
                    END ELSE BEGIN
                        IF GSTComponent.GET(DetailedGSTLedgerEntry."GST Component Code") THEN
                            IF GSTComponent."Report View" = ReportView THEN
                                GSTAmount += DetailedGSTLedgerEntry."GST Amount";
                    END;
                    DocumentNo := DetailedGSTLedgerEntry."Document No.";
                    LineNo := DetailedGSTLedgerEntry."Document Line No.";
                    OriginalInvoiceNo := DetailedGSTLedgerEntry."Original Invoice No.";
                    ItemChargesAssgnLineNo := DetailedGSTLedgerEntry."Item Charge Assgn. Line No.";
                UNTIL DetailedGSTLedgerEntry.NEXT = 0;
            EXIT(GSTAmount);
        end;

        local procedure ClearHSNInfo();
        begin
            CLEAR(GSTBaseAmount);
            CLEAR(HSNIGSTAmt);
            CLEAR(HSNCGSTAmt);
            CLEAR(HSNSGSTAmt);
            CLEAR(HSNCessAmt);
            CLEAR(HSNQty);
        end;

        local procedure GetCessAmount(DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"): Decimal;
        var
            DetailedGSTLedgerEntry1: Record "Detailed GST Ledger Entry";
            GSTComponent: Record 18202;
            DocCessAmount: Decimal;
        begin
            DetailedGSTLedgerEntry1.SETRANGE("Document No.", DetailedGSTLedgerEntry."Document No.");
            DetailedGSTLedgerEntry1.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
            IF DetailedGSTLedgerEntry1.FINDSET THEN
                REPEAT
                    GSTComponent.GET(DetailedGSTLedgerEntry1."GST Component Code");
                    IF GSTComponent."Report View" = GSTComponent."Report View"::CESS THEN
                        DocCessAmount += ABS(DetailedGSTLedgerEntry1."GST Amount");
                UNTIL DetailedGSTLedgerEntry1.NEXT = 0;
            EXIT(DocCessAmount);
        end;

        local procedure GetInvoiceValue(DocumentNo: Code[20]; DocumentType: Option " ",Payment,Invoice,"Credit Memo",,,,Refund; OriginalDocType: Option " ",Payment,Invoice,"Credit Memo",Transfer,"Finance Charge Memo",Reminder,Refund,"Transfer Shipment","Transfer Receipt"; OriginalDocNo: Code[20]) GSTAmt: Decimal;
        var
            CustLedgerEntry: Record 21;
            RecTransShipLine: Record 5745;
        begin
            //CCIT-PRI
            IF OriginalDocType = OriginalDocType::"Transfer Shipment" THEN BEGIN

                RecTransShipLine.RESET;
                RecTransShipLine.SETFILTER(RecTransShipLine.Quantity, '<>%1', 0);
                RecTransShipLine.SETRANGE(RecTransShipLine."Transfer Order No.", OriginalDocNo);
                IF RecTransShipLine.FINDFIRST THEN
                    REPEAT
                        GSTAmt += RecTransShipLine."GST Base Amount" + RecTransShipLine."Total GST Amount";
                    UNTIL RecTransShipLine.NEXT = 0;
            END ELSE BEGIN  //CCIT-PRI
                CustLedgerEntry.SETRANGE("Document Type", DocumentType);
                CustLedgerEntry.SETRANGE("Document No.", DocumentNo);
                IF CustLedgerEntry.FINDFIRST THEN BEGIN
                    CustLedgerEntry.CALCFIELDS("Amount (LCY)");
                    GSTAmt := CustLedgerEntry."Amount (LCY)";
                END;
            END;
            EXIT(ABS(GSTAmt));
        end;

        local procedure GetGSTPaymentOfDuty(DocumentNo: Code[20]): Boolean;
        var
            DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        begin
            DetailedGSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
            IF DetailedGSTLedgerEntry.FINDFIRST THEN
                EXIT(DetailedGSTLedgerEntry."GST Without Payment of Duty");
        end;

        local procedure CheckComponentReportView(ComponentCode: Code[10]);
        var
            GSTComponent: Record 18202;
        begin
            GSTComponent.GET(ComponentCode);
            GSTComponent.TESTFIELD("Report View");
        end;
        */
}

