module Doccex
  class Engine < Rails::Engine
    isolate_namespace Doccex

    initializer 'doccex.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Doccex::DoccexHelper
      end
    end

  end
end
