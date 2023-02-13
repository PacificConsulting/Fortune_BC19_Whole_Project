pageextension 50095 "Invt_Put_away_Subf_ext" extends "Invt. Put-away Subform"
{
    // version NAVW19.00.00.45778,CCIT-Fortune

    layout
    {

        modify("Lot No.")
        {
            Editable = HideLotNo;
        }
        modify(Description)
        {

            //Unsupported feature: Change Name on "Control 30". Please convert manually.

            CaptionML = ENU = 'Fortune Description', ENN = 'Description';
        }
        modify(Quantity)
        {

            //Unsupported feature: Change Name on "Control 34". Please convert manually.

            CaptionML = ENU = 'BTO Qty. In KG', ENN = 'Quantity';
        }
        modify("Qty. to Handle")
        {

            //Unsupported feature: Change Name on "Control 20". Please convert manually.

            CaptionML = ENU = 'GRN Qty. In KG', ENN = 'Qty. to Handle';
        }
        modify("Qty. Handled")
        {
            CaptionML = ENU = 'Qty. Handled In KG-WH', ENN = 'Qty. Handled';
        }
        modify("Qty. Outstanding")
        {
            CaptionML = ENU = 'Qty. Outstanding In KG', ENN = 'Qty. Outstanding';
        }

        modify("Expiration Date")
        {
            Editable = HideMfgDate;
            trigger OnAfterValidate()
            begin
                //CCIT-JAGA 03/11/2018
                //TESTFIELD("Manufacturing Date");
                //VALIDATE("Manufacturing Date");
                IF "Expiration Date" <> 0D then
                    IF "Expiration Date" < "Warranty Date" THEN
                        ERROR('Po Expiry Date should be Greater than Manufacturing Date');
                //CCIT-JAGA 03/11/2018

            end;
        }

        addafter("Variant Code")
        {
            field("Vendor Description"; "Description 2")
            {
                CaptionML = ENU = 'Vendor Description',
                            ENN = 'Description 2';
                ApplicationArea = all;
            }
        }
        addafter("Serial No.")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Expiration Date")
        {
            field("Manufacturing Date"; "Manufacturing Date")
            {
                Caption = 'Manufacturing Date';
                Editable = true;
                Enabled = true;
                Visible = false;
                ApplicationArea = all;
            }
            field("Warranty Date"; "Warranty Date")
            {
                Caption = 'Manufacturing Date';
                Editable = HideLotNo;
                Enabled = true;
                // Visible = false;
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    IF "Expiration Date" <> 0D then
                        IF "Expiration Date" < "Warranty Date" THEN
                            ERROR('Expiration Date Should not be less than Manufacturing Date');

                end;
            }
        }
        addafter("Bin Code")
        {
            field("HS Code"; "HS Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Qty. to Handle")
        {
            field("Conversion Qty To Handle"; "Conversion Qty To Handle")
            {
                ApplicationArea = all;
                Caption = 'GRN Qty In PCS';
                DecimalPlaces = 0 : 5;
            }
        }
        addafter(Quantity)
        {
            field("PO Qty. In KG"; "Conversion Qty")
            {
                Caption = 'BTO Qty. In PCS';
                Editable = false;
                ApplicationArea = all;
            }


            field("Qty. Handled In KG"; "Qty. Handled In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. Handled In PCS-WH';
            }

            field("Qty. Outstanding In KG"; "Qty. Outstanding In KG")
            {
                ApplicationArea = all;
                Caption = 'Qty. Outstanding In PCS';
            }
            field("Damage Qty. In PCS"; "Damage Qty. In PCS")
            {
                ApplicationArea = all;
                Caption = 'Varinance Qty. In KG';
            }
            field("Damage Qty. In KG"; "Damage Qty. In KG")
            {
                ApplicationArea = all;
                Caption = 'Variance Qty. In PCS';
            }
            field("Saleable Qty. In PCS"; "Saleable Qty. In PCS")
            {
                ApplicationArea = all;
                Caption = 'Saleable Qty. In KG';
            }
            field("Saleable Qty. In KG"; "Saleable Qty. In KG")
            {
                ApplicationArea = all;
                Caption = 'Saleable Qty. In PCS';
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
        addafter("Qty. Outstanding (Base)")
        {
            field("Gen.Prod.Post.Group"; "Gen.Prod.Post.Group")
            {
                ApplicationArea = all;
            }

        }
        addafter("Special Equipment Code")
        {
            field("PO Lot No."; "PO Lot No.")
            {
                ApplicationArea = all;
            }
            field("PO Expiration Date"; "PO Expiration Date")
            {
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    //CCIT-JAGA 03/11/2018
                    TESTFIELD("PO Manufacturing Date");
                    VALIDATE("PO Manufacturing Date");
                    IF "PO Expiration Date" < "PO Manufacturing Date" THEN
                        ERROR('Po Expiry Date should be Greater than PO Manufacturing Date');
                    //CCIT-JAGA 03/11/2018
                end;
            }
            field("PO Manufacturing Date"; "PO Manufacturing Date")
            {
                ApplicationArea = all;
            }
            field(Weight1; Weight1)
            {
                ApplicationArea = all;
            }
            field("Actual Batch"; "Actual Batch")
            {
                ApplicationArea = all;
            }
            field("Actual MFG Date"; "Actual MFG Date")
            {
                ApplicationArea = all;
            }
            field("Actual EXP Date"; "Actual EXP Date")
            {
                ApplicationArea = all;
            }
            field("Actual Batch PCS"; "Actual Batch PCS")
            {
                ApplicationArea = all;
            }
            field("Actual Batch KGS"; "Actual Batch KGS")
            {
                ApplicationArea = all;
            }
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {

        //Unsupported feature: PropertyDeletion on "SplitWhseActivityLine(Action 1901991804)". Please convert manually.

    }

    var
        HideLotNo: Boolean;
        HideMfgDate: Boolean;


    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin
        //CCIT-SG-26072018
        IF "Source Document" = "Source Document"::"Inbound Transfer" THEN BEGIN
            HideLotNo := false;//FALSE; //PCPL/MIG/NSW
            HideMfgDate := false;//FALSE; //PCPL/MIG/NSW
        END ELSE BEGIN
            HideLotNo := TRUE;
            HideMfgDate := TRUE;
        END;
        //CCIT-SG-26072018    
    end;

    //Unsupported feature: CodeInsertion on "OnOpenPage". Please convert manually.

    trigger OnOpenPage();
    begin
        //CCIT-SG-26072018
        IF "Source Document" = "Source Document"::"Inbound Transfer" THEN BEGIN
            HideLotNo := false;//FALSE; //PCPL/MIG/NSW
            HideMfgDate := false;//FALSE; //PCPL/MIG/NSW
        END ELSE BEGIN
            HideLotNo := TRUE;
            HideMfgDate := TRUE;
        END;
        //CCIT-SG-26072018    
    end;



}

