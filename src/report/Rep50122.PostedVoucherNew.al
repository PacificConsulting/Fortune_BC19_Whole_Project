report 50122 "Posted Voucher New"
{
    // version TFS225977

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Posted Voucher New.rdl';
    Caption = 'Posted Voucher';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date", Amount)
                                ORDER(Descending);
            RequestFilterFields = "Posting Date", "Document No.";
            column(VoucherSourceDesc; SourceDesc + ' Voucher')
            {
            }
            column(DocumentNo_GLEntry; "Document No.")
            {
            }
            column(PostingDateFormatted; 'Date: ' + FORMAT("Posting Date"))
            {
            }
            column(CompanyInformationAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
            {
            }
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(CreditAmount_GLEntry; "Credit Amount")
            {
            }
            column(DebitAmount_GLEntry; "Debit Amount")
            {
            }
            column(DrText; DrText)
            {
            }
            column(GLAccName; GLAccName)
            {
            }
            column(CrText; CrText)
            {
            }
            column(DebitAmountTotal; DebitAmountTotal)
            {
            }
            column(CreditAmountTotal; CreditAmountTotal)
            {
            }
            column(ChequeDetail; 'Cheque No: ' + ChequeNo + '  Dated: ' + FORMAT(ChequeDate))
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(ChequeDate; ChequeDate)
            {
            }
            column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
            {
            }
            column(EntryNo_GLEntry; "Entry No.")
            {
            }
            column(PostingDate_GLEntry; "Posting Date")
            {
            }
            column(TransactionNo_GLEntry; "Transaction No.")
            {
            }
            column(VoucherNoCaption; VoucherNoCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(ParticularsCaption; ParticularsCaptionLbl)
            {
            }
            column(AmountInWordsCaption; AmountInWordsCaptionLbl)
            {
            }
            column(PreparedByCaption; PreparedByCaptionLbl)
            {
            }
            column(CheckedByCaption; CheckedByCaptionLbl)
            {
            }
            column(ApprovedByCaption; ApprovedByCaptionLbl)
            {
            }
            column(GlobalDimension1Code_Branch_GLEntry; "G/L Entry"."Global Dimension 1 Code")
            {
            }
            column(PurchComment; PurchComment)
            {
            }
            column(SrNoCaption; SrNoCaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(InvNoCaption; InvNoCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(InvAmtCaption; InvAmtCaptionLbl)
            {
            }
            column(TDSAmtCaption; TDSAmtCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(SourceType_GLEntry; "G/L Entry"."Source Type")
            {
            }
            column(SourceNo_GLEntry; "G/L Entry"."Source No.")
            {
            }
            column(Srno; Srno)
            {
            }
            column(PayDocNo; DocNo)
            {
            }
            column(PayInvNo; InvNo)
            {
            }
            column(PayDate; FORMAT(Date))
            {
            }
            column(PayInvAmt; InvAmt)
            {
            }
            column(PayTDSAmt; TDSAmt)
            {
            }
            column(PayAmt; Amt)
            {
            }
            dataitem("<Cust. Ledger Entry>"; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Document No."),
                               "Source Code" = FIELD("Source Code"),
                               "Entry No." = FIELD("Entry No.");
                column(EntryNo_CustLedgerEntryIN; AppliedExterdocnocust)
                {
                }
                column(PostingDate_CustLedgerEntryIN; AppliedDatecust)
                {
                }
                column(DocumentNo_CustLedgerEntryIN; AppDocumentNocust)
                {
                }
                column(Amount_CustLedgerEntryIN; AppliedAmtcust)
                {
                }
                column(AppliestoDocNo_CustLedgerEntryIN; AppDocumentNocust)
                {
                }
                column(TotalTDSTCSInclSHECESS_CustLedgerEntryIN; AppliedTotalamtcust)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    RECCustDetldLedgerEntry.RESET();
                    RECCustDetldLedgerEntry.SETRANGE(RECCustDetldLedgerEntry."Document No.", "<Cust. Ledger Entry>"."Document No.");
                    RECCustDetldLedgerEntry.SETRANGE("Entry Type", RECCustDetldLedgerEntry."Entry Type"::Application);
                    IF RECCustDetldLedgerEntry.FIND('-') THEN BEGIN
                        REPEAT
                            RECCustDetldLedgerEntry1.RESET();
                            RECCustDetldLedgerEntry1.SETRANGE(RECCustDetldLedgerEntry1."Cust. Ledger Entry No.", RECCustDetldLedgerEntry."Cust. Ledger Entry No.");
                            RECCustDetldLedgerEntry1.SETFILTER(RECCustDetldLedgerEntry1."Document Type", '<>%1', RECCustDetldLedgerEntry1."Document Type"::Payment);
                            IF RECCustDetldLedgerEntry1.FINDFIRST() THEN BEGIN
                                AppDocumentNocust := RECCustDetldLedgerEntry1."Document No.";
                                AppliedAmtcust := RECCustDetldLedgerEntry1.Amount;
                                AppliedDatecust := RECCustDetldLedgerEntry1."Posting Date";
                                RECLE.RESET();
                                RECLE.SETRANGE(RECLE."Document No.", RECCustDetldLedgerEntry1."Document No.");
                                IF RECLE.FINDFIRST THEN BEGIN
                                    AppliedExterdocnocust := RECLE."External Document No.";
                                    AppliedTotalamtcust := 0; //PCPL/MIG/NSW RECLE."Total TDS/TCS Incl SHE CESS"; Field Not Avail in BC18
                                                              // MESSAGE(RECLE."External Document No.");
                                END;
                            END;
                        UNTIL RECCustDetldLedgerEntry.NEXT = 0;
                    END;
                end;
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Document No."),
                               "Source Code" = FIELD("Source Code"),
                               "Entry No." = FIELD("Entry No.");
                column(EntryNo_VendorLedgerEntryIN; AppliedExterdocno)
                {
                }
                column(PostingDate_VendorLedgerEntryIN; AppliedDate)
                {
                }
                column(DocumentNo_VendorLedgerEntryIN; AppDocumentNo)
                {
                }
                column(Amount_VendorLedgerEntryIN; AppliedAmt)
                {
                }
                column(TotalTDSIncludingSHECESS_VendorLedgerEntryIN; AppliedTotalamt)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    RECDetldLedgerEntry.RESET();
                    RECDetldLedgerEntry.SETRANGE(RECDetldLedgerEntry."Document No.", "Vendor Ledger Entry"."Document No.");
                    RECDetldLedgerEntry.SETRANGE("Entry Type", RECDetldLedgerEntry."Entry Type"::Application);
                    IF RECDetldLedgerEntry.FIND('-') THEN BEGIN
                        REPEAT
                            RECDetldLedgerEntry1.RESET();
                            RECDetldLedgerEntry1.SETRANGE(RECDetldLedgerEntry1."Vendor Ledger Entry No.", RECDetldLedgerEntry."Vendor Ledger Entry No.");
                            RECDetldLedgerEntry1.SETFILTER(RECDetldLedgerEntry1."Document Type", '<>%1', RECDetldLedgerEntry1."Document Type"::Payment);
                            IF RECDetldLedgerEntry1.FINDFIRST() THEN BEGIN
                                AppDocumentNo := RECDetldLedgerEntry1."Document No.";
                                AppliedAmt := RECDetldLedgerEntry1.Amount;
                                AppliedDate := RECDetldLedgerEntry1."Posting Date";
                                RECVLE.RESET();
                                RECVLE.SETRANGE(RECVLE."Document No.", RECDetldLedgerEntry1."Document No.");
                                IF RECVLE.FINDFIRST THEN BEGIN
                                    AppliedExterdocno := RECVLE."External Document No.";
                                    AppliedTotalamt := RECVLE."Total TDS Including SHE CESS";
                                    MESSAGE(RECVLE."External Document No.");
                                END;
                            END;
                        UNTIL RECDetldLedgerEntry.NEXT = 0;
                    END;
                end;
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Document No." = FIELD("Document No."),
                               "Source Code" = FIELD("Source Code"),
                               "Entry No." = FIELD("Entry No.");
                dataitem("Bank Account Ledger Entry_IN"; "Bank Account Ledger Entry")
                {
                    column(EntryNo_BankAccountLedgerEntryIN; "Bank Account Ledger Entry_IN"."Entry No.")
                    {
                    }
                    column(PostingDate_BankAccountLedgerEntryIN; FORMAT("Bank Account Ledger Entry_IN"."Posting Date"))
                    {
                    }
                    column(DocumentNo_BankAccountLedgerEntryIN; "Bank Account Ledger Entry_IN"."Document No.")
                    {
                    }
                    column(Amount_BankAccountLedgerEntryIN; "Bank Account Ledger Entry_IN".Amount)
                    {
                    }
                }
            }
            dataitem(LineNarration; "Posted Narration")
            {
                DataItemLink = "Transaction No." = FIELD("Transaction No."),
                               "Entry No." = FIELD("Entry No.");
                DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.");
                column(Narration_LineNarration; Narration)
                {
                }
                column(PrintLineNarration; PrintLineNarration)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF PrintLineNarration THEN BEGIN
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    END;
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(IntegerOccurcesCaption; IntegerOccurcesCaptionLbl)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PageLoop := PageLoop - 1;
                end;

                trigger OnPreDataItem();
                begin
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                    GLEntry.ASCENDING(FALSE);
                    GLEntry.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                    GLEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                    GLEntry.FINDLAST;
                    IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                        CurrReport.BREAK;

                    SETRANGE(Number, 1, PageLoop)
                end;
            }
            dataitem(PostedNarration1; "Posted Narration")
            {
                DataItemLink = "Transaction No." = FIELD("Transaction No.");
                DataItemTableView = SORTING("Entry No.", "Transaction No.", "Line No.")
                                    WHERE("Entry No." = FILTER(0));
                column(Narration_PostedNarration1; Narration)
                {
                }
                column(NarrationCaption; NarrationCaptionLbl)
                {
                }

                trigger OnPreDataItem();
                begin
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                    GLEntry.ASCENDING(FALSE);
                    GLEntry.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
                    GLEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                    GLEntry.FINDLAST;
                    IF NOT (GLEntry."Entry No." = "G/L Entry"."Entry No.") THEN
                        CurrReport.BREAK;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                IF Amount < 0 THEN BEGIN
                    CrText := 'To';
                    DrText := '';
                END ELSE BEGIN
                    CrText := '';
                    DrText := 'Dr';
                END;

                SourceDesc := '';
                IF "Source Code" <> '' THEN BEGIN
                    SourceCode.GET("Source Code");
                    SourceDesc := SourceCode.Description;
                END;

                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;

                ChequeNo := '';
                ChequeDate := 0D;
                IF ("Source No." <> '') AND ("Source Type" = "Source Type"::"Bank Account") THEN BEGIN
                    IF BankAccLedgEntry.GET("Entry No.") THEN BEGIN
                        ChequeNo := BankAccLedgEntry."Cheque No.";
                        ChequeDate := BankAccLedgEntry."Cheque Date";
                    END;
                END;

                IF (ChequeNo <> '') AND (ChequeDate <> 0D) THEN BEGIN
                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;
                END;
                IF PostingDate <> "Posting Date" THEN BEGIN
                    PostingDate := "Posting Date";
                    TotalDebitAmt := 0;
                END;
                IF DocumentNo <> "Document No." THEN BEGIN
                    DocumentNo := "Document No.";
                    TotalDebitAmt := 0;
                END;

                IF PostingDate = "Posting Date" THEN BEGIN
                    InitTextVariable;
                    TotalDebitAmt += "Debit Amount";
                    FormatNoText(NumberText, ABS(TotalDebitAmt), '');
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                END;
                IF (PrePostingDate <> "Posting Date") OR (PreDocumentNo <> "Document No.") THEN BEGIN
                    DebitAmountTotal := 0;
                    CreditAmountTotal := 0;
                    PrePostingDate := "Posting Date";
                    PreDocumentNo := "Document No.";
                END;

                DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                CreditAmountTotal := CreditAmountTotal + "Credit Amount";
                CLEAR(PurchComment);
                PurchCommentLine.RESET();
                PurchCommentLine.SETRANGE(PurchCommentLine."No.", "Document No.");
                PurchCommentLine.SETRANGE("Document Type", PurchCommentLine."Document Type"::"Posted Invoice");
                IF PurchCommentLine.FIND('-') THEN BEGIN
                    PurchComment := PurchCommentLine.Comment;
                END;
                //CCIT AN
                //PaymentDetails("Source Type","Source No.");
            end;

            trigger OnPreDataItem();
            begin
                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
                Srno := 0;
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
                    Caption = 'Options';
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        Caption = 'PrintLineNarration';
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
        CompanyInformation.GET;
    end;

    var
        AppDocumentNocust: Code[20];
        RECCustDetldLedgerEntry: Record 379;
        RECCustDetldLedgerEntry1: Record 379;
        RECLE: Record 21;
        RECVLE: Record 25;
        AppliedExterdocnocust: Code[20];
        AppliedExterdocno: Code[20];
        AppliedTotalamtcust: Decimal;
        AppliedTotalamt: Decimal;
        AppDocumentNo: Code[20];
        AppliedAmtcust: Decimal;
        AppliedAmt: Decimal;
        AppliedDatecust: Date;
        AppliedDate: Date;
        RECDetldLedgerEntry1: Record 380;
        RECDetldLedgerEntry: Record 380;
        CompanyInformation: Record 79;
        SourceCode: Record 230;
        GLEntry: Record 17;
        BankAccLedgEntry: Record 271;
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array[2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        PrintLineNarration: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[50];
        VoucherNoCaptionLbl: Label 'Voucher No. :';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        ParticularsCaptionLbl: Label 'Particulars';
        AmountInWordsCaptionLbl: Label 'Amount (in words):';
        PreparedByCaptionLbl: Label 'Prepared by:';
        CheckedByCaptionLbl: Label 'Checked by:';
        ApprovedByCaptionLbl: Label 'Approved by:';
        IntegerOccurcesCaptionLbl: Label 'IntegerOccurces';
        NarrationCaptionLbl: Label 'Narration :';
        PurchCommentLine: Record 43;
        PurchComment: Text;
        SrNoCaptionLbl: Label 'Source Type';
        DocNoCaptionLbl: Label 'Document No.';
        InvNoCaptionLbl: Label 'Invoice No.';
        DateCaptionLbl: Label 'Date';
        InvAmtCaptionLbl: Label 'Invoice Amount';
        TDSAmtCaptionLbl: Label 'TDS Amount';
        AmountCaptionLbl: Label 'Amount Paid';
        DocNo: Code[20];
        InvNo: Code[20];
        Date: Date;
        InvAmt: Decimal;
        TDSAmt: Decimal;
        Amt: Decimal;
        Srno: Integer;

    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50];
    var
        AccName: Text[50];
        VendLedgerEntry: Record 25;
        Vend: Record 23;
        CustLedgerEntry: Record 21;
        Cust: Record 18;
        BankLedgerEntry: Record 271;
        Bank: Record 270;
        GLAccount: Record 15;
    begin
        IF "Source Type" = "Source Type"::Vendor THEN
            IF VendLedgerEntry.GET("Entry No.") THEN
                IF IsGSTDocument(VendLedgerEntry."Document Type", VendLedgerEntry."Document No.") THEN BEGIN
                    //CCIT-PRI-OriginalCodeCommented
                    /* GLAccount.GET("G/L Account No.");
                     AccName := GLAccount.Name;*/
                    //CCIT-PRI-OriginalCodeCommented
                    //CCIT-PRI-NewCode
                    Vend.GET("Source No.");
                    AccName := Vend.Name;
                    //CCIT-PRI-NewCode
                END ELSE BEGIN
                    Vend.GET("Source No.");
                    AccName := Vend.Name;
                END
            ELSE BEGIN
                GLAccount.GET("G/L Account No.");
                AccName := GLAccount.Name;
            END
        ELSE
            IF "Source Type" = "Source Type"::Customer THEN
                IF CustLedgerEntry.GET("Entry No.") THEN
                    IF IsGSTDocument(CustLedgerEntry."Document Type", CustLedgerEntry."Document No.") THEN BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END ELSE BEGIN
                        Cust.GET("Source No.");
                        AccName := Cust.Name;
                    END
                ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END
            ELSE
                IF "Source Type" = "Source Type"::"Bank Account" THEN
                    IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
                        Bank.GET("Source No.");
                        AccName := Bank.Name;
                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END
                ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount.Name;
        END;

        EXIT(AccName);

    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record 4;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description);  //Currency."Currency Numeric Description" Original code PCPL/MIG/NSW
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description + ' ONLY') //Currency."Currency Decimal Description" Original code PCPL/MIG/NSW
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text16529, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;

    procedure IsGSTDocument(DocumentType: Option; DocumentNo: Code[20]): Boolean;
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SETRANGE("Document No.", DocumentNo);
        IF DetailedGSTLedgerEntry.FINDFIRST THEN
            EXIT(TRUE);
        DetailedGSTLedgerEntry.SETRANGE("Document No.");
        DetailedGSTLedgerEntry.SETRANGE("Entry Type", DetailedGSTLedgerEntry."Entry Type"::Application);
        DetailedGSTLedgerEntry.SETRANGE("Application Doc. Type", DocumentType);
        DetailedGSTLedgerEntry.SETRANGE("Application Doc. No", DocumentNo);
        IF NOT DetailedGSTLedgerEntry.ISEMPTY THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    local procedure PaymentDetails("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Source No.": Code[20]);
    var
        RecVenderLedger: Record 25;
        RecCustLedgerEntry: Record 21;
        RecBankLedgerEntry: Record 271;
        RecSalesInvHeader: Record 112;
        RecSalesInvLine: Record 113;
        CustLedgerEntry: Record 21;
    begin
        //MESSAGE('1');
        //CCIT AN
        CLEAR(DocNo);
        CLEAR(InvNo);
        CLEAR(Date);
        CLEAR(InvAmt);
        CLEAR(TDSAmt);
        CLEAR(Amt);
        Srno := Srno + 1;
        IF "Source Type" = "Source Type"::Customer THEN BEGIN
            RecCustLedgerEntry.RESET;
            RecCustLedgerEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
            RecCustLedgerEntry.SETRANGE("Source Code", "G/L Entry"."Source Code");
            RecCustLedgerEntry.SETRANGE("Entry No.", "G/L Entry"."Entry No.");
            IF RecCustLedgerEntry.FINDSET THEN BEGIN
                //MESSAGE('%1',RecCustLedgerEntry."Document No.");
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Closed by Entry No.", RecCustLedgerEntry."Entry No.");
                IF CustLedgerEntry.FIND('-') THEN
                    REPEAT
                        //MESSAGE('inn %1',CustLedgerEntry."Document No.");
                        DocNo := CustLedgerEntry."Document No.";
                        InvNo := FORMAT(CustLedgerEntry."Entry No.");
                        Date := CustLedgerEntry."Posting Date";
                        CustLedgerEntry.CALCFIELDS(Amount);
                        InvAmt := CustLedgerEntry.Amount;
                        Amt := CustLedgerEntry.Amount
                    UNTIL CustLedgerEntry.NEXT = 0;
            END;
        END;
        /*IF("Source Type"="Source Type"::Vendor ) THEN
           BEGIN
               RecVenderLedger.RESET;
               RecVenderLedger.SETRANGE("Document No.","G/L Entry"."Document No.");
               RecVenderLedger.SETRANGE("Source Code","G/L Entry"."Source Code");
               RecVenderLedger.SETRANGE("Entry No.","G/L Entry"."Entry No.");
               IF RecVenderLedger.FINDSET THEN
                 BEGIN
                    DocNo := RecVenderLedger."Document No.";
                    InvNo := FORMAT(RecVenderLedger."Entry No.");   //InvNo := RecVenderLedger."External Document No.";
                    Date := RecVenderLedger."Posting Date";
                    RecVenderLedger.CALCFIELDS(Amount);
                    InvAmt := RecVenderLedger.Amount;
                    TDSAmt := RecVenderLedger."Total TDS Including SHE CESS";
                    RecVenderLedger.CALCFIELDS("Amount (LCY)");
                    Amt := RecVenderLedger."Amount (LCY)";
                END;
          END;*/
        /*IF "Source Type" = "Source Type"::"Bank Account" THEN
          BEGIN
                RecBankLedgerEntry.RESET;
                RecBankLedgerEntry.SETRANGE("Document No.","G/L Entry"."Document No.");
                RecBankLedgerEntry.SETRANGE("Source Code","G/L Entry"."Source Code");
                RecBankLedgerEntry.SETRANGE("Entry No.","G/L Entry"."Entry No.");
                IF RecBankLedgerEntry.FIND('-') THEN
                  BEGIN
                     DocNo := RecBankLedgerEntry."Document No.";
                     InvNo := FORMAT(RecBankLedgerEntry."Entry No.");
                     Date  := RecBankLedgerEntry."Posting Date";
                     RecBankLedgerEntry.CALCFIELDS(Amount);
                     InvAmt:= RecBankLedgerEntry.Amount;
                     //TDSAmt:= RecBankLedgerEntry.;
                     RecBankLedgerEntry.CALCFIELDS("Amount (LCY)");
                     Amt := RecBankLedgerEntry."Amount (LCY)";
                  END;
            END;
        */

    end;
}

