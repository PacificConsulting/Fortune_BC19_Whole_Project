pageextension 50005 "Customer_Card_ext" extends "Customer Card"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        addafter("Address 2")
        {
            field("Address 4"; "Address 4")
            {
                ApplicationArea = all;
            }
        }
        addafter("State Code")
        {
            field("Editable Sales Order"; "Editable Sales Order")
            {
                ApplicationArea = All;
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; "Sales Person Name")
            {
                ApplicationArea = all;
            }


            field("Created Date"; "Created Date")
            {
                ApplicationArea = all;
            }

            field("FSSAI License No"; "FSSAI License No")
            {
                ApplicationArea = all;
            }
            field("FSSAI License Start Date"; "FSSAI License Start Date")
            {
                ApplicationArea = all;
            }
            field("FSSAI License End Date"; "FSSAI License End Date")
            {
                ApplicationArea = all;
            }
            field("Accepted Product Shelf Life"; "Accepted Product Shelf Life")
            {
                ApplicationArea = all;
            }
            field("Sales Return Allowed"; "Sales Return Allowed")
            {
                ApplicationArea = all;
            }
            field("Contact No.(Sales)"; "Contact No.(Sales)")
            {
                ApplicationArea = all;
            }
            field("Sales E-Mail"; "Sales E-Mail")
            {
                ApplicationArea = all;
            }
            field("Contact No.(Purchase)"; "Contact No.(Purchase)")
            {
                ApplicationArea = all;
            }
            field("Purchase E-Mail"; "Purchase E-Mail")
            {
                ApplicationArea = all;
            }
            field("Contact No.(Accounts)"; "Contact No.(Accounts)")
            {
                ApplicationArea = all;
            }
            field("Accounts E-Mail"; "Accounts E-Mail")
            {
                ApplicationArea = all;
            }
            field("Vertical Category"; "Vertical Category")
            {
                ApplicationArea = all;
            }
            field("Vertical Sub Category"; "Vertical Sub Category")
            {
                ApplicationArea = all;
            }
            field("Outlet Area"; "Outlet Area")
            {
            }
            field("Business Format / Outlet Name"; "Business Format / Outlet Name")
            {
                ApplicationArea = all;
            }
            field("Responsible Collection Person"; "Responsible Collection Person")
            {
                ApplicationArea = all;
            }
            field("Duty Free"; "Duty Free")
            {
                ApplicationArea = all;
            }
            field(Referance; Referance)
            {
                ApplicationArea = all;
            }
            field("194Q Applicable"; "194Q Applicable")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    IF Rec."194Q Applicable" = Rec."194Q Applicable"::Yes then begin
                        Rec."TCS 206 CAA Applicable" := Rec."TCS 206 CAA Applicable"::"Non Comply";
                        Modify();
                        Vedit := false;
                    end else
                        if Rec."194Q Applicable" = Rec."194Q Applicable"::No then begin
                            Rec."TCS 206 CAA Applicable" := Rec."TCS 206 CAA Applicable"::Comply;
                            Modify();
                            Vedit := true;
                        end;
                end;
            }
            field("TCS 206 CAA Applicable"; "TCS 206 CAA Applicable")
            {
                ApplicationArea = all;
                Editable = Vedit;
            }
            field("EAN Code"; "EAN Code")
            {
                ApplicationArea = all;

            }
            field("BOND Dispatch"; "BOND Dispatch")
            {
                ApplicationArea = all;
            }
            field("Free Sample"; "Free Sample")
            {
                ApplicationArea = all;
            }
            field("Sales Reporting Field"; "Sales Reporting Field")
            {
                ApplicationArea = all;
            }
            field("UIN Number"; "UIN Number")
            {
                ApplicationArea = all;
            }
        }
        addafter("Customized Calendar")
        {
            field("Minimum Shelf Life %"; "Minimum Shelf Life %")
            {
                ApplicationArea = all;
            }
            field("Delivery Outlet"; "Delivery Outlet")
            {
                ApplicationArea = all;
            }
            group("Route Days")
            {
                Caption = 'Route Days';
                field("Route Days Applicable"; "Route Days Applicable")
                {
                    Editable = false;
                }
                field(Sunday; Sunday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Sunday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Monday; Monday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Monday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Tuesday; Tuesday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Tuesday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Wednesday; Wednesday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Wednesday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Thursday; Thursday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Thursday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Friday; Friday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Friday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Saturday; Saturday)
                {

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Saturday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
            }
        }

    }
    actions
    {

        addafter(Dimensions)
        {
            action("PDC Cheques")
            {
                Image = ListPage;


                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 50067;
                RunPageLink = "Cust.Code" = FIELD("No.");



            }
            action("License Details")
            {
                Promoted = true;
                ApplicationArea = all;
                RunObject = Page "License List";
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageView = ORDER(Ascending);

            }
            action(Available)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    APage: Record Customer;
                    Dec: Decimal;
                //BPage : Page "Customer Details FactBox";
                begin
                    APage.CalcAvailableCreditUI()
                end;
            }

            // action(Items)
            // {
            //     CaptionML = ENU='Items',
            //                 ENN='Items';
            //     Image = Item;
            //     RunObject = Page "Item Vendor Catalog";
            //     RunPageLink = "Vendor/Customer No."=FIELD("No.");
            //     RunPageView = SORTING("Vendor/Customer No.","Item No.");
            // }
        }
    }

    var
        UserSetup: Record 91;
        Vedit: Boolean;




    trigger OnModifyRecord(): Boolean;
    begin

        //RL
        /*
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Customer Permission", TRUE);
        IF UserSetup.FINDFIRST THEN
            ERROR('You do not have permission to access please contact administrator');
            */
        //>>PCPL/NSW/07  29June22
        IF (UserSetup.GET(USERID)) AND (NOT UserSetup."Customer Permission") THEN
            ERROR('You do not have permission to modify customer card ');
        //<<PCPL/NSW/07  29June22
        //RL

    end;




    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        //CCIT-SG-21062018
        //TESTFIELD(Structure);'
        if "No." <> 'DISFREEM01' then
            TESTFIELD("Location Code");
        //CCIT-SG-21062018

    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."194Q Applicable" = Rec."194Q Applicable"::No then
            Vedit := true
        else
            if Rec."194Q Applicable" = Rec."194Q Applicable"::Yes then
                Vedit := false;
    end;



}

