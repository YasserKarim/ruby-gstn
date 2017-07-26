require 'test_helper'

class TaxPayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tax_payer = tax_payers(:one)
  end

  test "should get index" do
    get tax_payers_url
    assert_response :success
  end

  test "should get new" do
    get new_tax_payer_url
    assert_response :success
  end

  test "should create tax_payer" do
    assert_difference('TaxPayer.count') do
      post tax_payers_url, params: { tax_payer: { app_key: @tax_payer.app_key, gstin: @tax_payer.gstin, password: @tax_payer.password, username: @tax_payer.username } }
    end

    assert_redirected_to tax_payer_url(TaxPayer.last)
  end

  test "should show tax_payer" do
    get tax_payer_url(@tax_payer)
    assert_response :success
  end

  test "should get edit" do
    get edit_tax_payer_url(@tax_payer)
    assert_response :success
  end

  test "should update tax_payer" do
    patch tax_payer_url(@tax_payer), params: { tax_payer: { app_key: @tax_payer.app_key, gstin: @tax_payer.gstin, password: @tax_payer.password, username: @tax_payer.username } }
    assert_redirected_to tax_payer_url(@tax_payer)
  end

  test "should destroy tax_payer" do
    assert_difference('TaxPayer.count', -1) do
      delete tax_payer_url(@tax_payer)
    end

    assert_redirected_to tax_payers_url
  end
end
