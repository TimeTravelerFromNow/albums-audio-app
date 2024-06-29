module Admin
class MusicsController < AdminController
  before_action :set_album, only: %i[ swap_up swap_down create  ]
  before_action :set_music, only: %i[ show edit update destroy swap_up swap_down ]

  # GET /musics or /musics.json
  def index
    @musics = Music.all
  end

  # GET /musics/1 or /musics/1.json
  def show
  end

  # GET /musics/new
  def new
    @music = Music.new
  end

  # GET /musics/1/edit
  def edit
  end

  def swap_up
    remove_music_position_gaps()

    pos_before = @music.position
    @music.position = @music.position - 1

    didSwap = false
    # swap the other element
    @album.musics.each do | e |
      if ( e.position == @music.position )
        e.position = pos_before
        e.save # SAVE!!!!
        didSwap = true
        break
      end
    end
    if( didSwap ) # if we didn't swap, no need to save this new value.
      @music.save # SAVE!!!!
    end
    redirect_to edit_album_path(@album)
  end

  def swap_down
    remove_music_position_gaps()

    pos_before = @music.position
    @music.position = @music.position + 1

    didSwap = false
    # swap the other element
    @album.musics.each do | e |
      if ( e.position == @music.position )
        e.position = pos_before
        e.save # SAVE!!!!
        didSwap = true
        break
      end
    end
    if( didSwap ) # if we didn't swap, no need to save this new value.
      @music.save # SAVE!!!!
    end
    redirect_to edit_album_path(@album)
  end
  # POST /musics or /musics.json
  def create
    max_position = get_max_music_position()
    @music = @album.musics.build(music_params)
    @music.position = max_position + 1

    respond_to do |format|
      music_file_name = ""
      if music_params["music_file"] == nil && !( @music.single? )
         format.html { redirect_to edit_album_path(@album), notice: "please upload a music file." }
         format.json { render :show, status: :unprocessable_entity, location: @album }
      else
        if music_params["name"] == ""
          music_file_name = @music.music_file.filename

          @music.name = music_file_name
        end
        if @music.save
          if @music.single?
            format.html { redirect_to music_index_path, notice: "Music was successfully created." }
            format.json { render :show, status: :created, location: @music }
          else
            format.html { redirect_to edit_album_path(@album), notice: "new music added to album" }
          end
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @music.errors, status: :unprocessable_entity }
        end
      end


    end
  end

  # PATCH/PUT /musics/1 or /musics/1.json
  def update
      respond_to do |format|
      if @music.update(music_params)
          if @music.single?
            format.html { redirect_to music_url(@music), notice: "Music was successfully updated." }
            format.json { render :show, status: :ok, location: @music }
        else
          redirect_to edit_album_path(@music.album)

        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1 or /musics/1.json
  def destroy
    if @music.destroy
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: "deletion successful"}
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: "deletion error"}
      end
    end
  end

  private
    def get_max_music_position
      posMax = 0
      @album.musics.each do |m|
        if m.position > posMax
          posMax = m.position
        end
      end
      return posMax
    end

    def get_min_music_position

      posMin = get_max_music_position()
      @album.musics.each do |m|
        if m.position < posMin
          posMin = m.position
        end
      end
      return posMin
    end

    # this function is for removing gaps in the positions of elements during sorting
    def remove_music_position_gaps
      didMutate = true
      safetyIterationN = 1000

      min_position_with_gap_after = 0
      i = 0

      min_pos = get_min_music_position()
      @album.musics.each do |e|
        e.position = e.position - min_pos
        e.save
      end

      while( didMutate && i < safetyIterationN )

        # find position with gap afterwards
        @album.musics.each do |e|
          if( e.position == min_position_with_gap_after + 1 )
            min_position_with_gap_after = e.position
          end
        end

        max_pos = get_max_music_position()
        if min_position_with_gap_after == max_pos
          didMutate = false
          return
        end

        gap_position = max_pos

        # find position after gap
        @album.musics.each do |e|
          if( e.position > min_position_with_gap_after && e.position < gap_position)
            gap_position = e.position
          end
        end

        # separation to subtract
        separation = gap_position - min_position_with_gap_after

        # subtract the gap distance from each above min_pos...
        @album.musics.each do |e|
          if( e.position > min_position_with_gap_after )
            e.position = e.position - separation + 1 # PLUS 1 so that there's still in order, no duplicate positions
            e.save
          end
        end

        i = i + 1
      end # while loop
    end# end remove gaps

    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
      if @music.single?
      else
        @album = Album.find_by!(name: params[:album_name])
      end
    end

    def set_album
      @album = Album.find_by!(name: params[:album_name])
    end

    # Only allow a list of trusted parameters through.
    def music_params
      params.require(:music).permit(:name, :music_file, :single_cover_image, :album_name)
    end
end
end # module Admin
