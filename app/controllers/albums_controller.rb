# non- Admin controller
 class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show ]

  # GET /albums or /albums.json
  def index
    @albums = Album.all
  end

  # GET /albums/1 or /albums/1.json
  def show
      @albums = Album.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
        @album = Album.find_by!(name: params[:name])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album)
    end
end
