report 50105 "Update Location On ILE"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Temp Table"; "Temp Table")
        {

            trigger OnAfterGetRecord();
            begin

                /*RecILE.RESET;
                RecILE.SETFILTER(RecILE."Document Type",'=%1',RecILE."Document Type"::"Transfer Receipt");
                RecILE.SETRANGE(RecILE."Document No.","Temp Table"."Document No.");
                IF RecILE.FINDSET THEN
                  REPEAT
                    RecILE."Location Code" := "Temp Table".ToLocation;
                    RecILE.Quantity := ABS(RecILE.Quantity);
                    RecILE."Remaining Quantity" := ABS(RecILE."Remaining Quantity");
                    RecILE."Invoiced Quantity" := ABS(RecILE."Invoiced Quantity");
                    RecILE."Remainig Qty. In KG" := ABS(RecILE."Remainig Qty. In KG");
                    RecILE.MODIFY;
                  UNTIL RecILE.NEXT=0;*/


                RecILE.RESET;
                RecILE.SETRANGE(RecILE."Order No.", "Temp Table"."Document No.");
                IF RecILE.FINDSET THEN
                    REPEAT
                        IF RecILE."Document Type" = RecILE."Document Type"::"Transfer Shipment" THEN BEGIN
                            RecILE1.RESET;
                            RecILE1.SETFILTER(RecILE1."Document Type", '=%1', RecILE1."Document Type"::"Transfer Receipt");
                            RecILE1.SETRANGE(RecILE1."Order No.", RecILE."Order No.");
                            RecILE1.SETRANGE(RecILE1."Item No.", RecILE."Item No.");
                            RecILE1.SETFILTER(RecILE1."Lot No.", '=%1', '');
                            IF RecILE1.FINDFIRST THEN BEGIN
                                //MESSAGE('%1',RecILE1."Entry No.");
                                RecILE1."Lot No." := RecILE."Lot No.";
                                RecILE1."Manufacturing Date" := RecILE."Manufacturing Date";
                                RecILE1."Expiration Date" := RecILE."Expiration Date";
                                RecILE1.MODIFY;
                            END;
                        END;
                    UNTIL RecILE.NEXT = 0;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        MESSAGE('Update Successfully...');
    end;

    var
        RecILE: Record 32;
        RecILE1: Record 32;
}

