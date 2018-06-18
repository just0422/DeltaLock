# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

#p "Destroying Addresses"
#Address.destroy_all
p "Destroying Assignments"
Relationship.destroy_all
p "Destroying PurchaseOrders"
PurchaseOrder.destroy_all
p "Destroying Purchasers"
Purchaser.destroy_all
p "Destroying EndUsers"
EndUser.destroy_all
p "Destroying Keys"
Key.destroy_all

p "Trying to create"
Key.create!([{
	id: 1,
    keyway: "1",
    master_key: "11",
    control_key: "111",
    operating_key: "1AA",
    bitting: 12223432,
	system_name: "CHEasdff",
	comments: "HAHAHA"
},
{
	id: 2,
    keyway: "2",
    master_key: "22",
    control_key: "222",
    operating_key: "2AA",
    bitting: 98765432,
	system_name: "CHgrsehf",
	comments: "HAHAHA"
},
{
	id: 3,
    keyway: "3",
    master_key: "33",
    control_key: "333",
    operating_key: "3AA",
    bitting: 18266212,
	system_name: "qhgh5ehf",
	comments: "HAHAHA"
},
{
	id: 4,
    keyway: "4",
    master_key: "44",
    control_key: "444",
    operating_key: "4AA",
    bitting: 13828212,
	system_name: "qaFEEehf",
	comments: "HAHAHA"
}])
p "Created #{Key.count} Keys"

EndUser.create!([{
    id: 1,
    name: "asdf",
    phone: "234",
    department: "asdf",
    store_number: 2,
	group_name: "Google"
},
{
    id: 2,
    name: "sdf",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_name: "Google"
},
{
    id: 7,
    name: "New London",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_name: "Google"
},
{
    id: 6,
    name: "Church",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_name: "Google"
},
{
    id: 5,
    name: "Luhi",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_name: "Google"
},
{
    id: 4,
    name: "asdf",
    phone: "2344444",
    department: "as",
    store_number: 1,
	group_name: "Google"
},
{
    id: 3,
    name: "asdfasdf",
    phone: "64221",
    department: "asdf",
    store_number: 3,
	group_name: "Google"
}])

p "Created #{EndUser.count} End Users"

Purchaser.create!([{
    id:1, 
    name: "justin",
    phone: "1234",
	group_name: "Google",
    fax: "q34re"
},
{
    id: 2,
    name: "just",
    phone: "134",
	group_name: "Google",
    fax: "q34"
},
{
    id: 3,
    name: "stan",
    phone: "1f34",
	group_name: "Google",
    fax: "q3asd4"
}])
p "Created #{Purchaser.count} Purchasers"

PurchaseOrder.create!([{
    id: 1,
    so_number: 1,
    po_number: 4,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 2,
    so_number: 2,
    po_number: 3,
    date_order: DateTime.strptime("09/14/2010 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 3,
    so_number: 3,
    po_number: 2,
    date_order: DateTime.strptime("09/14/2011 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 4,
    so_number: 4,
    po_number: 1,
    date_order: DateTime.strptime("09/14/2012 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 5,
    so_number: 5,
    po_number: 4,
    date_order: DateTime.strptime("09/14/2013 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 6,
    so_number: 6,
    po_number: 4,
    date_order: DateTime.strptime("09/14/2014 8:00", "%m/%d/%Y %H:%M")
},
{
    id: 7,
    so_number: 7,
    po_number: 5,
    date_order: DateTime.strptime("09/14/2015 8:00", "%m/%d/%Y %H:%M")
}])

p "Created #{PurchaseOrder.count} Purchase Orders"


Relationship.create!([{
    purchaseorders: 1,
    purchasers: 1,
    endusers: 1,
    keys: 1
},
{
    purchaseorders: 2,
    purchasers: 3,
    endusers: 1
}])

p "Created #{Relationship.count} Assignments"
