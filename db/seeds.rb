# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(id: 1, name: 'test-Admin', email: 'test@abv.bg', password: '123123', role: 'Admin', owner_id: 0, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
User.create(id: 2, name: 'test1-Admin', email: 'test1@abv.bg', password: '123123', role: 'Admin', owner_id: 0, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')

User.create(id: 3, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'Reseller', owner_id: 1, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
User.create(id: 4, name: 'test3', email: 'test3@abv.bg', password: '123123', role: 'User', owner_id: 3, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
User.create(id: 5, name: 'test4', email: 'test4@abv.bg', password: '123123', role: 'User', owner_id: 3, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')


User.create(id: 6, name: 'test5', email: 'test5@abv.bg', password: '123123', role: 'Reseller', owner_id: 2, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
User.create(id: 7, name: 'test6', email: 'test6@abv.bg', password: '123123', role: 'User', owner_id: 6, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
User.create(id: 8, name: 'test7', email: 'test7@abv.bg', password: '123123', role: 'User', owner_id: 6, created_at: '2018-02-22 12:02:55', updated_at: '2018-03-11 13:39:21')
