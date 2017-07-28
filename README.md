# Ruby-GSTN is a ruby implementation of connecting with the GSTN API

This rails project is not a gem yet. It will run as a rails application until testing phase. Once the tests have been completed, the project would be turned into a gem for GSTN connectivity

## This project has implemented the following APIs

1. Authentication APIs
  1. OTPRequest

## Tax Payer Authentication APIs

### The Authentication Process
#### Step 1 Exchange of Keys

1. GSTN has implemented two-factor authentication. Whenever we are to connect with GSTN for uploading or downloading Tax Payer's data, it requires the tax payer to submit an OTP (One Time Password). The OTP would be sent to Tax Payer's mobile phone.
2. Further GSTN has also implemented symmetric encryption for communicating between GSP and GSTN. What that means is that GSP and GSTN would use the same key to encrypt and decrypt the messages they send to each other. Let me explain that in some greater details for the cryptographic-virgins. In order to prevent snooping of data during communication, the two communicating parties usually encrypt the message. This encryption is done using an encryption algorithm. The encryption algorithm takes two inputs - The message to be encrypted & a key that is used to encrypt the message. If both communicating parties know the key, then they can use the algorithm to encrypt and decrypt the messages. 
3. Therefore the first step is to generate a secure key. What do we mean by secure key? Well imagine if we only had a 4 character key, then I can try out all permutation-combinations of the 4 characters and figure out the key. Once I have the key, I can decrypt all the messages. Hence, as a precautionary measure, we use a 256 bit (32 Bytes) key. A 256 bit key is usually strong enough that computers would take an enormous amount of time to break it using brute force method.
4. Now what does this key look like? In its human readable form, it is simply a 32 character string. Hence "AllThisEncryptionIsATooMuchForMe" is a perfectly valid key. However, we generally work with keys in their byte Array form. 
5. Once we have generated a secure key, we have to share it with the other party. In our case the GSP will generate a secure key and then send it over to GSTN. Once both parties have the same key, they can start communicating and transmitting data with each other
6. So the first step is to send the key to the GSTN. However if we send the key, anybody who is snooping on this line will be able to read the key. So in order to transmit the key, the key itself should be encrypted. However, that brings us to a chicken and egg problem. We need to share a key to start transmitting but we need to transmit the key.
7. This is achieved by using asymmetric encryption. Let me explain that as well. GSTN has created a special lock, that anybody can close but only GSTN can open. Imagine it to be one of those click locks - which can be pushed to close but they still need a key to open. In encryption world, these are called public keys. If I have a public key, then I can encrypt my message using that public key. But only the entity with the private key can decrypt it. 
8. Therefore as part of my first message, I encrypt my secure key using the public key from GSTN and send it to GSTN. Once GSTN has my key, we can start communicating 

### Implementation of Step 1 - OTPREQUEST call
Here is how we generate a secure AES-256-bit key. The function is pretty straightforward. We have implemented this in the TaxPayer class in this application. 

```
    cipher = OpenSSL::Cipher.new('aes-256-ecb')
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv #Not required for ECB

    Base64.encode64(key)
```

Let us examine what's going on here (in plain english first)
1. Since we need to generate a 256 bit key, we have decided to use AES algorithm to do so. There are other ways to do this as well and all of them work well. Instead of using AES 256 bit cipher algorithm, I could have used the SHA-256 algorithm as well. In that case the code would have looked like this 
`secret_key = Digest::SHA256.hexdigest('a secret key')`
But since GSTN prefers AES-256 key, that's what we'll go with. 

2. Taking a deep dive into this code, lets examine it in details
`cipher = OpenSSL::Cipher.new('aes-256-ecb') `
  1. This instantiates a new cipher of AES (Advanced Encryption Standard) algorithm. This means we will be executing steps as defined in AES algorithm to encrypt our message. The 256 means we will be using a 256 bit key (conisidered most secure). We could have used a 128 bit or a 64 bit key as well but since they can be broken using brute force method, they are best avoided. [The ECB at the end is a mode of encryption](https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb)
  2. `cipher.encrypt` tells us that this is going to be used to encrypt messages. You would read on the internet that .encrypt or .decrypt should ideally be the immediately following steps after instance has been initiated. 
  3. The random_key method of the cipher generates random 256-bit data. Since this is in binary format, its not even readable by users. We can't print it out or send it since this data can not be represented in the ASCII format. Similarly, we can't even store it (in session). That is the reason we use Base64 to encode it. _Base64 is a group of similar binary-to-text encoding schemes that represent binary data in an ASCII string format_.
  4. The iv is the initialization vector but in our case its not required. This is because GSTN has decided to use the ECB mode which doesn't require the IV. 
