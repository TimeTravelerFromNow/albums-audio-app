# non- Admin controller

class MusicsController < ApplicationController
  before_action :set_music, only: %i[ show]

  # GET /musics or /musics.json
  def index
    @musics = Music.all
  end

  # GET /musics/1 or /musics/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
      if @music.single?
      else
        @album = Album.find(params[:album_id])
      end
    end

    # Only allow a list of trusted parameters through.
    def music_params
      params.require(:music).permit( :album_id)
    end
end
