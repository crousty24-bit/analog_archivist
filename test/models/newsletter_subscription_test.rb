require "test_helper"

class NewsletterSubscriptionTest < ActiveSupport::TestCase
  test "normalizes email before validation" do
    subscription = NewsletterSubscription.create!(email: "  Curator@Example.COM ")

    assert_equal "curator@example.com", subscription.email
  end

  test "rejects duplicate normalized emails" do
    NewsletterSubscription.create!(email: "curator@example.com")

    duplicate = NewsletterSubscription.new(email: " Curator@Example.com ")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end
end
