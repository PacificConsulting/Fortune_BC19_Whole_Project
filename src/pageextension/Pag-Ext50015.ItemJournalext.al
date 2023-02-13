pageextension 50015 "Item_Journal_ext" extends "Item Journal"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,CCIT-Fortune

    layout
    {


        //Unsupported feature: CodeModification on "Control 37.OnValidate". Please convert manually.
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                // CCIT--- AN
                Location.RESET;
                Location.SETFILTER(Code, "Location Code");
                IF Location.FIND('-') THEN BEGIN
                    "Shortcut Dimension 1 Code" := Location."Branch Code";
                END

            end;
        }
        modify(Quantity)
        {
            Caption = 'Quantity In KG';
            ApplicationArea = all;
        }


        addafter("Posting Date")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Cutting In (Pc)"; "Cutting In (Pc)")
            {
                ApplicationArea = all;

            }
        }
        addafter(Quantity)
        {
            field("Conversion Qty"; "Conversion Qty")
            {
                Caption = 'Quantity In PCS';
                ApplicationArea = all;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Storage Categories"; "Storage Categories")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action("Cutting Process")
            {
                Caption = 'Cutting Process';

                trigger OnAction();
                begin
                    //>> CS
                    //>> CS
                    //REPORT.RUN(REPORT::Report70004)
                    //<< CS


                end;
            }
        }
        addfirst("P&osting")
        {
            action("Import Data")
            {
                Caption = 'Import Data';

                trigger OnAction();
                begin
                    //IJI.getdata(Rec);
                    Clear(IJI);
                    IJI.RUN;
                end;
            }
        }
    }

    var
        IJI: XMLport 50006;
        Location: Record 14;

    //Unsupported feature: PropertyChange. Please convert manually.

}

