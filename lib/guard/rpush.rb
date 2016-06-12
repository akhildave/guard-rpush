require "guard/rpush/version"
require 'guard/compat/plugin'
module Guard
  class Rpush < Plugin
    DEFAULT_SIGNAL = :TERM

    def start
      @rpush_started = false
      begin
        check_init_pidfile_directory
        UI.info "Starting Rpush daemon.." 
        sid = spawn({},cmd)
        Process.wait(sid)
        UI.info "Rpush is running with PID #{pid}"
        @rpush_started = $?.success?
      rescue ::Exception => err
        UI.error "Unable to start Rpush. Errors: #{err}"
      end
      @rpush_started
    end

    def stop
      if @rpush_started
        shutdown_rpush
        true
      else
        UI.info "Rpush was not started. Skipping stop process.."
        true
      end
    end

    def reload
      UI.info "Reloading Rpush..."
      stop
      start
      UI.info "Rpush restarted successfully."
    end

    def run_all
      true
    end

    def run_on_change(paths)
      reload if reload_on_change?
    end 
    
    def shutdown_rpush
      return UI.info "No instance of Rpush to stop." unless pid
      return UI.info "Rpush (#{pid}) was already stopped." unless process_running?
      UI.info "Sending TERM signal to Rpush (#{pid})..."
      Process.kill("TERM", pid)

      return if shutdown_retries == 0
      shutdown_retries.times do
        return UI.info "Rpush stopped." unless process_running?
        UI.info "Rpush is still shutting down. Retrying in #{ shutdown_wait } second(s)..."
        sleep shutdown_wait
      end
      UI.error "Rpush didn't shut down after #{ shutdown_retries * shutdown_wait } second(s)."
    end

    def pidfile_path
      options.fetch(:pidfile) {
        File.expand_path('/tmp/rpush.pid', File.dirname(__FILE__))
      }
    end

    def check_init_pidfile_directory
      pidfile_dir = File.dirname(pidfile_path)
      unless Dir.exist? pidfile_dir
        UI.info "Creating directory #{pidfile_dir} for pidfile"
        FileUtils.mkdir_p pidfile_dir
      end

      unless File.writable? pidfile_dir
        raise "No write access to pidfile directory #{pidfile_dir}"
      end
    end 
    
    def pid
      count = 0
      loop do
        if count > 5
          raise "pidfile was never written to #{pidfile_path}"
        end

        break if File.exists? pidfile_path
        UI.info "Waiting for pidfile to appear at #{pidfile_path}..."
        count += 1
        sleep 1
      end
      File.read(pidfile_path).to_i
    end 
    
    def cmd
      command = ['bundle exec rpush start'] 
      command << "-e #{@options[:environment]}"  if @options[:environment]  
      command.join(' ')
    end 

    def logfile
      options.fetch(:logfile) {
        if capture_logging? then "log/rpush.log" else 'stdout' end
      }
    end

    def shutdown_retries
      options.fetch(:shutdown_retries) { 0 }
    end

    def shutdown_wait
      options.fetch(:shutdown_wait) { 0 }
    end 

    def reload_on_change?
      options.fetch(:reload_on_change) { false }
    end

    def process_running?
      begin
        Process.getpgid pid
        true
      rescue Errno::ESRCH
        false
      end
    end

    def capture_logging?
      options.fetch(:capture_logging) { false }
    end 
  
   
  end
end
