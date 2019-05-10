class ContactsController < ApplicationController

  before_action :authenticate_user!
  before_action :contact, only: [:edit, :update]

  def index
    if search_params[:query]
      @query = search_params[:query].downcase.gsub(/[^-a-z0-9_\ ]/, '')
    end

    qs = []
    if @query && !@query.blank?
      qs = @query =~ /\ / ? @query.split : [@query]
    end

    @contacts = current_user.contacts
    @tags = current_user.tags

    ids = []
    unless qs.empty?
      ct = Contact.arel_table
      tt = Tag.arel_table
      qs.each do |q|
        q = "%#{q}%"
        cons = @contacts.where(ct[:first_name].matches(q).or(ct[:last_name].matches(q)))
        cons.each { |c| ids << c.id }
        tgs = @tags.where(tt[:name].matches(q))
        ContactTag.where(tag: tgs).each { |con_tg| ids << con_tg.contact_id }
      end
    end
    ids = ids.uniq

    @contacts = @contacts.where(id: ids) unless qs.empty?
    @contacts = @contacts.includes([:incomplete_followups, :sales, :tags, :state, phones: :phone_type])

    if qs.empty? && current_user.contacts.count.zero?
      redirect_to new_contact_path
    else
      @contacts = @contacts.ordered.paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @contact = current_user.contacts.new
    @errors = {}
  end

  def create
    @contact = current_user.contacts.create(contact_params)
    if @contact.persisted?
      @errors = FieldValue.update_values(current_user, @contact, custom_fields_params)
      if @errors.empty?
        redirect_to new_contact_followup_path(@contact)
      else
        redirect_to edit_contact_path(@contact)
      end
    else
      render :new
    end
  end

  def edit
    redirect_to contacts_path unless @contact
  end

  def update
    if @contact
      @contact.update_attributes(contact_params)
      @errors = FieldValue.update_values(current_user, @contact, custom_fields_params)
      if @contact.errors.empty? && @errors.empty?
        redirect_to edit_contact_path(@contact)
      else
        render :edit
      end
    else
      redirect_to contacts_path
    end
  end

  def autocomplete
    @contacts = []
    if search_params[:query]
      contacts = current_user.contacts
      t = Contact.arel_table
      query = search_params[:query].downcase.gsub(/[^-0-9a-z\ ]/, '')
      query = query =~ /\ / ? query.split : [query]
      if query.size == 1
        contacts = contacts.where(t[:first_name].matches("#{query[0]}%"))
      elsif query.size == 2
        contacts = contacts.where(t[:first_name].matches(query[0]).and(t[:last_name].matches("#{query[1]}%")))
      end
      contacts = contacts.order([:first_name, :last_name])
      @contacts = contacts.collect { |c| { value: c.fullname, data: c.id } }
    end
    render plain: "{\"suggestions\":#{@contacts.to_json}}".html_safe
  end

  private

  def search_params
    params.permit(:query)
  end

  def contact
    @contact = current_user.contacts.find_by(id: params[:id])
  end

  def custom_fields_params
    if params[:custom_fields]
      params.require(:custom_fields).permit!
    else
      []
    end
  end

  def contact_params
    params.require(:contact).permit(
      :first_name, :last_name,
      :address, :address2,
      :city, :state_id, :zip,
      :email, :tags_string
    )
  end
end
