pageextension 50026 "Purch_Inv_Subform_ext" extends "Purch. Invoice Subform"
{
    // version NAVW19.00.00.48992,NAVIN9.00.00.48992

    layout
    {

        modify("GST Group Code")
        {
            Editable = true;

        }


        modify(Type)
        {
            trigger OnAfterValidate();
            begin
                //11-06-2019
                IF Type = Type::Item THEN
                    Type_Editable := FALSE
                ELSE
                    Type_Editable := TRUE;

            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate();
            begin
                //11-06-2019
                IF Type = Type::Item THEN
                    ERROR('You cannot enter Item in Invoice');


            end;
        }

        addbefore("TDS Section Code")
        {
            field("TDS Section"; "TDS Section")
            {
                ApplicationArea = all;
                Visible = TDSSecVisible;

            }
        }
        addafter(Description)
        {
            field("Bill Of Entry No."; "Bill Of Entry No.")
            {
                ApplicationArea = all;

            }
            // field("HSN/SAC Code"; "HSN/SAC Code")
            // {
            //     ApplicationArea = all;
            //     Editable = true;
            //     TableRelation = "HSN/SAC".Code where("GST Group Code" = field("GST Group Code"));
            //     trigger OnValidate()
            //     var
            //         CalculateTax: Codeunit "Calculate Tax";
            //     begin
            //         CurrPage.SaveRecord();
            //         CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);
            //     end;

            //     // trigger OnLookup(var Text: Text): Boolean
            //     // Var
            //     //     HSNSAC: Record "HSN/SAC";
            //     //     CalculateTax: Codeunit "Calculate Tax";
            //     // begin
            //     //     HSNSAC.Reset();
            //     //     HSNSAC.SetRange("GST Group Code", "GST Group Code");
            //     //     IF HSNSAC.FindFirst() then
            //     //         IF PAGE.RUNMODAL(18005, HSNSAC) = ACTION::LookupOK THEN begin
            //     //             "HSN/SAC Code" := HSNSAC.Code;
            //     //             CurrPage.SaveRecord();
            //     //             CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);
            //     //         end;
            //     // end;



            // }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = all;
            // }
            // field("Description 2"; "Description 2")
            // {
            //     ApplicationArea = all;
            // }
        }
        addafter("Return Reason Code")
        {
            field("Inv. Disc. Amount to Invoice"; "Inv. Disc. Amount to Invoice")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {

            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
        }
        addafter("Unit Price (LCY)")
        {
            field("TCS Nature of Collection"; "TCS Nature of Collection")
            {
                ApplicationArea = all;
            }
        }


        addafter("Depr. Acquisition Cost")
        {
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                Caption = 'Saleable Qty. In KG';
                ApplicationArea = all;
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                Caption = 'Damage Qty. In KG';
                ApplicationArea = all;
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                Caption = 'Saleable Qty. In PCS';
                ApplicationArea = all;
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                Caption = 'Damage Qty. In PCS';
                ApplicationArea = all;
            }
            field("BOE Qty.In PCS"; "BOE Qty.In PCS")
            {
                Caption = 'BOE Qty.In KG';
                ApplicationArea = all;
            }
            field("BOE Qty.In KG"; "BOE Qty.In KG")
            {
                Caption = 'BOE Qty.In PCS';
                ApplicationArea = all;
            }

            field("TCS %"; "TCS %")
            {
                ApplicationArea = all;
            }
            field("TCS Base Amount"; "TCS Base Amount")
            {
                ApplicationArea = all;
            }
            field("TCS Type"; "TCS Type")
            {
                ApplicationArea = all;
            }
            field("Purchase Amount"; "Purchase Amount")
            {
                ApplicationArea = all;
            }
            field("Price Inclusive of Tax"; "Price Inclusive of Tax")
            {
                ApplicationArea = all;
            }
            field("GST On Assessable Value"; "GST On Assessable Value")
            {
                ApplicationArea = all;
            }
            field("GST Assessable Value (LCY)"; "GST Assessable Value (LCY)")
            {
                ApplicationArea = all;
            }
            field("TCS Amount"; "TCS Amount")
            {
                ApplicationArea = all;
            }


        }
        addafter("Item Reference No.")
        {
            field("GST Reverse Charge"; "GST Reverse Charge")
            {
                Editable = true;
                Visible = true;
            }
            field("Non-GST Line"; "Non-GST Line")
            {
                Editable = true;
                Visible = true;
            }
        }


    }
    actions
    {
        addafter("&Line")
        {
            action("Insert New Line")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    RecPL: Record 39;
                    RecPurchLine: Record 39;
                    InitPurchLine: Record 39;
                    Vend: Record Vendor;
                    CalculateTax: Codeunit "Calculate Tax";
                begin
                    IF Vend.Get("Buy-from Vendor No.") then;
                    IF Vend."GST Custom House" then begin
                        CurrPage.SetSelectionFilter(RecPL);
                        RecPL.SetRange(Type, RecPL.Type::"G/L Account");
                        IF RecPL.FindFirst() then begin
                            RecPurchLine.Reset();
                            RecPurchLine.SetRange("Document No.", RecPL."Document No.");
                            RecPurchLine.SetRange("Document Type", RecPL."Document Type");
                            IF RecPurchLine.FindLast() then begin
                                InitPurchLine.Init();
                                InitPurchLine.TransferFields(RecPurchLine);
                                InitPurchLine."Line No." := RecPurchLine."Line No." + 10000;
                                InitPurchLine.Validate("Direct Unit Cost", -(RecPurchLine."Direct Unit Cost"));
                                InitPurchLine.Exempted := true;
                                CalculateTax.CallTaxEngineOnPurchaseLine(InitPurchLine, xRec);
                                InitPurchLine.Insert(True);
                                Message('New Line Inserted Successfully with Line No. %1', InitPurchLine."Line No.");
                            end;
                        end else
                            Error('You can only Insert Line when Type is "G/L Account".');
                    end
                    else
                        Error('You are not allowed to Insert new line beacuse GST Custom House is not activate for Vendor %1', Vend."No.");

                end;

            }
            // action("Delete Line")
            // {
            //     ApplicationArea = all;
            //     trigger OnAction()
            //     var
            //         PurchLine: Record 39;
            //         DeletePurchLine: Record 39;
            //     begin
            //         CurrPage.SetSelectionFilter(PurchLine);
            //         IF PurchLine.FindFirst() then begin
            //             DeletePurchLine.Reset();
            //             DeletePurchLine.SetRange("Document No.", PurchLine."Document No.");
            //             DeletePurchLine.SetRange("Line No.", PurchLine."Line No.");
            //             IF DeletePurchLine.FindFirst() then
            //                 DeletePurchLine.Delete(True);
            //             Message('Selected line Deleted Succesfully');
            //         end;

            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    var
        Vend: Record Vendor;
    Begin
        Clear(TDSSecVisible);
        IF Vend.Get("Buy-from Vendor No.") then begin
            IF Vend."Applicability of 206AB" = Vend."Applicability of 206AB"::"Not Comply" then
                TDSSecVisible := True
            else
                TDSSecVisible := false;
        END;
    End;

    trigger OnAfterGetRecord()
    var
        Vend: Record Vendor;
        TaxRecordID: RecordId;
        ComponentJobject: JsonObject;
        TDSAmt: Decimal;
        PurchLine: Record 39;
        NewPurchLine: Record 39;
    Begin
        Clear(TDSSecVisible);
        IF Vend.Get("Buy-from Vendor No.") then begin
            IF Vend."Applicability of 206AB" = Vend."Applicability of 206AB"::"Not Comply" then
                TDSSecVisible := True
            else
                TDSSecVisible := false;
        END;

        // NewPurchLine.Reset();
        // NewPurchLine.SetRange("Document No.", "Document No.");
        // NewPurchLine.SetRange("Line No.", "Line No.");
        // if NewPurchLine.FindFirst() then
        //     TaxRecordID := NewPurchLine.RecordId();
        // // IF PurchLine.GET(NewPurchLine."Document No.", NewPurchLine."Line No.") then


        // TDSAmt := GetTDSAmtLineWise(TaxRecordID, ComponentJobject);
        // Message('%1', TDSAmt);
    END;

    // local procedure GetTDSAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    // var
    //     TaxTransactionValue: Record "Tax Transaction Value";
    //     TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
    //     ComponentAmt: Decimal;
    //     JArray: JsonArray;
    //     ComponentJObject: JsonObject;
    // begin
    //     if not GuiAllowed then
    //         exit;

    //     TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
    //     TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
    //     TaxTransactionValue.SetRange("Visible on Interface", true);
    //     TaxTransactionValue.SetRange("Tax Type", 'TDS');
    //     if TaxTransactionValue.FindFirst() then
    //         //repeat
    //         begin
    //         Clear(ComponentJObject);
    //         //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
    //         //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
    //         ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
    //         //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
    //         JArray.Add(ComponentJObject);
    //     end;
    //     //        TCSAMTLinewise := ComponentAmt;
    //     //until TaxTransactionValue.Next() = 0;
    //     exit(ComponentAmt)

    // end;

    var
        Type_Editable: Boolean;
        TDSSecVisible: Boolean;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    local procedure UpdateTaxAmount()
    var
        CalculateTax: Codeunit "Calculate Tax";
    begin
        CurrPage.SaveRecord();
        CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

