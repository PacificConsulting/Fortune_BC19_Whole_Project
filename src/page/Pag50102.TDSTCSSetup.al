page 50102 "TDS TCS Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TDS TCS Setup";

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("Tax Type"; "Tax Type")
                {
                    ApplicationArea = All;

                }
                field(eTDS; eTDS)
                {
                    ApplicationArea = all;
                    //Visible=false;
                    TableRelation = "TDS Section".ecode;
                }
                field("Section Code"; "Section Code")
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TDSSEC: Record "TDS Section";
                        TCSSEC: Record "TCS Nature Of Collection";
                    begin
                        IF "Tax Type" = 'TCS' then begin
                            IF PAGE.RUNMODAL(18811, TCSSEC) = ACTION::LookupOK THEN begin
                                Rec.Validate("Section Code", TCSSEC.Code);
                                TCSSEC.Reset();
                                TCSSEC.SetRange(TCSSEC.Code, "Section Code");
                                IF TCSSEC.FindFirst() then begin
                                    eTDS := TCSSEC.eTCS;
                                    // Modify();
                                end;
                            end;
                        end;
                        IF "Tax Type" = 'TDS' then begin
                            IF PAGE.RUNMODAL(18695, TDSSEC) = ACTION::LookupOK THEN begin
                                Rec.Validate("Section Code", TDSSEC.Code);
                                TDSSEC.Reset();
                                TDSSEC.SetRange(Code, "Section Code");
                                IF TDSSEC.FindFirst() then begin
                                    eTDS := TDSSEC.ecode;
                                    //Modify();
                                end;
                            end;
                        end;
                    END;
                }
                field("Assessee Code"; "Assessee Code")
                {
                    ApplicationArea = all;
                }
                field("Effective Date"; "Effective Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Concessional Code"; "Concessional Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Nature of Remittance"; "Nature of Remittance")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Act Applicable"; "Act Applicable")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("TDS %"; "TDS %")
                {
                    ApplicationArea = all;
                }
                field("TDS Threshold Amount"; "TDS Threshold Amount")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}