# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#User.create!(full_name: 'admin', username: 'admin@example.com', password: 'admin@example.com', email: 'admin@mail.ru', created_at: Time.now, is_admin: true, is_super_admin: true) unless User.exists?(username: 'admin@example.com', email: 'admin@example.com',  is_admin: true, is_super_admin: true)

players = [
  {name: 'Никита', surname: 'Меденко', gender: 'male'},
  {surname: 'Воронов', name: 'Илья', gender: 'male'},
  {surname: 'Светлова', name: 'Анна', gender: 'female'},
  {surname: 'Формичев', name: 'Федеор', gender: 'male'},
  {surname: 'Стрюков', name: 'Максим', gender: 'male'},
  {surname: 'Потанин', name: 'Сергей', gender: 'male'},
  {surname: 'Горбан', name: 'Даниил', gender: 'male'},
  {surname: 'Девятаева', name: 'Елизавета', gender: 'female'},
  {surname: 'Сизова', name: 'Анастасия', gender: 'female'},
  {surname: 'Ливанова', name: 'Регина', gender: 'female'},
  {surname: 'Мишнев', name: 'Николай', gender: 'male'},
  {surname: 'Власов', name: 'Арсений', gender: 'male'},
  {surname: 'Дмитриев', name: 'Максим', gender: 'male'},
  {surname: 'Егоров', name: 'Никита', gender: 'male'},
  {surname: 'Кудрявцев', name: 'Вячеслав', gender: 'male'},
  {surname: 'Кремнев', name: 'Алексей', gender: 'male'},
  {surname: 'Кремнев', name: 'Александр', gender: 'male'},
  {surname: 'Шуба', name: 'Михаил', gender: 'male'},
  {surname: 'Смирнова', name: 'Анна', gender: 'famale'},
  {surname: 'Мельникова', name: 'Анна', gender: 'female'},
  {surname: 'Якутин', name: 'Евгений', gender: 'male'},
  {surname: 'Хисамова', name: '????', gender: 'female'},
  {surname: 'Мозалев', name: 'Алексей', gender: 'male'}

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
