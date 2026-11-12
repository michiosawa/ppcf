json.extract! workday, :id, :worker_id, :workplace_id, :checkin, :checkout, :healthcheck, :overtime, :comment, :created_at, :updated_at
json.url workday_url(workday, format: :json)
