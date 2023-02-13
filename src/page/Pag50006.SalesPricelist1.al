page 50006 "Sales Price list 1"
{
    PageType = List;
    //Editable =true;
    SourceTable = "Sales Price";
    ApplicationArea = all;
    UsageCategory = Lists;
    Caption = 'Fortune-Sales price';



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Sales Code"; "Sales Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                //PCPL/MIG/VR
                // field("Unit Price Per KG"; "Unit Price Per KG")
                // {

                //     CaptionML = ENU = 'Unit Price(KG)',
                //                 ENN = 'Unit Price';
                //     ApplicationArea = All;
                // }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Sales Type"; "Sales Type")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Quantity in KG"; "Quantity in KG")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Quantity in PCS"; "Quantity in PCS")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                //PCPL/MIG/VR
                //field("MRP Price"; "MRP Price")
                //{                    
                //}
                //field(MRP; MRP)
                //{
                //}
                //field("Abatement %"; "Abatement %")
                //{
                //}
                //field("PIT Structure"; "PIT Structure")
                //{
                //}
                field("Price Inclusive of Tax"; "Price Inclusive of Tax")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Discount %"; "Discount %")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Customer Code"; "Customer Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("List Price"; "List Price")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }

                field("Conversion UOM"; "Conversion UOM")
                {
                    ApplicationArea = all;
                    Caption = 'Conversion UOM(PCS/CASE)';
                }
                field(Block; Block)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Special Price"; "Special Price")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Conversion Price Per PCS"; "Conversion Price Per PCS")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Monthly Qty in Kgs"; "Monthly Qty in Kgs")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Target Qty in Kgs"; "Target Qty in Kgs")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Total Sales Qty in Kgs"; "Total Sales Qty in Kgs")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Monthly Qty in PCs"; "Monthly Qty in PCs")
                {

                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Target Qty in PCs"; "Target Qty in PCs")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Total Sales Qty in PCs"; "Total Sales Qty in PCs")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Line Updated On"; "Line Updated On")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Line Updated By"; "Line Updated By")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Reason Desc"; "Reason Desc")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Ref. Expiry Date"; "Ref. Expiry Date")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field("Gen.Bus.Posting Group"; "Gen.Bus.Posting Group")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("MRP Price"; "MRP Price")
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }
                field(MRP; MRP)
                {
                    ApplicationArea = all;
                    Editable = Vedit;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            //Caption1 = 'Process';
            action("SP Blocked")
            {
                Caption = 'SP Blocked';
                ApplicationArea = all;

                trigger OnAction();
                begin
                    //CCIT_TK-01-0421
                    SalesPrice.RESET;
                    SalesPrice.COPYFILTERS(Rec);
                    IF SalesPrice.FINDSET THEN BEGIN
                        REPEAT
                            SalesPrice.Block := TRUE;
                            SalesPrice.MODIFY;
                        UNTIL SalesPrice.NEXT = 0;
                    END
                end;

            }


            action("SP UNBlocked")
            {
                Caption = 'SP UNBlocked';

                trigger OnAction();
                begin
                    //CCIT_TK-01-0421
                    SalesPrice1.RESET;
                    SalesPrice1.COPYFILTERS(Rec);
                    IF SalesPrice1.FINDSET THEN BEGIN
                        REPEAT
                            SalesPrice1.Block := FALSE;
                            SalesPrice1.MODIFY;
                        UNTIL SalesPrice1.NEXT = 0;
                    END;
                end;
            }
            action("Update Sales Quantity")
            {

                trigger OnAction();
                begin
                    SP.RESET;
                    SP.SETFILTER("Monthly Qty in Kgs", '<>%1', 0);
                    IF SP.FINDSET THEN
                        REPEAT
                            SP."Total Sales Qty in Kgs" := 0;
                            PSL.RESET;
                            PSL.SETRANGE(PSL."Sell-to Customer No.", SP."Customer Code");
                            PSL.SETRANGE(PSL."No.", SP."Item No.");
                            PSL.SETRANGE(PSL."Customer Price Group", SP."Sales Code");
                            PSL.SETFILTER(PSL."Posting Date", '>=%1', SP."Starting Date");
                            //  PSL.SETFILTER("Posting Date", '<=%1', SP."Ending Date");//   //PCPL/MIG/VR
                            IF PSL.FINDSET THEN
                                REPEAT
                                    SP."Total Sales Qty in Kgs" += PSL.Quantity;
                                UNTIL PSL.NEXT = 0;
                            SP.MODIFY;
                        UNTIL SP.NEXT = 0;

                end;
            }
            action(Blocked)
            {

                trigger OnAction();
                begin
                    //CCIT_TK-01-0421
                    SalesPrice.RESET;
                    SalesPrice.COPYFILTERS(Rec);
                    IF SalesPrice.FINDSET THEN BEGIN
                        REPEAT
                            SalesPrice.Block := TRUE;
                            SalesPrice.MODIFY;
                        UNTIL SalesPrice.NEXT = 0;
                    END;
                end;
            }
            action(UNBlocked)
            {

                trigger OnAction();
                begin
                    //CCIT_TK-01-0421
                    SalesPrice1.RESET;
                    SalesPrice1.COPYFILTERS(Rec);
                    IF SalesPrice1.FINDSET THEN BEGIN
                        REPEAT
                            SalesPrice1.Block := FALSE;
                            SalesPrice1.MODIFY;
                        UNTIL SalesPrice1.NEXT = 0;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF Block = TRUE THEN
            BlockHide := FALSE
        ELSE
            BlockHide := TRUE;

        /*//CCIT
        RecCust.RESET;
        RecCust.SETRANGE(RecCust."No.",Rec."Customer Code");
        IF RecCust.FINDSET THEN
          REPEAT
            "Gen.Bus.Posting Group" := RecCust."Gen. Bus. Posting Group";
             Rec.MODIFY;
          UNTIL RecCust.NEXT=0;
        //*/

    end;

    trigger OnInit();
    begin
        //BlockHide := TRUE;
    end;

    trigger OnModifyRecord(): Boolean;
    begin

        //>>PCPL/NSW/07  29June22
        IF (UserSetup.GET(USERID)) AND (NOT UserSetup."Sales Price Permission") THEN
            ERROR('You do not have permission to modify sales price. ');
        //<<PCPL/NSW/07  29June22

        //CCIT-TK-121219 Start
        RecCust.RESET;
        RecCust.SETRANGE(RecCust."No.", Rec."Customer Code");
        IF RecCust.FINDFIRST THEN
            REPEAT
                Rec."Gen.Bus.Posting Group" := RecCust."Gen. Bus. Posting Group";
                Rec.MODIFY;
            UNTIL RecCust.NEXT = 0;
        //CCIT-TK-121219 Start
    end;

    trigger OnOpenPage();
    begin

        //>>PCPL/NSW/07  29June22
        IF UserSetup.GET(USERID) then begin
            IF (UserSetup."Sales Price Permission") THEN
                Vedit := true
            else
                Vedit := false;
        end;

        //<<PCPL/NSW/07  29June22
        /*//CCIT-SG-14062018
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
        IF RecUserBranch.FINDFIRST THEN
          REPEAT
            LocCode := LocCode + RecUserBranch."Location Code" + '|';
          UNTIL RecUserBranch.NEXT=0 ;
        LocCodeText := DELSTR(LocCode,STRLEN(LocCode),1);
        IF LocCodeText <> '' THEN BEGIN
          SETFILTER("Location Code",LocCodeText);
        END;
        //CCIT-SG-14062018*/

        //CCIT
        /*RecCust.RESET;
        RecCust.SETRANGE(RecCust."No.",Rec."Customer Code");
        //IF RecCust.FINDSET THEN
        IF RecCust.FINDFIRST THEN //CCIT-TK
          REPEAT
            Rec."Gen.Bus.Posting Group" := RecCust."Gen. Bus. Posting Group";
             Rec.MODIFY;
          UNTIL RecCust.NEXT=0;
        //*/

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        //CCIT-SG-31072018
        //TESTFIELD("Starting Date");//tk 150420
        //TESTFIELD("Ending Date");//tk 150420
        //TESTFIELD("Unit of Measure Code");//tk 150420
        //TESTFIELD("Location Code");
        //TESTFIELD("Conversion Price Per PCS");//tk 150420
        //CCIT-SG-31072018
    end;

    var
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record "User Branch Table";
        BlockHide: Boolean;
        PSL: Record "Sales Invoice Line";
        PSCM: Record "Sales Cr.Memo line";
        SP: Record "Sales Price";
        RecCust: Record "Customer";
        SalesPrice: Record "Sales Price";
        SalesPrice1: Record "Sales Price";
        UserSetup: Record 91;
        Vedit: Boolean;
}

