module Admin
class ElementsController < AdminController

    before_action :set_blog_post
    before_action :set_element, only: [:update, :destroy, :swap_up, :swap_down ]

    def swap_up
      remove_element_position_gaps()

      pos_before = @element.position
      @element.position = @element.position - 1

      didSwap = false
      # swap the other element
      @blog_post.elements.each do | e |
        if ( e.position == @element.position )
          e.position = pos_before
          e.save # SAVE!!!!
          didSwap = true
          break
        end
      end
      if( didSwap ) # if we didn't swap, no need to save this new value.
        @element.save # SAVE!!!!
      end
      redirect_to edit_blog_post_path(@blog_post)
    end

    def swap_down
      remove_element_position_gaps()
      pos_before = @element.position
      @element.position = @element.position + 1

      didSwap = false
      # swap the other element
      @blog_post.elements.each do | e |
        if ( e.position == @element.position )
          e.position = pos_before
          e.save # SAVE!!!!
          didSwap = true
          break
        end
      end
      if( didSwap ) # if we didn't swap, no need to save this new value.
        @element.save # SAVE!!!!
      end
      redirect_to edit_blog_post_path(@blog_post)
    end

    # POST /elements or /elements.json
    def create
      if @blog_post
        max_position = get_max_element_position()
        @element = @blog_post.elements.build(element_params)

        @element.position = max_position + 1

        if @element.save
          notice = nil
        else
          notice = @element.errors.full_messages.join(". ") << "."
        end
        redirect_to edit_blog_post_path(@blog_post)
      end

      if @album
        @element = @album.elements.build(element_params)
        if @element.save
          notice = "successfully made element "
        else
          notice = @element.errors.full_messages.join(". ") << "."
        end
        redirect_to edit_album_path(@album)
      end
    end

    # PATCH/PUT /elements/1 or /elements/1.json
    def update
        @element.update(element_params)
        if @blog_post
          redirect_to edit_blog_post_path(@element.blog_post)
        end
    end

    # DELETE /elements/1 or /elements/1.json
    def destroy
      @element.destroy
      if @blog_post
        redirect_to edit_blog_post_path(@element.blog_post)
      end
      if @album
        redirect_to edit_album_path(@element.album)
      end
    end

    private
      def get_max_element_position

        posMax = 0
        @blog_post.elements.each do |e|
          if e.position > posMax
            posMax = e.position
          end
        end
        return posMax
      end

      def get_min_element_position

        posMin = get_max_element_position()
        @blog_post.elements.each do |e|
          if e.position < posMin
            posMin = e.position
          end
        end
        return posMin
      end
      # this function is for removing gaps in the positions of elements during sorting
      def remove_element_position_gaps
        didMutate = true
        safetyIterationN = 1000

        min_position_with_gap_after = 0
        i = 0

        min_pos = get_min_element_position()
        @blog_post.elements.each do |e|
          e.position = e.position - min_pos
          e.save
        end

        while( didMutate && i < safetyIterationN )

          # find position with gap afterwards
          @blog_post.elements.each do |e|
            if( e.position == min_position_with_gap_after + 1 )
              min_position_with_gap_after = e.position
            end
          end

          max_pos = get_max_element_position()
          if min_position_with_gap_after == max_pos
            didMutate = false
            return
          end

          gap_position = max_pos

          # find position after gap
          @blog_post.elements.each do |e|
            if( e.position > min_position_with_gap_after && e.position < gap_position)
              gap_position = e.position
            end
          end

          # separation to subtract
          separation = gap_position - min_position_with_gap_after

          # subtract the gap distance from each above min_pos...
          @blog_post.elements.each do |e|
            if( e.position > min_position_with_gap_after )
              e.position = e.position - separation + 1 # PLUS 1 so that there's still in order, no duplicate positions
              e.save
            end
          end

          i = i + 1
        end # while loop
      end

      def set_blog_post
        if params[:blog_post_id]
          @blog_post = BlogPost.find(params[:blog_post_id])
        end

        if params[:album_name]
          @album = Album.find_by!(name: params[:album_name])
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_element
        if @blog_post
          @element = @blog_post.elements.find(params[:id])
        end

        if @album
          @element = @album.elements.find(params[:id])
        end
      end

      # Only allow a list of trusted parameters through.
      def element_params
        params.require(:element).permit(:kind, :content, :image, :position, :ext_link)
      end
end
end #module Admin
