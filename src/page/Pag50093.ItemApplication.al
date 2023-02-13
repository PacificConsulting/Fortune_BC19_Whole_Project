page 50093 "Item Application"
{
    PageType = List;
    Permissions = TableData 339 = rimd;
    SourceTable = 339;
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    applicationArea = All;
                }
                field("Item Ledger Entry No."; "Item Ledger Entry No.")
                {
                    applicationArea = All;
                }
                field("Inbound Item Entry No."; "Inbound Item Entry No.")
                {
                    applicationArea = All;
                }
                field("Outbound Item Entry No."; "Outbound Item Entry No.")
                {
                    applicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    applicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Transferred-from Entry No."; "Transferred-from Entry No.")
                {
                    applicationArea = All;
                }
                field("Creation Date"; "Creation Date")
                {
                    applicationArea = All;
                }
                field("Created By User"; "Created By User")
                {
                    applicationArea = All;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    applicationArea = All;
                }
                field("Last Modified By User"; "Last Modified By User")
                {
                    applicationArea = All;
                }
                field("Cost Application"; "Cost Application")
                {
                    applicationArea = All;
                }
                field("Output Completely Invd. Date"; "Output Completely Invd. Date")
                {
                    applicationArea = All;
                }
                field("Outbound Entry is Updated"; "Outbound Entry is Updated")
                {
                    applicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

