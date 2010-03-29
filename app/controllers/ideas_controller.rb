class IdeasController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?
  before_filter :set_current_tab
  before_filter :login_required, :only => [:like, :new, :create, :update]
  before_filter :load_top_ideas
  before_filter :load_newest_ideas
  before_filter :load_featured_ideas, :only => [:index]
  before_filter :set_idea_board
  before_filter :load_newest_idea_boards

  def index
    @current_sub_tab = 'Browse Ideas'
    @ideas = Idea.paginate :page => params[:page], :per_page => Idea.per_page, :order => "created_at desc"
    respond_to do |format|
      format.html
      format.fbml
      format.atom
      format.json { @ideas = Idea.refine(params) }
      format.fbjs { @ideas = Idea.refine(params) }
    end
  end

  def new
    @current_sub_tab = 'Suggest Idea'
    @idea = Idea.new
    @idea.idea_board = @idea_board if @idea_board.present?
    @ideas = Idea.newest
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    @idea.tag_list = params[:idea][:tags_string]
    if params[:idea][:idea_board_id].present?
    	@idea_board = IdeaBoard.find_by_id(params[:idea][:idea_board_id])
    	@idea.section_list = @idea_board.section unless @idea_board.nil?
    end

    if @idea.save
    	flash[:success] = "Thank you for your idea!"
    	redirect_to @idea_board.present? ? [@idea_board, @idea] : @idea
    else
      @ideas = Idea.newest
    	render :new
    end
  end

  def show
    @idea = Idea.find(params[:id])
    tag_cloud @idea
  end

  def my_ideas
    @current_sub_tab = 'My Ideas'
    @user = User.find(params[:id])
    @ideas = @user.ideas
  end

  def set_slot_data
    @ad_banner = Metadata.find_by_key_type_sub_name('ads', 'primary', 'ideas')
    @ad_leaderboard = Metadata.find_by_key_type_sub_name('ads', 'leaderboard', 'ideas')
    @ad_skyscraper = Metadata.find_by_key_type_sub_name('ads', 'skyscraper', 'ideas')
  end

  private

  def set_idea_board
    @idea_board = params[:idea_board_id].present? ? IdeaBoard.find(params[:idea_board_id]) : nil
  end

  def set_current_tab
    @current_tab = 'ideas'
  end

end
