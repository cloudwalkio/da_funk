class Device
  class Runtime
    include DaFunk::Helper

    def self.adapter
      Device.adapter::Runtime
    end

    # Execute app in new context.
    #   To execute the should exists a zip file cotain the app,
    #   previously downloaded from CloudWalk.
    #
    # @param app [String] App name, example "app", should exists file app.zip
    # @param json [String] Parameters to confifure new aplication.
    # @return [Object] From the new runtime instance.
    def self.execute(app, json = nil)
      buf = "#{json.dup}" if json.is_a?(String)
      mrb_eval("Context.execute('#{app.dup}', '#{Device.adapter}', '#{buf}')", "#{app.dup}")
    ensure
      self.system_reload
    end

    def self.start(app, json = nil)
      buf = "#{json.dup}" if json.is_a?(String)
      mrb_eval("Context.start('#{app.dup}', '#{Device.adapter}', '#{buf}')", "#{app.dup}")
    end

    def self.stop(app)
      mrb_stop(app)
    end

    # Check if any change has happen to Network, Settings or ParamsDat
    # @return [NilClass] From the new runtime instance.
    def self.system_reload
      Device::Setting.setup
      DaFunk::ParamsDat.setup
      Device::Network.setup
      nil
    end

    def self.reload
      self.adapter.reload
    end
  end
end
