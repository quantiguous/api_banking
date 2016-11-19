module ApiBanking
  module Environment
    class Factory
      def build(bank_name, env_name, params)        
        case bank_name.downcase
        when "ybl"
          case env_name.downcase
          when "uat"
            return ApiBanking::Environment::YBL::UAT.new(params[:user], params[:password], params[:client_id], params[:client_secret])
          when "prd"
            return ApiBanking::Environment::YBL::PRD.new(params[:user], params[:password], parmas[:client_id], params[:client_secret], params[:client_cert], params[:client_key])
        end
        
        return nil
      end
    end
  end
end
