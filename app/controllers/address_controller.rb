class AddressController < ApplicationController
  include ObjectErrorsLogger, PostcodeLookup
  before_action :authenticate_user!, :check_and_set_model_type

  def assign_address_attributes

    assign_attributes(@model_object)
    render :show

  end

  # This method updates the mission attribute of an organisation,
  # redirecting to :organisation_mission if successful and re-rendering
  # :about method if unsuccessful
  def update

    logger.info "Updating address for #{@type} ID: #{@model_object.id}"

    @model_object.validate_address = true

    @model_object.update(model_params)

    if @model_object.valid?

      logger.info "Finished updating address for #{@type} ID: " \
                  "#{@model_object.id}"

      if @type == "organisation"
        redirect_to organisation_mission_path(params['id'])
      elsif @type == "project"
        redirect_to three_to_ten_k_project_description_get_path(params['id'])
      elsif @type == "user"
        redirect_to :authenticated_root
      end

    else

      logger.info "Validation failed when attempting to update address for " \
                  "#{@type} ID: #{@model_object.id}"

      log_errors(@model_object)

      render :show

    end

  end


  private

  # Checks for a known type of model in the params.
  # If correct, then assign the model type to a @type instance variable.
  def check_and_set_model_type
    if %w(user organisation project).include? params[:type]
      @type = params[:type]
      case @type
      when "organisation"
        @model_object = Organisation.find(params[:id])
      when "project"
        @model_object = Project.find(params[:id])
      when "user"
        @model_object = User.find_by(organisation_id: params[:id])
        unless @model_object.id == current_user.id
          redirect_to :root
        end
      end
    else
      redirect_to :root
    end
  end

  def model_params
    params.require(@type)
        .permit(:name, :line1, :line2, :line3,
                :townCity, :county, :postcode)
  end

end
