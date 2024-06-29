module Admin
class CategoriesController < AdminController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
    @blog_posts = BlogPost.where(category: @category)
    @categories = Category.all
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @blog_posts = BlogPost.all
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to dashboard_index_path, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @blog_posts = @category.blog_posts

    @blog_posts.each do |bp|
      bp.category_id = nil
      bp.save
    end

    @category.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_index_path	, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_bp_category
    if params[:id] == 0
      @blog_posts_category = nil
      redirect_to  request.referrer
    end
    @blog_posts_category = Category.find(params[:id])
    redirect_to  request.referrer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :description, :category_image, :blog_post)
    end
end
end #module Admin
