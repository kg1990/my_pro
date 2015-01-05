  def build_json(excute_block)
    rs = {}
    msg_json = {}
    code = 200
    message = ''
    begin
      excute_block.call(msg_json, code, message)
      rs[:code] = 200
    rescue ParamErr => par
      rs[:code], msg_json[:desc] = 202, par.message
      err_raiser(par)
    rescue JumpErr => jump
      rs[:code], msg_json[:url] = 302, jump.message
      #err_raiser(jump)
    rescue BizErr => biz
      rs[:code], msg_json[:desc] = 201, biz.message
      #err_raiser(biz)
    rescue LimitErr => limiterr
      rs[:code], msg_json[:desc] = 205, limiterr.message
      #err_raiser(limiterr)
    rescue Exception => e
      rs[:code], msg_json[:desc] = 500, 'Sorry,服务器遇到小麻烦,刚才的操作没成功'
      # err_raiser(e)
      raise e
    end
    rs[:msg] = msg_json
    Oj.dump(rs, mode: :compat)
  end

  def is_mobile_agent?(agent)
    return true if agent.to_s.downcase =~ Regexp.new('palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                          'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                          'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                          'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|' +
                          'mobile|zune')
    false
  end