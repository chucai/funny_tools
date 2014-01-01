require 'rchardet19'

class String
  def to_utf_8
    cd = CharDet.detect(self)      #用于检测编码格式  在gem rchardet9里
    if cd.confidence > 0.6
      self.force_encoding(cd.encoding)
    end
    self.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    return self
  end
end
