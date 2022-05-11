module Pipark

  class << self

    # Creates a Host object for the address.
    def host(address)
      Host.new(address)
    end

    alias pi host

    # Creates a Host object for localhost.
    def localhost
      host 'localhost'
    end

  end


  class Host

    attr_reader :address

    def initialize(address)
      @address = address
    end

    # Returns a programmer-friendly representation of the Host.
    def inspect
      "Host '#{address}'"
    end

    # Flushes cached attributes.
    def flush
      @cache = {}
    end

    private

    def cache
      @cache ||= {}
    end

    def file_read(file)
      if localhost?
        File.read(file)
      else
        `ssh #{address} cat #{file}`
      end
    end

  end

end
