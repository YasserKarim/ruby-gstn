# Ruby-GSTN is a ruby implementation of connecting with the GSTN API

This rails project is not a gem yet. It will run as a rails application until testing phase. Once the tests have been completed, the project would be turned into a gem for GSTN connectivity

## This project has implemented the following APIs

1. Authentication APIs
  1. OTPRequest

## Tax Payer Authentication APIs

### The Authentication Process - Step 1 Exchange of Keys
1. GSTN has implemented two-factor authentication. Whenever we are to connect with GSTN for uploading or downloading Tax Payer's data, it requires the tax payer to submit an OTP (One Time Password). The OTP would be sent to Tax Payer's mobile phone.
2. Further GSTN has also implemented symmetric encryption for communicating between GSP and GSTN. What that means is that GSP and GSTN would use the same key to encrypt and decrypt the messages they send to each other. Let me explain that in some greater details for the cryptographic-virgins. In order to prevent snooping of data during communication, the two communicating parties usually encrypt the message. This encryption is done using an encryption algorithm. The encryption algorithm takes two inputs - The message to be encrypted & a key that is used to encrypt the message. If both communicating parties know the key, then they can use the algorithm to encrypt and decrypt the messages.
3. Therefore the first step is to generate a secure key. What do we mean by secure key? Well imaging if we only had a 4 character key, then I can try out all permutation-combinations of the 4 characters and figure out the key. Once I have the key, I can decrypt all the messages. Hence, as a precautionary measure, we use a 256 bit (32 Bytes) key. A 256 bit key is usually strong enough that computers would take an enormous amount of time to break it using brute force method
4. Once we have generated a secure key, we have to share it with the other party. In our case the GSP will generate a secure key and then send it over to GSTN. Once both parties have the same key, they can start communicating and transmitting data with each other
5. So the first step is to send the key to the GSTN. However if we send the key, anybody who is snooping on this line will be able to read the key. So in order to transmit the key, the key itself should be encrypted. However, that brings us to a chicken and egg problem. We need to share a key to start transmitting but we need to transmit the key.
6. This is achieved by using asymmetric encryption. Let me explain that as well. GSTN has created a special lock, that anybody can close but only GSTN can open. Imagine it to be one of those click locks - which can be pushed to close but they still need a key to open. In encryption world, these are called public keys. If I have a public key, then I can encrypt my message using that public key. But only the entity with the private key can decrypt it. 
7. Therefore as part of my first message, I encrypt my secure key using the public key from GSTN and send it to GSTN. Once GSTN has my key, we can start communicating 