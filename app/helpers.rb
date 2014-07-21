# coding:utf-8
require 'uri'

Ermos.helpers do
  POEMS = %w(
    何か言おうとしてたけど忘れた
    猫を見ると猫がにらみ返す
    煮込んでも煮込んでも物足りない
    世界人類が平和でありますように 
    ぼくはプログラミングができない
    視線に意識を代入する
    こんなくだらないウェブサービスは即刻退会しろ
    目を覚ましたら夕方で頬に畳のあとがついていた
    暖炉の前でお父様のお話を聞きながら眠ってしまっていた
    くだらない言葉ばかり増えて言いたいことは何も言えない
    おれはもうだめだ
    ねぇ、聞いてる？
    半眼微笑のマシンガンを抱えた仏さま
    リロードしたら消えてしまう本質
    灰色の美しい雨の匂い
    プールの底に沈めたピアノ
    今何時？
    消失
    愛
    ため息
  )

  def title
    num = rand(2)
    text = rand(1000) == 0 ? POEMS.sample : Ermos::TITLE
    if num == 0
      unsearchablize(text)
    else
      unsearchablize2(text)
    end
  end

  def unsearchablize(text=' ')
    separator = "?./+*-  "
    text.split('').reduce {|memo, c|
      memo + separator.split('').sample + c
    }.gsub(/\b /, '')
  end

  def unsearchablize2(text)
    separator =
      "\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0307\u0308\u0309\u030A\u030B\u030C\u030D\u030E\u030F" +
      "\u0310\u0311\u0312\u0313\u0314\u0315\u0316\u0317\u0317\u0318\u0319\u031A\u031B\u031C\u031D\u031E\u031F" +
      "\u0320\u0321\u0322\u0323\u0324\u0325\u0326\u0327\u0327\u0328\u0329\u032A\u032B\u032C\u032D\u032E\u032F" +
      "\u0330\u0331\u0332\u0333\u0334\u0335\u0336\u0337\u0337\u0338\u0339\u033A\u033B\u033C\u033D\u033E\u033F" +
      "\u0340\u0341\u0342\u0343\u0344\u0345\u0346\u0347\u0347\u0348\u0349\u034A\u034B\u034C\u034D\u034E\u034F" +
      "\u0350\u0351\u0352\u0353\u0354\u0355\u0356\u0357\u0357\u0358\u0359\u035A\u035B\u035C\u035D\u035E\u035F" +
      "\u0360\u0361\u0362\u0363\u0364\u0365\u0366\u0367\u0367\u0368\u0369\u036A\u036B\u036C\u036D\u036E\u036F"
    text.split('').reduce {|memo, c|
      memo + separator.split('').sample + c
    }.gsub(/\b /, '')
  end

  def link_to_prev_page(scope, name, options = {})
    params = options.delete(:params) || (Rack::Utils.parse_query(env['QUERY_STRING']).symbolize_keys rescue {})
    param_name = options.delete(:param_name) || Kaminari.config.param_name
    placeholder = options.delete(:placeholder) || ""
    query = params.merge(param_name => (scope.current_page - 1))
    unless scope.first_page?
      link_to name, env['PATH_INFO'] + (query.empty? ? '' : "?#{query.to_query}"), options.merge(:rel => 'prev')
    else
      placeholder
    end
  end

  # access control helpers
  def current_ability
    @ability ||= Ability.new(current_account)
  end

  def can? *args
    current_ability.can? *args
  end
  
  def cannot? *args
    current_ability.cannot? *args
  end
  
  def authorize! *args
    current_ability.authorize! *args
  end
end
