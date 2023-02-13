pageextension 50019 "Sales_order_subform_ext" extends "Sales Order Subform"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    layout
    {

        //Unsupported feature: CodeModification on "Control 2.OnValidate". Please convert manually.
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                IF Type = Type::Item then
                    Error('You can not Change the unit price for Item type');
            end;
        }
        Modify("TCS Nature of Collection")
        {
            Editable = EditableNew;
        }
        modify(Description)
        {
            Editable = false;
        }

        modify("HSN/SAC Code")
        {
            Editable = false;
        }
        modify("GST Group Code")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Unit of Measure Code")
        {
            Editable = false;
        }
        modify("Tax Area Code")
        {
            Editable = false;
        }
        modify("Tax Group Code")
        {
            Editable = false;
        }


        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                IF SalesHeader.GET("Document Type", "Document No.") THEN
                    "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";//ccit san


                // IF Type = Type::Item then
                //     UnitPriceEdit := false
                // else
                //     UnitPriceEdit := true;



            end;
        }
        //<<PCPL/NSW/19May22
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                IF SalesHeader.GET("Document Type", "Document No.") THEN begin
                    "Location Code" := SalesHeader."Location Code";
                    Modify();
                end;
            end;
        }
        //>>PCPL/NSW/19May22


        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                //--- CCIT-SG

                RecSH.RESET;
                RecSH.SETRANGE("No.", "Document No.");
                IF RecSH.FINDFIRST THEN
                    IF RecLoc1.GET("Location Code") THEN BEGIN
                        IF RecLoc1."Duty Free" = TRUE THEN BEGIN
                            Qty := 0;
                            RecILE.RESET;
                            RecILE.SETRANGE(RecILE.Reserved, TRUE);
                            IF RecILE.FINDSET THEN
                                    REPEAT
                                        Qty := Qty + RecILE."Remaining Quantity";
                                    UNTIL RecILE.NEXT = 0;
                        END
                    END;
                //IF  (Rec.Quantity > Qty) AND ("Location Code" = 'DUTY FREE') THEN

                //--- CCIT-SG

            end;
        }
        //<<PCPL/DM/13June22
        modify("Line Amount")
        {
            Editable = false;
        }
        //>>PCPL/DM/13June22       

        addafter("Unit Price")
        {
            field("Rate In PCS"; "Rate In PCS")
            {
                Editable = false;
                ApplicationArea = all;

            }
            field("Amount In PCS"; "Amount In PCS")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Actual Qty In PCS"; "Actual Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Actual Qty In KG"; "Actual Qty In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Reason For Free Sample"; "Reason For Free Sample")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Available Qty.In PCS"; "Available Qty.In PCS")
            {
                ApplicationArea = all;
                Caption = 'Duty Free Available Qty.In PCS';
                Editable = false;
            }
            field("Available Qty.In KG"; "Available Qty.In KG")
            {
                Caption = 'Duty Free Available Qty.In KG';
                Editable = false;
                ApplicationArea = all;
            }

        }
        addafter("Item Reference No.")
        {
            field("Main Quantity in PCS"; "Main Quantity in PCS")
            {
                Caption = 'Qty In PCS';
                ApplicationArea = all;
                //Editable = false;
            }
            field("Main Quantity in KG"; "Main Quantity in KG")
            {
                BlankZero = true;
                Caption = 'Quantity In KG';
                //ShowMandatory = TypeChosen;
                ApplicationArea = all;
                //Editable = false;
            }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
            field("Customer Price Group"; "Customer Price Group")
            {
                ApplicationArea = all;
                Editable = true;
                trigger OnLookup(var Text: Text): Boolean
                var
                    CPG: Record 6;
                    SP: Record "Sales Price";
                    SPNew: Record "Sales Price";
                    SH: Record 36;

                begin
                    SH.reset;
                    SH.SetRange("No.", "Document No.");
                    IF SH.FindFirst() then;
                    IF "Special Price" = "Special Price"::" " then begin
                        SP.Reset();
                        sp.SetRange("Customer Code", "Sell-to Customer No.");
                        SP.SetRange("Item No.", "No.");
                        SP.SetRange(Block, false);
                        IF SP.FindFirst() then begin
                            IF PAGE.RUNMODAL(50006, SP) = ACTION::LookupOK THEN begin
                                IF SP."Ending Date" < SH."Posting Date" then
                                    Error('Selected Sales price is Expired for Sale price %1', SP."Sales Code");
                                Rec.Validate("Customer Price Group", SP."Sales Code");
                                if SH."Posting Date" < SP."Ending Date" then begin
                                    Rec.validate("Unit Price", SP."Unit Price");
                                End;
                                Rec.validate("Rate In PCS", sp."Conversion Price Per PCS");
                                IF sp.MRP then
                                    "MRP Price" := sp."MRP Price";

                                // SPNew.Reset();
                                // SPNew.SetRange("Item No.", SP."Item No.");
                                // SPNew.SetRange("Sales Code", SP."Sales Code");
                                // SPNew.SetRange(MRP, true);
                                // IF SPNew.FindFirst() then begin
                                //     "MRP Price" := SPNew."MRP Price";
                                //     Modify();
                                // end;

                            end;
                        end;
                    END
                    else
                        if "Special Price" <> "Special Price"::" " then begin
                            SP.Reset();
                            sp.SetRange("Special Price", "Special Price");
                            SP.SetRange("Item No.", "No.");
                            SP.SetRange(Block, false);
                            IF SP.FindFirst() then begin
                                IF PAGE.RUNMODAL(50006, SP) = ACTION::LookupOK THEN begin
                                    IF SP."Ending Date" < SH."Posting Date" then
                                        Error('Selected Sales price is Expired for Sale price %1', SP."Sales Code");
                                    Rec.Validate("Customer Price Group", SP."Sales Code");
                                    if SH."Posting Date" < SP."Ending Date" then begin
                                        Rec.validate("Unit Price", SP."Unit Price");
                                    END;
                                    Rec.validate("Rate In PCS", sp."Conversion Price Per PCS");
                                    IF Sp.MRP then
                                        "MRP Price" := SP."MRP Price";
                                    // SPNew.Reset();
                                    // SPNew.SetRange("Item No.", SP."Item No.");
                                    // SPNew.SetRange("Sales Code", SP."Sales Code");
                                    // SPNew.SetRange(MRP, true);
                                    // IF SPNew.FindFirst() then begin
                                    //     "MRP Price" := SPNew."MRP Price";
                                    //     Modify();
                                    // end;
                                end;
                            end;
                        end;

                end;

                trigger OnValidate()
                var
                    CPG: Record 6;
                    SP: Record "Sales Price";
                    SPNew: Record "Sales Price";
                    SH: Record 36;
                begin
                    //SP.reset;
                    SH.reset;
                    SH.SetRange("No.", "Document No.");
                    IF SH.FindFirst() then;
                    IF "Special Price" = "Special Price"::" " then begin
                        SP.Reset();
                        sp.SetRange("Customer Code", "Sell-to Customer No.");
                        SP.SetRange("Item No.", "No.");
                        SP.SetRange(Block, false);
                        IF Not SP.FindFirst() then begin
                            Error('Please Select proper Custome price Group');
                        end;

                    End else
                        if "Special Price" <> "Special Price"::" " then begin
                            SP.Reset();
                            sp.SetRange("Special Price", "Special Price");
                            SP.SetRange("Item No.", "No.");
                            Sp.SetRange("Sales Code", "Customer Price Group");
                            SP.SetRange(Block, false);
                            IF Not SP.FindFirst() then begin
                                Error('Please Select proper Custome price Group');
                            end;
                        end;

                    SH.reset;
                    SH.SetRange("No.", "Document No.");
                    IF SH.FindFirst() then;
                    IF "Special Price" = "Special Price"::" " then begin
                        SP.Reset();
                        sp.SetRange("Customer Code", "Sell-to Customer No.");
                        SP.SetRange("Item No.", "No.");
                        SP.SetRange(Block, false);
                        SP.SetRange("Sales Code", "Customer Price Group");
                        IF SP.FindFirst() then begin
                            IF SP."Ending Date" < SH."Posting Date" then
                                Error('Selected Sales price is Expired for Sale price %1', SP."Sales Code");
                            Rec.Validate("Customer Price Group", SP."Sales Code");
                            if SH."Posting Date" < SP."Ending Date" then begin
                                Rec.validate("Unit Price", SP."Unit Price");
                            End;
                            Rec.validate("Rate In PCS", sp."Conversion Price Per PCS");
                            IF sp.MRP then
                                "MRP Price" := sp."MRP Price";

                        end;
                    END
                    else
                        if "Special Price" <> "Special Price"::" " then begin
                            SP.Reset();
                            sp.SetRange("Special Price", "Special Price");
                            SP.SetRange("Item No.", "No.");
                            SP.SetRange(Block, false);
                            SP.SetRange("Sales Code", "Customer Price Group");
                            IF SP.FindFirst() then begin
                                IF SP."Ending Date" < SH."Posting Date" then
                                    Error('Selected Sales price is Expired for Sale price %1', SP."Sales Code");
                                Rec.Validate("Customer Price Group", SP."Sales Code");
                                if SH."Posting Date" < SP."Ending Date" then begin
                                    Rec.validate("Unit Price", SP."Unit Price");
                                END;
                                Rec.validate("Rate In PCS", sp."Conversion Price Per PCS");
                                IF Sp.MRP then
                                    "MRP Price" := SP."MRP Price";

                            end;
                        end;
                END;

            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                Editable = false;
                ApplicationArea = all;
            }



        }
        addafter("Unit Price")
        {
            field("MRP Price"; "MRP Price")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        // addafter("Item Reference No.")
        // {

        // }
        addafter(Quantity)
        {
            field("Qty In PCS"; "Conversion Qty")
            {
                Caption = 'Qty In PCS';
                Visible = false;

                trigger OnValidate();
                begin
                    //--- CCIT-SG

                    RecUOM1.RESET;
                    IF RecUOM1.GET("No.", "Unit of Measure Code") THEN BEGIN
                        RecSH.RESET;
                        RecSH.SETRANGE("No.", "Document No.");
                        IF RecSH.FINDFIRST THEN
                            ShipToCode := RecSH."Ship-to Code";
                        Qty := 0;
                        RecILE.RESET;
                        RecILE.SETRANGE(RecILE.Reserved, TRUE);
                        IF RecILE.FINDSET THEN
                            REPEAT
                                    Qty := Qty + RecILE."Remaining Quantity";
                                Qty1 := Qty * RecUOM1.Weight;
                            UNTIL RecILE.NEXT = 0;
                    END;
                    IF (Rec."Conversion Qty" > Qty1) AND (RecILE.Reserved = TRUE) THEN
                        ERROR('Reserved Quantity for Customer is  %1', Qty1);


                    //--- CCIT-SG
                end;
            }
        }
        addafter("Unit of Measure")
        {
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
            }
        }
        addafter("Line Discount %")
        {
            field("Qty. to Invoice In KG"; "Qty. to Invoice In KG")
            {
                Caption = 'Qty. to Invoice In PCS';
                ApplicationArea = all;
            }
            field("Qty. to Ship In KG"; "Qty. to Ship In KG")
            {
                Caption = 'Qty. to Ship In PCS';
                ApplicationArea = all;
            }
            field("Fill Rate %"; "Fill Rate %")
            {
                ApplicationArea = all;
            }
        }

        addafter("Inv. Discount Amount")
        {
            field("Quantity Shipped In KG"; "Quantity Shipped In KG")
            {
                ApplicationArea = all;
                Caption = 'Quantity Shipped In PCS';
                Editable = false;
            }
        }
        addafter("Qty. to Ship")
        {
            field("Quantity Invoiced In KG"; "Quantity Invoiced In KG")
            {
                Caption = 'Quantity Invoiced In PCS';
                ApplicationArea = all;
                Editable = false;
            }
            field("Outstanding Quantity"; "Outstanding Quantity")
            {
                Caption = 'Outstanding Quantity In KG';
                ApplicationArea = all;
                Editable = false;
            }
            field("Outstanding Quantity In KG"; "Outstanding Quantity In KG")
            {
                Caption = 'Outstanding Quantity In PCS';
                Editable = false;
                ApplicationArea = all;
            }
            field("Quarantine Qty In PCS"; "Quarantine Qty In PCS")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Quarantine Qty In KG"; "Quarantine Qty In KG")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }
        addafter("Prepmt Amt Deducted")
        {
            field(FOC; FOC)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales Category"; "Sales Category")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Use Duplication List")
        {
            field("Special Order Purchase No."; "Special Order Purchase No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Special Order Purch. Line No."; "Special Order Purch. Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Brand Name"; "Brand Name")
            {
            }
        }
        addafter("Document No.")
        {
            field(Weight; Weight)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sell-to Customer No."; "Sell-to Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer License No."; "Customer License No.")
            {
                ApplicationArea = all;
            }
            field("Customer License Name"; "Customer License Name")
            {
                ApplicationArea = all;
            }
            field("Customer License Date"; "Customer License Date")
            {
                ApplicationArea = all;
            }
            field("License No."; "License No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }


    var
        Editable: Boolean;
        RecSH: Record 36;
        ShipToCode: Code[10];
        Qty: Decimal;
        RecILE: Record 32;
        RecLoc: Record 14;
        RecSH1: Record 36;
        ShipToCode1: Code[10];
        Qty1: Decimal;
        RecILE1: Record 32;
        RecLoc1: Record 14;
        RecUOM1: Record 5404;
        Cust: Record 18;
        AllowDisc: Boolean;
        SalesHeader: Record 36;
        EditableNew: Boolean;

        UnitPriceEdit: Boolean;





    trigger OnAfterGetCurrRecord();
    begin
        IF SalesHeader.GET("Document Type", "Document No.") THEN
            "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";//ccit 

        // IF Type = Type::Item then
        //     UnitPriceEdit := false
        // else
        //     UnitPriceEdit := true;
    end;




    trigger OnAfterGetRecord();
    var

    begin
        /*//rdk 130719
        //IF Cust.GET(SalesHeader."Sell-to Customer No.") THEN
        IF Cust.GET(Rec."Sell-to Customer No.") THEN//CCIT
          AllowDisc := Cust."Line Discount Allow";//CCIT-TK-071220 LInediscount property called}
          */



        IF Rec."Allow discount" = TRUE THEN BEGIN
            Editable := TRUE
        END ELSE BEGIN
            Editable := FALSE;
        END;

        IF cust.get("Sell-to Customer No.") then begin
            IF cust."194Q Applicable" = cust."194Q Applicable"::Yes then
                EditableNew := false
            else
                EditableNew := true
        end;

    end;


    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        IF SalesHeader.GET("Document Type", "Document No.") THEN
            "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";//ccit san

    end;



    trigger OnOpenPage();
    begin


        IF Rec."Allow discount" = TRUE THEN BEGIN
            Editable := TRUE
        END ELSE BEGIN
            Editable := FALSE;
        END;


        IF cust.get("Sell-to Customer No.") then begin
            IF cust."194Q Applicable" = cust."194Q Applicable"::Yes then
                EditableNew := false
            else
                EditableNew := true
        end;
    end;


    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

