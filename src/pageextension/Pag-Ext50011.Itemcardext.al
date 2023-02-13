pageextension 50011 "Item_card_ext" extends "Item Card"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,CCIT-Fortune

    layout
    {

        modify("Safety Stock Quantity")
        {
            Visible = false;

        }
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                CaptionML = ENU = 'Vendor Descrption',
                            ENN = 'Description 2';
                ApplicationArea = all;
            }
        }
        addbefore(Blocked)
        {
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Base Unit of Measure")
        {

            field("Conversion UOM"; "Conversion UOM")
            {
                ApplicationArea = all;
            }

            field("Product Type"; "Product Type")
            {
            }
        }
        addafter("Search Description")
        {
            field("Conversion Inventory In KG"; "Conversion Inventory")
            {
                ApplicationArea = all;
                Caption = 'Conversion Inventory In PCS';
            }
        }
        addafter("Qty. on Purch. Order")
        {
            field("Purchase Order Conversion"; "Purchase Order Conversion")
            {
                ApplicationArea = all;
            }
        }
        addafter("Qty. on Sales Order")
        {
            field("Sales Order Conversion"; "Sales Order Conversion")
            {
                ApplicationArea = all;
            }
        }

        addafter(PreventNegInventoryDefaultNo)
        {
            field("Sales Category"; "Sales Category")
            {
                ApplicationArea = all;
            }
            field("Parent item"; "Parent item")
            {
                ApplicationArea = all;
            }
            field("Launch Month"; "Launch Month")
            {
                ApplicationArea = all;
            }
            field("Brand Name"; "Brand Name")
            {
                ApplicationArea = all;
            }
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
            }
            field("Storage Temperature"; "Storage Temperature")
            {
                ApplicationArea = all;
            }
            field(Tolerance; Tolerance)
            {
                ApplicationArea = all;
            }
            field("Custom Duty Per"; "Custom Duty Per")
            {
                ApplicationArea = all;
            }
            field("Surcharge Per"; "Surcharge Per")
            {
                ApplicationArea = all;
            }
            field("Safety Stock"; "Safety Stock")
            {
            }
        }
        addafter("Standard Cost")
        {
            field("Unit Cost In PCS"; "Unit Cost In PCS")
            {
                ApplicationArea = all;
            }
        }
        addafter(Exempted)
        {
            field("EAN Code No."; "EAN Code No.")
            {
                ApplicationArea = all;
            }
            field("EAN Code"; "EAN Code")
            {
                ApplicationArea = all;
            }
        }
        addafter(Reserve)
        {
            field("Reserved Qty. on Sales Orders"; "Reserved Qty. on Sales Orders")
            {
                ApplicationArea = all;
            }
            field("Res. Qty. on Outbound Transfer"; "Res. Qty. on Outbound Transfer")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        RecItem2: Record 27;
        RecUOM: Record 5404;
        UserSetup: Record 91;


    trigger OnModifyRecord(): Boolean
    begin
        //>>PCPL/NSW/07  29June22
        IF (UserSetup.GET(USERID)) AND (NOT UserSetup."Item Card Permission") THEN
            ERROR('You do not have permission to modify item card ');
        //<<PCPL/NSW/07  29June22
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

