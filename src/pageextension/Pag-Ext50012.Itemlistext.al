pageextension 50012 "Item_list_ext" extends "Item List"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {

        addafter(Description)
        {
            field("Brand Name"; "Brand Name")
            {
                ApplicationArea = all;
            }
            field("EAN Code No."; "EAN Code No.")
            {
                ApplicationArea = all;
            }
            field("EAN Code"; "EAN Code")
            {
                ApplicationArea = all;
            }
            field("Unit Cost In PCS"; "Unit Cost In PCS")
            {
                ApplicationArea = all;
            }

            field("Description 2"; "Description 2")
            {
                ApplicationArea = all;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Supplier Code"; "Supplier Code")
            {
                ApplicationArea = all;
            }
            field("Supplier Name"; "Supplier Name")
            {
                ApplicationArea = all;
            }

            field(Inventory; Inventory)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("GST Group Code"; "GST Group Code")
            {
                ApplicationArea = all;
            }
            field("HSN/SAC Code"; "HSN/SAC Code")
            {
                ApplicationArea = all;
            }
            field(GTIN; GTIN)
            {
                ApplicationArea = all;
            }
            field("Statistics Group"; "Statistics Group")
            {
                ApplicationArea = all;
            }
            field("Sales Category"; "Sales Category")
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
            field("Inventory Classification"; "Inventory Classification")
            {
                ApplicationArea = all;
            }
            field("Unit Volume"; "Unit Volume")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;


    trigger OnOpenPage();
    begin
        /*
        {//CCIT-SG-05062018
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID",USERID);
        IF RecUserBranch.FINDFIRST THEN
          REPEAT
            //IF RecUserBranch."Location Code" <> '' THEN
            IF RecLoc.GET(RecUserBranch."Location Code") THEN
              IF RecLoc.Loc_Main  THEN
                LocCode := RecUserBranch."Location Code";
          UNTIL RecUserBranch.NEXT=0;
        //LocCodeText := DELSTR(LocCode,STRLEN(LocCode),1);
        IF LocCode <> '' THEN BEGIN
          SETRANGE("Location Filter",LocCode);
        END;
        IF LocCodeText <> '' THEN
          ClearHide := FALSE
        ELSE
          ClearHide := TRUE;
        //CCIT-SG-05062018
        }
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        */
    end;

    //Unsupported feature: PropertyChange. Please convert manually.

}

