# MMT-11

require 'rails_helper'

describe 'Search drafts results', js: true do
  short_name = 'id_123'
  entry_title = 'Aircraft Flux-Filtered: Univ. Col. (FIFE)'

  before :each do
    login
    visit '/search'
    create(:draft, entry_title: entry_title, short_name: short_name)
    click_on 'Full Metadata Record Search'
  end

  context 'when searching drafts by entry id' do
    before do
      select 'Draft Records', from: 'record_state'
      select 'Short Name', from: 'search_term_type'
      fill_in 'search_term', with: short_name
      click_on 'Submit'
    end

    it 'displays collection results' do
      expect(page).to have_search_query(1, "Short Name: #{short_name}", 'Record State: Draft Records')
    end

    it 'displays expected data' do
      expect(page.find('table#search-results')).to have_content(short_name)
      expect(page.find('table#search-results')).to have_content(entry_title)
    end
  end

  context 'when searching drafts by entry title' do
    before do
      select 'Draft Records', from: 'record_state'
      select 'Entry Title', from: 'search_term_type'
      fill_in 'search_term', with: entry_title
      click_on 'Submit'
    end

    it 'displays collection results' do
      expect(page).to have_search_query(1, "Entry Title: #{entry_title}", 'Record State: Draft Records')
    end

    it 'displays expected data' do
      expect(page.find('table#search-results')).to have_content(short_name)
      expect(page.find('table#search-results')).to have_content(entry_title)
    end
  end

  context 'when searching drafts by entry id' do # is actually searching published and drafts for a draft by entry id
    before do
      select 'Published & Draft Records', from: 'record_state'
      select 'Short Name', from: 'search_term_type'
      fill_in 'search_term', with: short_name
      click_on 'Submit'
    end

    it 'displays collection results' do
      expect(page).to have_search_query(1, "Short Name: #{short_name}", 'Record State: Published And Draft Records')
    end

    it 'displays expected data' do
      expect(page.find('table#search-results')).to have_content(short_name)
      expect(page.find('table#search-results')).to have_content(entry_title)
    end
  end
end