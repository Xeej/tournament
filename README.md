# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Local commands:
- bundle update
- rake db:migrate
- rake db:rollback
- rails s
- rails c

- dropdb ssb-tournament-manager_development
- heroku pg:pull \<postgresql-name\> ssb-tournament-manager_development --app ssb-tournament-manager

- heroku pg:reset --app ssb-tournament-manager-stage --confirm ssb-tournament-manager-stage
- heroku pg:push ssb-tournament-manager_development \<postgresql-name\> --app ssb-tournament-manager-stage

Stage commands:
- git push stage master
- git push stage <branch>:main
- heroku logs --tail --remote stage
- heroku run rake db:migrate --remote stage
- heroku run rails c --remote stage
- heroku restart --remote stage

- heroku run rake tournaments_crawler:all --remote stage
- heroku run rake results_crawler:all --remote stage
- heroku run rake utils:remove_player_from_finished_tournament[<t_id>,<p_id>] --remote stage

Prod commands:
- git push prod master
- heroku logs --tail --remote prod
- heroku run rake db:migrate --remote prod
- heroku run rails c --remote prod
- heroku restart --remote prod

- heroku run rake tournaments_crawler:all --remote prod
- heroku run rake results_crawler:all --remote prod
- heroku run rake utils:remove_player_from_finished_tournament[<t_id>,<p_id>] --remote prod

General links:
- http://www.vs-open.com