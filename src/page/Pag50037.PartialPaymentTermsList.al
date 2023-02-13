page 50037 "Partial Payment Terms List"
{
    // version CCIT-Fortune

    PageType = List;
    SourceTable = "Partial Payment Terms";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Percentage; Percentage)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        /*TotalPer:=0;
                        RecPartialPayTrems.RESET;
                        RecPartialPayTrems.SETRANGE(RecPartialPayTrems.Code,Rec.Code);
                        IF RecPartialPayTrems.FINDSET THEN
                          REPEAT
                             TotalPer +=RecPartialPayTrems.Percentage;
                          UNTIL RecPartialPayTrems.NEXT=0;
                        IF (TotalPer > 100) THEN
                          ERROR('%1',TotalPer);
                        */

                    end;
                }
                field("Due Date Calculation"; "Due Date Calculation")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Shipment Method"; "Shipment Method")
                {
                    ApplicationArea = All;
                }
                field("Customer/Vendor Type"; "Customer/Vendor Type")
                {
                    ApplicationArea = All;
                }
                field("Customer/Vendor No."; "Customer/Vendor No.")
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
        RecPartialPayTrems: Record "Partial Payment Terms";
        TotalPer: Decimal;
}

