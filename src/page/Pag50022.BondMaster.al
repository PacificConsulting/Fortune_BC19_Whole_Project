page 50022 "Bond Master"
{
    // version CCIT-Fortune

    PageType = Card;
    SourceTable = "Bond Master";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Bond No. Series"; "Bond No. Series")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin

                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;

                    end;
                }
                field("Supplier No."; "Supplier No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; "Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Data Logger"; "Data Logger")
                {
                    ApplicationArea = All;
                }
                field("Supplier PO No."; "Supplier PO No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order No."; "Purchase Order No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Freight Type"; "Freight Type")
                {
                    ApplicationArea = All;
                }
                field("Container Type"; "Container Type")
                {
                    ApplicationArea = All;
                }
                field("Container No."; "Container No.")
                {
                    ApplicationArea = All;
                }
                field("Seal No"; "Seal No")
                {
                    ApplicationArea = All;
                }
                field("Mode of Transport"; "Mode of Transport")
                {
                    ApplicationArea = All;
                }
                field(CHA; CHA)
                {
                    ApplicationArea = All;
                }
                field("CHA Job No."; "CHA Job No.")
                {
                    ApplicationArea = All;
                }
                field("BL/AWB No."; "BL/AWB No.")
                {
                    ApplicationArea = All;
                }
                field("BL Date"; "BL Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Departure Date"; "Actual Departure Date")
                {
                    ApplicationArea = All;
                }
                field("Total Transit Day"; "Total Transit Day")
                {
                    ApplicationArea = All;
                }
                field("Shipment Arrival at Port Date"; "Shipment Arrival at Port Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Transit Days"; "Actual Transit Days")
                {
                    ApplicationArea = All;
                }
                field("Date Of Shipment Move. at CFS"; "Date Of Shipment Move. at CFS")
                {
                    ApplicationArea = All;
                }
                field("Name of CFS"; "Name of CFS")
                {
                    ApplicationArea = All;
                }
                field("Date of Move. from CFS Bond"; "Date of Move. from CFS Bond")
                {
                    ApplicationArea = All;
                }
                field("No. of Days Move. CFS to Bond"; "No. of Days Move. CFS to Bond")
                {
                    ApplicationArea = All;
                }
                field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-20042021
                        RecBondMaster.RESET;
                        RecBondMaster.SETRANGE(RecBondMaster."In-Bond Bill of Entry No.", Rec."In-Bond Bill of Entry No.");
                        IF RecBondMaster.FINDFIRST THEN
                            ERROR('In-Bond Bill of Entry No. already exist');
                        //CCIT-20042021
                    end;
                }
                field("In-Bond BOE Date"; "In-Bond BOE Date")
                {
                    ApplicationArea = All;
                }
                field("Bond Number"; "Bond Number")
                {
                    ApplicationArea = All;
                }
                field("Bond Sr.No."; "Bond Sr.No.")
                {
                    ApplicationArea = All;
                }
                field("Bond Date"; "Bond Date")
                {
                    ApplicationArea = All;
                }
                field("FSSAI ICA No."; "FSSAI ICA No.")
                {
                    ApplicationArea = All;
                    Caption = 'FSSAI   ICA No.';
                }
                field("Date of FSSAI Appointment"; "Date of FSSAI Appointment")
                {
                    ApplicationArea = All;
                }
                field("No. of Days Approval for FSSAI"; "No. of Days Approval for FSSAI")
                {
                    ApplicationArea = All;
                }
                field("FSSAI Sample Withdrawal Date"; "FSSAI Sample Withdrawal Date")
                {
                    ApplicationArea = All;
                }
                field("FSSAI Report Date"; "FSSAI Report Date")
                {
                    ApplicationArea = All;
                }
                field("CHA Name"; "CHA Name")
                {
                    ApplicationArea = All;
                }
                field("Bond Value"; "Bond Value")
                {
                    ApplicationArea = All;
                }
                field("Utilized Bond Value"; "Utilized Bond Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        DutyPaid: Boolean;
        DutyFree: Boolean;
        RecBondMaster: Record "Bond Master";

}

