require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

p 'How many tickets u want to buy?'
tickets = gets.to_i
p 'Id for event?'
id = gets.to_i

module MyCapybaraTest
  class Test
    include Capybara::DSL

    def login
      login
    end

    def main(id)
      open_event_page(id)
      test_event
      sleep 4
      stripe
      sleep 8
    end

    def login
      visit 'http://127.0.0.1:3000/users/sign_in'
      fill_in 'Email', with: 'admin@gmail.com'
      fill_in 'Password', with: 'admin@gmail.com'
      click_on 'Login'
    end

    def open_event_page(id)
      visit "http://127.0.0.1:3000/events/#{id}"
      page.execute_script 'window.scrollBy(0,10000)'
    end

    def test_event
      click_on 'Buy a ticket'
    end

    def stripe
      fill_in 'cardNumber', with: '5454 5454 5454 5454'
      fill_in 'cardExpiry', with: '1123'
      fill_in 'cardCvc', with: '333'
      fill_in 'billingName', with: '333'
      click_on 'Pay'
    end
  end
end

t = MyCapybaraTest::Test.new
t.login
while id < 100
  tickets.times { t.main(id) }
  id += 1
end
