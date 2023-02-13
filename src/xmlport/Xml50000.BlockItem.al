xmlport 50000 "Block Item"
{
    // version CCIT-Fortune

    //applicationarea=all;


    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                fieldelement(ItemNo; Item."No.")
                {
                }

                trigger OnAfterModifyRecord();
                begin
                    ItemRec.GET(Item."No.");
                    ItemRec.Blocked := TRUE;
                    ItemRec.MODIFY(TRUE);
                end;
            }
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

    var
        ItemRec: Record 27;
}

