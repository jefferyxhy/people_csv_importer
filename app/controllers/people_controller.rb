# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.all.includes(:locations, :affiliations)
    if @api_control.q.present?
      @people = @people.where('first_name ilike :q OR last_name ilike :q', q: "%#{@api_control.q}%")
    end
    @people = @api_control.sort(@people) # ApiControl record inherit from ApplicationController, read default sort info from params
    @people = @api_control.paginate(@people) # ApiControl record inherit from ApplicationController, read default paginate info from params
  end

  def batch_create
    @person_csv_importer = PersonCsvImporter.new(safe_params[:csv])
    @person_csv_importer.call
    flash[@person_csv_importer.errors_exist? ? :error : :notice] = @person_csv_importer.full_messages
    redirect_to people_path
  end

  private

  def safe_params
    params.require(:people).permit(:csv)
  end
end
