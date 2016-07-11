module PullRequestResource
  class Out
    def initialize(input, destination)
      @input = input
      @destination = destination
    end

    def error
      first_error ->{validate_status(input['params']['status'])},
                  ->{validate_required_keys(input['params'])},
                  ->{validate_path(input['params']['path'])}
    end

    private

    attr_reader :input, :destination

    def first_error(*validators)
      validators.lazy.map {|validator| validator[]}.detect(&:itself)
    end

    def path
      File.join(destination, input['params']['path'])
    end

    def validate_status(status)
      unless %w(success failure error pending).include?(status)
        status_not_supported_error(status)
      end
    end

    def validate_required_keys(params)
      '`path` required in `params`' unless input['params'].key?('path')
    end

    def validate_path(input_path)
      %(`path` "#{input_path}" does not exist) unless File.exist?(path)
    end

    def status_not_supported_error(status)
      %(`status` "#{status}" is not supported -- only success, failure, error, or pending)
    end
  end
end

