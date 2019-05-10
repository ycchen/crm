class FollowupsController < ApplicationController

  before_action :authenticate_user!
  before_action :contact, only: [:index, :new, :create, :edit, :cancel_edit, :update, :complete, :completed]
  before_action :followup, only: [:edit, :cancel_edit, :update, :complete, :completed]

  def index
    @followups = @contact ? @contact.followups : current_user.followups
    if session[:show_completed_followups] == 1
      @followups = @followups.completed.ordered.reverse_order
    else
      @followups = @followups.incomplete.ordered
    end
    @followups = @followups.includes([:followup_type, :contact])
    @followups = @followups.paginate(page: params[:page], per_page: 10)
  end

  def completed
    session[:show_completed_followups] = params[:show_completed_followups].to_i
    if @contact
      redirect_to contact_followups_path(@contact)
    else
      redirect_to followups_path
    end
  end

  def new
    @followup = current_user.followups.new
  end

  def create
    if @contact
      @followup = @contact.followups.create(followup_params.merge(user_id: current_user.id))
      if @followup.persisted?
        @errors = FieldValue.update_values(current_user, @followup, custom_fields_params)
        if @errors.empty?
          redirect_to contact_followups_path(@contact)
        else
          redirect_to edit_contact_followup_path(@contact, @followup)
        end
      else
        render :new
      end
    else
      redirect_to followups_path
    end
  end

  def edit; end

  def update
    @followup.update_attributes(followup_params)
    @errors = FieldValue.update_values(current_user, @followup, custom_fields_params)
    if @followup.errors.empty? && @errors.empty?
      if @contact
        redirect_to edit_contact_followup_path(@contact, @followup)
      else
        redirect_to edit_followup_path(@followup)
      end
    else
      render :edit
    end
  end

  def complete
    @followup.update_attribute(:completed, true)
  end

  private

  def contact
    @contact = current_user.contacts.find_by(id: params[:contact_id])
  end

  def followup
    @followup = @contact ? @contact.followups : current_user.followups
    @followup = @followup.find_by(id: params[:id])
  end

  def followup_params
    params.require(:followup).permit(:followup_type_id, :note, :when, :completed)
  end

  def custom_fields_params
    if params[:custom_fields]
      params.require(:custom_fields).permit!
    else
      []
    end
  end

end
