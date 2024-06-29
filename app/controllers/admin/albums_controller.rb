module Admin
 class AlbumsController < AdminController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :set_link_positions, only: %i[ edit ]

  # GET /albums or /albums.json
  def index
    @albums = Album.all
  end

  # GET /albums/1 or /albums/1.json
  def show
      @albums = Album.all
  end

  # GET /albums/new
  def new
    @album = Album.new( )
    @music = Music.new()
  end

  # GET /blog_posts/1/edit
  def edit
    @music = @album.musics.build(name: "unnamed song", id: 0)
    @element = @album.elements.build()
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_url(@album), notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to edit_album_path(@album), notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_index_path, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
        @album = Album.find_by!(name: params[:name])
    end

    def set_link_positions

      a_elms = @album.elements
      @hardcoded_positions = [ a_elms.where(:position => 0).exists?,
         a_elms.where(:position => 1).exists?,
            a_elms.where(:position => 2).exists? ]

      eCount = @album.elements.count
      @positions = Array.new(eCount)

      @album.elements.order(position: :asc).each_with_index.map { |e, index|
        @positions[index] = e.position
      }
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:name, :album_cover_image, :music, :story)
    end
end
end # module Admin
