module FakeObjects

  # Mock class for HTTP responses
  class FakeHttpResponse

    attr_reader :status, :body
    attr_writer :status, :body
  
    def initialize(status, body)
      self.status = status
      self.body = body
    end
  
  end

  # Mock class for the NotifyMailer class
  class FakeNotifyMailer
    def deliver_later
      return 'deliver_later'
    end
  end

  # Mock class for ActiveStorage file objects
  class FakeFile
    class FakeBlob
      def filename
        return 'filename.txt'
      end
    end
    def blob
      return FakeBlob.new
    end
  end

end
