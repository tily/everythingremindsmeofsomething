Padrino.configure_apps do
  set :session_secret, ENV['SESSION_SECRET']
end

Padrino.mount("Ermos").to('/')
