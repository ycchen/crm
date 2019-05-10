
include FactoryBot::Syntax::Methods
Faker::Config.locale = 'en-US'

[{ name: 'Alabama',        abbr: 'AL' },
{ name: 'Alaska',         abbr: 'AK' },
{ name: 'Arizona',        abbr: 'AZ' },
{ name: 'Arkansas',       abbr: 'AR' },
{ name: 'California',     abbr: 'CA' },
{ name: 'Colorado',       abbr: 'CO' },
{ name: 'Connecticut',    abbr: 'CT' },
{ name: 'Delaware',       abbr: 'DE' },
{ name: 'Florida',        abbr: 'FL' },
{ name: 'Georgia',        abbr: 'GA' },
{ name: 'Hawaii',         abbr: 'HI' },
{ name: 'Idaho',          abbr: 'ID' },
{ name: 'Illinois',       abbr: 'IL' },
{ name: 'Indiana',        abbr: 'IN' },
{ name: 'Iowa',           abbr: 'IA' },
{ name: 'Kansas',         abbr: 'KS' },
{ name: 'Kentucky',       abbr: 'KY' },
{ name: 'Louisiana',      abbr: 'LA' },
{ name: 'Maine',          abbr: 'ME' },
{ name: 'Maryland',       abbr: 'MD' },
{ name: 'Massachusetts',  abbr: 'MA' },
{ name: 'Michigan',       abbr: 'MI' },
{ name: 'Minnesota',      abbr: 'MN' },
{ name: 'Mississippi',    abbr: 'MS' },
{ name: 'Missouri',       abbr: 'MO' },
{ name: 'Montana',        abbr: 'MT' },
{ name: 'Nebraska',       abbr: 'NE' },
{ name: 'Nevada',         abbr: 'NV' },
{ name: 'New Hampshire',  abbr: 'NH' },
{ name: 'New Jersey',     abbr: 'NJ' },
{ name: 'New Mexico',     abbr: 'NM' },
{ name: 'New York',       abbr: 'NY' },
{ name: 'North Carolina', abbr: 'NC' },
{ name: 'North Dakota',   abbr: 'ND' },
{ name: 'Ohio',           abbr: 'OH' },
{ name: 'Oklahoma',       abbr: 'OK' },
{ name: 'Oregon',         abbr: 'OR' },
{ name: 'Pennsylvania',   abbr: 'PA' },
{ name: 'Rhode Island',   abbr: 'RI' },
{ name: 'South Carolina', abbr: 'SC' },
{ name: 'South Dakota',   abbr: 'SD' },
{ name: 'Tennessee',      abbr: 'TN' },
{ name: 'Texas',          abbr: 'TX' },
{ name: 'Utah',           abbr: 'UT' },
{ name: 'Vermont',        abbr: 'VT' },
{ name: 'Virginia',       abbr: 'VA' },
{ name: 'Washington',     abbr: 'WA' },
{ name: 'West Virginia',  abbr: 'WV' },
{ name: 'Wisconsin',      abbr: 'WI' },
{ name: 'Wyoming',        abbr: 'WY' }
].each do |state|
  create(:state, name: state[:name], abbr: state[:abbr])
end

puts "#{State.count} states created"

%w(Main Cell Work Home Other Fax).each do |name|
  create(:phone_type, name: name)
end

puts "#{PhoneType.count} phone types created"

%w(Call Text Email Facebook Instagram Twitter Pinterest).each do |name|
  create(:followup_type, name: name)
end

puts "#{FollowupType.count} followup types created"

user = create(
  :user,
  fname: 'Greg',
  lname: 'Donald',
  email: 'gdonald@gmail.com',
  password: 'changeme',
  password_confirmation: 'changeme',
)
user.skip_confirmation!
user.save

puts "#{User.count} users created"

100.times do
  c = create(:contact, :valid_contact, user: user)
  (1..3).collect { |x| x }.sample(1).first.times do
    pt = PhoneType.find(PhoneType.pluck(:id).shuffle.first)
    create(:phone, contact: c, phone_type: pt, number: "#{Faker::PhoneNumber.area_code}#{Faker::PhoneNumber.exchange_code}#{Faker::PhoneNumber.subscriber_number}")
  end
end

puts "#{Contact.count} contacts created"
puts "#{Phone.count} phones created"

Contact.all.each do |c|
  (1..2).collect { |x| x }.sample(1).first.times do
    ft = FollowupType.find(FollowupType.pluck(:id).shuffle.first)
    create(:followup, :completed, user: user, contact: c, followup_type: ft, note: Faker::Lorem.sentences(rand(5) + 1).join(' '), when: (rand(15) + 1).days.ago + rand(24).hours + rand(60).minutes)
  end
  (1..2).collect { |x| x }.sample(1).first.times do
    ft = FollowupType.find(FollowupType.pluck(:id).shuffle.first)
    create(:followup, user: user, contact: c, followup_type: ft, note: Faker::Lorem.sentences(rand(5) + 1).join(' '), when: Time.current + rand(30).days + rand(24).hours + rand(60).minutes)
  end
  (1..4).collect { |x| x }.sample(1).first.times do
    n = create(:note, user: user, contact: c, note: Faker::Lorem.sentences(rand(5) + 1).join(' '))
    n.update_attribute(:created_at, rand(60).days.ago)
  end
end

puts "#{Followup.count} followups created"
puts "#{Note.count} notes created"

100.times do
  create(:product, user: user)
end

puts "#{Product.count} products created"

Contact.all.each do |c|
  (0..2).collect { |x| x }.sample(1).first.times do
    sale = create(:sale, user: user, contact: c)
    (1..5).collect { |x| x }.sample(1).first.times do
      p = Product.find_by(id: (1..Product.count).collect { |x| x }.sample(1).first)
      create(:sale_item, sale: sale, product: p, price: p.price, quantity: (1..5).collect { |x| x }.sample(1).first)
    end
  end
end

puts "#{Sale.count} sales created"
puts "#{SaleItem.count} sale items created"

%w(Contact Product Followup Sale).sort.each do |name|
  create(:entity_type, name: name)
end
puts "#{EntityType.count} entity types created"

%w(text textarea checkbox checkboxes select radio date time datetime number color range email url).sort.each do |name|
  field_type = create(:field_type, name: name)
  required = !%w(checkbox).include?(name)
  EntityType.ordered.each do |entity_type|
    custom_field = create(:custom_field, user: user, entity_type: entity_type, field_type: field_type, name: name.titleize, required: required)
    next unless custom_field.can_have_options?
    (2..4).collect { |x| x }.sample(1).first.times do |x|
      create(:field_option, custom_field: custom_field, name: "Option #{x}")
    end
  end
end

puts "#{FieldType.count} field types created"
puts "#{CustomField.count} custom fields created"
puts "#{FieldOption.count} field options created"
