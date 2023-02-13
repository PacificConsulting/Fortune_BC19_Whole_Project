xmlport 50099 "GENERAL TEMP"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'GENERAL';
                fieldelement(JournalTemplateName; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldelement(JournalBatchName; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldelement("LineNo."; "Gen. Journal Line"."Line No.")
                {
                }
                fieldelement(DocumentType; "Gen. Journal Line"."Document Type")
                {
                }
                fieldelement(PostingDate; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement("ExternalDocumentNo."; "Gen. Journal Line"."External Document No.")
                {
                }
                fieldelement(DocumentDate; "Gen. Journal Line"."Document Date")
                {
                }
                fieldelement(DueDate; "Gen. Journal Line"."Due Date")
                {
                }
                fieldelement("DocumentNo."; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(AccountType; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement("AccountNo."; "Gen. Journal Line"."Account No.")
                {
                }
                fieldelement(Description; "Gen. Journal Line".Description)
                {
                }
                fieldelement(Amount; "Gen. Journal Line".Amount)
                {
                }
                fieldelement("Bal.AccountType"; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                fieldelement("Bal.AccountNo."; "Gen. Journal Line"."Bal. Account No.")
                {
                }
                fieldelement(Branch; "Gen. Journal Line"."Shortcut Dimension 1 Code")
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

