require 'rails_helper'

RSpec.describe CoverPhotosController, type: :controller do


  describe 'PATCH #update' do

    let(:new_photo) { create(:photo) }

    context 'when user is authorized' do

      before do
        request.cookies[:auth_token] = new_photo.owner.auth_token
        patch :update, :photo_id => new_photo.id, :user_id => new_photo.owner
      end


      it 'assigns @user' do
        expect(assigns(:user)).to eq(new_photo.owner)
      end

      it 'assigns @photo' do
        expect(assigns(:photo)).to eq(new_photo)
      end

      it 'saves the new photo ID as cover_photo_id' do
        new_photo.reload
        expect(new_photo.owner.cover_photo).to eq(new_photo)
      end

      it 'redirects to user show page' do
        expect(response).to redirect_to(user_path(new_photo.owner))
      end

    end


    context 'when user is unauthorized' do

      let(:unauthorized_user) { create(:user) }

      before do
        request.cookies[:auth_token] = unauthorized_user.auth_token
        patch :update, :photo_id => new_photo.id, :user_id => new_photo.owner
      end


      it 'does not modify cover_photo_id' do
        expect(new_photo.owner.cover_photo).not_to eq(new_photo)
      end

      it 'flashes a warning' do
        expect(flash[:danger]).to eq("You're not authorized to do this!")
      end

      it 'redirects back to user photo index page' do
        expect(response).to redirect_to(user_photos_path(new_photo.owner))
      end

    end


  end

end
