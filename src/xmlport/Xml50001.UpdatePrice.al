xmlport 50001 "Update Price"
{
    // version CCIT-Fortune

    Direction = Import;
    Format = VariableText;
    //applicationarea=All;

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
                fieldelement(Price; Item."Unit Price")
                {
                }
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
}

