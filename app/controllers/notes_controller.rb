class NotesController < ApplicationController

  before_action :authenticate_user!
  before_action :contact, only: [:index, :new, :create, :edit, :cancel_edit, :update]
  before_action :note, only: [:edit, :cancel_edit, :update]

  def index
    @notes = @contact.notes.ordered.paginate(page: params[:page], per_page: 10)
  end

  def new
    @note = current_user.notes.new
  end

  def create
    @note = @contact.notes.create(note_params.merge(user_id: current_user.id))
    if @note.persisted?
      redirect_to contact_notes_path(@contact)
    else
      render :new
    end
  end

  def edit; end

  def cancel_edit; end

  def update
    @note.update_attributes(note_params)
  end

  private

  def contact
    @contact = current_user.contacts.find_by(id: params[:contact_id])
    head :unauthorized unless @contact
  end

  def note
    @note = @contact.notes.find_by(id: params[:id]) if @contact
    head :unauthorized unless @note
  end

  def note_params
    params.require(:note).permit(:note)
  end

end
