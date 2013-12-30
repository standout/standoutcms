# FTP helper module/wrapper for remote server communication

module Standout
  module Ftp
    require 'net/ftp'

    def connect
      @ftp = Net::FTP.new(host)
      @ftp.passive = true
      @ftp.login username, password
      log "connected to #{host}"
    end

    def disconnect
      @ftp.close
      log "disconnected"
    end

    def go_to(dir)
      @ftp.chdir(dir)
      log "went to #{dir}" 
    end
    
    #list files in current dir
    def files
      filter = %w( . .. .htpasswd stats)
      @ftp.nlst.select do |filename|
        !filter.include?(filename)
      end
    end

    # only remove files, not dirs
    def remove(path)
      # TODO: catch this better
      begin 
        @ftp.delete(path)
      rescue => e
        log e
      end
      log "removed #{path}"
    end

    def log(string)
      puts string
    end

  end
end
