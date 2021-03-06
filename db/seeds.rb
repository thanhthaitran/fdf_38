User.create!(name: "Le Cao Dat", email: "lecaodat1909@gmail.com",
  password: "123456", password_confirmation: "123456", is_admin: true)

9.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@gmail.com"
  password = "password"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end

Category.create!(name: "Foods", parent_id: 0)
Category.create!(name: "Drinks", parent_id: 0)
food = Category.find_by name: "Foods"
drink = Category.find_by name: "Drinks"

3.times do |n|
  name = Faker::Name.name
  parent_id = food.id
  Category.create!(name: name, parent_id: parent_id)
end

3.times do |n|
  name = Faker::Name.name
  parent_id = drink.id
  Category.create!(name: name, parent_id: parent_id)
end

categories = Category.all
10.times do
  price = 10000
  quality = 10
  categories.each{|category| category.products.create!(name: Faker::Name.name, detail: Faker::Lorem.sentence(20), price: price, quality: quality)}
end

users = User.take(5)
3.times do |n|
  users.each do |user|
    user.orders.create!(status: false, total: 0)
  end
end

orders = Order.all
products = Product.take(2)
orders.each do |order|
  2.times do |n|
    products.each do |product|
      order_detail = order.order_details.new quality: 2
      product.order_details << order_detail
      total = order.total + order_detail.quality * product.price
      order.update_attribute :total, total
    end
  end
end

users.each do |user|
  products.each do |product|
    rating = user.ratings.new rate:4
    product.ratings << rating
  end
end

users.each do |user|
  products.each do |product|
    comment = user.comments.new content: Faker::Lorem.sentence(5)
    product.comments << comment
  end
end
