class MapController < ApplicationController
    def index
        @enduser = EndUser.find(1)

        EndUser.within(5, :origin => [37.792,-122.393])
    end
end
