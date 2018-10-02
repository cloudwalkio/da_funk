module DaFunk
  class EventListener
    class << self
      attr_accessor :listeners
    end

    self.listeners = {}

    def self.check(_type = nil)
      if _type
        self.listeners.each { |type, listener| listener.check if type == _type }
      else
        self.listeners.each { |type, listener| listener.check }
      end
    end

    def self.register(event_listener)
      self.listeners[event_listener.type] = event_listener
    end

    def self.delete(event_listener)
      self.listeners.delete(event_listener.type)
    end

    def self.add_handler(handler)
      if listener = self.listeners[handler.type]
        listener.handlers[handler.option] = handler
      end
    end

    attr_accessor :block_start, :block_check, :block_finish, :handlers
    attr_reader :type

    def initialize(type)
      @type     = type
      @handlers = {}
      yield self if block_given?
      self.register
      self.start
    end

    def register
      EventListener.register(self)
    end

    def delete
      self.finish if self.started?
      EventListener.delete(self)
    end

    def start(&block)
      if block_given?
        @block_start = block
      else
        if @block_start
          @started = @block_start.call
        else
          @started = true
        end
      end
    end

    def check(&block)
      if block_given?
        @block_check = block
      else
        if @block_check && ! self.handlers.empty? && self.started?
          @block_check.call
        end
      end
    end

    def finish(&block)
      if block_given?
        @block_finish = block
      else
        @started = false
        @block_finish.call if @block_finish
      end
    end

    def started?
      @started
    end
  end
end

