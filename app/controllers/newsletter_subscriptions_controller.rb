class NewsletterSubscriptionsController < ApplicationController
  def create
    subscription = NewsletterSubscription.new(subscription_params)

    if subscription.save
      redirect_back fallback_location: root_path, notice: "Your archive entry has been recorded."
    else
      redirect_back fallback_location: root_path, alert: subscription.errors.full_messages.to_sentence
    end
  end

  private

  def subscription_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
