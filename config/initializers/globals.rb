require 'ColumnTitles'

ColumnTypeXls = {
	"id" => "String",
	"name" => "String",
	"phone" => "String",
	"fax" => "String",
	"department" => "String",
	"store_number" => "Number",
	"group_name" => "String",
	"primary_contact" => "String",
	"primary_contact_type" => "String",
	"sub_department_1" => "String",
	"sub_department_2" => "String",
	"sub_department_3" => "String",
	"sub_department_4" => "String",
	"keyway" => "String",
	"master_kay" => "String",
	"control_key" => "String",
	"bitting" => "String", 
	"system_name" => "String", 
	"comments" => "String",
	"po_number" => "Number",
	"so_number" => "Number",
	"date_order" => "DateTime",
	"address" => "String"
}

ColumnLabels = BiHash.new
ColumnLabels.insert("id", "ID")
# End Users / Purchasers
ColumnLabels.insert("name", "Name")
#ColumnLabels.insert("address_id", "Address")
ColumnLabels.insert("phone", "Phone Number")
ColumnLabels.insert("fax", "Fax Number")
ColumnLabels.insert("department", "Department")
ColumnLabels.insert("store_number", "Store Number")
ColumnLabels.insert("group_name", "Group")
ColumnLabels.insert("primary_contact", "Primary Contact")
ColumnLabels.insert("primary_contact_type", "Primary Contact Type")
ColumnLabels.insert("sub_department_1", "Subdepartment 1")
ColumnLabels.insert("sub_department_2", "Subdepartment 2")
ColumnLabels.insert("sub_department_3", "Subdepartment 3")
ColumnLabels.insert("sub_department_4", "Subdepartment 4")
#ColumnLabels.insert("lat", "Latitude")
#ColumnLabels.insert("lng", "Longitude")

# Key
ColumnLabels.insert("keyway", "Keyway")
ColumnLabels.insert("master_key", "Master Key Code")
ColumnLabels.insert("control_key", "Control Key Code")
ColumnLabels.insert("operating_key", "Operating Key Code")
ColumnLabels.insert("bitting", "Bitting")
ColumnLabels.insert("system_name", "System Name")
ColumnLabels.insert("comments", "Comments")

# Purchase Orders
ColumnLabels.insert("po_number", "Purchase Order #")
ColumnLabels.insert("so_number", "Shipping Order #")
ColumnLabels.insert("date_order", "Date Ordered")

# Address
ColumnLabels.insert("address", "Address")
