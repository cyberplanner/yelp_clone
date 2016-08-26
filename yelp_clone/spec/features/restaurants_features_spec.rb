require 'rails_helper'

feature 'restaurants' do
  before do
    User.create email: 'sal@email.com', password: 'secret', password_confirmation: 'secret'
    User.create email: 'giancarlo@email.com', password: 'secret1', password_confirmation: 'secret1'
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add restaurants' do
      sign_in
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

    context 'restaurants have been added' do
      before do
        Restaurant.create name: 'KFC', description: 'Deep fried goodness'
      end

      scenario 'displays restaurants' do
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end
    end


    context 'creating restaurants' do
      scenario 'prompt user to fill out a form, then displays the new restaurant' do
        sign_in
        add_restaurant(name: 'KFC')
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_in
        add_restaurant(name: 'kf')
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'viewing restaurants' do
      let!(:kfc){ Restaurant.create(name:'KFC', description: 'Filthiest chicken money can buy!') }

      scenario 'lets a user view a restaurant' do
        visit '/restaurants'
        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(page).to have_content 'Filthiest chicken money can buy!'
        expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end

    context 'editing restaurants' do
      before do
        Restaurant.create name: 'KFC', description: 'Deep fried goodness'
      end
      scenario 'let user edit a restaurant' do
        sign_in
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        fill_in 'Description', with: 'Deep fried goodness'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(page).to have_content 'Deep fried goodness'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do
      before do
        Restaurant.create name: 'KFC', description: 'Deep fried goodness'
      end
      scenario 'removes a restaurant when a user clicks a delete link' do
        sign_in
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end

    context 'user not logged in' do
      scenario 'cannot create restaurants' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to have_content 'Log in'
      end
    end

    # context "While signed out" do
    #   scenario 'cannot edit a restaurant' do
    #     sign_in(email: 'sal@email.com', password: 'secret')
    #     add_restaurant(name: 'KFC')
    #     sign_out
    #     sign_in(email: 'giancarlo@email.com', password: 'secret1')
    #     click_link 'Edit KFC'
    #     expect(page).to have_content "You cannot edit someone else's restaurant!"
    #   end
    #
    #   scenario 'cannot delele a restaurant' do
    #     sign_in(email: 'sal@email.com', password: 'secret')
    #     add_restaurant(name: 'KFC')
    #     sign_out
    #     sign_in(email: 'giancarlo@email.com', password: 'secret1')
    #     click_link 'Delete KFC'
    #     expect(page).to have_content "You cannot delete someone else's restaurant!"
    #   end
    # end
end
