# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_api_control

  def api_control
    @api_control ||= set_api_control
  end

  private

  def set_api_control

    attributes = params[:api_control] || {}
    attributes[:per_page] = params[:per_page]
    attributes[:page] = params[:page]
    @api_control = ApiControl.new(attributes)
  end
end
