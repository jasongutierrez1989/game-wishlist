require './config/environment'

class GamesController < ApplicationController
  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/games' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    @user = User.current_user(session)
    erb :'/games/index'
  end

  get '/games/new' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    erb :'/games/new'
  end

  get '/games/:id/edit' do
    @game = Game.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != @game.user.id
      redirect to '/'
    end

    erb :'/games/edit'
  end

  get '/games/:id' do
    @game = Game.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != @game.user.id
      redirect to '/'
    end
    
    erb :'/games/show'
  end

  post '/games' do
    if !User.logged_in?(session)
      redirect to '/'
    end

    if game = Game.create(name: params[:game][:name])
      game.user = User.current_user(session)
      game.save

      redirect to "/games/#{game.id}"
    else
      redirect to 'games/new'
    end
  end

  patch '/games/:id' do
    game = Game.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != game.user.id
      redirect to '/'
    end

    if game
      if params[:game][:name] && params[:game][:name] != ""
        game.update(name: params[:game][:name])
      end

      game.save

      redirect to "/games/#{game.id}"
    else
      redirect to "/games"
    end    
  end

  delete '/games/:id' do
    game = Game.find_by(id: params[:id])

    if !User.logged_in?(session) ||  User.current_user(session).id != game.user.id
      redirect to '/'
    end

    if game
      game.destroy
    end

    redirect to '/games'
  end
end