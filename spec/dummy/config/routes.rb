Rails.application.routes.draw do
  mount Doccex::Engine => "/doccex"
  get "/test(.:format)", :to => "test#index", :as => :test
end
