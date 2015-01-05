require 'mime/types'
class Validator

  # 验证邮箱格式
  def self.email?(email)
    return false if email.length <= 3 || email.length >= 255
    # email如包含\xBF则会报错：inval​id by​te se​quenc​e in ​UTF-8，在ruby2.1可以用scrub函数去掉错误编码的字符
    return true if email.to_s =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i rescue nil
    false
  end

  def self.empty?(obj)
    obj.to_s.empty?
  end

  def self.user_name?(user_name)
    return true if user_name.to_s =~ /^([a-z\u4e00-\u9fa5])[a-z0-9\u4e00-\u9fa5_-]{3,16}$/
    false
  end

  def self.url?(url)
    return true if url.to_s =~ /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
    false
  end

  def self.password?(pwd)
    return true if pwd.length >=4 && pwd.length <= 40
    false
  end

  def self.password_min?(pwd)
    return true if pwd.length >=4
    false
  end

  def self.password_max?(pwd)
    return true if pwd.length <= 40
    false
  end

  def self.image?(file_name)
    name = file_name.to_s.downcase
    ext = File.extname(name)
    return false if ext.empty?
    ['.jpg', '.jpeg', '.gif', '.png', '.bmp', '.webp'].include?(ext)
  end

  def self.json?(file_name)
    name = file_name.to_s.downcase
    ext = File.extname(name)
    return false if ext.empty?
    ['.json'].include?(ext)
  end

  def self.under_size?(size_in_byte, limit_mb)
    size_in_byte <= limit_mb * 1024 * 1024
  end

end