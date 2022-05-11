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

    # Returns true if the address can be pinged.
    def pingable?(address)
      system "ping -c 1 #{address} > /dev/null 2>&1"
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

    # Returns true if the Host is localhost.
    def localhost?
      @localhost ||= %w(localhost 127.0.0.1 ::1).include? address
    end

    # Returns true if the Host can be pinged.
    def pingable?
      Pipark.pingable? address
    end

    # Returns the Host's hostname.
    def hostname
      cache['hostname'] ||= file_read('/etc/hostname').chomp
    end

    # Returns the Host's Raspberry Pi model.
    def model
      cache['model'] ||= file_read('/proc/device-tree/model').chop
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
