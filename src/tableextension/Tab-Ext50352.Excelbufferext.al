tableextension 50352 "Excel_buffer_ext" extends "Excel Buffer"
{
    // version TFS225977

    fields
    {


        field(50000; "Custom Background color"; Integer)
        {
            Description = 'rdk 220919';
        }
        field(50001; "USing Customer DEcorator"; Boolean)
        {
            Description = 'rdk 220919';
        }
    }



    var
        BGColor: Integer;
        UsingCustomFormat: Boolean;
    //  BGColor : Integer;
    //        UsingCustomFormat : Boolean;


}

