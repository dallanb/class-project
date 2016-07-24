class ReviewsController < ApplicationController
  before_action :current_bath
   
  
  def new
    @review = Review.new(bath: @bath)
  end

  def create
    @review = @bath.reviews.build(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = "Review created"
      redirect_to view_path(@bath)
    else
      flash[:danger] = "Unable to create review"
      render 'new'
    end
  end


  def edit
    @review = Review.find(params[:id])
    @bath = Bath.find(params[:bath_id])
      
  end
  
  def reported
    @reviews = Review.where(:flag.count > 5)
  end

  def show
    @reviews = @bath.reviews.all
  end

  def update
    @review = Review.find(params[:id])
    @bath = Bath.find(params[:bath_id])
    if @review.update_attributes(review_params)
      flash[:success] = "Profile updated"
      redirect_to view_path(@bath)
    else
      render 'edit'
    end
  end
  
  def destroy
    @bath = Bath.find_by_id(params[:bath_id])
    @review= Review.find(params[:id])
    @review.destroy
    redirect_to view_path(@bath), notice: "Review Deleted"
  end


private

  def current_bath
    @bath = Bath.find_by_id(params[:bath_id])
  end
  
  def review_params
    params.require(:review).permit(:post, :rating, :report)
  end

end

