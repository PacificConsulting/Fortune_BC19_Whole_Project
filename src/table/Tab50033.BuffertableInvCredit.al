table 50033 "Buffer table Inv-Credit"
{
    // version CCIT-HARSHAL


    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = 'Invoice,Credit';
            OptionMembers = Invoice,Credit;
        }
        field(3;"Line No";Integer)
        {
        }
        field(4;"Item No";Code[20])
        {
        }
        field(5;Description;Text[50])
        {
        }
        field(6;"Posting Date";Date)
        {
        }
        field(7;"Customer No.";Code[20])
        {
        }
        field(8;"Customer Name";Code[50])
        {
        }
        field(9;Brand;Code[100])
        {
        }
        field(10;Quantity;Decimal)
        {
        }
        field(11;"Unit Price";Decimal)
        {
        }
        field(12;"Customer Posting Group";Code[20])
        {
        }
        field(13;"Amount To Customer";Decimal)
        {
        }
        field(14;"Charge To Customer";Decimal)
        {
        }
        field(15;"Location Code";Code[20])
        {
            TableRelation = Location.Code;
        }
        field(16;Narration;Code[20])
        {
        }
        field(17;"Unit Of Measure Code";Code[10])
        {
        }
        field(18;"FASSI No.";Code[20])
        {
        }
        field(19;Address;Text[50])
        {
        }
        field(20;Address2;Text[50])
        {
        }
        field(21;Name;Text[50])
        {
        }
        field(22;Name2;Text[50])
        {
        }
        field(23;"Phone No.";Text[30])
        {
        }
        field(24;"Phone No.2";Text[30])
        {
        }
        field(25;City;Text[30])
        {
        }
        field(26;"Post Code";Code[20])
        {
        }
        field(27;State;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Document Type","Line No","Customer Posting Group","Location Code")
        {
        }
    }

    fieldgroups
    {
    }
}

