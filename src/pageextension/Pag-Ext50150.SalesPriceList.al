pageextension 50150 Sale_price_list_ext extends "Sales Price List"
{
    layout
    {

        addafter(Description)
        {
            // field("Location Code"; "Location Code")
            // {
            //     ApplicationArea = all;
            // }
            field("Special Price"; "Special Price")
            {
                ApplicationArea = all;
            }
            field("Location Code"; "Location Code")
            {
                ApplicationArea = all;
            }
        }
        modify(SourceType)
        {
            trigger OnAfterValidate()
            begin
                IF xRec."Source Type" <> "Source Type" then begin
                    Clear("Location Code");
                    //Clear("Source Type");
                    Clear("Source No.");
                end;
            end;
        }
        modify(SourceNo)
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                CPG: Record 6;
                Cust: Record 18;
                CDG: Record 340;
                Campaign: Record 5071;
                Contact: Record 5050;
            begin
                IF ("Source Type" = "Source Type"::Customer) then begin
                    IF PAGE.RUNMODAL(22, Cust) = ACTION::LookupOK THEN begin
                        //Rec.Validate("Source No.", Cust."No.");
                        "Source No." := Cust."No.";
                        Modify();
                    end;
                end else
                    IF ("Source Type" = "Source Type"::"Customer Price Group") then begin
                        //IF "Special Price" = '' then
                        //  Error('Please Selecet Location Code for Customer Price Group.');
                        CPG.Reset();
                        //CPG.SetRange("Special Price", Rec."Special Price");
                        //CPG.SetRange("Location Code", "Location Code");
                        IF CPG.FindFirst() then
                            IF PAGE.RUNMODAL(7, CPG) = ACTION::LookupOK THEN begin
                                Rec.Validate("Source No.", CPG.Code);
                                Modify();
                            end;
                    end else
                        IF ("Source Type" = "Source Type"::Customer) then begin
                            IF PAGE.RUNMODAL(22, Cust) = ACTION::LookupOK THEN begin
                                Rec.Validate("Source No.", Cust."No.");
                                Modify();
                            end;
                        end else
                            IF ("Source Type" = "Source Type"::"Customer Disc. Group") then begin
                                IF PAGE.RUNMODAL(512, CDG) = ACTION::LookupOK THEN begin
                                    Rec.Validate("Source No.", CDG.Code);
                                    Modify();
                                end;
                            end else
                                IF ("Source Type" = "Source Type"::Campaign) then begin
                                    IF PAGE.RUNMODAL(5087, Campaign) = ACTION::LookupOK THEN begin
                                        Rec.Validate("Source No.", Campaign."No.");
                                        Modify();
                                    end;
                                end else
                                    IF ("Source Type" = "Source Type"::Contact) then begin
                                        IF PAGE.RUNMODAL(5052, Contact) = ACTION::LookupOK THEN begin
                                            Rec.Validate("Source No.", Contact."No.");
                                            Modify();
                                        end;
                                    end;
            end;

        }
    }


}