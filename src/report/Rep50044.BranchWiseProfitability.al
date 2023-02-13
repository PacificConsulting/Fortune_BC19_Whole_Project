report 50044 "Branch Wise Profitability"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;

    dataset
    {
        dataitem("Branch Master"; "Branch Master")
        {
            RequestFilterFields = "Code";

            trigger OnAfterGetRecord();
            begin

                //-------------------------------------
                /*IF (CurrLoc = 'FORTUNE BLANK') THEN BEGIN
                   CurrLoc := "Branch Master".Code;
                   I := 0;
                   ItemCounter := EntryCount(CurrLoc);
                   MESSAGE('%1',ItemCounter);
                END;
                I += 1;
                
                IF I = ItemCounter THEN BEGIN
                  MakeExcelDataBody(CurrLoc);
                  CurrItem := 'FORTUNE BLANK';
                  ItemCounter :=0;
                END;*/

            end;

            trigger OnPreDataItem();
            begin

                Locations := "Branch Master".GETFILTER("Branch Master".Code);

                MakeExcelDataHeader;
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
                group("Request Fields")
                {
                    field("From Date"; From_Date)
                    {
                    }
                    field("To Date"; To_Date)
                    {
                        Visible = true;
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

    trigger OnInitReport();
    begin
        CurrLoc := 'FORTUNE BLANK';
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        //MakeExcelDataHeader;

        //LocTotal := 0;
    end;

    var
        From_Date: Date;
        To_Date: Date;
        ExcelBuf: Record 370 temporary;
        Supplier: Text[50];
        RecVend: Record 23;
        TotalUseShelfLifeDays: Decimal;
        DaysToExpire: Decimal;
        ShelfLifePerAvailable: Decimal;
        ProductDesc: Text[100];
        RecItem: Record 27;
        RecILE: Record 32;
        RecILE33: Record 32;
        CurrLoc: Code[20];
        I: Integer;
        LocCount: Integer;
        Brand: Code[20];
        CurrItem: Code[20];
        RecLoc: Record 14;
        RecLocation: Record 14;
        GlobLoc: Text[100];
        RecILE2: Record 32;
        LocQty: Decimal;
        RecILE3: Record 32;
        RecILE4: Record 32;
        ItemTotal: Decimal;
        LocTotal: Decimal;
        LocTotal1: Decimal;
        LocCode: Code[20];
        LocQtyPCS: Decimal;
        Loc1: Code[10];
        Loc2: Code[10];
        Loc3: Code[10];
        RecItem2: Record 27;
        RecUOM: Record 5404;
        CostAmt_IN_RS: Decimal;
        Rec_AccType: Record 15;
        RecBranchTbl: Record 50028;
        Locations: Code[10];
        ItemCounter: Integer;
        CostAmt_IN_RS1: Decimal;
        LocQty1: Decimal;
        LocStr: Text[200];

    procedure CreateExcelBook();
    begin

        ExcelBuf.CreateBookAndOpenExcel('F:\Reports\BRANCH WISE PROFITABILITY.xlsx', 'BRANCH WISE PROFITABILITY', 'BRANCH WISE PROFITABILITY', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('BRANCH WISE PROFITABILITY', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Date :' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;

        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(RecBranchTbl.Code, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecBranchTbl.NEXT = 0;
        //-----------------------------------------
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                ExcelBuf.AddColumn('In Rs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('Per KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('% Sales', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            UNTIL RecBranchTbl.NEXT = 0;
        //------------------------------------------
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('SR No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Perticulars', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //ExcelBuf.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('I', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Volume (Kgs.)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Horeca_And_Retail_InRs_QtySum(RecBranchTbl.Code);
            UNTIL RecBranchTbl.NEXT = 0;
        //------------------------------ // HORECA
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Horeca', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Horeca_Qty(RecBranchTbl.Code);

            UNTIL RecBranchTbl.NEXT = 0;

        //-------------------------------- // RETAIL
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Retail ', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Retail_Qty(RecBranchTbl.Code);

            UNTIL RecBranchTbl.NEXT = 0;
        //----------------------------------- // Sales
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('II', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Horeca_And_Retail_InRs_ValueSum(RecBranchTbl.Code);
                LocationWise_Horeca_And_Retail_PerKG_Sum(RecBranchTbl.Code);
            UNTIL RecBranchTbl.NEXT = 0;

        //------------------------------------ // HORECA
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Horeca', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Horeca_Value(RecBranchTbl.Code);
                LocationWise_Horeca_Per_KG(RecBranchTbl.Code);
            UNTIL RecBranchTbl.NEXT = 0;
        //------------------------------------// Retail
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Retail ', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        RecBranchTbl.RESET;
        IF Locations <> '' THEN
            RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
        ELSE
            RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
        IF RecBranchTbl.FINDSET THEN
            REPEAT
                LocationWise_Retail_Value(RecBranchTbl.Code);
                LocationWise_Retail_Per_KG(RecBranchTbl.Code);
            UNTIL RecBranchTbl.NEXT = 0;
        //------------------------------------- // Landed Cost
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('III', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Landed Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //------------------------------------  // Horeca
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Horeca', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //------------------------------------  //Retail
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Retail ', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //-----------------------------------  Gross Profit
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('IV', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gross Profit', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //------------------------------------
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Horeca', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //------------------------------------
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Retail ', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //-------------------------------------  Chart of Account (Storage)
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('V', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        Account_Details('401600', '401699');

        //-------------------------------------  Chart of Account(Logistic - Primary)
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('VI', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Logistic - Primary', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        Account_Details('402000', '402999');
        ExcelBuf.NewRow;
        //--------------------------------------  Chart of Account(Selling Expenses)

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('VII', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Selling Expenses', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        Account_Details('404000', '404999');
        ExcelBuf.NewRow;
        //-------------------------------------  Chart of Account(Distribution Expenses)
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('VIII', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Distribution Expenses', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        Account_Details('403000', '403999');
        ExcelBuf.NewRow;
        //------------------------------------  Chart of Account(Administrative Expenses)

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('IX', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Administrative Expenses', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        Account_Details('502100', '502199');
        ExcelBuf.NewRow;
    end;

    procedure MakeExcelDataBody(CurrLoc: Code[10]);
    begin
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(LocCode: Code[20]): Integer;
    var
        RecBranchDetails: Record 50028;
    begin
        RecBranchDetails.RESET;
        RecBranchDetails.SETRANGE(RecBranchDetails.Code, LocCode);
        RecBranchDetails.SETRANGE(RecBranchDetails.Branch, TRUE);
        IF RecBranchDetails.FINDSET THEN
            EXIT(RecBranchDetails.COUNT);
    end;

    local procedure Location1(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
    begin
        ExcelBuf.AddColumn('In Rs', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Per KG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('% Sales', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure Location2(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
    begin
        //IF Branch_Loc.GET(Loc) THEN BEGIN

        IF "Branch Master".GET(Loc) THEN BEGIN
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(Loc, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        END;
    end;

    local procedure LocationWise_Horeca_Qty(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQtyPCS := 0;
                CostAmt_IN_RS := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(ABS(LocQty), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Retail_Qty(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQtyPCS := 0;
                CostAmt_IN_RS := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(ABS(LocQty), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure Account_Details(StartingAcc: Code[10]; EndingAcc: Code[10]);
    begin
        Rec_AccType.RESET;
        Rec_AccType.SETRANGE(Rec_AccType."No.", StartingAcc, EndingAcc);
        IF Rec_AccType.FINDSET THEN
            REPEAT
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Rec_AccType.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                IF Locations <> '' THEN
                    RecBranchTbl.SETFILTER(RecBranchTbl.Code, STRSUBSTNO('%1', Locations))
                ELSE
                    RecBranchTbl.SETRANGE(RecBranchTbl.Branch, TRUE);
                IF RecBranchTbl.FINDSET THEN
                    REPEAT
                        IF ExcelBuf."Column No." = 2 THEN BEGIN
                            //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn(ABS(ROUND((ABS(Account_Details_Amount1(Rec_AccType."No.", RecBranchTbl.Code))) / (LocationWise_Horeca_And_Retail_InRs_QtySum1(RecBranchTbl.Code)), 0.001)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        END
                        ELSE BEGIN
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                            IF Account_Details_Amount1(Rec_AccType."No.", RecBranchTbl.Code) <> 0 THEN
                                ExcelBuf.AddColumn(ABS(ROUND((ABS(Account_Details_Amount1(Rec_AccType."No.", RecBranchTbl.Code))) / (LocationWise_Horeca_And_Retail_InRs_QtySum1(RecBranchTbl.Code)), 0.001)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                        END
                    UNTIL RecBranchTbl.NEXT = 0;
            UNTIL Rec_AccType.NEXT = 0;

    end;

    local procedure LocationWise_Horeca_Value(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQtyPCS := 0;
                CostAmt_IN_RS := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(CostAmt_IN_RS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Retail_Value(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQtyPCS := 0;
                CostAmt_IN_RS := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(CostAmt_IN_RS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Horeca_Per_KG(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                CostAmt_IN_RS := 0;
                PerKG := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ABS(ROUND(PerKG, 0.001)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Retail_Per_KG(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                CostAmt_IN_RS := 0;
                PerKG := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                    END;
                                END;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ABS(ROUND(PerKG, 0.001)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Horeca_And_Retail_PerKG_Sum(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG1: Decimal;
        PerKG: Decimal;
        Total: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQty1 := 0;
                CostAmt_IN_RS := 0;
                CostAmt_IN_RS1 := 0;
                PerKG := 0;
                PerKG1 := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                        //Total :=
                                    END;
                                END;
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty1 := LocQty1 + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS1 := CostAmt_IN_RS1 + RecILE2."Sales Amount (Actual)";
                                        IF LocQty1 <> 0 THEN
                                            PerKG1 := CostAmt_IN_RS1 / LocQty1;
                                    END;
                                END;
                                Total := PerKG + PerKG1;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ABS(ROUND(Total, 0.001)), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Horeca_And_Retail_InRs_QtySum(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG1: Decimal;
        PerKG: Decimal;
        Total: Decimal;
        QtySum: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQty1 := 0;
                CostAmt_IN_RS := 0;
                CostAmt_IN_RS1 := 0;
                PerKG := 0;
                PerKG1 := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                        //Total :=
                                    END;
                                END;
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty1 := LocQty1 + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS1 := CostAmt_IN_RS1 + RecILE2."Sales Amount (Actual)";
                                        IF LocQty1 <> 0 THEN
                                            PerKG1 := CostAmt_IN_RS1 / LocQty1;
                                    END;
                                END;
                                QtySum := LocQty + LocQty1;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                ExcelBuf.AddColumn(ABS(ROUND(QtySum, 0.001)), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure LocationWise_Horeca_And_Retail_InRs_ValueSum(Loc: Code[10]);
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG1: Decimal;
        PerKG: Decimal;
        Total: Decimal;
        ValueSum: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQty1 := 0;
                CostAmt_IN_RS := 0;
                CostAmt_IN_RS1 := 0;
                PerKG := 0;
                PerKG1 := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                        //Total :=
                                    END;
                                END;
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty1 := LocQty1 + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS1 := CostAmt_IN_RS1 + RecILE2."Sales Amount (Actual)";
                                        IF LocQty1 <> 0 THEN
                                            PerKG1 := CostAmt_IN_RS1 / LocQty1;
                                    END;
                                END;
                                ValueSum := CostAmt_IN_RS + CostAmt_IN_RS1;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(ROUND(ValueSum, 0.001), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
            END;
        END;
    end;

    local procedure Account_Details_Amount(StartingAcc: Code[10]; EndingAcc: Code[10]; Loc: Code[10]) AccTotAmt: Decimal;
    var
        RecGLEntries: Record 17;
        AmtTotal: Decimal;
        Branch_Loc: Record 50028;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocStr := '';
                RecLoc.RESET;
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        LocStr += RecLoc.Code + '|';
                    UNTIL RecLoc.NEXT = 0;
                LocStr := DELSTR(LocStr, STRLEN(LocStr), 1);
                Rec_AccType.RESET;
                Rec_AccType.SETRANGE(Rec_AccType."No.", StartingAcc, EndingAcc);
                IF Rec_AccType.FINDSET THEN
                    REPEAT
                        //AmtTotal :=0;
                        AccTotAmt := 0;
                        RecGLEntries.RESET;
                        RecGLEntries.SETRANGE(RecGLEntries."G/L Account No.", Rec_AccType."No.");
                        RecGLEntries.SETRANGE(RecGLEntries."Posting Date", From_Date, To_Date);
                        //RecGLEntries.SETFILTER(RecGLEntries."Location Code",LocStr); //PCPL/MIG/NSW Filed Not Exist in BC
                        IF RecGLEntries.FINDSET THEN
                            REPEAT
                                AccTotAmt += RecGLEntries.Amount;
                            //ERROR('%1',AmtTotal);
                            UNTIL RecGLEntries.NEXT = 0;
                    UNTIL Rec_AccType.NEXT = 0;

            END;
        END;
    end;

    local procedure Account_Details_Amount1(AccNo: Code[10]; Loc: Code[10]) AccTotAmt: Decimal;
    var
        RecGLEntries: Record 17;
        AmtTotal: Decimal;
        Branch_Loc: Record 50028;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocStr := '';
                RecLoc.RESET;
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        LocStr += RecLoc.Code + '|';
                    UNTIL RecLoc.NEXT = 0;
                LocStr := DELSTR(LocStr, STRLEN(LocStr), 1);
                //ERROR('%1',LocStr);
                AccTotAmt := 0;
                RecGLEntries.RESET;
                RecGLEntries.SETRANGE(RecGLEntries."G/L Account No.", AccNo);
                RecGLEntries.SETRANGE(RecGLEntries."Posting Date", From_Date, To_Date);
                //RecGLEntries.SETFILTER(RecGLEntries."Location Code",LocStr); //PCPL/MIG/NSW Filed Not Exist in BC
                IF RecGLEntries.FINDSET THEN
                    REPEAT
                        AccTotAmt += RecGLEntries.Amount;
                    //ERROR('%1',AmtTotal);
                    UNTIL RecGLEntries.NEXT = 0;

            END;
        END;
    end;

    procedure LocationWise_Horeca_And_Retail_InRs_QtySum1(Loc: Code[10]) TotQty: Decimal;
    var
        Branch_Loc: Record 50028;
        LocQtyTot: Decimal;
        RecItem: Record 27;
        PerKG1: Decimal;
        PerKG: Decimal;
        Total: Decimal;
        QtySum: Decimal;
    begin
        IF Branch_Loc.GET(Loc) THEN BEGIN
            IF Branch_Loc.Branch = TRUE THEN BEGIN
                LocQty := 0;
                LocQty1 := 0;
                CostAmt_IN_RS := 0;
                CostAmt_IN_RS1 := 0;
                PerKG := 0;
                PerKG1 := 0;
                RecLoc.RESET;
                IF LocCode <> '' THEN
                    RecLoc.SETRANGE(RecLoc.Code, LocCode);
                RecLoc.SETRANGE(RecLoc.Loc_Branch, Loc);
                IF RecLoc.FINDSET THEN
                    REPEAT
                        RecILE2.RESET;
                        RecILE2.SETRANGE(RecILE2."Posting Date", From_Date, To_Date);
                        RecILE2.SETFILTER(RecILE2."Entry Type", '%1', RecILE2."Entry Type"::Sale);
                        RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                        IF RecILE2.FINDSET THEN
                            REPEAT

                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'HORECA' THEN BEGIN
                                        LocQty := LocQty + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS := CostAmt_IN_RS + RecILE2."Sales Amount (Actual)";
                                        IF LocQty <> 0 THEN
                                            PerKG := CostAmt_IN_RS / LocQty;
                                        //Total :=
                                    END;
                                END;
                                IF RecItem.GET(RecILE2."Item No.") THEN BEGIN
                                    IF RecItem."Gen. Prod. Posting Group" = 'RETAIL' THEN BEGIN
                                        LocQty1 := LocQty1 + RecILE2.Quantity;
                                        RecILE2.CALCFIELDS(RecILE2."Sales Amount (Actual)");
                                        CostAmt_IN_RS1 := CostAmt_IN_RS1 + RecILE2."Sales Amount (Actual)";
                                        IF LocQty1 <> 0 THEN
                                            PerKG1 := CostAmt_IN_RS1 / LocQty1;
                                    END;
                                END;
                                TotQty := LocQty + LocQty1;
                            UNTIL RecILE2.NEXT = 0;
                    UNTIL RecLoc.NEXT = 0;
            END;
        END;
    end;
}

