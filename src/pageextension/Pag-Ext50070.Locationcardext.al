pageextension 50070 "Location_card_ext" extends "Location Card"
{
    // version TFS225977,CCIT-Fortune

    layout
    {

        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Use As In-Transit")
        {
            field("BOND Dispatch"; "BOND Dispatch")
            {
                ApplicationArea = all;
            }
            field("Quarantine Location"; "Quarantine Location")
            {
                ApplicationArea = all;
            }
            field("Used In Reports"; "Used In Reports")
            {
                ApplicationArea = all;
            }
            field("Duty Free"; "Duty Free")
            {
                ApplicationArea = all;
            }
            field("Used In Stock Ageing Report"; "Used In Stock Ageing Report")
            {
                ApplicationArea = all;
            }
            field("Used In MA-Product"; "Used In MA-Product")
            {
                ApplicationArea = all;
            }
            field("Used In Inventory Planning HO"; "Used In Inventory Planning HO")
            {
                ApplicationArea = all;
            }
            field("Used In InventoryPAN INDIA"; "Used In InventoryPAN INDIA")
            {
                ApplicationArea = all;
            }
            field("Used In GST Calculation"; "Used In GST Calculation")
            {
                ApplicationArea = all;
            }
            field("Used In Quarantine Report"; "Used In Quarantine Report")
            {
                ApplicationArea = all;
            }
            field("SO GST Calculation"; "SO GST Calculation")
            {
                ApplicationArea = all;
            }
            field(Loc_DF; Loc_DF)
            {
                ApplicationArea = all;
            }
            field(Loc_Main; Loc_Main)
            {
                ApplicationArea = all;
            }
            field(Loc_Intra; Loc_Intra)
            {
                ApplicationArea = all;
            }
            field(Loc_Block; Loc_Block)
            {
                ApplicationArea = all;
            }
            field(Loc_Reco; Loc_Reco)
            {
                ApplicationArea = all;
            }
            field(Loc_Bond; Loc_Bond)
            {
                ApplicationArea = all;
            }
            field(Loc_Branch; Loc_Branch)
            {
                ApplicationArea = all;
            }

            field("FSSAI No"; "FSSAI No")
            {
                ApplicationArea = all;
            }
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = all;
            }
            // field("Posting No. Series"; "Posting No. Series")
            // {
            //     ApplicationArea = all;
            // }
            // field("Sales Cr Memo No."; "Sales Cr Memo No.")
            // {
            //     ApplicationArea = all;
            // }
        }
    }
    actions
    {
        modify("&Location")
        {
            CaptionML = ENU = '&Location';
        }
        modify("&Resource Locations")
        {
            CaptionML = ENU = '&Resource Locations';
        }
        modify("&Zones")
        {
            CaptionML = ENU = '&Zones';
        }
        modify("&Bins")
        {
            CaptionML = ENU = '&Bins';
        }
        modify("Online Map")
        {
            CaptionML = ENU = 'Online Map';
        }
    }




    //Unsupported feature: PropertyChange. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

