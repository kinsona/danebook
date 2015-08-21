require 'rails_helper'


describe 'photos/show.html.erb' do

  let(:photo) { create(:photo) }

  before do
    assign(:photo, photo)
    assign(:user, photo.owner)
  end


  context 'when not logged in' do

    before do

      photo.comments.create(attributes_for(:comment, :author_id => photo.owner.id))

      def view.signed_in_user?
        false
      end

      def view.current_user
        nil
      end

      render

    end


    it 'displays photo and owner' do
      expect(rendered).to have_css("img[src*='#{photo.photo.url(:medium)}']")
      expect(rendered).to have_content(photo.photo_updated_at)
    end


    it 'displays comments' do
      expect(rendered).to have_content(photo.comments.first.body)
    end


    it 'does not display New Comment form' do
      expect(rendered).not_to have_css('#new_comment')
    end

    it 'does not display Like/Unlike links' do
      expect(rendered).not_to have_link('Like')
    end

    it 'does not display Photo action links' do
      expect(rendered).not_to have_link('delete photo')
    end

  end



  context 'when logged in as any user' do

    let(:logged_in_user) { create(:user) }

    before do
      assign(:logged_in_user, logged_in_user)

      def view.signed_in_user?
        true
      end

      def view.current_user
        @logged_in_user
      end

      render

    end


    it 'displays New Comment form' do
      expect(rendered).to have_css('#new_comment')
    end

    it 'displays Like/Unlike links' do
      expect(rendered).to have_link('Like')
    end

  end


  context 'when logged in as photo owner' do


    let(:photo_owner) { create(:user) }

    before do
      assign(:photo_owner, photo_owner)

      def view.signed_in_user?
        true
      end

      def view.current_user
        @photo_owner
      end

      render

    end


    it 'displays action links' do
      expect(rendered).to have_link('delete photo')
    end

  end


end