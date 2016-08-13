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

EndUser.create!([{
    id: 1,
    name: "asdf",
    address: "aa",
    email: ";lkj",
    phone: "234",
    department: "asdf",
    store_number: 2
},
{
    id: 2,
    name: "sdf",
    address: "fdaasdf",
    email: "jjjjjj",
    phone: "2344",
    department: "as",
    store_number: 1
},
{
    id: 3,
    name: "asdfasdf",
    address: "fdssssaa",
    email: "ffdsas",
    phone: "64221",
    department: "asdf",
    store_number: 3
}])


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


PurchaseOrder.create!([{
    so_number: 1,
    po_number: 4,
    date_order: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
    purchaser_id: 1,
    end_user_id: 1
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


p "Created #{Key.count} Keys"
p "Created #{EndUser.count} Users"
p "Created #{Purchaser.count} Purchasers"
p "Created #{PurchaseOrder.count} Purchase Orders"
p "Created #{PoK.count} PurchaseOrder--Keys"

