Rails.application.routes.draw do
  mount Doccex::Engine => "/doccex"
  match "/test(.:format)", :to => "test#index", :as => :test
end
