class KeycodesController < ApplicationController
    def index
        Rails.logger.debug("HIIII")
    end

    def show
        Rails.logger.debug("**********************************************")
        Rails.logger.debug("***************PARAMETERS*********************")
        Rails.logger.debug("**********************************************")
        Rails.logger.debug(params)
    end
end
