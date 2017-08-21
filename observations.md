pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start


Please note that GSTN_G2A_SANDBOX_UAT_public.cer is a DER encoded certificate
As found through this 
openssl x509 -in certificate.der -inform der -text -noout


-----BEGIN PUBLIC KEY----- 
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn4ccEVpmsRfrUvxK6yfk g6brTJoGe90qzDNWOSqXJh51mwyLKjd7mccSaL7oMKTkXKLRmZvZtR1NYWnAU6nu KNjDQOC6LTzhoSE7siL2rneh0+A9rXyjEl6FuYp+ilV5rrsuWR3RLCUDYOFkIobH Ddhbl/B8Ol05bLrZvU1XIn7E98j47q/rWGp+SiHA5Ui7hAw+b2UCv8os8HWKmr6z NDziKPCGabrZTws/e1XJ0/uW5mxTfX/DOjbukP+aosMrlD1kVocJr+SrVRKzIOiC 7FYuY6q2CGY5+soXz8cQi7be6h5wJvZB9HdU6mYzTk4yw/bnNvuqlGIgoGF0nZzn 
MwIDAQAB -----END PUBLIC KEY-----

-----BEGIN RSA PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn4ccEVpmsRfrUvxK6yfk
g6brTJoGe90qzDNWOSqXJh51mwyLKjd7mccSaL7oMKTkXKLRmZvZtR1NYWnAU6nu
KNjDQOC6LTzhoSE7siL2rneh0+A9rXyjEl6FuYp+ilV5rrsuWR3RLCUDYOFkIobH
Ddhbl/B8Ol05bLrZvU1XIn7E98j47q/rWGp+SiHA5Ui7hAw+b2UCv8os8HWKmr6z
NDziKPCGabrZTws/e1XJ0/uW5mxTfX/DOjbukP+aosMrlD1kVocJr+SrVRKzIOiC
7FYuY6q2CGY5+soXz8cQi7be6h5wJvZB9HdU6mYzTk4yw/bnNvuqlGIgoGF0nZzn
MwIDAQAB
-----END RSA PUBLIC KEY-----

-----BEGIN RSA PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn4ccEVpmsRfrUvxK6yfk
g6brTJoGe90qzDNWOSqXJh51mwyLKjd7mccSaL7oMKTkXKLRmZvZtR1NYWnAU6nu
KNjDQOC6LTzhoSE7siL2rneh0+A9rXyjEl6FuYp+ilV5rrsuWR3RLCUDYOFkIobH
Ddhbl/B8Ol05bLrZvU1XIn7E98j47q/rWGp+SiHA5Ui7hAw+b2UCv8os8HWKmr6z
NDziKPCGabrZTws/e1XJ0/uW5mxTfX/DOjbukP+aosMrlD1kVocJr+SrVRKzIOiC
7FYuY6q2CGY5+soXz8cQi7be6h5wJvZB9HdU6mYzTk4yw/bnNvuqlGIgoGF0nZzn
MwIDAQAB
-----END RSA PUBLIC KEY-----


1. OpenSSH through OpenSSL
https://stackoverflow.com/questions/36290640/ssh-subjectpublickeyinfo-from-modulus-and-exponent/36302768#36302768
https://redmine.ruby-lang.org/issues/4421
https://gist.github.com/emboss/1470287
https://gist.github.com/emboss/2902696
https://stackoverflow.com/questions/30475758/use-openssl-rsa-key-with-net
https://stackoverflow.com/questions/4635837/invalid-public-keys-when-using-the-ruby-openssl-library
http://www.gtopia.org/blog/2010/02/der-vs-crt-vs-cer-vs-pem-certificates/
https://stackoverflow.com/questions/26259432/how-to-check-a-public-rsa-key-file/26260514#26260514
https://github.com/racker/ruby-1.9.3-lucid/blob/master/test/openssl/test_pkey_rsa.rb#L82



https://stackoverflow.com/questions/37384701/yodlee-api-pki-trying-to-encrypt-data-rsa-ecb-pkcs1padding-using-rails-ruby
This guy says that final key should be Hex Encoded


https://stackoverflow.com/questions/1303220/padding-error-when-using-rsa-encryption-in-c-sharp-and-decryption-in-java?rq=1

A node.js implementation of the TSL standard
https://github.com/digitalbazaar/forge

Problem
The data that we are encrypting using public key, when its sent to GSTN, they give me an error 