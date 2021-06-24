# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(full_name: 'Rulev Denis Igorevich', username: 'administrator', password: 'administrator', email: 'administrator@mail.ru', created_at: Time.now, is_admin: true, is_super_admin: true) unless User.exists?(username: 'administrator', email: 'administrator@mail.ru',  is_admin: true, is_super_admin: true)

players = [
  {name: 'Денис', surname: 'Рулев', patronymic: 'Игоревич', birth_year: 1999, gender: 'male', wins: 32, losses: 5},
  {name: 'Никита', surname: 'Лох', patronymic: 'Игоревич', birth_year: 1999, gender: 'male', wins: 3, losses: 50}
]

players.each do |player|
  Player.find_or_create_by!(player)
end
# yomi = User.find_by_email('jascha_haldemann@hotmail.com')
# if yomi.present?
#   yomi.update(is_admin: true, is_super_admin: true)
# end

# hdmp = User.find_by_email('wanja_haldemann@hotmail.ch')
# if hdmp.present?
#   hdmp.update(is_admin: true, is_super_admin: true)
# end
