class LogEntriesController < ApplicationController
  def create
    log = LogEntry.create(sanitize(params[:log_entry]))

    render :json => log
  end

  def index
    require 'pry';binding.pry
    logs = LogEntry.page(:page => (params[:page] || 1), :per_page => 30)

    render :json => logs
  end

  def sanitize(model)
    sanitized = {}
    LogEntry.attr_accessible[:default].each do |attr|
      sanitized[attr] = model[attr] if model[attr]
    end
    sanitized
  end
end
