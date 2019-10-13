class Admin::WhitelistsController < Comfy::Admin::Cms::BaseController

  before_action :build_whitelist,  :only => [:new, :create]
  before_action :load_whitelist,   :only => [:show, :edit, :update, :destroy]

  def index
    @whitelists = Whitelist.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @whitelist.save!
    flash[:success] = 'Whitelist created'
    redirect_to :action => :show, :id => @whitelist
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Whitelist'
    render :action => :new
  end

  def update
    @whitelist.update_attributes!(whitelist_params)
    flash[:success] = 'Whitelist updated'
    redirect_to :action => :show, :id => @whitelist
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Whitelist'
    render :action => :edit
  end

  def destroy
    @whitelist.destroy
    flash[:success] = 'Whitelist deleted'
    redirect_to :action => :index
  end

protected

  def build_whitelist
    @whitelist = Whitelist.new(whitelist_params)
  end

  def load_whitelist
    @whitelist = Whitelist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Whitelist not found'
    redirect_to :action => :index
  end

  def whitelist_params
    params.fetch(:whitelist, {}).permit(:ip_address)
  end
end