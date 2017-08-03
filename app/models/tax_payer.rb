class TaxPayer < ApplicationRecord
  include HTTParty
  debug_output $stdout  
  base_uri "http://devapi.gstsystem.co.in/taxpayerapi/v0.2"

  def generate_encoded_aes_256_bit_key

    cipher = OpenSSL::Cipher.new('aes-256-ecb')
    cipher.encrypt
    key = cipher.random_key
    #iv = cipher.random_iv #Not required for ECB

    Base64.encode64(key)
  end

  def extract_public_key_from_certificate

    certificate_file_content = File.read("#{Rails.root}/lib/certificates/GSTN_G2B_SANDBOX_UAT_public.cer")
    cert = OpenSSL::X509::Certificate.new(Base64.decode64(certificate_file_content))
    cert.public_key

  end



  def convert_public_key_to_old_ruby_pkcs1_format

    gst_pem_file = File.read("#{Rails.root}/lib/certificates/GSTN_G2B_SANDBOX_UAT_public.pem")
    
    rsa = OpenSSL::PKey::RSA.new(gst_pem_file)
    modulus = rsa.n
    exponent = rsa.e

    ary = [OpenSSL::ASN1::Integer.new(modulus), OpenSSL::ASN1::Integer.new(exponent)]
    pub_key = OpenSSL::ASN1::Sequence.new(ary)
    pem = pub_key.to_der
    #base64 = Base64.encode64(pub_key.to_der)

    #This is the equivalent to the PKCS#1 encoding used before 1.9.3
    #pem = "-----BEGIN RSA PUBLIC KEY-----\n#{base64}-----END RSA PUBLIC KEY-----"
    the_public_key = OpenSSL::PKey::RSA.new(pem)

  end

  def generate_otp_request(encrypted_key)
    
    gstn_server_response = self.class.post('/authenticate', 
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
        #:app_key => encrypted_key
        :app_key => "M4AfEHQ+377Y1Zuor32nX257utICg0LPLRelyyX+ukTTvrVkb9rTO4TN7f2WbUi2rek8LoiLQkcficAsuAHtY8qAoFAOZ/UslhnYbIn4YScr1z8DpDCPbN2Dj3vTkjZqgT3Pp6fV0eoCSMOq3mg7pUNyygiNiSezP0+IT4VDTP+qKNEOB+9SIrr5QSjg8VwH2kwjPcZ0oRfJaidBI9omfdiOrVjS70iQvQXM5eZjVZ5hTGj6NNkRmJgFoDwHMgl0xom8HHFJQTlo2zl82QcoulEpfSmD4bpO51WMrJedhwrwSBXBin5zXa+CmxUeD7DNMnIkSgVY7ggAio6sfIXAgw=="
      }.to_json
    )

  end  
end