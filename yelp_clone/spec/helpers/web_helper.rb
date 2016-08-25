def sign_in(email: 'sal@email.com', password: 'secret')
  visit '/restaurants'
  click_link 'Sign in'
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

def sign_out
  click_link 'Sign out'
end

def add_restaurant(name: 'ChuckyCheese')
  click_link 'Add a restaurant'
  fill_in 'Name',  with: name
  click_button 'Create Restaurant'
end
