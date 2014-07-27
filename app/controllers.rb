Ermos.controllers do

  error 404 do
    "404 Not Found"
  end

  # トップ
  get '/' do
    @pairs = Pair.desc(:created_at).page(params[:page])
    haml :top
  end

  # トップ (json)
  get '/*.json' do
    content_type 'text/json'
    @pairs = Pair.desc(:created_at).page(params[:page])
    @pairs.to_json
  end

  # 連想
  get %r{/souvenirs/(.+)} do
    @thing = params[:captures].first
    @pairs = Pair.where(:$or => [{:a => @thing}, {:b => @thing}]).desc(:created_at).page(params[:page])
    haml :souvenirs
  end

  # ログアウト
  get '/logout' do
    set_current_account(nil)
    redirect '/'
  end

  # 説明
  get '/about' do
    haml :about
  end

  # Pair 作成フォーム
  get "/pairs/new" do
    authorize! :create, Pair
    @pair = Pair.new
    haml :new_pair
  end

  # 個別 Pair
  get "/pairs/:id" do
    begin
    @pair = Pair.find(params[:id])
    rescue Mongoid::Errors::DocumentNotFound => e
      halt 404
    end
    haml :pair
  end

  # Pair 作成
  post "/pairs" do
    authorize! :create, Pair
    begin
      current_account.pairs.create!(params[:pair])
    rescue Mongoid::Errors::Validations => e
      @pair = current_account.pairs.last
      return haml :new_pair
    end
    redirect "/#{current_account.screen_name}"
  end

  # Like 作成
  post "/likes/:pair_id" do
    @pair = Pair.find(params[:pair_id])
    Like.create(:pair_id => params[:pair_id], :account_id => current_account.id)
    redirect "/pairs/#{@pair.id}"
  end

  # Pair 削除
  delete "/pairs/:id" do
    @pair = Pair.find(params[:id])
    authorize! :delete, @pair
    screen_name = @pair.account.screen_name
    @pair.destroy
    @pair.likes.destroy 
    redirect "/#{screen_name}"
  end

  # Like 削除
  delete "/likes/:pair_id" do
    @like = Like.where(:pair_id => params[:pair_id], :account_id => current_account.id).first
    authorize! :delete, @like
    @like.destroy
    redirect back
  end

  # 個別ユーザ
  get "/:screen_name" do
    @account = Account.where(:screen_name => params[:screen_name]).first
    halt 404 if @account.nil?
    @pairs = @account.pairs.desc(:created_at).page(params[:page])
    haml :account
  end

  # 個別ユーザ編集
  get "/:screen_name/edit" do
    @account = Account.where(:screen_name => params[:screen_name]).first
    haml :account_edit
  end

  # 個別ユーザ更新
  put "/:screen_name" do
    @account = Account.where(:screen_name => params[:screen_name]).first
    authorize! :update, @account
    @account.set(:name, params[:account][:name])
    redirect "/#{@account.screen_name}"
  end

  get :auth, :map => '/auth/:provider/callback' do
    auth    = request.env["omniauth.auth"]
    account = Account.where(:provider => auth["provider"], :uid => auth["uid"]).first || 
              Account.create_with_omniauth(auth)
    set_current_account(account)
    redirect "http://" + request.env["HTTP_HOST"] + "/#{account.screen_name}"
  end
end
