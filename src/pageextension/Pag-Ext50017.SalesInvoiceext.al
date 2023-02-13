pageextension 50017 "Sales_Invoice_ext" extends "Sales Invoice"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    layout
    {

        //Unsupported feature: Change Editable on "Control 14". Please convert manually.

        addafter("Posting Date")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
            field("Shipping No. Series"; "Shipping No. Series")
            {
                ApplicationArea = all;
            }

        }
        addafter("Document Date")
        {
            field("Customer Type"; "Customer Type")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
            field("Sample For"; "Sample For")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("Vertical Category"; "Vertical Category")
            {
                ApplicationArea = all;
            }
            field("Vertical Sub Category"; "Vertical Sub Category")
            {
                ApplicationArea = all;
            }
            field("Calculate IGST"; "Calculate IGST")
            {
                ApplicationArea = all;
                Visible = IGSTBoolean;
            }

            field("Outlet Area"; "Outlet Area")
            {
                ApplicationArea = all;
            }
            field("P.A.N No."; "P.A.N No.")
            {
                ApplicationArea = all;
            }
            field("Sales Value"; "Sales Value")
            {
                ApplicationArea = all;
            }
        }
        addafter("E-Commerce Merchant Id")
        {
            field("PAY REF"; "Your Reference")
            {
                CaptionML = ENU = 'PAY REF',
                            ENN = 'Your Reference';
                ApplicationArea = all;
            }
            field("PAY REF DATE"; "PAY REF DATE")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {


        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec."Posting Date" := Today;
                Rec.Modify();
            end;

            trigger OnAfterAction()
            begin
                //RL ++
                ShipmentNo;
                //RL --

            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                RecLocation: Record 14;
            begin
                // //<<PCPL/NSW/17March2022
                // IF RecLocation.Get("Location Code") then begin
                //     "Posting No. Series" := RecLocation."Posting No. Series";
                //     Rec.Modify();
                //     Message('Posting No Series Updated %1', "Posting No. Series");
                // ENd;
                // //>>PCPL/NSW/17March2022
            end;
        }
        modify(PostAndSend)
        {
            trigger OnAfterAction()
            begin
                //RL ++
                ShipmentNo;
                //RL --
            end;
        }

    }

    var
        IGSTBoolean: Boolean;

    trigger OnOpenPage();
    begin
        //CCIT-SG
        IF (USERID = 'FORTUNE\AJIT') OR (USERID = 'FORTUNE\LOGISTICSMGR') OR (USERID = 'FORTUNE\JWL') OR (USERID = 'FORTUNE\AUDITOR4') OR (USERID = 'FORTUNE\AUDITOR3') THEN
            IGSTBoolean := TRUE
        ELSE
            IGSTBoolean := FALSE;
        //CCIT-SG    
    end;

    procedure PostSalesInv();
    begin
        //Post(CODEUNIT::"Sales-Post (Yes/No)");
        MESSAGE("No.");
    end;

    local procedure ShipmentNo();

    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", "No.");
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETFILTER("No.", '<>%1', '');
        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine.TESTFIELD("Shipment No.");
            UNTIL SalesLine.NEXT = 0;
    end;

    var
        salesLine: Record 37;


}

