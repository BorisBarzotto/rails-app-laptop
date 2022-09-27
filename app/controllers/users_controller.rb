class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index, :new, :create]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
      
      @pagy, @user_articles = pagy(@user.articles)
      
    end

    def index
      @pagy, @users = pagy(User.all)
    end

    def new
        @user = User.new
    end

    def edit
      
    end

    def update
      
      if @user.update(user_params)
        flash[:success] = "User edited"    
        redirect_to user_path(@user[:id])  
     else
        render 'edit', status: :unprocessable_entity
     end  
  
    end

    def create
        @user = User.new(user_params)
        if @user.save
          session[:user_id] = @user.id
          flash[:success] = "Welcome #{@user.username} "
          redirect_to articles_path
        else
          render 'new', status: :unprocessable_entity
        end
    end

    def destroy
      @user.destroy
      session[:user_id] = nil if @user == current_user
      flash[:success] = "Profile deleted and all associated articles"
      redirect_to articles_path
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password) 
    end

    def set_user
      @user = User.find(params[:id])
    end  

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:danger] = "You can only edit or delete your profile"
        redirect_to user_path(@user[:id]) 
      end
    end

end