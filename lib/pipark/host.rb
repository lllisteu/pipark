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

    # Returns a programmer-friendly representation of the host.
    def inspect
      %Q(Pipark::Host "#{address}")
    end

    # Flushes cached attributes.
    def flush
      @cache = {}
    end

    # Returns true if the host is localhost.
    def localhost?
      @localhost ||= %w(localhost 127.0.0.1 ::1).include? address
    end

    # Returns true if the host can be pinged.
    def pingable?
      Pipark.pingable? address
    end

    # Returns the host's hostname.
    def hostname
      cache['hostname'] ||= file_read('/etc/hostname').chomp
    end

    # Returns the host's Raspberry Pi model.
    def model
      cache['model'] ||= file_read('/proc/device-tree/model').chop
    end

    # Returns the hosts's CPU temperature.
    def cpu_temperature
      file_read('/sys/class/thermal/thermal_zone0/temp').chomp.to_i
    end

    # Returns information about the host's operating system.
    def os_release
      cache['os-release'] ||=
        file_read('/etc/os-release').lines.map { |l| l.chomp.split('=') }.map { |k,v| [k,v.chomp.gsub('"','')] }.to_h
    end

    # Returns the host's boot time.
    def boot_time
      cache['boot_time'] ||=
        file_read('/proc/stat').match( /btime\s+(\d+)/ ) { |m| Time.at(m.captures[0].to_i) }
    end

    # Returns the host's serial number.
    def serial_number
      cache['serial-number'] ||= file_read('/proc/device-tree/serial-number').chop
    end

    # Returns version information for the Ruby installed on the host.
    #
    # Nil if no Ruby is found.
    def ruby
      cache['ruby'] ||=
        if localhost?
          RUBY_DESCRIPTION
        else
          (result = sh 'ruby -v').empty? ? nil : result.chomp
        end
    end

    # Experimental: returns the status of the host's LEDs.
    def led_status
      dir = '/sys/class/leds'
      if localhost?
        Dir[dir + '/led[0-9]'].map do |f|
          if f.match(dir + '/(led\d)')
            [ $1, get_led_status($1) ]
          end
        end.to_h
      end
    end

    # Returns the host's state.
    def state
      result = { 'update_time' => Time.now.gmtime }
      result.merge %w(
        address hostname model serial_number
        os_release boot_time
        ruby
        cpu_temperature
      ).map { |m| [m, send(m)] }.to_h
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

    def sh(command)
      if localhost?
        `#{command}`
      else
        `ssh #{address} "#{command}"`
      end
    end

    def get_led_status(led)
      file = "/sys/class/leds/#{led}/trigger"
      if File.readable? file
        if File.read(file).match(/\[(.*)\]/)
          $1
        end
      end
    end

    def _view_21x8
      view = 'RPi ' + hostname.rjust(17) + "\n\n"
      view << os_release['NAME'].center(21) + "\n"
      view << os_release['VERSION'].center(21) + "\n\n"
      view << "      CPU %2d °C\n" % (cpu_temperature*0.001)
    end

  end

end
