ActiveAdmin.register Lead, as: 'LeadForm' do
  actions :all, except: [:edit, :create, :new]

  config.sort_order = 'created_at_desc'
end
