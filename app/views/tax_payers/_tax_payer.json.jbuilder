json.extract! tax_payer, :id, :username, :gstin, :password, :app_key, :created_at, :updated_at
json.url tax_payer_url(tax_payer, format: :json)
