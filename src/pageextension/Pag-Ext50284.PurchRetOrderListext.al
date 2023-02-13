pageextension 50284 "Purch_Ret_Order_List_ext" extends "Purchase Return Order List"
{
    // version NAVW19.00.00.46621

    layout
    {
        addafter("Location Code")
        {
            field("Created User"; "Created User")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        //Unsupported feature: CodeModification on "Post(Action 52).OnAction". Please convert manually.
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }

        modify(PostBatch)
        {
            trigger OnBeforeAction()
            begin
                //CCIT-PRI-191118
                ERROR('You do not have permission');
                //CCIT-PRI-191118

            end;
        }


    }
}

