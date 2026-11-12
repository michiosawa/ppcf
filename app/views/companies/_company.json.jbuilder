json.extract! company, :id, :name, :tel, :address, :owner, :comment, :created_at, :updated_at
json.url company_url(company, format: :json)
