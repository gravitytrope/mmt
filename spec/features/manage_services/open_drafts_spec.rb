require 'rails_helper'

describe 'Drafts listed on the Manage Services page' do
  draft_display_max_count = 5 # Should agree with @draft_display_max_count found in manage_variables_controller

  before do
    @other_user_id = User.create(urs_uid: 'adminuser').id

    @current_user_id = User.create(urs_uid: 'testuser').id
    login
  end

  context 'when no drafts exist' do
    before do
      visit manage_services_path
    end

    it 'does not display any drafts' do
      expect(page).to have_content('MMT_2 Service Drafts')

      within '.open-drafts' do
        expect(page).to have_content('MMT_2 has no drafts to display.')
      end
    end
  end

  context 'when there are open drafts from multiple users' do
    before do
      # create 2 drafts per user
      2.times { create(:empty_service_draft, user_id: @current_user_id) }
      2.times { create(:empty_service_draft, user_id: @other_user_id) }

      visit manage_services_path
    end

    it 'displays all the drafts' do
      within '.open-drafts' do
        expect(page).to have_content('<Blank Name>', count: 4)
      end
    end
  end

  context "when more than #{draft_display_max_count} open drafts exist" do
    before do
      # create draft_display_max_count drafts per user
      draft_display_max_count.times { create(:empty_service_draft, user_id: @current_user_id) }
      draft_display_max_count.times { create(:empty_service_draft, user_id: @other_user_id) }

      visit manage_services_path
    end

    it 'the "More" is displayed' do
      within '.open-drafts' do
        expect(page).to have_link('More')
      end
    end

    context 'when clicking on the "More" link' do
      before do
        within '.open-drafts' do
          click_on 'More'
        end
      end

      it 'the Service Drafts index page is displayed with all open drafts for the provider' do
        expect(page).to have_content('<Blank Name>', count: (draft_display_max_count * 2))
      end

      context 'when "<Blank Name>" is clicked on' do
        before do
          click_on '<Blank Name>', match: :first
        end

        it 'the draft is opened for view/edit' do
          within '.eui-breadcrumbs' do
            expect(page).to have_content('Service Drafts')
          end

          expect(page).to have_css('p', text: 'No value for Name provided.')
          expect(page).to have_css('p', text: 'No value for Long Name provided.')
        end
      end
    end
  end
end
