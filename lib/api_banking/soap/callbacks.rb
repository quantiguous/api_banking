module ApiBanking
  class Callbacks
    def initialize
      yield(self) if block_given?
    end

    def before_send(&block)
      @before_send = block if block_given?
      @before_send
    end

    def on_complete(&block)
      @on_complete = block if block_given?
      @on_complete
    end
  end
end
