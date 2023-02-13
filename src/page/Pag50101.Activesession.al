page 50101 "Active session"
{
    PageType = List;
    Permissions = TableData 2000000110 = rimd;
    SourceTable = "Active Session";
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User SID"; "User SID")
                {
                    ApplicationArea = all;

                }
                field("Server Instance ID"; "Server Instance ID")
                {
                    ApplicationArea = all;

                }
                field("Session ID"; "Session ID")
                {
                    ApplicationArea = all;

                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = all;
                }
                field("Server Computer Name"; "Server Computer Name")
                {
                    ApplicationArea = all;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field("Client Type"; "Client Type")
                {
                    ApplicationArea = all;
                }
                field("Client Computer Name"; "Client Computer Name")
                {
                    ApplicationArea = all;
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = all;
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = all;
                }
                field("Session Unique ID"; "Session Unique ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

