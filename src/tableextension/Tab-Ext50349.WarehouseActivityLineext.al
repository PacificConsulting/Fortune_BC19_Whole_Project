tableextension 50349 "Warehouse_Activity_Line_ext" extends "Warehouse Activity Line"
{
    // version NAVW19.00.00.48822,CCIT-Fortune

    fields
    {


        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        Weight1 := RecUOM.Weight;
                    END
                END;
                //---- CCIT-SG
            end;
        }

        modify("Qty. to Handle")
        {
            trigger OnAfterValidate()
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Conversion Qty To Handle" := Rec."Qty. to Handle" / RecUOM.Weight;
                        END
                    END
                END;
                //CCIT-JAGA 22/11/2018
                IF (Rec."Source Document" = Rec."Source Document"::"Sales Order") OR (Rec."Source Document" = Rec."Source Document"::"Outbound Transfer") THEN BEGIN
                    IF "TO Qty. In PCS" <> 0 THEN
                        "Fill Rate %" := ("Qty. to Handle" / "TO Qty. In PCS") * 100
                    ELSE
                        "Fill Rate %" := ("Qty. to Handle" / Quantity) * 100;
                END;
                //CCIT-JAGA 22/11/2018

                IF "Qty. Handled" = 0 THEN BEGIN
                    "Damage Qty. In KG" := "Conversion Qty" - "Conversion Qty To Handle";
                    "Damage Qty. In PCS" := Quantity - "Qty. to Handle";
                    "Saleable Qty. In PCS" := Quantity - "Damage Qty. In PCS";
                    "Saleable Qty. In KG" := "Conversion Qty" - "Damage Qty. In KG";
                END
                ELSE
                    IF "Qty. Handled" <> 0 THEN BEGIN
                        "Damage Qty. In KG" := "Qty. Outstanding In KG" - "Conversion Qty To Handle";
                        "Damage Qty. In PCS" := "Qty. Outstanding" - "Qty. to Handle";
                        "Saleable Qty. In PCS" := "Qty. Outstanding" - "Damage Qty. In PCS";
                        "Saleable Qty. In KG" := "Qty. Outstanding In KG" - "Damage Qty. In KG";
                    END;

                //IF "Quarantine Qty In KG" = 0 THEN //CCIT-SD-03-05-2018
                "Actual Qty In KG" := "Qty. to Handle" - "Quarantine Qty In KG";
                "Actual Qty In PCS" := "Conversion Qty To Handle" - "Quarantine Qty In PCS";



            end;

        }
        //Unsupported feature: CodeModification on ""Qty. to Handle"(Field 26).OnValidate". Please convert manually.
        modify("Qty. Handled")
        {
            trigger OnAfterValidate()
            begin
                //CCIT-SG

                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            "Qty. Handled In KG" := "Qty. Handled" / RecUOM.Weight;
                            VALIDATE("Qty. Handled In KG");
                            "Qty. Outstanding In KG" := "Conversion Qty" - "Qty. Handled In KG";
                        END
                    END
                END;
                //CCIT-SG

            end;
        }
        modify("Serial No.")
        {
            trigger OnAfterValidate()
            begin
                //>> CS
                IF "Serial No." <> xRec."Serial No." THEN
                    "Manufacturing Date" := 0D;
                //<< CS
            end;
        }
        modify("Lot No.")
        {
            trigger OnBeforeValidate()
            begin
                //JAGA 08102018
                //IF "Qty. Handled (Base)" <> 0 THEN
                IF "Tolerance Qty" <> 0 THEN
                    ERROR('Please clear the BTO Qty Field');
                //JAGA 08102018
            end;

            trigger OnAfterValidate()
            var
                ILE1: Record 32;
                WSL: Record 5767;
            begin
                //Validate("Expiration Date");
                //CITS-SD-29-12-2017 -
                IF "Lot No." <> xRec."Lot No." THEN
                    UpdateLotNoCITS;
                //CITS-SD-29-12-2017
                IF "Lot No." <> '' then begin
                    ILE1.Reset();
                    ILE1.SetRange("Lot No.", "Lot No.");
                    //ILE1.SetRange(ILE1."Entry Type", ILE1."Entry Type"::"Positive Adjmt.");
                    IF ILE1.FindFirst() then begin
                        Validate("Warranty Date", ILE1."Warranty Date"); //"Warranty Date" := ILE1."Warranty Date";
                                                                         // Message(Format("Warranty Date"));
                    end;
                end;
            end;
        }
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin

                //CCIT-SG-19112018
                IF "Expiration Date" < "Manufacturing Date" THEN
                    ERROR('Expiration Date Should not be less than Manufacturing Date');
                //CCIT-SG-19112018
                //CITS-SD-29-12-2017 -
                IF "Expiration Date" <> xRec."Expiration Date" THEN
                    UpdateLotNoCITS;
                //CITS-SD-29-12-2017 +

                //CCIT-SG
                Today_Date := TODAY + 1;
                IF "Expiration Date" = Today_Date THEN
                    ERROR('Batch near to Expire');
                //CCIT-SG
                // IF "Expiration Date" < Today then
                //     Error('Selected Lot Expired..');
            end;
        }

        field(50006; "PO No."; Code[20])
        {
            Editable = false;
        }
        field(50008; Completed; Boolean)
        {
        }
        field(50009; Weighted; Boolean)
        {
            Editable = false;
        }
        field(50012; isFirst; Boolean)
        {
        }
        field(50013; "Packet Quantity To Handle"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50014; "Whse Act Bin Lot Line No."; Integer)
        {
            Description = 'CCIT SAN';
        }
        field(50028; "Conversion Qty To Handle"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //---- CCIT-SG
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Qty. to Handle" := Rec."Conversion Qty To Handle" * RecUOM1.Weight;
                        END;
                    END;
                END;
                IF "Conversion Qty To Handle" > "Conversion Qty" THEN
                    ERROR('You can not handle more than the %1 units', "Conversion Qty");
                IF "TO Qty. In KG" <> 0 THEN
                    "Fill Rate %" := ("Conversion Qty To Handle" / "TO Qty. In KG") * 100;
                //---- CCIT-SG
            end;
        }
        field(50030; Weight1; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50031; "Conversion Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50032; "Reason Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Reason Code";

            trigger OnValidate();
            begin
                //CCIT
                IF RecReasonCode.GET("Reason Code") THEN BEGIN
                    IF RecReasonCode.Blocked = TRUE THEN
                        ERROR('This Reason Code is Blocked');
                END;
                //CCIT
            end;
        }
        field(50068; "Qty. to Invoice In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50069; "Qty. to Receive In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50070; "HS Code"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "HS Code Master"."HS Code";
        }
        field(50073; "Lot No.GRN"; Code[10])
        {
            Description = 'CCIT';
        }
        field(50074; "Expiration Date GRN"; Date)
        {
            Description = 'CCIT';
        }
        field(50075; "Manufacturing Date GRN"; Date)
        {
            Description = 'CCIT';
        }
        field(50076; "Qty. Handled In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
            Editable = false;
        }
        field(50077; "Qty. Outstanding In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
            Editable = false;
        }
        field(50078; "Saleable Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50079; "Damage Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //CCIT-SG
                //"Damage Qty. In PCS":=0;
                "Damage Qty. In KG" := 0;
                "Saleable Qty. In PCS" := 0;
                "Saleable Qty. In KG" := 0;

                IF "Damage Qty. In PCS" <> 0 THEN BEGIN
                    "Saleable Qty. In PCS" := Quantity - "Damage Qty. In PCS";
                    IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                "Damage Qty. In KG" := Rec."Damage Qty. In PCS" / RecUOM.Weight;
                                "Saleable Qty. In KG" := Rec."Saleable Qty. In PCS" / RecUOM.Weight;
                            END;
                        END;
                    END;
                END;
                //CCIT-SG
            end;
        }
        field(50080; "Saleable Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';
        }
        field(50081; "Damage Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                //"Saleable Qty. In KG" := "Conversion Qty" - "Damage Qty. In KG";
            end;
        }
        field(50083; "Gen.Prod.Post.Group"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50087; "Sales Category"; Code[20])
        {
            Description = 'CCIT';
            TableRelation = "Sales Category".Code;
        }
        field(50088; "TO Qty. In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50089; "TO Qty. In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50090; "Tolerance Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-19-04-2018';

            trigger OnValidate();
            var
                WhseRequest: Record "Warehouse Request";
            begin
                //JAGA 08102018
                IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN

                    TESTFIELD("Lot No.");

                    RecILE.RESET;
                    RecILE.SETRANGE(RecILE."Item No.", "Item No.");
                    RecILE.SETRANGE(RecILE."Lot No.", "Lot No.");
                    RecILE.SETRANGE(RecILE."Location Code", "Location Code");
                    IF RecILE.FINDSET THEN
                        REPEAT
                            TotalILEQty += RecILE.Quantity;
                        UNTIL RecILE.NEXT = 0;

                    RecSalesAndReceivableSetup.GET;
                    IF RecSalesAndReceivableSetup.Tolerance <> 0 THEN BEGIN
                        LotToleranceQty := (RecSalesAndReceivableSetup.Tolerance * TotalILEQty) / 100;
                    END;

                    FinLotQty := TotalILEQty + LotToleranceQty;

                    IF "Tolerance Qty" > FinLotQty THEN
                        ERROR('BTO Qty must be less than or equal to %1', FinLotQty); //ccit  25122020
                END;
                // //PCPL-0070 30Nov2022 New Tolerance Code
                // RecSL.RESET;
                // RecSL.SETRANGE("Document No.", "Source No.");
                // RecSL.SETRANGE("Line No.", "Source Line No.");
                // RecSL.SETRANGE("No.", "Item No.");
                // IF RecSL.FINDFIRST THEN BEGIN
                //     IF RecSH.GET(RecSL."Document Type", RecSL."Document No.") then begin
                //         RecSH.Status := RecSH.Status::Open;
                //         RecSH.Modify();
                //     ENd;
                //     RecSL."Invt.Pick Tolerance Qty" := "Tolerance Qty";
                //     RecSL.Modify();
                // End;


                // WareActHdr.Reset();
                // WareActHdr.SetRange("No.", "No.");
                // WareActHdr.SetRange(Type, WareActHdr.Type::"Invt. Pick");
                // if WareActHdr.FindFirst() then begin
                //     WareActLine.Reset();
                //     WareActLine.SetRange("No.", WareActHdr."No.");
                //     if WareActLine.FindSet() then
                //         repeat
                //             WareActLine.Delete();
                //         until WareActLine.Next() = 0;
                //     WareActHdr.Delete();
                // End;
                // RecSL.Validate("Main Quantity in KG", RecSL."Invt.Pick Tolerance Qty");
                // RecSL.Modify();

                // RecSH.Status := RecSH.Status::Released;
                // RecSH.Modify();
                // Commit();

                // WhseRequest.SetRange("Source No.", RecSH."No.");
                // REPORT.RunModal(REPORT::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);

                //PCPL -0070 30Nov2022 New Tolerance Code

                //JAGA 08102018
                /* //PCPL-0070 Original Tolerance Qty Code
                                //CCIT-SD-19-04-2018 -
                                IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN

                                    SalesLineQty := "Remaining Quantity";//"Main Quantity in KG";
                                                                         //ELSE
                                                                         //  SalesLineQty := "Main Quantity in KG";
                                    IF Location."Duty Free" <> TRUE THEN BEGIN
                                        QtyToHandle := 0;
                                        RecSalesAndReceivableSetup.GET;
                                        IF RecSalesAndReceivableSetup.Tolerance <> 0 THEN BEGIN
                                            ToleranceQty := (RecSalesAndReceivableSetup.Tolerance * SalesLineQty) / 100;
                                            QtyToHandle := SalesLineQty + ToleranceQty;
                                            PostPickLineQty := 0;

                                            PickLineQty := 0;
                                            IF (QtyToHandle - (PostPickLineQty + PickLineQty + "Tolerance Qty")) < 0 THEN
                                                ERROR('BTO Qty. In KG not greater than %1', ("Tolerance Qty" +
                                                                  (QtyToHandle - (PostPickLineQty + PickLineQty + "Tolerance Qty"))));
                                        END;

                                    END;
                                    //UNTIL RecSL.NEXT=0;
                                    //END;

                                    IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                                        IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                            IF (RecUOM.Weight <> 0) THEN BEGIN
                                                "Tolerance Qty in PCS" := "Tolerance Qty" / RecUOM.Weight;

                                            END
                                        END
                                    END;
                                    IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                                        IF "Tolerance Qty" <> xRec."Tolerance Qty" THEN BEGIN
                                            RecSH.RESET;
                                            RecSH.SETRANGE("No.", "Source No.");
                                            IF RecSH.FINDFIRST THEN BEGIN
                                                RecSH.Status := RecSH.Status::Open;
                                                RecSH.MODIFY;
                                            END;
                                            RecSL.RESET;
                                            RecSL.SETRANGE("Document No.", "Source No.");
                                            RecSL.SETRANGE("Line No.", "Source Line No.");
                                            RecSL.SETRANGE("No.", "Item No.");
                                            IF RecSL.FINDFIRST THEN BEGIN
                                                IF "Tolerance Qty" > "Qty. Outstanding" THEN BEGIN
                                                    IF ("Tolerance Qty" <> xRec."Tolerance Qty") AND (xRec."Tolerance Qty" <> 0) THEN BEGIN
                                                        IF "Tolerance Qty" > xRec."Tolerance Qty" THEN BEGIN
                                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - xRec."Tolerance Qty"));
                                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL.Quantity + ("Tolerance Qty" - "Main Quantity in KG")));
                                                            VALIDATE(Quantity, "Tolerance Qty");
                                                        END ELSE BEGIN
                                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - xRec."Tolerance Qty"));
                                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL.Quantity + ("Tolerance Qty" - xRec."Tolerance Qty")));
                                                            VALIDATE(Quantity, (Quantity + ("Tolerance Qty" - xRec."Tolerance Qty")));
                                                        END;
                                                    END ELSE
                                                        IF ("Tolerance Qty" <> xRec."Tolerance Qty") AND (xRec."Tolerance Qty" = 0) THEN BEGIN
                                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - "Qty. Outstanding"));
                                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL.Quantity + ("Tolerance Qty" - "Qty. Outstanding")));
                                                            VALIDATE(Quantity, (Quantity + ("Tolerance Qty" - "Qty. Outstanding")));
                                                        END;
                                                END ELSE BEGIN
                                                    IF ("Tolerance Qty" < "Qty. Outstanding") THEN BEGIN
                                                        IF ("Tolerance Qty" <= "Main Quantity in KG") THEN BEGIN
                                                            IF RecSL.Quantity > RecSL."Main Quantity in KG" THEN BEGIN
                                                                UpdateReservationEntry(Rec, ("Tolerance Qty" - "Qty. Outstanding"));
                                                                RecSL.VALIDATE(RecSL.Quantity, RecSL."Main Quantity in KG");//RecSL.Quantity - ("Qty. Outstanding" - "Tolerance Qty"));
                                                            END;
                                                            VALIDATE(Quantity, "Main Quantity in KG");
                                                        END ELSE BEGIN
                                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - "Main Quantity in KG"));
                                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL."Main Quantity in KG" + ("Tolerance Qty" - "Main Quantity in KG")));
                                                            VALIDATE(Quantity, ("Main Quantity in KG" + ("Tolerance Qty" - "Main Quantity in KG")));
                                                        END;
                                                    END ELSE
                                                        IF (xRec."Tolerance Qty" > "Qty. Outstanding") AND ("Tolerance Qty" > "Qty. Outstanding") THEN BEGIN
                                                        END;
                                                END;
                                                RecSL.MODIFY;
                                            END;

                                            VALIDATE("Qty. to Handle", "Tolerance Qty");
                                            RecSH.RESET;
                                            RecSH.SETRANGE("No.", "Source No.");
                                            IF RecSH.FINDFIRST THEN BEGIN
                                                RecSH.Status := RecSH.Status::Released;
                                                RecSH.MODIFY;
                                            END;
                                        END;
                                    END;

                                END ELSE BEGIN
                                    VALIDATE("Qty. to Handle", "Tolerance Qty");
                                END;
                                //CCIT-SD-19-04-2018 +
                                //CCIT-SG-24052018
                                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                                        IF (RecUOM.Weight <> 0) THEN BEGIN
                                            "Tolerance Qty in PCS" := "Tolerance Qty" / RecUOM.Weight;

                                        END
                                    END
                                END;
                                //CCIT-SG-24052018
*/ //PCPL_0070

            end;
        }
        field(50091; "Source Item No.1"; Code[20])
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50092; "Source Line No.1"; Integer)
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50093; Tolerance; Boolean)
        {
            Description = 'CCIT-SD-19-04-2018';
        }
        field(50111; "Fill Rate %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50120; "Quarantine Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            "Quarantine Qty In KG" := "Quarantine Qty In PCS" * RecUOM1.Weight;
                        END
                    END
                END;
                "Actual Qty In PCS" := "Conversion Qty To Handle" - "Quarantine Qty In PCS";
                "Actual Qty In KG" := "Qty. to Handle" - "Quarantine Qty In KG";
            end;
        }
        field(50121; "Quarantine Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Description = 'CCIT';

            trigger OnValidate();
            begin
                IF "Quarantine Qty In KG" > "Qty. to Handle" THEN
                    ERROR('Quarantine Qty. In KG Should not be greater than GRN Qty. In KG');
                "Actual Qty In KG" := "Qty. to Handle" - "Quarantine Qty In KG";
                IF RecItem2.GET(Rec."Item No.") THEN BEGIN
                    IF RecUOM1.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM1.Weight <> 0) THEN BEGIN
                            /*IF (RecItem2.Tolerance = FALSE) AND ((Rec."Quarantine Qty In KG" MOD RecUOM1.Weight) <> 0) THEN
                                ERROR('Please Enter Correct Qty in KG')
                            ELSE */
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Quarantine Qty In PCS" := "Quarantine Qty In KG" / RecUOM1.Weight;
                            "Actual Qty In PCS" := "Actual Qty In KG" / RecUOM1.Weight
                        END
                    END
                END;

            end;
        }
        field(50122; "Actual Qty In PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50123; "Actual Qty In KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT';
        }
        field(50126; "Transfer From Reason Code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50127; "Transfer To Reason Code"; Code[20])
        {
            Description = 'CCIT';
        }
        field(50500; "Actual Batch"; Code[20])
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50501; "Actual MFG Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50502; "Actual EXP Date"; Date)
        {
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50503; "Actual Batch PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50504; "Actual Batch KGS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-JAGA-09-05-18';
        }
        field(50505; "Main Quantity in KG"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';
            Editable = false;

            trigger OnValidate();
            begin
                //CCIT-SD-14-05-2018 -
                IF RecItem2.GET(Rec."No.") THEN BEGIN
                    IF RecUOM.GET(RecItem2."No.", RecItem2."Base Unit of Measure") THEN BEGIN
                        IF (RecUOM.Weight <> 0) THEN BEGIN
                            /*IF (RecItem2.Tolerance = FALSE) AND ((Rec."Main Quantity in KG" MOD RecUOM.Weight) <> 0) THEN
                               ERROR('Please Enter Correct Qty in KG')
                            ELSE */
                            //"Conversion Qty" := Rec.Quantity / RecUOM.Weight;
                            "Main Quantity in PCS" := "Main Quantity in KG" / RecUOM.Weight;
                        END
                    END
                END;
                //CCIT-SD-14-05-2018 +

            end;
        }
        field(50506; "Main Quantity in PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-14-05-2018';
        }
        field(50507; "Tolerance Qty in PCS"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CCIT-SD-19-04-2018';

            trigger OnValidate();
            begin
                //CCIT-SD-19-04-2018 -
                IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                    /* RecSH.RESET;
                     RecSH.SETRANGE(RecSH."No.",Rec."Source No.");
                     IF RecSH.FINDFIRST THEN BEGIN
                        RecSL.RESET;
                        RecSL.SETRANGE(RecSL."Document No.",RecSH."No.");
                        RecSL.SETRANGE(RecSL."No.",Rec."Item No.");
                        IF RecSL.FINDSET THEN
                          REPEAT
                            SalesLineQty := RecSL."Main Quantity in KG";
                            IF Location."Duty Free" <> TRUE THEN BEGIN
                             QtyToHandle :=0;
                             RecSalesAndReceivableSetup.GET;
                             IF RecSalesAndReceivableSetup.Tolerance <> 0 THEN BEGIN
                                ToleranceQty := (RecSalesAndReceivableSetup.Tolerance * SalesLineQty) / 100;
                                QtyToHandle := SalesLineQty + ToleranceQty;
                                PostPickLineQty :=0;
                                RecPostInvPickLine.RESET;
                                RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source No.",Rec."Source No.");
                                RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source Line No.",Rec."Source Line No.");
                                IF RecPostInvPickLine.FINDSET THEN
                                  REPEAT
                                    PostPickLineQty += RecPostInvPickLine.Quantity;
                                  UNTIL RecPostInvPickLine.NEXT=0;
                                PickLineQty :=0;
                                RecInvPickLine.RESET;
                                RecInvPickLine.SETRANGE("Source No.","Source No.");
                                RecInvPickLine.SETRANGE("Source Line No.","Source Line No.");
                                RecInvPickLine.SETFILTER("Line No.",'<>%1',"Line No.");
                                RecInvPickLine.SETFILTER("Source Item No.1",'%1','');
                                IF RecInvPickLine.FINDSET THEN
                                  REPEAT
                                    PickLineQty += RecInvPickLine."Tolerance Qty";
                                  UNTIL RecInvPickLine.NEXT=0;
                                IF (QtyToHandle - (PostPickLineQty + PickLineQty + "Tolerance Qty")) < 0 THEN
                                     ERROR('BTO Qty. In KG not greater than %1',("Tolerance Qty" +
                                                       (QtyToHandle - (PostPickLineQty + PickLineQty+ "Tolerance Qty"))));
                                END;

                            END;
                          UNTIL RecSL.NEXT=0;*/
                    /* RecSH.RESET;
                    // RecSH.SETRANGE(RecSH."No.",Rec."Source No.");
                    // IF RecSH.FINDFIRST THEN BEGIN
                    //    RecSL.RESET;
                        RecSL.SETRANGE(RecSL."Document No.",RecSH."No.");
                        RecSL.SETRANGE(RecSL."No.",Rec."Item No.");
                        IF RecSL.FINDSET THEN
                          REPEAT*/
                    //IF "Remaining Quantity" <> 0 THEN
                    SalesLineQty := "Remaining Quantity";//"Main Quantity in KG";
                                                         //ELSE
                                                         //  SalesLineQty := "Main Quantity in KG";
                    IF Location."Duty Free" <> TRUE THEN BEGIN
                        QtyToHandle := 0;
                        RecSalesAndReceivableSetup.GET;
                        IF RecSalesAndReceivableSetup.Tolerance <> 0 THEN BEGIN
                            ToleranceQty := (RecSalesAndReceivableSetup.Tolerance * SalesLineQty) / 100;
                            QtyToHandle := SalesLineQty + ToleranceQty;
                            PostPickLineQty := 0;
                            /*RecPostInvPickLine.RESET;
                            RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source No.",Rec."Source No.");
                            RecPostInvPickLine.SETRANGE(RecPostInvPickLine."Source Line No.",Rec."Source Line No.");
                            RecPostInvPickLine.SETFILTER("Line No.",'%1',"Line No.");
                            RecPostInvPickLine.SETRANGE("Lot No.","Lot No.");
                            IF RecPostInvPickLine.FINDSET THEN
                              REPEAT
                                PostPickLineQty += RecPostInvPickLine.Quantity;
                              UNTIL RecPostInvPickLine.NEXT=0;*/
                            PickLineQty := 0;
                            /*RecInvPickLine.RESET;
                            RecInvPickLine.SETRANGE("Source No.","Source No.");
                            RecInvPickLine.SETRANGE("Source Line No.","Source Line No.");
                            RecInvPickLine.SETFILTER("Line No.",'<>%1',"Line No.");
                            RecInvPickLine.SETFILTER("Source Item No.1",'%1','');
                            IF RecInvPickLine.FINDSET THEN
                              REPEAT
                                PickLineQty += RecInvPickLine."Tolerance Qty";
                              UNTIL RecInvPickLine.NEXT=0;*/
                            IF (QtyToHandle - (PostPickLineQty + PickLineQty + "Tolerance Qty")) < 0 THEN
                                ERROR('BTO Qty. In KG not greater than %1', ("Tolerance Qty" +
                                                  (QtyToHandle - (PostPickLineQty + PickLineQty + "Tolerance Qty"))));
                        END;

                    END;
                    //UNTIL RecSL.NEXT=0;
                    //END;

                    IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                        IF "Tolerance Qty" <> xRec."Tolerance Qty" THEN BEGIN
                            RecSH.RESET;
                            RecSH.SETRANGE("No.", "Source No.");
                            IF RecSH.FINDFIRST THEN BEGIN
                                RecSH.Status := RecSH.Status::Open;
                                RecSH.MODIFY;
                            END;
                            RecSL.RESET;
                            RecSL.SETRANGE("Document No.", "Source No.");
                            RecSL.SETRANGE("Line No.", "Source Line No.");
                            RecSL.SETRANGE("No.", "Item No.");
                            IF RecSL.FINDFIRST THEN BEGIN
                                IF "Tolerance Qty" > "Qty. Outstanding" THEN BEGIN
                                    IF ("Tolerance Qty" <> xRec."Tolerance Qty") AND (xRec."Tolerance Qty" <> 0) THEN BEGIN
                                        UpdateReservationEntry(Rec, ("Tolerance Qty" - xRec."Tolerance Qty"));
                                        RecSL.VALIDATE(RecSL.Quantity, (RecSL.Quantity + ("Tolerance Qty" - xRec."Tolerance Qty")));
                                        VALIDATE(Quantity, (Quantity + ("Tolerance Qty" - xRec."Tolerance Qty")));
                                    END ELSE
                                        IF ("Tolerance Qty" <> xRec."Tolerance Qty") AND (xRec."Tolerance Qty" = 0) THEN BEGIN
                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - "Qty. Outstanding"));
                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL.Quantity + ("Tolerance Qty" - "Qty. Outstanding")));
                                            VALIDATE(Quantity, (Quantity + ("Tolerance Qty" - "Qty. Outstanding")));
                                        END;
                                END ELSE BEGIN
                                    IF ("Tolerance Qty" < "Qty. Outstanding") THEN BEGIN
                                        IF ("Tolerance Qty" <= "Main Quantity in KG") THEN BEGIN
                                            IF RecSL.Quantity > RecSL."Main Quantity in KG" THEN BEGIN
                                                UpdateReservationEntry(Rec, ("Tolerance Qty" - "Qty. Outstanding"));
                                                RecSL.VALIDATE(RecSL.Quantity, RecSL.Quantity - ("Qty. Outstanding" - "Tolerance Qty"));
                                            END;
                                            VALIDATE(Quantity, "Main Quantity in KG");
                                        END ELSE BEGIN
                                            UpdateReservationEntry(Rec, ("Tolerance Qty" - "Main Quantity in KG"));
                                            RecSL.VALIDATE(RecSL.Quantity, (RecSL."Main Quantity in KG" + ("Tolerance Qty" - "Main Quantity in KG")));
                                            VALIDATE(Quantity, ("Main Quantity in KG" + ("Tolerance Qty" - "Main Quantity in KG")));
                                        END;
                                    END ELSE
                                        IF (xRec."Tolerance Qty" > "Qty. Outstanding") AND ("Tolerance Qty" > "Qty. Outstanding") THEN BEGIN
                                        END;
                                END;
                                RecSL.MODIFY;
                            END;

                            VALIDATE("Qty. to Handle", "Tolerance Qty");
                            RecSH.RESET;
                            RecSH.SETRANGE("No.", "Source No.");
                            IF RecSH.FINDFIRST THEN BEGIN
                                RecSH.Status := RecSH.Status::Released;
                                RecSH.MODIFY;
                            END;
                        END;
                    END;

                    /*
                    IF "Tolerance Qty" <> xRec."Tolerance Qty" THEN BEGIN
                      IF xRec."Tolerance Qty" > "Tolerance Qty" THEN BEGIN
                        RecSL.RESET;
                        RecSL.SETRANGE("Document No.","Source No.");
                        RecSL.SETRANGE("Line No.","Source Line No.");
                        RecSL.SETRANGE("No.","Item No.");
                          IF RecSL.FINDFIRST THEN BEGIN
                            RecSL.VALIDATE("Qty. to Ship",(RecSL."Qty. to Ship" - (xRec."Tolerance Qty"- "Tolerance Qty")));
                            RecSL.MODIFY;
                          END;
                      END;
                        RecWAL.RESET;
                        RecWAL.SETRANGE("No.","No.");
                        RecWAL.SETRANGE("Source Item No.1","Item No.");
                        RecWAL.SETRANGE("Source Line No.1","Line No.");
                          IF RecWAL.FINDFIRST THEN
                            RecWAL.DELETE;
                      //END;
                    END;
                    IF "Tolerance Qty" > "Qty. Outstanding" THEN BEGIN
                      VALIDATE("Qty. to Handle",Quantity);
                      RecSL.RESET;
                      RecSL.SETRANGE("Document No.","Source No.");
                      RecSL.SETRANGE("Line No.","Source Line No.");
                      RecSL.SETRANGE("No.","Item No.");
                        IF RecSL.FINDFIRST THEN BEGIN
                          RecSL.VALIDATE("Qty. to Ship",(RecSL."Qty. to Ship"+("Tolerance Qty"- "Qty. Outstanding")));
                          RecSL.VALIDATE(Tolerance,TRUE);
                          {RecSH.RESET;
                          RecSH.SETRANGE("No.",RecSL."Document No.");
                            IF RecSH.FINDFIRST THEN BEGIN
                              RecSH.Status := RecSH.Status::Open;
                              RecSH.MODIFY;
                            END;}
                        END;
                      {
                      RecSL.RESET;
                      RecSL.SETRANGE("Document No.","Source No.");
                      RecSL.SETRANGE("Line No.","Source Line No.");
                      RecSL.SETRANGE("No.","Item No.");
                        IF RecSL.FINDFIRST THEN BEGIN
                          RecSL.VALIDATE(Quantity,Quantity+("Tolerance Qty" - "Qty. Outstanding"));
                          RecSH.RESET;
                          RecSH.SETRANGE("No.",RecSL."Document No.");
                            IF RecSH.FINDFIRST THEN BEGIN
                              RecSH.Status := RecSH.Status::Released;
                              RecSH.MODIFY;
                            END;
                          RecSL.MODIFY;
                        END;
                        }
                    LineNo := 0;
                    RecWAL.RESET;
                    RecWAL.SETRANGE("No.","No.");
                      IF RecWAL.FINDLAST THEN
                        LineNo := RecWAL."Line No.";

                    RecWAL.INIT;
                    RecWAL.TRANSFERFIELDS(Rec);
                    RecWAL."Line No." := LineNo + 10000;
                    RecWAL.VALIDATE(Quantity,"Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Qty. (Base)","Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Qty. Outstanding","Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Qty. Outstanding (Base)","Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Qty. to Handle","Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Qty. to Handle (Base)","Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.VALIDATE("Source Item No.1","Item No.");
                    RecWAL.VALIDATE("Source Line No.1","Line No.");
                    RecWAL."Tolerance Qty" := ("Tolerance Qty"-"Qty. Outstanding");
                    RecWAL.Tolerance := TRUE;
                    RecWAL.INSERT;
                    END ELSE BEGIN
                      VALIDATE("Qty. to Handle","Tolerance Qty");
                    END;
                    */
                END ELSE BEGIN
                    VALIDATE("Qty. to Handle", "Tolerance Qty");
                END;

                //CCIT-SD-19-04-2018 +

            end;
        }
        field(70000; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            Description = 'CS';

            trigger OnValidate();
            var
                WhseActLine: Record 5767;
            begin
                IF "Lot No." <> '' THEN BEGIN
                    WITH WhseActLine DO BEGIN
                        RESET;
                        SETCURRENTKEY("No.", "Line No.", "Activity Type");
                        SETRANGE("No.", Rec."No.");
                        SETRANGE("Item No.", Rec."Item No.");
                        SETRANGE("Lot No.", Rec."Lot No.");
                        IF FINDSET THEN
                            REPEAT
                                IF ("Line No." <> Rec."Line No.") AND ("Manufacturing Date" <> Rec."Manufacturing Date")
                                  AND (Rec."Manufacturing Date" <> 0D) AND ("Manufacturing Date" <> 0D) THEN
                                    Rec.FIELDERROR("Manufacturing Date");
                            UNTIL NEXT = 0;
                    END;
                END;
                //CCIT-SG-19112018
                IF "Expiration Date" < "Manufacturing Date" THEN
                    ERROR('Expiration Date Should not be less than Manufacturing Date');
                //CCIT-SG-19112018
                //CITS-SD-29-12-2017 -
                IF "Manufacturing Date" <> xRec."Manufacturing Date" THEN
                    UpdateLotNoCITS;
                //CITS-SD-29-12-2017 +
            end;
        }

        field(70004; "PO Lot No."; Code[20])
        {
            Description = 'CITS-SD-26-12-17';
            Editable = false;
        }
        field(70005; "PO Expiration Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
            Editable = false;
        }
        field(70006; "PO Manufacturing Date"; Date)
        {
            Description = 'CITS-SD-26-12-17';
            Editable = false;
        }
        field(70007; "Remaining Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CITS-SD-26-12-17';
        }
    }

    LOCAL PROCEDURE UpdateLotNoCITS();
    VAR
        ReservEntry: Record 337;
    BEGIN
        //CITS-SD-29-12-17 -
        ReservEntry.RESET;
        ReservEntry.SETRANGE("Source ID", "Source No.");
        ReservEntry.SETRANGE("Item No.", "Item No.");
        ReservEntry.SETRANGE("Lot No.", xRec."Lot No.");
        ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Surplus);
        IF ReservEntry.FINDFIRST THEN BEGIN
            IF "Lot No." <> xRec."Lot No." THEN
                ReservEntry."Lot No." := "Lot No.";
            IF "Manufacturing Date" <> xRec."Manufacturing Date" THEN
                ReservEntry."Manufacturing Date" := "Manufacturing Date";
            IF "Expiration Date" <> xRec."Manufacturing Date" THEN
                ReservEntry."Expiration Date" := "Expiration Date";
            ReservEntry.MODIFY;
        END;
        //CITS-SD-29-12-17 +
    END;

    LOCAL PROCEDURE UpdateSalesLineQty();
    BEGIN
        RecInvPickLine.RESET;
        RecInvPickLine.SETRANGE("Source No.", "Source No.");
        RecInvPickLine.SETRANGE("Source Line No.", "Source Line No.");
        //RecInvPickLine.SETFILTER("Line No.",'<>%1',"Line No.");
        RecInvPickLine.SETFILTER("Source Item No.1", '<>%1', '');
        IF RecInvPickLine.FINDSET THEN
            REPEAT
                RecSL.RESET;
                RecSL.SETRANGE("Document No.", RecInvPickLine."Source No.");
                RecSL.SETRANGE("Line No.", RecInvPickLine."Source Line No.");
                IF RecSL.FINDFIRST THEN BEGIN
                    RecSL.VALIDATE("Qty. to Ship", (RecSL."Qty. to Ship" - RecInvPickLine."Tolerance Qty"));
                    RecSL.MODIFY;
                END;
            UNTIL RecInvPickLine.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateReservationEntry(WAL: Record 5767; TolQty: Decimal);
    VAR
        ReservationEntry: Record 337;
    BEGIN
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source ID", WAL."Source No.");
        ReservationEntry.SETRANGE("Item No.", WAL."Item No.");
        ReservationEntry.SETRANGE("Lot No.", WAL."Lot No.");
        ReservationEntry.SETRANGE("Location Code", WAL."Location Code");
        ReservationEntry.SETRANGE("Manufacturing Date", WAL."Manufacturing Date");
        IF ReservationEntry.FINDFIRST THEN BEGIN
            ReservationEntry.VALIDATE("Quantity (Base)", (ReservationEntry."Quantity (Base)" - TolQty));
            ReservationEntry.MODIFY;
        END;
    END;



    var
        QtyAvail: Decimal;
        QtyOutstanding: Decimal;
        AvailableQty: Decimal;
        RecUOM1: Record 5404;
        RecUOM: Record 5404;
        RecItem2: Record 27;
        Today_Date: Date;
        QtyToHandle: Decimal;
        RecSalesAndReceivableSetup: Record 311;
        ToleranceQty: Decimal;
        Text021: Label '"Do you want to change SO/Pick List Qty. In KG "';
        RecWAL: Record 5767;
        RecSH: Record 36;
        RecSL: Record 37;
        SalesLineQty: Decimal;
        RecPostInvPickLine: Record 7343;
        PostPickLineQty: Decimal;
        LineNo: Integer;
        RecInvPickLine: Record 5767;
        PickLineQty: Decimal;
        RecItem: Record 27;
        Caption: Text[100];
        RecILE: Record 32;
        TotalILEQty: Decimal;
        LotToleranceQty: Decimal;
        FinLotQty: Decimal;
        FinToleranceQty: Decimal;
        RecReasonCode: Record 231;
        Location: Record 14;
        WareActHdr: Record "Warehouse Activity Header";
        WareActLine: Record "Warehouse Activity Line";
}

