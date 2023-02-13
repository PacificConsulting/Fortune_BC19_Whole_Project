pageextension 50097 "Invt_Pick_Subform_ext" extends "Invt. Pick Subform"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {
        modify("Expiration Date")
        {
            Editable = false;

        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                ILE: Record 32;
                EntrySummary: Record 338;
                WH: Record 5766;
            begin

                // ILE.Reset();
                // ILE.SetRange("Lot No.", "Lot No.");
                // IF ILE.FindLast() then begin
                //     IF ILE."Expiration Date" < Today then
                //         Error('Selected Lot Expired..');
                // end; 
                // IF WH.GET(Rec."Activity Type", Rec."No.") then Begin
                //     Rec.RESET;
                //     Rec.SETRANGE(Rec."Source No.", WH."Source No.");
                //     IF Rec.FINDSET THEN
                //         REPEAT
                //             IF Rec."Expiration Date" < WH."Posting Date" then
                //                 Error('Selected Lot No, %1 is Expired', Rec."Lot No.");
                //         UNTIL Rec.NEXT = 0;
                //     //exit;
                // end;
            end;

        }


        addafter("Bin Code")
        {
            field("Warranty Date"; "Warranty Date")
            {
                Caption = 'Manufacturing Date';
                Visible = True;
                ApplicationArea = all;
                Editable = false;
            }

        }
        addafter("Expiration Date")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
                trigger OnValidate();
                begin

                    //CCIT-SG-19932018
                    RecSL.RESET;
                    RecSL.SETRANGE(RecSL."Document No.", Rec."Source No.");
                    RecSL.SETRANGE(RecSL."Line No.", Rec."Source Line No.");
                    IF RecSL.FINDSET THEN
                        REPEAT
                            RecSL."Reason Code" := "Reason Code";
                            RecSL.MODIFY;
                        UNTIL RecSL.NEXT = 0;
                    //CCIT-SG-19932018
                end;
            }

        }

        addafter("Shelf No.")
        {
            field("Main Quantity in KG"; "Main Quantity in KG")
            {
                ApplicationArea = all;

            }
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'SO/Pick List Qty. In PCS';
                Editable = false;
                Enabled = false;
                ApplicationArea = all;
            }
            field("Tolerance Qty"; "Tolerance Qty")
            {
                Caption = 'BTO Qty. In KG';
                ApplicationArea = all;
                trigger OnValidate();
                var
                    WhseRequest: Record "Warehouse Request";
                begin
                    //CurrPage.UPDATE(FALSE); //CCIT-SD-19-04-2018
                    //PCPL-0070 30Nov2022 New Tolerance Code
                    RecSL.RESET;
                    RecSL.SETRANGE("Document No.", "Source No.");
                    RecSL.SETRANGE("Line No.", "Source Line No.");
                    RecSL.SETRANGE("No.", "Item No.");
                    IF RecSL.FINDFIRST THEN BEGIN
                        IF RecSH.GET(RecSL."Document Type", RecSL."Document No.") then begin
                            RecSH.Status := RecSH.Status::Open;
                            RecSH.Modify();
                        ENd;
                        RecSL."Invt.Pick Tolerance Qty" := "Tolerance Qty";
                        WareActLineQty := RecSL."Invt.Pick Tolerance Qty";
                        RecSL.Modify();
                    End;
                    TempWareActHdr.DeleteAll();
                    TempWareActLine.DeleteAll();

                    WareActHdr.Reset();
                    WareActHdr.SetRange("No.", "No.");
                    WareActHdr.SetRange(Type, WareActHdr.Type::"Invt. Pick");
                    if WareActHdr.FindFirst() then begin
                        TempWareActHdr.Init();
                        TempWareActHdr.TransferFields(WareActHdr, true);
                        TempWareActHdr.Insert();
                        WareActLine.Reset();
                        WareActLine.SetRange("No.", WareActHdr."No.");
                        if WareActLine.FindSet() then
                            repeat
                                TempWareActLine.Init();
                                TempWareActLine.TransferFields(WareActLine);
                                TempWareActLine.Insert();
                                WareActLine.Delete();
                            until WareActLine.Next() = 0;
                        WareActHdr.Delete();
                    End;

                    //SalesLineBeforQty := RecSL."Main Quantity in KG";
                    RecSL.Validate("Main Quantity in KG", RecSL."Invt.Pick Tolerance Qty");
                    RecSL.Modify();

                    RecSH.Status := RecSH.Status::Released;
                    RecSH.Modify();
                    Commit();

                    /*
                     WhseRequest.SetRange("Source No.", RecSH."No.");
                     REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);
                     //WhaCre.Run();
                     // WhaCre.SetTableView(WhseRequest);
                     // WhaCre.Run();                    
                     Message('Please Refresh the Current Page OR Press the F5 Button');

                     WareActHdr.Reset();
                     WareActHdr.SetRange("Source No.", RecSH."No.");
                     WareActHdr.SetRange(Type, WareActHdr.Type::"Invt. Pick");
                     if not WareActHdr.FindFirst() then begin
                         RecSH.Status := RecSH.Status::Open;
                         RecSH.Modify();
                         RecSL.Validate("Main Quantity in KG", SalesLineBeforQty);
                         RecSL.Modify();
                         RecSH.Status := RecSH.Status::Released;
                         RecSH.Modify();
                         WareActHdr.Init();
                         WareActHdr.TransferFields(TempWareActHdr, true);
                         WareActHdr.Insert();
                         if TempWareActLine.FindSet() then
                             repeat
                                 WareActLine.Init();
                                 WareActLine.TransferFields(TempWareActLine, true);
                                 WareActLine.Insert();
                             until TempWareActLine.Next() = 0;
                     end;
                     */
                    WareActHdr.Init();
                    WareActHdr.TransferFields(TempWareActHdr, true);
                    WareActHdr.Insert();

                    if TempWareActLine.FindSet() then
                        repeat
                            WareActLine.Init();
                            WareActLine.TransferFields(TempWareActLine, true);
                            WareActLine.Insert();
                        until TempWareActLine.Next() = 0;

                    WareActLine.Validate("Main Quantity in KG", WareActLineQty);
                    WareActLine.Validate(Quantity, WareActLineQty);
                    WareActLine.Validate("Remaining Quantity", WareActLineQty);
                    WareActLine.Validate("Qty. Outstanding", WareActLineQty);
                    WareActLine.Validate("Tolerance Qty", WareActLineQty);
                    WareActLine."Conversion Qty" := WareActLineQty / RecSL.Weight;
                    WareActLine.Validate("Tolerance Qty in PCS", "Tolerance Qty" / RecSL.Weight);
                    WareActLine.Modify();
                    Message('Please Refresh the Current Page OR Press the F5 Button');
                end;
            }
            field("Tolerance Qty in PCS"; "Tolerance Qty in PCS")
            {
                Caption = 'BTO Qty. In PCS';
                Editable = true;
                ApplicationArea = all;
            }
        }
        addafter("Qty. Handled")
        {
            field("Conversion Qty To Handle"; "Conversion Qty To Handle")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Transfer From Reason Code"; "Transfer From Reason Code")
            {
                ApplicationArea = all;
            }
            field("Transfer To Reason Code"; "Transfer To Reason Code")
            {
                ApplicationArea = all;
            }
            field("Remaining Quantity"; "Remaining Quantity")
            {
                ApplicationArea = all;
            }

            field("TO Qty. In PCS"; "TO Qty. In PCS")
            {
                Caption = 'TO Qty. In KG';
                Editable = false;
                ApplicationArea = all;
            }
            field("TO Qty. In KG"; "TO Qty. In KG")
            {
                Caption = 'TO Qty. In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
            {
                ApplicationArea = all;
            }
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
            }
            field("Actual Qty In PCS"; "Actual Qty In PCS")
            {
                ApplicationArea = all;
            }
            field("Actual Qty In KG"; "Actual Qty In KG")
            {
                ApplicationArea = all;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
            }
        }
        addafter("Assemble to Order")
        {
            field(Weight1; Weight1)
            {
                Caption = 'Weight';
                ApplicationArea = all;
            }
            field("Gen.Prod.Post.Group"; "Gen.Prod.Post.Group")
            {
                ApplicationArea = all;
            }

        }

    }
    actions
    {

        //Unsupported feature: PropertyDeletion on "SplitWhseActivityLine(Action 1900206104)". Please convert manually.

    }

    var
        RecWAL: Record 5767;
        RecUOM: Record 5404;
        Today_Date: Date;
        RecSH: Record 36;
        RecSL: Record 37;
        WareActHdr: Record "Warehouse Activity Header";
        WareActLine: Record "Warehouse Activity Line";
        WhaCre: Report "Create Invt Put-away/Pick/Mvmt";
        TempWareActHdr: Record "Warehouse Activity Header" temporary;
        TempWareActLine: Record "Warehouse Activity Line" temporary;
        SalesLineBeforQty: Decimal;
        WareActLineQty: Decimal;

}

