require "application_system_test_case"

class StorefrontCheckoutTest < ApplicationSystemTestCase
  setup do
    Rails.application.load_seed
    @user = users(:archivist)
    @product = Product.find_by!(slug: "solaris-pinball-cabinet")
  end

  test "guest checkout redirects to archive access" do
    visit catalog_path(@product)
    click_button "Add to Basket"
    visit shipping_ledger_path

    click_button "Finalize Order & Seal Manifest"

    assert_current_path new_user_session_path
    assert_text "Return to the private ledger"
  end

  test "signed in user can place an order from the shipping ledger" do
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    visit catalog_path(@product)
    click_button "Add to Basket"
    visit shipping_ledger_path

    fill_in "Full name", with: "Ada Archivist"
    fill_in "Correspondence Email", with: "ada@example.com"
    fill_in "Street Address", with: "123 Archive Way"
    fill_in "City / Province", with: "Paris"
    fill_in "Postal Code", with: "75001"
    choose "Pony Express Premium"
    click_button "Finalize Order & Seal Manifest"

    assert_current_path shipping_ledger_path
    assert_text "Manifest sealed"
    assert_text "Your ledger is empty"
  end
end
