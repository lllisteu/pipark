module Pipark
end

%w(

  version

).each { |m| require "pipark/#{m}" }
