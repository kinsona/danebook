class UsersController < ApplicationController

  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)
      flash[:success] = 'Thank you for signing up!'
      redirect_to root_url
    else
      flash[:danger] = 'Sign up failed due to errors.  Please correct and try again.'
      render :new
    end
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
