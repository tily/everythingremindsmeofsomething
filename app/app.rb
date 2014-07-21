# coding:utf-8
class Ermos < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl
  register Kaminari::Helpers::SinatraHelpers
  
  set :login_page, "/" # determines the url login occurs
  
  access_control.roles_for :any do |role|
    role.protect "/admin" # here a demo path
  end
  
  access_control.roles_for :users do |role|
  end

  case Padrino.env
  when :production
    uri = URI.parse(ENV['MONGOHQ_URL'])
    db = uri.path.gsub(/^\//, '')
    connection = Mongo::Connection.new(uri.host, uri.port)
    connection.db(db).authenticate(uri.user, uri.password) unless (uri.user.nil? || uri.password.nil?)
    use Rack::Session::Mongo, :connection => connection, :db => db, :expire_after => 60*60*24*7 # 1 week
  when :development
    connection = Mongo::Connection.new
    use Rack::Session::Mongo, :connection => connection, :db => 'ermos_development', :expire_after => 60*60*24*7 # 1 week
  end

  use Rack::Csrf, :raise => true
  set :haml, {:escape_html => true}

  use OmniAuth::Builder do
    provider :twitter,  'x0KN32X1MYVpvH32RK1WeA', 'RgpQaBBCHQxn3OdXmEXmgMRttLdKnKt4VIxBI52MF0'
  end

  use Rack::GoogleAnalytics, :tracker => 'UA-28951043-1'

  configure do
    TITLE = '何を見ても何か思い出す'
  end
end
