class StoriesController < ApplicationController
  def index
    @stories = Story.all
  end
  
  def new
    @story = Story.new
    @fragment = @story.fragments.new
  end
  
  def show
    @story = Story.find(params[:id])
    @fragment =  @story.fragments.new
    
    gon.fragments = add_author_name(@story.fragments.arrange_serializable(order: :created_at).first)
    
    render layout: 'story'
  end

  def create
    @story = current_user.stories.build(story_params)
    @fragment = @story.fragments.build(story_fragment_params.merge(author: current_user))
    
    if @story.save
      redirect_to @story
    else
      render 'new'
    end
  end
  
  private
  def story_params
    params.require(:story).permit(:title)
  end
  
  def story_fragment_params
    params.require(:story).permit(fragment: [:content, :parent])[:fragment]
  end

  def add_author_name(hash)
    hash[:author_name] = User.find(hash["author_id"]).username
    if hash["children"].count > 0
      hash["children"].each do |c|
        add_author_name(c)
      end
    end
    
    hash
  end
end
