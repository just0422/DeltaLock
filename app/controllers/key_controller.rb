class KeyController < ApplicationController
    def show
        print("***PARAMS")
        print(params[:key_hash])
        print("\n")
        @key = Key.find(params[:id])
        @pok = PoK.find_by_key_id(@key[:key_hash])
    end
end
