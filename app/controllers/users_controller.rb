class UsersController < ApplicationController
  
   before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user,     only: :destroy
    
    
    def following
        @title = "Following"
        @user = User.find(params[:id])
        @users = @user.followed_users.paginate(page: params[:page])
        render 'show_follow'
      end

      def followers
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        render 'show_follow'
      end
    
    
    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])
      end
    
    def index
      @users = User.paginate(page: params[:page])
     end
     
  def new
    if !signed_in?
      @user = User.new
    else
    redirect_to(root_url) 
    end 
  end
  
  def destroy
    if !User.find(params[:id]).admin
       
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    else
      flash[:error] = "You are administrator"
      @user = User.find(params[:id])
      redirect_to @user
    end
  end
  
  def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_paramsSecure)
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    end 
  
  def edit 
    @user = User.find(params[:id])
  end
  
  def create
    if !signed_in?
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to(root_url) 
    end
    end

    private


    def user_paramsSecure
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
      def user_params
        params.require(:user).permit(:name, :email, :password,:admin,
                                     :password_confirmation)
      end
      
     # def signed_in_user
      #  unless signed_in?
       #     store_location
        #    redirect_to signin_url, notice: "Please sign in." 
        #end
        #end
          
      def correct_user
                @user = User.find(params[:id])
                redirect_to(root_url) unless current_user?(@user)
      end
      
      def admin_user
            redirect_to(root_url) unless current_user.admin?
          end
      
  end