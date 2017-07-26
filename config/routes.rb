Rails.application.routes.draw do
  
  root 'tax_payers#index'
  resources :tax_payers
  resources :tax_payers do
    get 'request_otp' => 'tax_payers#request_otp', as: :request_otp
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
