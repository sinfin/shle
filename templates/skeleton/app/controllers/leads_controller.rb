class LeadsController < ApplicationController
  def create
    @lead = Lead.new(lead_params)
    success = @lead.save

    LeadMailer.notification_email(@lead).deliver_later if success

    render partial: 'leads/form', locals: { did_send: success }
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :note)
  end
end
