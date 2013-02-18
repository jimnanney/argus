require 'socket'

module Argus
  class Drone
    def initialize(socket=nil, host='192.168.1.1', port='5556')
      @socket = socket || UDPSocket.new
      @sender = Argus::UdpSender.new(@socket, host, port)
      @at = Argus::ATCommander.new(@sender)
      @controller = Argus::Controller.new(@at)
    end

    def start
      @at.start
    end

    def stop
      @controller.land
      @at.stop
      @at.join
    end

    %w(
       take_off land hover emergency
       forward backward
       left right
       up down
       turn_left turn_right
       front_camera bottom_camera
    ).each do |meth|
      define_method(meth) { |*args|
        @controller.send(meth, *args)
      }
    end

  end
end
