class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    current_user

    if params[:search].present?
       @products = Product.where(name: params[:search])
       p @products
    else
       @products = Product.all
    end

    # @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @review = Review.new
    current_user
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save!

        #start picture
        if product_params[:attaches_picture].size > 0
          product_params[:attaches_picture].each do | upload_io |
            @attachment = Attach.new
            @attachment.picture = upload_io
            @attachment.attacheable_type = "Product"
            @attachment.attacheable_id = @product.id
            @attachment.save!
          end
        end
        #end

        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    #start picture
    if product_params[:attaches_picture]
      product_params[:attaches_picture].each do | upload_io |
        @attachment = Attach.new
        @attachment.picture = upload_io
        @attachment.attacheable_type = "Product"
        @attachment.attacheable_id = @product.id
        @attachment.save!
      end
    end
    #end

    respond_to do |format|
      if @product.update(product_params)

        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price_in_cents, :attaches_picture => [])
    end
end
