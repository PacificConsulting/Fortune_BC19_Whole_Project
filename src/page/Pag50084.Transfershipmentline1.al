page 50084 "Transfer shipment line1"
{
    PageType = List;
    Permissions = TableData 5745 = rimd;
    SourceTable = "Transfer Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Units per Parcel"; "Units per Parcel")
                {
                    ApplicationArea = All;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                }
                field("Transfer Order No."; "Transfer Order No.")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("In-Transit Code"; "In-Transit Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field("Item Shpt. Entry No."; "Item Shpt. Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                }

                field("Transfer-from Bin Code"; "Transfer-from Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("BED Amount"; Amount)
                {
                    ApplicationArea = All;
                }
                // field("AED(GSI) Amount"; "AED(GSI) Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("SED Amount"; "SED Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("SAED Amount"; "SAED Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("CESS Amount"; "CESS Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("NCCD Amount"; "NCCD Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("eCess Amount"; "eCess Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Amount"; "Excise Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Amount Including Excise"; "Amount Including Excise")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Accounting Type"; "Excise Accounting Type")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Prod. Posting Group"; "Excise Prod. Posting Group")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Bus. Posting Group"; "Excise Bus. Posting Group")
                // {
                //     ApplicationArea = All;
                // }
                // field("Capital Item"; "Capital Item")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Base Quantity"; "Excise Base Quantity")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Base Amount"; "Excise Base Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Amount Added to Excise Base"; "Amount Added to Excise Base")
                // {
                //     ApplicationArea = All;
                // }
                // field("Amount Added to Inventory"; "Amount Added to Inventory")
                // {
                //     ApplicationArea = All;
                // }
                // field("Charges to Transfer"; "Charges to Transfer")
                // {
                //     ApplicationArea = All;
                // }
                // field("Total Amount to Transfer"; "Total Amount to Transfer")
                // {
                //     ApplicationArea = All;
                // }
                // field("Claim Deferred Excise"; "Claim Deferred Excise")
                // {
                //     ApplicationArea = All;
                // }
                // field("Unit Cost"; "Unit Cost")
                // {
                //     ApplicationArea = All;
                // }
                // field("ADET Amount"; "ADET Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("AED(TTA) Amount"; "AED(TTA) Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("ADE Amount"; "ADE Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Assessable Value"; "Assessable Value")
                // {
                //     ApplicationArea = All;
                // }
                // field("SHE Cess Amount"; "SHE Cess Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("ADC VAT Amount"; "ADC VAT Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("CIF Amount"; "CIF Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("BCD Amount"; "BCD Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field(CVD; CVD)
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Loading on Inventory"; "Excise Loading on Inventory")
                // {
                //     ApplicationArea = All;
                // }
                // field("Captive Consumption %"; "Captive Consumption %")
                // {
                //     ApplicationArea = All;
                // }
                // field("Admin. Cost %"; "Admin. Cost %")
                // {
                //     ApplicationArea = All;
                // }
                // field("MRP Price"; "MRP Price")
                // {
                //     ApplicationArea = All;
                // }
                // field(MRP; MRP)
                // {
                //     ApplicationArea = All;
                // }
                // field("Abatement %"; "Abatement %")
                // {
                //     ApplicationArea = All;
                // }
                // field("Applies-to Entry (RG 23 D)"; "Applies-to Entry (RG 23 D)")
                // {
                //     ApplicationArea = All;
                // }
                // field("Cost of Production"; "Cost of Production")
                // {
                //     ApplicationArea = All;
                // }
                // field("Cost Of Prod. Incl. Admin Cost"; "Cost Of Prod. Incl. Admin Cost")
                // {
                //     ApplicationArea = All;
                // }
                // field("Custom eCess Amount"; "Custom eCess Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Custom SHECess Amount"; "Custom SHECess Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("Excise Effective Rate"; "Excise Effective Rate")
                // {
                //     ApplicationArea = All;
                // }
                // field("GST Base Amount"; "GST Base Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("GST %"; "GST %")
                // {
                //     ApplicationArea = All;
                // }
                // field("Total GST Amount"; "Total GST Amount")
                // {
                //     ApplicationArea = All;
                // }
                // field("GST Group Code"; "GST Group Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("HSN/SAC Code"; "HSN/SAC Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("GST Credit"; "GST Credit")
                // {
                //     ApplicationArea = All;
                // }
                // field(Exempted; Exempted)
                // {
                //     ApplicationArea = All;
                // }
                // field("License No."; "License No.")
                // {
                //     ApplicationArea = All;
                // }
                // field(Weight; Weight)
                // {
                //     ApplicationArea = All;
                // }
                // field("Conversion Qty"; "Conversion Qty")
                // {
                //     ApplicationArea = All;
                // }
                // field("Customer No."; "Customer No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Customer Name"; "Customer Name")
                // {
                //     ApplicationArea = All;
                // }
                // field(Reserved; Reserved)
                // {
                //     ApplicationArea = All;
                // }
                field("In-Bond Bill of Entry No."; "In-Bond Bill of Entry No.")
                {
                    ApplicationArea = All;
                }
                field("In-Bond BOE Date"; "In-Bond BOE Date")
                {
                    ApplicationArea = All;
                }
                field("Bond Number"; "Bond Number")
                {
                    ApplicationArea = All;
                }
                field("Bond Sr.No."; "Bond Sr.No.")
                {
                    ApplicationArea = All;
                }
                field("Bond Date"; "Bond Date")
                {
                    ApplicationArea = All;
                }
                field("Conversion UOM"; "Conversion UOM")
                {
                    ApplicationArea = All;
                }
                field("Storage Categories"; "Storage Categories")
                {
                    ApplicationArea = All;
                }
                field("No. of Boxes"; "No. of Boxes")
                {
                    ApplicationArea = All;
                }
                field("Transfer Serial No."; "Transfer Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Customer License No."; "Customer License No.")
                {
                    ApplicationArea = All;
                }
                field("Customer License Name"; "Customer License Name")
                {
                    ApplicationArea = All;
                }
                field("Customer License Date"; "Customer License Date")
                {
                    ApplicationArea = All;
                }
                field("Sales Category"; "Sales Category")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.1"; "Supplier Invoice No.1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.1"; "Supplier Invoice Sr.No.1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 1"; "Supplier Invoice Date 1")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 1"; "Gross Weight 1")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 1"; "Net Weight 1")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.2"; "Supplier Invoice No.2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.2"; "Supplier Invoice Sr.No.2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 2"; "Supplier Invoice Date 2")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 2"; "Gross Weight 2")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 2"; "Net Weight 2")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.3"; "Supplier Invoice No.3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.3"; "Supplier Invoice Sr.No.3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 3"; "Supplier Invoice Date 3")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 3"; "Gross Weight 3")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 3"; "Net Weight 3")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No.4"; "Supplier Invoice No.4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No.4"; "Supplier Invoice Sr.No.4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date 4"; "Supplier Invoice Date 4")
                {
                    ApplicationArea = All;
                }
                field("Gross Weight 4"; "Gross Weight 4")
                {
                    ApplicationArea = All;
                }
                field("Net Weight 4"; "Net Weight 4")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice No."; "Supplier Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Sr.No."; "Supplier Invoice Sr.No.")
                {
                    ApplicationArea = All;
                }
                field("Supplier Invoice Date"; "Supplier Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Fill Rate %"; "Fill Rate %")
                {
                    ApplicationArea = All;
                }
                field("Custom Duty Amount"; "Custom Duty Amount")
                {
                    ApplicationArea = All;
                }
                field("GST Assessable Value"; "GST Assessable Value")
                {
                    ApplicationArea = All;
                }
                field("Transfer From Reason Code"; "Transfer From Reason Code")
                {
                    ApplicationArea = All;
                }
                field(Duty; Duty)
                {
                    ApplicationArea = All;
                }
                field(Cess; Cess)
                {
                    ApplicationArea = All;
                }
                field(Surcharge; Surcharge)
                {
                    ApplicationArea = All;
                }
                field("TO Order QTY"; "TO Order QTY")
                {
                    ApplicationArea = All;
                }
                field("TO Order Value"; "TO Order Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

