require 'digest'

def star1
  (0..).each do |n|
    return n if Digest::MD5.hexdigest("ckczppom#{n}").slice(..4) == '00000'
  end
end

def star2
  md5 = Digest::MD5.new
  (0..).each do |n|
    md5 << "ckczppom#{n}"
    return n if md5.hexdigest.start_with?('000000')
    md5.reset
  end
end

#p star1
p star2
