class TaxPayersController < ApplicationController
  before_action :set_tax_payer, only: [:show, :edit, :update, :destroy]
  before_action :set_tax_payer_resource, only: [:request_otp, :submit_otp]

  # GET /tax_payers
  # GET /tax_payers.json
  def index
    @tax_payers = TaxPayer.all
  end

  # GET /tax_payers/1
  # GET /tax_payers/1.json
  def show
  end


  # GET /tax_payers/new
  def new
    @tax_payer = TaxPayer.new
  end

  # GET /tax_payers/1/edit
  def edit
  end

  # POST /tax_payers
  # POST /tax_payers.json
  def create
    @tax_payer = TaxPayer.new(tax_payer_params)

    respond_to do |format|
      if @tax_payer.save
        format.html { redirect_to @tax_payer, notice: 'Tax payer was successfully created.' }
        format.json { render :show, status: :created, location: @tax_payer }
      else
        format.html { render :new }
        format.json { render json: @tax_payer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tax_payers/1
  # PATCH/PUT /tax_payers/1.json
  def update
    respond_to do |format|
      if @tax_payer.update(tax_payer_params)
        format.html { redirect_to @tax_payer, notice: 'Tax payer was successfully updated.' }
        format.json { render :show, status: :ok, location: @tax_payer }
      else
        format.html { render :edit }
        format.json { render json: @tax_payer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tax_payers/1
  # DELETE /tax_payers/1.json
  def destroy
    @tax_payer.destroy
    respond_to do |format|
      format.html { redirect_to tax_payers_url, notice: 'Tax payer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def request_otp

    #1. Create an AES 256 bit key
    @app_key = @tax_payer.generate_encoded_aes_256_bit_key

    #2. Load the public key
    @public_key = @tax_payer.extract_public_key_from_certificate

    #3. Encrypt @app_key using Public Key
    # The error that I was continuosly facing was that I was not decoding the app_key. It must be first decoded and only then should be used
    @encrypted_key = Base64.encode64(@public_key.public_encrypt(Base64.decode64(@app_key)))

    #4. Send an OTPREQUEST to GSTN portal
    @response_text = @tax_payer.generate_otp_request(@encrypted_key).parsed_response

    respond_to do |format|
      format.html {}
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax_payer
      @tax_payer = TaxPayer.find(params[:id])
    end

    def set_tax_payer_resource
      @tax_payer = TaxPayer.find(params[:tax_payer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_payer_params
      params.require(:tax_payer).permit(:username, :gstin, :password, :app_key)
    end
end
