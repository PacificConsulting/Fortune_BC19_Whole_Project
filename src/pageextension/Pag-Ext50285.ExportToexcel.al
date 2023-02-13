pageextension 50285 Export_ext extends "Tax Rates"
{

    layout
    {
        // modify(AttributeValue1)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         Message(Rec."Tax Rate ID");
        //         Message('OnafterValidate');

        //     end;

        //     trigger OnAfterAfterLookup(Selected: RecordRef)
        //     begin
        //         Message(Rec."Tax Rate ID");
        //         Message('OnAfterAfterLookup');
        //     end;
        // }
        // modify(AttributeValue2)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         Message(Rec."Tax Rate ID");
        //         Message('Test2');
        //     end;
        // }
    }

    actions
    {
        // modify(ExportToExcel)
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         Error('Error....');
        //     end;
        // }
        addafter(ExportToExcel)
        {
            action("New IMPORT")
            {
                Caption = 'New IMPORT';
                Image = ImportExcel;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                ToolTip = 'Import the tax rates from Excel.';
                trigger OnAction();
                var
                    TDSUP: XmlPort 50021;
                begin
                    Clear(TDSUP);
                    TDSUP.Run();
                end;
            }
        }
    }

    var
        GlobalTaxType: Code[20];
}