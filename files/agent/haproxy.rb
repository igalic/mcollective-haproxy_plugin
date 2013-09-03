module MCollective
  module Agent
    class Haproxy<RPC::Agent
      metadata :name        => 'haproxy',
               :description => 'Performs haproxy actions',
               :author      => 'Hunter Haugen',
               :license     => 'MIT',
               :version     => '1.0',
               :url         => 'http://puppetlabs.com',
               :timeout     => 120

      ['enable','disable'].each do |act|
        action act do
          validate :server, :shellsafe
          run_haproxyctl act, request[:server]
        end
      end
      action 'status' do
        run_haproxyctl 'status'
      end

      private
      def run_haproxyctl(action,server=nil)
        output = ''
        cmd = ['/usr/bin/haproxyctl']
        case action
        when 'enable','disable'
          cmd << 'enable' if action == 'enable'
          cmd << 'enable' if action == 'disable'
          cmd << server
          reply[:server] = server
        when 'status'
          cmd << 'show health'
        end
        reply[:status] = run(cmd, :stdout => :output, :chomp => true)
      end
    end
  end
end
