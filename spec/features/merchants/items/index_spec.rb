require 'rails_helper'

RSpec.describe 'Merchant/Items Index Page' do
before(:each) do 

  @merchant1 = Merchant.create!(name: "Hady", uuid: 1) 
  @merchant2 = Merchant.create!(name: "Malena", uuid: 2) 


  @item_1 = @merchant1.items.create(name: "Salt", description: "it is salty", unit_price: 12, uuid: 1)
  @item_2 = @merchant1.items.create(name: "Pepper", description: "it is peppery", unit_price: 11, uuid: 2)
  @item_3 = @merchant2.items.create(name: "Spices", description: "it is spicy", unit_price: 13, uuid: 3)
  @item_4 = @merchant2.items.create(name: "Sand", description: "its all over the place", unit_price: 14, uuid: 4)
  @item_5 = @merchant1.items.create(name: "Water", description: "nice and liquidy", unit_price: 15, status: 1, uuid: 5)

  @customer_1 = Customer.create(first_name: "Diego", last_name: "Flores")
  @customer_2 = Customer.create(first_name: "Sebastian", last_name: "Beltran")

  @invoice_1 = @customer_1.invoices.create(status: 0)
  @invoice_2 = @customer_1.invoices.create(status: 0)
  @invoice_3 = @customer_1.invoices.create(status: 0)
  @invoice_4 = @customer_2.invoices.create(status: 1)
  @invoice_50 = @customer_1.invoices.create(status: 1)

  InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_50.id, quantity: 2, unit_price: 75000, status: 2, uuid: 17)
end 

  describe "as a merchant" do 
    describe "visit merchant items index page" do 
      it "see link to create new item" do 

        visit "/merchants/#{@merchant1.id}/items"

        expect(page).to have_link("Add Item", href: "/merchants/#{@merchant1.id}/items/new")
      end

      it "click on the link and am taken to a form that allows me to add information" do 

        visit "/merchants/#{@merchant1.id}/items"

        click_link("Add Item")

        expect(current_path).to eq("/merchants/#{@merchant1.id}/items/new")

      end

      it "next to each item i see a button to disable or enable that item" do 

        visit "/merchants/#{@merchant1.id}/items"

        within("div#item_number_#{@item_1.id}") do 
          expect(page).to have_button("Enable/Disable Item #{@item_1.name}")
        end 

      end

      it "when click on that button, am redirected back to the items index and see that the item status has changed" do 

        visit "/merchants/#{@merchant1.id}/items"

        within("div#item_number_#{@item_1.id}") do 
          expect(page).to have_content("Status disabled")
        end 

        within("div#item_number_#{@item_5.id}") do 
          expect(page).to have_content("Status enabled")
        end 

        click_button("Enable/Disable Item #{@item_1.name}")

        click_button("Enable/Disable Item #{@item_5.name}")

        expect(current_path).to eq("/merchants/#{@merchant1.id}/items")

        within("div#item_number_#{@item_1.id}") do 
          expect(page).to have_content("Status enabled")
        end 

        within("div#item_number_#{@item_5.id}") do 
          expect(page).to have_content("Status disabled")
        end 
      end

      it "see sections for disabled and enabled items and items are sorted accordingly to their respective statuses" do 

        visit "/merchants/#{@merchant1.id}/items"
        
        within("div#enabled_items") do 
          expect(page).to have_content("List of Enabled Items")
          expect(page).to have_content(@item_5.name)
        end 

        within("div#disabled_items") do 
          expect(page).to have_content("List of Disabled Items")
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@item_2.name)
        end 
      end

      it "I see the names of the top 5 most popular items ranked by total revenue generated" do 

        merchant3 = Merchant.create!(name: "Diego", uuid: 3) 

        item_6 = merchant3.items.create(name: "Juice", description: "it is salty", unit_price: 12, uuid: 1)
        item_7 = merchant3.items.create(name: "Broccoli", description: "it is peppery", unit_price: 11, uuid: 2)
        item_8 = merchant3.items.create(name: "Computer", description: "it is spicy", unit_price: 13, uuid: 3)
        item_9 = merchant3.items.create(name: "Lighter", description: "its all over the place", unit_price: 14, uuid: 4)
        item_10 = merchant3.items.create(name: "Earplugs", description: "nice and liquidy", unit_price: 15, status: 1, uuid: 5)
        item_11 = merchant3.items.create(name: "Mouse", description: "it is salty", unit_price: 12, uuid: 1)
        item_12 = merchant3.items.create(name: "Dog", description: "it is peppery", unit_price: 11, uuid: 2)
        item_13 = merchant3.items.create(name: "Cat", description: "it is spicy", unit_price: 13, uuid: 3)
        item_14 = merchant3.items.create(name: "Hamster", description: "its all over the place", unit_price: 14, uuid: 4)
        item_15 = merchant3.items.create(name: "pens", description: "nice and liquidy", unit_price: 15, status: 1, uuid: 5)

        customer_1 = Customer.create(first_name: "Diego", last_name: "Flores")
        customer_2 = Customer.create(first_name: "Sebastian", last_name: "Beltran")

        invoice_4 = customer_2.invoices.create(status: 1)
        invoice_5 = customer_1.invoices.create(status: 1) 
        invoice_6 = customer_1.invoices.create(status: 1) 
        
        transaction_1 = invoice_4.transactions.create!(credit_card_number: "524234", credit_card_expiration_date: nil, result: 0, uuid: 1)
        transaction_3 = invoice_5.transactions.create!(credit_card_number: "524234", credit_card_expiration_date: nil, result: 0, uuid: 1)
        transaction_2 = invoice_6.transactions.create!(credit_card_number: "524234", credit_card_expiration_date: nil, result: 1, uuid: 1)

        
      
        InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 75000, status: 2, uuid: 6)
        InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 85000, status: 2, uuid: 7)
        InvoiceItem.create!(item_id: item_9.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 95000, status: 2, uuid: 8)
        InvoiceItem.create!(item_id: item_10.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 800000, status: 2, uuid: 9)
        InvoiceItem.create!(item_id: item_11.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 850000, status: 2, uuid: 10)
        InvoiceItem.create!(item_id: item_6.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 15000, status: 2, uuid: 11)
        InvoiceItem.create!(item_id: item_7.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 15000, status: 2, uuid: 12)
        InvoiceItem.create!(item_id: item_8.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 200, status: 2, uuid: 13)
        InvoiceItem.create!(item_id: item_11.id, invoice_id: invoice_5.id, quantity: 2, unit_price: 200, status: 2, uuid: 14)
        InvoiceItem.create!(item_id: item_12.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 10, status: 2, uuid: 15)
        InvoiceItem.create!(item_id: item_15.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 15, status: 2, uuid: 16)
        InvoiceItem.create!(item_id: item_15.id, invoice_id: invoice_6.id, quantity: 2, unit_price: 15, status: 2, uuid: 17)
        InvoiceItem.create!(item_id: item_15.id, invoice_id: invoice_4.id, quantity: 2, unit_price: 15, status: 1, uuid: 18)

        

        visit "/merchants/#{merchant3.id}/items"
        save_and_open_page
        
        within("div#5_most_popular_items") do 
          expect(page).to have_content("#{item_6.name}")
          expect(page).to have_content("#{item_7.name}")
          expect(page).to have_content("#{item_9.name}")
          expect(page).to have_content("#{item_10.name}")
          expect(page).to have_content("#{item_11.name}")
        end


      end




    end
  end 
end 

# HUY'S TESTS BELOW; HADYS ABOVE. NEED TO FIX THESE AT SOME POINT 

RSpec.describe 'index', type: :feature do
  describe "when merchant visit 'merchants/merchant_id/items'" do
    let!(:schroeder_jerde) { Merchant.create!(name: 'Schroeder-Jerde')}
    let!(:qui) {Item.create!(merchant: schroeder_jerde, name: 'Qui Esse', unit_price: 75107) }
    let!(:autem) {Item.create!(merchant: schroeder_jerde, name: 'Autem Minima', unit_price: 67076) }
    let!(:ea) {Item.create!(merchant: schroeder_jerde, name: 'Ea Voluptatum', unit_price: 32301) }

    it "should see a list of all that merchant items and not other merchan" do
      visit "/merchants/#{schroeder_jerde.id}/items"
      expect(page).to have_content(qui.name)
      expect(page).to have_content(autem.name)
      expect(page).to have_content(ea.name)
    end

    it 'should see a the name as a link that will direct to item show page where the item attribute is display' do
      visit "/merchants/#{schroeder_jerde.id}/items"
      expect(page).to have_link("#{qui.name}", href: "/merchants/#{schroeder_jerde.id}/items/#{qui.id}")
    end
  end
end