report 50050 "Trial Balance New"
{
    // version CCIt

    DefaultLayout = RDLC;
    RDLCLayout = 'src/reportlayout/Trial Balance New.rdl';
    Caption = 'Trial Balance';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Credit Amount", "Debit Amount";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompInfo_Address_3; '')
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TABLECAPTION + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FIELDCAPTION("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(G_L_Account___Opening_Caption; G_L_Account___Opening_CaptionLbl)
            {
            }
            column(G_L_Account___Opening_Control7Caption; G_L_Account___Opening_Control7CaptionLbl)
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change")
                {
                }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date")
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; FORMAT("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                column(GLAcc_Balance_at_Date; GLAcc."Balance at Date")
                {
                }
                column(GLAcc_Balance_at_Date_Control7; -GLAcc."Balance at Date")
                {
                }
                column(GTotalOpnDebit; GTotalOpnDebit)
                {
                }
                column(GTotalOpnCredit; GTotalOpnCredit)
                {
                }
                column(GTotalNetDebit; GTotalNetDebit)
                {
                }
                column(GTotalNetCredit; GTotalNetCredit)
                {
                }
                column(GTotalClosingDebit; GTotalClosingDebit)
                {
                }
                column(GTotalClosingCredit; GTotalClosingCredit)
                {
                }
                column(GL_Account_Debit_Amount; "G/L Account"."Debit Amount")
                {
                }
                column(GL_Account_Credit_Amount; "G/L Account"."Credit Amount")
                {
                }
                column(TotalCredit; TotalCredit)
                {
                }
                column(TotalDebit; TotalDebit)
                {
                }
                column(TotalNetChange; TotalNetChange)
                {
                }
                column(GLAccount_ArabicDescription; '')
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF ShowBal THEN BEGIN
                        IF (GLAcc."Balance at Date" = 0) AND ("G/L Account"."Net Change" = 0) AND ("G/L Account"."Balance at Date" = 0) THEN
                            CurrReport.SKIP;
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CALCFIELDS("Net Change", "Balance at Date", "Credit Amount", "Debit Amount");

                GLAcc.RESET;
                GLAcc.SETRANGE("No.", "G/L Account"."No.");
                GLAcc.SETFILTER("Date Filter", '%1..%2', 0D, "G/L Account".GETRANGEMIN("Date Filter") - 1);
                IF GLAcc.FINDFIRST THEN
                    GLAcc.CALCFIELDS(GLAcc."Balance at Date");


                IF "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting THEN BEGIN
                    //opn Total
                    IF GLAcc."Balance at Date" > 0 THEN
                        GTotalOpnDebit += ABS(GLAcc."Balance at Date")
                    ELSE
                        GTotalOpnCredit += ABS(GLAcc."Balance at Date");

                    //Net Change Total
                    IF "G/L Account"."Net Change" > 0 THEN
                        GTotalNetDebit += ABS("G/L Account"."Net Change")
                    ELSE
                        GTotalNetCredit += ABS("G/L Account"."Net Change");

                    TotalCredit += ABS("G/L Account"."Credit Amount");
                    TotalDebit += "G/L Account"."Debit Amount";
                    TotalNetChange += "G/L Account"."Net Change";

                    //Closing total
                    IF "G/L Account"."Balance at Date" > 0 THEN
                        GTotalClosingDebit += ABS("G/L Account"."Balance at Date")
                    ELSE
                        GTotalClosingCredit += ABS("G/L Account"."Balance at Date");

                END;


                IF PrintToExcel THEN
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
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
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                    field("Show Only Having Balances"; ShowBal)
                    {
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
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        GLFilter := "G/L Account".GETFILTERS;
        PeriodText := "G/L Account".GETFILTER("Date Filter");
        IF PrintToExcel THEN
            MakeExcelInfo;
    end;

    var
        Text000: Label 'Period: %1';
        ExcelBuf: Record 370 temporary;
        GLFilter: Text[250];
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: Label 'Trial Balance';
        Text002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        Trial_BalanceCaptionLbl: Label 'Trial Balance';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Net_ChangeCaptionLbl: Label 'Net Change';
        BalanceCaptionLbl: Label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name';
        G_L_Account___Net_Change_CaptionLbl: Label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: Label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: Label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: Label 'Credit';
        GLAcc: Record 15;
        G_L_Account___Opening_CaptionLbl: Label 'Debit';
        G_L_Account___Opening_Control7CaptionLbl: Label 'Credit';
        CompInfo: Record 79;
        ShowBal: Boolean;
        GTotalOpnDebit: Decimal;
        GTotalOpnCredit: Decimal;
        GTotalNetDebit: Decimal;
        GTotalNetCredit: Decimal;
        GTotalClosingDebit: Decimal;
        GTotalClosingCredit: Decimal;
        TotalCredit: Decimal;
        TotalDebit: Decimal;
        TotalNetChange: Decimal;

    procedure MakeExcelInfo();
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text005), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text007), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text001), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text006), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Inventory Planning - Branch", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text008), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text009), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text010), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("No."), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text011), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("Date Filter"), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuf.AddColumn("G/L Account".FIELDCAPTION("No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("G/L Account".FIELDCAPTION(Name), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT('Opening' + ' - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT('Opening' + ' - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Net Change") + ' - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Net Change") + ' - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //added>
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Net Change")), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //added<

        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Balance at Date") + ' - ' + Text003), FALSE, '', TRUE, FALSE, TRUE, '',
          ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(
          FORMAT("G/L Account".FIELDCAPTION("Balance at Date") + ' - ' + Text004), FALSE, '', TRUE, FALSE, TRUE, '',
          ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody();
    var
        BlankFiller: Text[250];
    begin
        IF ShowBal THEN BEGIN
            IF (GLAcc."Balance at Date" = 0) AND ("G/L Account"."Net Change" = 0) AND ("G/L Account"."Balance at Date" = 0) THEN
                CurrReport.SKIP;
        END;

        BlankFiller := PADSTR(' ', MAXSTRLEN(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
          ExcelBuf."Cell Type"::Text);
        IF "G/L Account".Indentation = 0 THEN
            ExcelBuf.AddColumn(
              "G/L Account".Name, FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
              ExcelBuf."Cell Type"::Text)
        ELSE
            ExcelBuf.AddColumn(
              COPYSTR(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        CASE TRUE OF
            //opening
            GLAcc."Balance at Date" = 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      '', FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(
                      '', FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                END;
            GLAcc."Balance at Date" > 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      GLAcc."Balance at Date", FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting,
                      FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(
                      '', FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                END;
            GLAcc."Balance at Date" < 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      '', FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(
                      -GLAcc."Balance at Date", FALSE, '', GLAcc."Account Type" <> GLAcc."Account Type"::Posting,
                      FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
                END;
        END;
        //opening

        ExcelBuf.AddColumn(
          "G/L Account"."Debit Amount", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
          FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(
        //  "G/L Account"."Debit Amount",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
        // ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          ABS("G/L Account"."Credit Amount"), FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
          FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(
        // ABS("G/L Account"."Credit Amount"),FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
        // ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          "G/L Account"."Net Change", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
          FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(
        //"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
        //ExcelBuf."Cell Type"::Text);

        /*
        CASE TRUE OF
          "G/L Account"."Net Change" = 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" > 0:
            BEGIN
              ExcelBuf.AddColumn(
                "G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" < 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        */
        CASE TRUE OF
            "G/L Account"."Balance at Date" = 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      '', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(
                      '', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                END;
            "G/L Account"."Balance at Date" > 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      "G/L Account"."Balance at Date", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(
                      '', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                END;
            "G/L Account"."Balance at Date" < 0:
                BEGIN
                    ExcelBuf.AddColumn(
                      '', FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, FALSE, FALSE, '',
                      ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(
                      -"G/L Account"."Balance at Date", FALSE, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
                END;
        END;

    end;

    procedure CreateExcelbook();
    begin
        ExcelBuf.CreateBookAndOpenExcel(Text001, Text002, Text001, COMPANYNAME, USERID);
        //ExcelBuf.CreateBookAndOpenExcel('', Text001, '', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
        ERROR('');
    end;
}

