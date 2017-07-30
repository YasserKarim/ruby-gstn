class TaxPayer < ApplicationRecord
  include HTTParty
  debug_output $stdout

  def generate_encoded_aes_256_bit_key

    cipher = OpenSSL::Cipher.new('aes-256-ecb')
    cipher.encrypt
    key = cipher.random_key
    #iv = cipher.random_iv #Not required for ECB

    Base64.encode64(key)
  end

  def extract_public_key_from_certificate

    certificate_file_content = File.read("#{Rails.root}/lib/certificates/GSTN_G2B_SANDBOX_UAT_public.cer")
    cert = OpenSSL::X509::Certificate.new(certificate_file_content)    
    cert.public_key

  end

  def generate_otp_request(encrypted_key)
    
    gstn_server_response = self.class.post('http://devapi.gstsystem.co.in/taxpayerapi/v0.2/authenticate', 
      :headers => {
        :clientid => 'l7xx6b008ac621824f79805cca0b205fa7fc', #Rails.application.secrets.gstn_client_id, 
        :'client-secret' => '27bef27a0d5046b4b1b1613279713cbe', #Rails.application.secrets.gstn_client_secret, 
        :'ip-usr' => '42.187.63.202', 
        :'state-cd' => '33', 
        :txn => 'OTPREQUEST',
        'Content-Type' => 'application/json'},
      :body => {
        :action => "OTPREQUEST",
        :username => self.username,
        :app_key => encrypted_key
      }.to_json
    )

  end



end
