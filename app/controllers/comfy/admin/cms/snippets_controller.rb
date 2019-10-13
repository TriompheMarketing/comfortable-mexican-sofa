class Comfy::Admin::Cms::SnippetsController < Comfy::Admin::Cms::BaseController

  before_action :build_snippet, :only => [:new, :create]
  before_action :load_snippet,  :only => [:edit, :update, :destroy]
  before_action :authorize, :verify_ip_address

  def index
    return redirect_to :action => :new if @site.snippets.count == 0
    @snippets = @site.snippets.includes(:categories).for_category(params[:category])
  end

  def new
    render
  end

  def edit
    @snippet.attributes = snippet_params
  end

  def create
    @snippet.save!
    flash[:success] = I18n.t('comfy.admin.cms.snippets.created')
    redirect_to :action => :edit, :id => @snippet
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = I18n.t('comfy.admin.cms.snippets.creation_failure')
    render :action => :new
  end

  def update
    @snippet.update_attributes!(snippet_params)
    flash[:success] = I18n.t('comfy.admin.cms.snippets.updated')
    redirect_to :action => :edit, :id => @snippet
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = I18n.t('comfy.admin.cms.snippets.update_failure')
    render :action => :edit
  end

  def destroy
    @snippet.destroy
    flash[:success] = I18n.t('comfy.admin.cms.snippets.deleted')
    redirect_to :action => :index
  end

  def reorder
    (params[:comfy_cms_snippet] || []).each_with_index do |id, index|
      ::Comfy::Cms::Snippet.where(:id => id).update_all(:position => index)
    end
    head :ok
  end

protected

  def build_snippet
    @snippet = @site.snippets.new(snippet_params)
  end

  def load_snippet
    @snippet = @site.snippets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('comfy.admin.cms.snippets.not_found')
    redirect_to :action => :index
  end

  def snippet_params
    params.fetch(:snippet, {}).permit!
  end

  private

  def verify_ip_address
    head :unauthorized if Whitelist.find_by(ip_address: request.remote_ip).nil?
    # if Whitelist.find_by(ip_address: request.remote_ip).nil?
    # redirect_to root_path, alert: 'Unauthorized access.'
    # end
  end

end
