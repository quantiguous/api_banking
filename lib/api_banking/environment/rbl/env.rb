module ApiBanking
  module Environment
    module RBL
      UAT = Struct.new(:code, :subCode, :reasonText)
      PRD = Struct.new(:code)
    end
  end  
end
