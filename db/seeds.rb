# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
p "Destroying PoKs"
PoK.destroy_all
p "Destroying PurchaseOrders"
PurchaseOrder.destroy_all
p "Destroying Purchasers"
Purchaser.destroy_all
p "Destroying EndUsers"
EndUser.destroy_all
p "Destroying Keys"
Key.destroy_all


Key.create!([{
    key: "1",
    master_key: "11",
    control_key: "111",
    stamp_code: "1AA",
    key_hash: 1
},
{
    key: "2",
    master_key: "22",
    control_key: "222",
    stamp_code: "2AA",
    key_hash: 2
},
{
    key: "3",
    master_key: "33",
    control_key: "333",
    stamp_code: "3AA",
    key_hash: 3,
},
{
    key: "4",
    master_key: "44",
    control_key: "444",
    stamp_code: "4AA",
    key_hash: 4
}])
p "Created #{Key.count} Keys"

EndUser.create!([{
    id: 1,
    name: "asdf",
    address: "100 Spear st, San Francisco, CA",
    email: ";lkj",
    phone: "234",
    department: "asdf",
    store_number: 2,
	group_id: 1
},
{
    id: 2,
    name: "sdf",
    address: "101 Spear st, San Francisco, CA",
    email: "jjjjjj",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_id: 1
},
{
    id: 7,
    name: "New London",
    address: "49 Washington St, New London, CT 06320",
    email: "jj",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_id: 1
},
{
    id: 6,
    name: "Church",
    address: "64-34 Myrtle Ave, Glendale, NY 11385",
    email: "jj",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_id: 1
},
{
    id: 5,
    name: "Luhi",
    address: "131 Brookville Rd, Glen Head, NY 11545",
    email: "jj",
    phone: "2344",
    department: "as",
    store_number: 1,
	group_id: 1
},
{
    id: 4,
    name: "asdf",
    address: "715 Todt Hill Rd, Staten Island, NY 10304",
    email: "asdfa",
    phone: "2344444",
    department: "as",
    store_number: 1,
	group_id: 1
},
{
    id: 3,
    name: "asdfasdf",
    address: "112 Ocean Avenue, Amytiville, NY",
    email: "ffdsas",
    phone: "64221",
    department: "asdf",
    store_number: 3,
	group_id: 1
}])
p "Created #{EndUser.count} Users"


Purchaser.create!([{
    id:1, 
    name: "justin",
    address: "123 abc",
    email: "asbcc@aa.c",
    phone: "1234",
    fax: "q34re"
},
{
    id: 2,
    name: "just",
    address: "13 abc",
    email: "asb@aa.c",
    phone: "134",
    fax: "q34"
},
{
    id: 3,
    name: "stan",
    address: "1asd3 abc",
    email: "asfaab@a44a.c",
    phone: "1f34",
    fax: "q3asd4"
}])
p "Created #{Purchaser.count} Purchasers"


PurchaseOrder.create!([{
    so_number: 1,
    po_number: 4,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 1,
    end_user_id: 1
},
{
    so_number: 6,
    po_number: 1,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 2,
    end_user_id: 6
},
{
    so_number: 4,
    po_number: 1,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 2,
    end_user_id: 4
},
{
    so_number: 3,
    po_number: 1,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 2,
    end_user_id: 3
},
{
    so_number: 2,
    po_number: 1,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 2,
    end_user_id: 2
},
{
    so_number: 12,
    po_number: 2,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 2,
    end_user_id: 1 
}])
p "Created #{PurchaseOrder.count} Purchase Orders"

PoK.create!([{
    quantity: 100,
    key_id: 1,
    purchase_order_id: 1
},
{
    quantity: 100,
    key_id: 2,
    purchase_order_id: 2
},
{
    quantity: 100,
    key_id: 3,
    purchase_order_id: 1
},
{
    quantity: 100,
    key_id: 4,
    purchase_order_id: 12
}])


p "Created #{PoK.count} PurchaseOrder--Keys"

