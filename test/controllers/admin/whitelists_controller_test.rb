require_relative '../../test_helper'

class Admin::WhitelistsControllerTest < ActionController::TestCase

  def setup
    # TODO: login as admin user
    @whitelist = whitelists(:default)
  end

  def test_get_index
    get :index
    assert_response :success
    assert assigns(:whitelists)
    assert_template :index
  end

  def test_get_show
    get :show, :id => @whitelist
    assert_response :success
    assert assigns(:whitelist)
    assert_template :show
  end

  def test_get_show_failure
    get :show, :id => 'invalid'
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Whitelist not found', flash[:danger]
  end

  def test_get_new
    get :new
    assert_response :success
    assert assigns(:whitelist)
    assert_template :new
    assert_select "form[action='/admin/whitelists']"
  end

  def test_get_edit
    get :edit, :id => @whitelist
    assert_response :success
    assert assigns(:whitelist)
    assert_template :edit
    assert_select "form[action='/admin/whitelists/#{@whitelist.id}']"
  end

  def test_creation
    assert_difference 'Whitelist.count' do
      post :create, :whitelist => {
        :ip_address => 'test ip_address',
      }
      whitelist = Whitelist.last
      assert_response :redirect
      assert_redirected_to :action => :show, :id => whitelist
      assert_equal 'Whitelist created', flash[:success]
    end
  end

  def test_creation_failure
    assert_no_difference 'Whitelist.count' do
      post :create, :whitelist => { }
      assert_response :success
      assert_template :new
      assert_equal 'Failed to create Whitelist', flash[:danger]
    end
  end

  def test_update
    put :update, :id => @whitelist, :whitelist => {
      :ip_address => 'Updated'
    }
    assert_response :redirect
    assert_redirected_to :action => :show, :id => @whitelist
    assert_equal 'Whitelist updated', flash[:success]
    @whitelist.reload
    assert_equal 'Updated', @whitelist.ip_address
  end

  def test_update_failure
    put :update, :id => @whitelist, :whitelist => {
      :ip_address => ''
    }
    assert_response :success
    assert_template :edit
    assert_equal 'Failed to update Whitelist', flash[:danger]
    @whitelist.reload
    refute_equal '', @whitelist.ip_address
  end

  def test_destroy
    assert_difference 'Whitelist.count', -1 do
      delete :destroy, :id => @whitelist
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Whitelist deleted', flash[:success]
    end
  end
end