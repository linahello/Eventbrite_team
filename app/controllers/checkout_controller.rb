class CheckoutController < ApplicationController
  def create
    event = Event.find(params[:event]).as_json
    @session = Stripe::Checkout::Session.create(
      metadata: {event: event["id"]},
      payment_method_types: ['card'],
      line_items: [
        {
          name: 'coucou',
          currency: 'eur',
          amount: 4000,
          quantity: 1
        },
      ],
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url,
    )
    respond_to do |format|
      format.js # renders create.js.erb
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end

  def cancel
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end
end