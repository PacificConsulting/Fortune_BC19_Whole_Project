pageextension 50083 "Item_Tracking_Lines_ext" extends "Item Tracking Lines"
{
    // version NAVW19.00.00.48822,NAVIN9.00.00.48822,CCIT-Fortune

    layout
    {
        modify("Warranty Date")
        {
            Caption = 'Manufacturing Date';
            Editable = true;
            Enabled = true;
            Visible = true;
            trigger OnAfterValidate()
            begin
                IF "Expiration Date" <> 0D then begin
                    IF "Warranty Date" > "Expiration Date" then begin
                        Error('Expiration date must be greater than Manufacturing date');
                    end;
                end;
            end;
        }
        modify("Expiration Date")
        {
            Visible = true;
            Editable = true;
            trigger OnAfterValidate()
            begin
                IF "Warranty Date" <> 0D then begin
                    IF "Warranty Date" > "Expiration Date" then begin
                        Error('Expiration date must be greater than Manufacturing date');
                    end;
                end;
            end;
        }

        modify("Quantity (Base)")
        {
            CaptionML = ENU = 'Quantity (Base) In KG', ENN = 'Quantity (Base)';
        }
        modify("Quantity Handled (Base)")
        {
            CaptionML = ENU = 'Qty. to Handle (Base) In KG', ENN = 'Qty. to Handle (Base)';
        }
        modify("Qty. to Invoice (Base)")
        {
            CaptionML = ENU = 'Qty. to Invoice (Base) In KG', ENN = 'Qty. to Invoice (Base)';
        }
        modify("Quantity Invoiced (Base)")
        {
            CaptionML = ENU = 'Quantity Invoiced (Base) In KG', ENN = 'Quantity Invoiced (Base)';
        }

        modify("New Expiration Date")
        {
            Editable = true;
        }

        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                //>> CS
                IF ("Expiration Date" <> 0D) AND ("Manufacturing Date" <> 0D) THEN
                    IF ("Expiration Date" - WORKDATE) / ("Expiration Date" - "Manufacturing Date") * 100 < MinShelfLife THEN
                        ERROR(MinShelfLifeErr, MinShelfLife, ROUND(("Expiration Date" - WORKDATE) / ("Expiration Date" - "Manufacturing Date") * 100), 0.01);
                //<< CS
                //vikas
                /* //PCPL/MIG/NSW  Temp Code Comment
                IF "Lot No." <> '' THEN BEGIN
                    ILE.RESET;
                    ILE.SETRANGE("Lot No.", "Lot No.");
                    ILE.SETFILTER("Posting Date", '>%1', 20201031D); //103120D
                    ILE.SETFILTER("Remaining Quantity", '>%1', 0);
                    ILE.SETRANGE("Location Code", "Location Code");
                    IF NOT ILE.FIND('-') THEN
                        ERROR('You are not allow to select this lot no.');
                END; //CCIT 
                */ //PCPL/MIG/NSW  Temp Code Comment
                   //PCPL/MIG/NSW  Temp Code Comment
                   // IF "Lot No." <> '' THEN BEGIN
                   //     ILE.RESET;
                   //     ILE.SETRANGE("Lot No.", "Lot No.");
                   //     ILE.SETFILTER("Posting Date", '>%1', 20201031D); //103120D
                   //     ILE.SETFILTER("Remaining Quantity", '>%1', 0);
                   //     ILE.SETRANGE("Location Code", "Location Code");
                   //     IF ILE.FindFirst() THEN begin
                   //         "Expiration Date" := ILE."Expiration Date";
                   //         Modify();
                   //     end;

                // END; //CCIT 
                //      //PCPL/MIG/NSW  Temp Code Comment
            end;
        }



        addafter("New Lot No.")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("New Manufacturing Date"; "New Manufacturing Date")
            {
                ApplicationArea = all;
            }

        }
        addafter("Location Code")
        {
            field("Qty. to Handle (Base) In KG"; "Qty. to Handle (Base) In KG")
            {
                Caption = 'Qty. to Handle (Base) In PCS';
                Editable = QtytoHandleBaseInKGEditable;
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    //    F6LookupAvailable
                end;
            }
        }
        addafter("Appl.-to Item Entry")
        {
            field("Remainig Qty. In KG"; "Remainig Qty. In KG")
            {
                Caption = 'Remainig Qty. In PCS';
                Editable = RemainigQtyInKGEditable;
                ApplicationArea = all;
            }
            field("PO Lot No."; "PO Lot No.")
            {

                ApplicationArea = all;
                trigger OnValidate();
                begin
                    UpdateData; //CITS-SD-26-12-17
                end;
            }
            field("PO Expiration Date"; "PO Expiration Date")
            {
                ApplicationArea = all;
                trigger OnValidate();
                begin
                    UpdateData; //CITS-SD-26-12-17
                end;
            }
            field("PO Manufacturing Date"; "PO Manufacturing Date")
            {
                ApplicationArea = all;
                trigger OnValidate();
                begin
                    UpdateData; //CITS-SD-26-12-17
                end;
            }
        }
    }


    var
        ILE: Record 32;
        MfgDate: Date;
        [InDataSet]
        "New Manufacturing DateEditable": Boolean;
        [InDataSet]
        "Manufacturing DateEditable": Boolean;
        [InDataSet]
        "New Manufacturing DateVisible": Boolean;
        MinShelfLife: Decimal;
        MinShelfLifeErr: Label '"Shelf life should not be less than %1 %. For current selection remaining shelf life is %2 % "';
        RecItem: Record 27;
        RecUOM1: Record 5404;
        QtytoHandleBaseInKGEditable: Boolean;
        RemainigQtyInKGEditable: Boolean;
        "QtytoHandleBaseInKG DateVisible": Boolean;
        "RemainigQtyInKGE DateVisible": Boolean;
        POLotNoEditable: Boolean;
        POManufacEditable: Boolean;
        POExpdateEditable: Boolean;
        Today_Date: Date;
        SalesSetup: Record 311;
        RecSIH: Record 112;
        RecSH: Record 38;


    //Unsupported feature: CodeModification on "OnAfterGetCurrRecord". Please convert manually.

    trigger OnAfterGetCurrRecord();
    begin
        /*
        {
        Today_Date := TODAY + 1;
        IF "Expiration Date" = Today_Date THEN
           ERROR('Batch near to Expire');
        }
        */
        //CCIT-SG-02062018
        RecSIH.RESET;
        RecSIH.SETRANGE(RecSIH."Order No.", Rec."Source ID");
        IF RecSIH.FINDFIRST THEN BEGIN
            RecSH.RESET;
            RecSH.SETRANGE(RecSH."Applies-to Doc. No.", RecSIH."No.");
            IF RecSH.FINDFIRST THEN BEGIN
                IF NOT (RecSH."Document Type" = RecSH."Document Type"::"Return Order") THEN BEGIN
                    Today_Date := TODAY + 1;
                    IF "Expiration Date" = Today_Date THEN
                        ERROR('Batch near to Expire');
                END;
            END;
        END;
        //CCIT-SG-02062018

    end;

    trigger OnOpenPage()
    var
        ILE: Record 32;
        RES: Record 337;
        IOM: Record 5404;
    begin
        // <<PCPL/NSW/07  15June22 New Code added Due to multiple Lot assign Exp Date Get Blank
        Res.RESET;
        Res.SETRANGE("Source ID", "Source ID");
        // Res.SETRANGE("Source Ref. No.", "Source Ref. No.");
        RES.SetFilter("Lot No.", '<>%1', '');
        IF Res.FindSet() THEN
            repeat
                ILE.Reset();
                ILE.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
                  "Lot No.", "Serial No.");
                ILE.SetRange("Item No.", RES."Item No.");
                ILE.SetRange("Variant Code", res."Variant Code");
                ILE.SetRange(Open, true);
                ILE.SetRange("Location Code", RES."Location Code");
                ILE.SetRange("Lot No.", RES."Lot No.");
                IF ILE.FindLast() then begin
                    // IF Res."Expiration Date" = 0D THEN Begin
                    Res."Expiration Date" := ILE."Expiration Date";
                    Validate("Quantity (Base)");
                    IOM.Reset();
                    IOM.SetRange("Item No.", "Item No.");
                    IF IOM.FindFirst() then begin
                        res.Validate("Qty. to Handle (Base) In KG", "Qty. to Handle (Base) In KG");
                        //res."Qty. to Handle (Base) In KG" := ("Quantity (Base)" / IOM.Weight);
                        //res."Remainig Qty. In KG" := ("Quantity (Base)" / IOM.Weight);
                    end;
                    Res.MODIFY;
                    // end;
                END;
            until res.Next() = 0;
        //>>PCPL/NSW/07  15June22

    end;

    trigger OnClosePage()
    var
        ILE: Record 32;
        RES: Record 337;
        VRes: Record 337;
        IOM: Record 5404;
    begin
        //<<PCPL/NSW/07  15June22 New Code added Due to multiple Lot assign Exp Date Get Blank
        Res.RESET;
        Res.SETRANGE("Source ID", "Source ID");
        RES.SetFilter("Lot No.", '<>%1', '');
        IF Res.FindSet() THEN
            repeat
                VRes.Reset();
                VRes.SETRANGE("Source ID", RES."Source ID");
                VRes.SETRANGE("Source Ref. No.", RES."Source Ref. No.");
                VRes.SetFilter("Lot No.", '<>%1', '');
                IF VRes.FindSet() then
                    repeat
                        ILE.Reset();
                        // ILE.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
                        //   "Lot No.", "Serial No.");
                        ILE.SetRange("Item No.", VRES."Item No.");
                        ILE.SetRange("Variant Code", Vres."Variant Code");
                        ILE.SetRange(Open, true);
                        ILE.SetRange("Location Code", VRES."Location Code");
                        ILE.SetRange("Lot No.", VRES."Lot No.");
                        IF ILE.FindLast() then begin
                            //IF VRes."Expiration Date" = 0D THEN Begin
                            VRes."Expiration Date" := ILE."Expiration Date";
                            Validate("Quantity (Base)");
                            IOM.Reset();
                            IOM.SetRange("Item No.", "Item No.");
                            IF IOM.FindFirst() then begin
                                res.Validate("Qty. to Handle (Base) In KG", "Qty. to Handle (Base) In KG");
                                //res."Qty. to Handle (Base) In KG" := ("Quantity (Base)" / IOM.Weight);
                                //res."Remainig Qty. In KG" := ("Quantity (Base)" / IOM.Weight);
                            end;
                            VRes.MODIFY;
                            //End;
                        END;
                    until VRes.Next() = 0;
            until res.Next() = 0;
        //>>PCPL/NSW/07  15June22
    end;


    // trigger OnAfterGetRecord();
    // var
    //     ILE: Record 32;
    //     RES: Record 337;
    // begin
    //     //>> CS
    //     //ExpirationDateOnFormat;
    //     //<< CS
    //     //<<PCPL/NSW/07  15June22 New Code added Due to multiple Lot assign Exp Date Get Blank
    //     RES.RESET;
    //     RES.SETRANGE("Source ID", "Source ID");
    //     RES.SETRANGE("Source Ref. No.", "Source Ref. No.");
    //     RES.SetFilter("Lot No.", '<>%1', '');
    //     IF RES.FindSet() THEN
    //         repeat
    //             ILE.Reset();
    //             ILE.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking",
    //               "Lot No.", "Serial No.");
    //             ILE.SetRange("Item No.", RES."Item No.");
    //             ILE.SetRange("Variant Code", RES."Variant Code");
    //             ILE.SetRange(Open, true);
    //             ILE.SetRange("Location Code", RES."Location Code");
    //             ILE.SetRange("Lot No.", RES."Lot No.");
    //             IF ILE.FindLast() then begin
    //                 IF RES."Expiration Date" = 0D THEN Begin
    //                     RES."Expiration Date" := ILE."Expiration Date";
    //                     RES.MODIFY;
    //                 End
    //             END;
    //         until RES.Next() = 0;
    //     //>>PCPL/NSW/07  15June22

    // end;

    local procedure UpdateMfgDateEditable();
    begin
        //>> CS
        "Manufacturing DateEditable" :=
          NOT (("Buffer Status2" = "Buffer Status2"::"ExpDate blocked"));//OR (CurrentSignFactor < 0));//PCPL/MIG/NSW
                                                                         //<< CS
    end;

    local procedure ManufacturingDateOnFormat();
    begin
        //>> CS
        UpdateMfgDateColor;
        //<< CS
    end;

    local procedure UpdateMfgDateColor();
    begin
        //>> CS
        //<< CS
    end;

    procedure SetMinShelfLife(_MinShelfLife: Decimal);
    begin
        //>> CS
        MinShelfLife := _MinShelfLife;
        //<< CS
    end;

    local procedure "//CITS-SD"();
    begin
    end;

    local procedure UpdateData();
    begin
        //CITS-SD-26-12-17
        //IF "Lot No." = '' then
        VALIDATE("Lot No.", "PO Lot No.");
        VALIDATE("Expiration Date", "PO Expiration Date");
        VALIDATE("Manufacturing Date", "PO Manufacturing Date");
        //Validate("Warranty Date");
    end;


    //Unsupported feature: PropertyChange. Please convert manually.

}

