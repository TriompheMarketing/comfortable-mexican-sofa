require_relative '../test_helper'

class WhitelistTest < ActiveSupport::TestCase

  def test_fixtures_validity
    Whitelist.all.each do |whitelist|
      assert whitelist.valid?, whitelist.errors.inspect
    end
  end

  def test_validation
    whitelist = Whitelist.new
    assert whitelist.invalid?
    assert_errors_on whitelist, :ip_address
  end

  def test_creation
    assert_difference 'Whitelist.count' do
      Whitelist.create(
        :ip_address => 'test ip_address',
      )
    end
  end

end