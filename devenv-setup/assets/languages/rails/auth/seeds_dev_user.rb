if Rails.env.development?
  User.find_or_create_by!(email_address: "dev@example.com") do |user|
    user.password = "Xk9#mP7$qR2@vL5"
    user.admin = true
  end
end
