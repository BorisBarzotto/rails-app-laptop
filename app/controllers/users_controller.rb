class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update]

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
        flash[:notice] = "User edited"    
        redirect_to user_path(@user[:id])  
     else
        render 'edit', status: :unprocessable_entity
     end  
  
    end

    def create
        @user = User.new(user_params)
        if @user.save
          session[:user_id] = @user.id
          flash[:notice] = "Welcome #{@user.username} "
          redirect_to articles_path
        else
          render 'new', status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password) 
    end

    def set_user
      @user = User.find(params[:id])
    end  

end