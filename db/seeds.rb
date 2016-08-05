# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
EndUser.destroy_all

EndUser.create!([{
    name: "asdf",
    address: "aa",
    email: ";lkj",
    phone: "234",
    department: "asdf",
    store_number: 2
},
{
    name: "sdf",
    address: "fdaasdf",
    email: "jjjjjj",
    phone: "2344",
    department: "as",
    store_number: 1
},
{
    name: "asdfasdf",
    address: "fdssssaa",
    email: "ffdsas",
    phone: "64221",
    department: "asdf",
    store_number: 3
}])

p "Created #{EndUser.count} Users"
