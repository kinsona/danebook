require 'rails_helper'


feature 'Edit User Profile' do

  let(:base_profile) { create(:base_profile) }
  let(:full_profile_fields) { build(:full_profile) }

  before do
    sign_in(base_profile.user)
    visit(user_path(base_profile.user))
    click_link 'Edit your profile'
  end


  scenario 'with valid input' do
    fill_out_user_profile(full_profile_fields)

    click_button 'Save Changes'

    expect(page).to have_content 'Profile updated'
    expect(page).to have_content full_profile_fields.hometown
    expect(page.current_path).to eq(user_path(base_profile.user))
  end


  scenario 'with a valid blank input' do
    fill_out_user_profile(full_profile_fields)

    fill_in 'user_profile_attributes_telephone', with: ""

    click_button 'Save Changes'

    expect(page).to have_content 'Profile updated'
    expect(page).to have_content full_profile_fields.hometown
    expect(page).not_to have_content 'Telephone:'
    expect(page).not_to have_content full_profile_fields.telephone
    expect(page.current_path).to eq(user_path(base_profile.user))
  end


  scenario 'with invalid input' do
    fill_out_user_profile(full_profile_fields)

    invalid_town = "a"*65
    fill_in 'user_profile_attributes_hometown', with: invalid_town

    click_button 'Save Changes'

    expect(page).to have_content 'error'
    expect(page).not_to have_content invalid_town
    expect(page.current_path).to eq(user_path(base_profile.user))
  end


  scenario 'for an unauthorized user' do
    other_user = build(:full_profile).user
    visit edit_user_path(other_user)

    # what about forcing in some edit params without hitting Edit page?

    expect(page).to have_content 'not authorized'
    expect(page.current_path).to eq(root_path)
  end

end