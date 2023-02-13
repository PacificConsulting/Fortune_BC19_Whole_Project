report 50018 "Inventory Report PAN India"
{
    // version CCIT-Fortune-SG

    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Location Filter";

            trigger OnAfterGetRecord();
            begin
                //MESSAGE('%1',Item."No.");
                ItemTotal := 0;
                RecILE3.RESET;
                RecILE3.SETRANGE(RecILE3."Item No.", Item."No.");
                //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                IF RecILE3.FINDFIRST THEN
                    REPEAT
                        //ItemTotal += RecILE3.Quantity;
                        ItemTotal += RecILE3."Remaining Quantity";
                    UNTIL RecILE3.NEXT = 0;

                IF RecVend.GET(Item."Vendor No.") THEN
                    Supplier := RecVend.Name;

                IF ItemTotal = 0 THEN
                    CurrReport.SKIP;


                ExcelBuf.NewRow;
                ExcelBuf.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Supplier, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Brand Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Sales Category", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Global Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Storage Categories", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Item."Conversion UOM", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


                //------------------------------------------------------
                IF Loc_Block = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Block, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //--------------------------------------------------------
                IF Loc_Main = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Main, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //---------------------------------------------------------------
                IF Loc_DF = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_DF, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //---------------------------------------------------------
                IF Loc_Reco = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Reco, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);

                        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //------------------------------------------------------------
                IF Loc_Intra = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Intra, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //-----------------------------------------------------------------
                IF Loc_Bond = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Bond, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //-----------------------------------------------------------------
                IF (Loc_Intra = FALSE) AND (Loc_Block = FALSE) AND (Loc_DF = FALSE) AND (Loc_Main = FALSE) AND (Loc_Reco = FALSE) AND (Loc_Bond = FALSE) THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(RecLoc."Used In InventoryPAN INDIA", TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocQty := 0;
                            LocQtyPCS := 0;
                            RecILE2.RESET;
                            RecILE2.SETRANGE(RecILE2."Item No.", Item."No.");
                            //RecILE2.SETRANGE(RecILE2."Posting Date",From_Date,To_Date);
                            RecILE2.SETRANGE(RecILE2."Posting Date", 99990101D, To_Date);
                            //RecILE2.SETFILTER(RecILE2."Entry Type",'%1',RecILE2."Entry Type"::Transfer);
                            RecILE2.SETRANGE(RecILE2."Location Code", RecLoc.Code);
                            IF RecILE2.FINDSET THEN
                                REPEAT
                                    //LocQty := LocQty + RecILE2.Quantity;
                                    LocQty := LocQty + RecILE2."Remaining Quantity";
                                    //LocQtyPCS := LocQtyPCS + ROUND(RecILE2."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE2."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocQtyPCS := LocQtyPCS + ROUND((RecILE2."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE2.NEXT = 0;
                            ExcelBuf.AddColumn(LocQty, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocQtyPCS, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;

                //-----------------------------------------------------------------
            end;

            trigger OnPostDataItem();
            begin
                ExcelBuf.NewRow;
                ExcelBuf.NewRow;
                ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                //--------------------------------------------
                //LocTotal1 :=0;
                IF Loc_Block = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Block, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    //LocTotal := LocTotal + RecILE2.Quantity;
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //----------------------------------------------------
                IF Loc_Main = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Main, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //-----------------------------------------------------------
                IF Loc_DF = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_DF, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //-----------------------------------------------------------
                IF Loc_Reco = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Reco, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    // LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //-------------------------------------------------------------
                IF Loc_Intra = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Intra, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //------------------------------------------------------
                IF Loc_Bond = TRUE THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(Loc_Bond, TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //------------------------------------------------------
                IF (Loc_Intra = FALSE) AND (Loc_Block = FALSE) AND (Loc_DF = FALSE) AND (Loc_Main = FALSE) AND (Loc_Reco = FALSE) AND (Loc_Bond = FALSE) THEN BEGIN
                    RecLoc.RESET;
                    IF LocCode <> '' THEN
                        RecLoc.SETRANGE(RecLoc.Code, LocCode);
                    RecLoc.SETRANGE(REcLoc."Used In InventoryPAN INDIA", TRUE);
                    IF RecLoc.FINDFIRST THEN
                        REPEAT
                            LocTotal := 0;
                            LocTotal1 := 0;
                            RecILE3.RESET;
                            //RecILE3.SETRANGE(RecILE3."Posting Date",From_Date,To_Date);
                            RecILE3.SETRANGE(RecILE3."Posting Date", 99990101D, To_Date);
                            RecILE3.SETRANGE(RecILE3."Location Code", RecLoc.Code);
                            IF RecILE3.FINDSET THEN
                                REPEAT
                                    LocTotal := LocTotal + RecILE3."Remaining Quantity";
                                    //LocTotal1 := LocTotal1 + ROUND(RecILE3."Remainig Qty. In KG",1,'=');
                                    IF RecItem2.GET(RecILE3."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                LocTotal1 := LocTotal1 + ROUND((RecILE3."Remaining Quantity" / RecUOM.Weight), 1, '=');
                                            END
                                        END
                                    END;
                                UNTIL RecILE3.NEXT = 0;

                            ExcelBuf.AddColumn(LocTotal, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                            ExcelBuf.AddColumn(LocTotal1, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                        UNTIL RecLoc.NEXT = 0;
                END;
                //------------------------------------------------------
            end;

            trigger OnPreDataItem();
            begin
                //GlobLoc := "Item Ledger Entry".GETFILTER("Item Ledger Entry"."Location Code");
                //IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
                //IF To_Date <> 0D THEN
                // RecILE.SETRANGE(RecILE."Posting Date",From_Date,To_Date);
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
                    field("As On Date"; To_Date)
                    {
                        Visible = true;
                    }
                    field("Location DF"; Loc_DF)
                    {
                    }
                    field("Location Main"; Loc_Main)
                    {
                    }
                    field("Location Intra"; Loc_Intra)
                    {
                    }
                    field("Location Reco"; Loc_Reco)
                    {
                    }
                    field("Location Block"; Loc_Block)
                    {
                    }
                    field("Location Bond"; Loc_Bond)
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

    trigger OnInitReport();
    begin
        //CurrItem := 'CRONUS BLANK';
        CurrLoc := 'FORTUNE BLANK';
        From_Date := 20100101D;//010110D; //PCPL/MIG/NSW
    end;

    trigger OnPostReport();
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport();
    begin
        MakeExcelDataHeader;

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
        Loc_DF: Boolean;
        Loc_Main: Boolean;
        Loc_Intra: Boolean;
        Loc_Reco: Boolean;
        Loc_Block: Boolean;
        Loc_Bond: Boolean;
        RecItem2: Record 27;
        RecUOM: Record 5404;
        AsOnDate: Date;

    procedure CreateExcelBook();
    begin

        //ExcelBuf.CreateBookAndOpenExcel('E:\Reports\INVENTORY REPORT PAN INDIA.xlsx', 'INVENTORY REPORT PAN INDIA', 'INVENTORY REPORT PAN INDIA', COMPANYNAME, USERID);
        ExcelBuf.CreateBookAndOpenExcel('D:\Reports\INVENTORY REPORT PAN INDIA.xlsx', 'INVENTORY REPORT PAN INDIA', 'INVENTORY REPORT PAN INDIA', COMPANYNAME, USERID);
        //PCPL/MIG/NSW
    end;

    procedure MakeExcelDataHeader();
    var
        RecLoc: Record 14;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('INVENTORY REPORT PAN INDIA', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        IF (From_Date <> 0D) AND (To_Date <> 0D) THEN
            ExcelBuf.AddColumn('From Date : ' + FORMAT(From_Date) + '  TO   ' + FORMAT(To_Date), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text)
        ELSE
            IF (AsOnDate <> 0D) THEN
                ExcelBuf.AddColumn('As On Date : ' + FORMAT(AsOnDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Date : ' + FORMAT(SYSTEM.TODAY), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Time : ' + FORMAT(TIME), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        //ExcelBuf.NewRow;
        //ExcelBuf.AddColumn('Date :' + FORMAT(From_Date) + '  To  ' + FORMAT(To_Date) ,FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Gen. Prod. Posting Group', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Brand Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Sales Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Group Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Storage Category', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        //-------------------------------------------------------
        IF Loc_Block = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Block, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //-------------------------------------------------------
        IF Loc_Main = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Main, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //-------------------------------------------------------
        IF Loc_DF = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_DF, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;

        //-------------------------------------------------------
        IF Loc_Reco = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Reco, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //-------------------------------------------------------
        IF Loc_Intra = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Intra, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //-------------------------------------------------------
        IF Loc_Bond = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Bond, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------------
        IF (Loc_Intra = FALSE) AND (Loc_Block = FALSE) AND (Loc_DF = FALSE) AND (Loc_Main = FALSE) AND (Loc_Reco = FALSE) AND (Loc_Bond = FALSE) THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE("Used In InventoryPAN INDIA", TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn(RecLocation.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------------
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        //-------------------------------------------------
        IF Loc_Block = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Block, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //----------------------------------------------------
        IF Loc_Main = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Main, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------
        IF Loc_DF = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_DF, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------
        IF Loc_Reco = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Reco, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------
        IF Loc_Intra = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Intra, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------
        IF Loc_Bond = TRUE THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE(Loc_Bond, TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //------------------------------------------------
        IF (Loc_Intra = FALSE) AND (Loc_Block = FALSE) AND (Loc_DF = FALSE) AND (Loc_Main = FALSE) AND (Loc_Reco = FALSE) AND (Loc_Bond = FALSE) THEN BEGIN
            RecLocation.RESET;
            IF LocCode <> '' THEN
                RecLocation.SETRANGE(RecLocation.Code, LocCode);
            RecLocation.SETRANGE("Used In InventoryPAN INDIA", TRUE);
            IF GlobLoc <> '' THEN
                RecLocation.SETFILTER(RecLocation.Code, CurrLoc);
            IF RecLocation.FINDSET THEN
                REPEAT
                    ExcelBuf.AddColumn('Qty In KGS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Qty In PCS', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
                UNTIL RecLocation.NEXT = 0;
        END;
        //-------------------------------------------------
    end;

    procedure MakeExcelDataBody(CurrLoc: Code[10]);
    begin
    end;

    procedure MakeExcelTotal();
    begin
    end;

    procedure EntryCount(ItemNo: Code[20]; LocCode: Code[20]): Integer;
    begin

        RecILE33.SETRANGE(RecILE33."Posting Date", From_Date, To_Date);
        RecILE33.SETRANGE(RecILE33."Posting Date", 99990101D, To_Date);  //0110199D
        RecILE33.SETRANGE("Item No.", ItemNo);
        RecILE33.SETRANGE("Location Code", LocCode);
        IF RecILE33.FINDSET THEN
            EXIT(RecILE33.COUNT);
    end;
}

