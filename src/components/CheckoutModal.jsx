import { useState } from 'react';
import { supabase } from '../supabaseClient';
import './CheckoutModal.css';

function CheckoutModal({ isOpen, cart, totalAmount, onClose, onOrderComplete }) {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    address: '',
    notes: '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [orderSuccess, setOrderSuccess] = useState(false);
  const [orderNumber, setOrderNumber] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      let customerId = null;

      const { data: existingCustomer } = await supabase
        .from('customers')
        .select('id')
        .eq('email', formData.email)
        .maybeSingle();

      if (existingCustomer) {
        customerId = existingCustomer.id;
      } else {
        const { data: newCustomer, error: customerError } = await supabase
          .from('customers')
          .insert({
            name: formData.name,
            email: formData.email,
            phone: formData.phone,
          })
          .select()
          .single();

        if (customerError) throw customerError;
        customerId = newCustomer.id;
      }

      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
          customer_id: customerId,
          customer_name: formData.name,
          customer_email: formData.email,
          customer_phone: formData.phone,
          delivery_address: formData.address,
          total_amount: totalAmount,
          status: 'pending',
          notes: formData.notes,
        })
        .select()
        .single();

      if (orderError) throw orderError;

      const orderItems = cart.map((item) => ({
        order_id: order.id,
        product_id: item.id,
        product_name: item.name,
        product_price: item.price,
        quantity: item.quantity,
        subtotal: item.price * item.quantity,
      }));

      const { error: itemsError } = await supabase
        .from('order_items')
        .insert(orderItems);

      if (itemsError) throw itemsError;

      setOrderNumber(order.id.substring(0, 8).toUpperCase());
      setOrderSuccess(true);
      onOrderComplete();

      setTimeout(() => {
        setOrderSuccess(false);
        setFormData({
          name: '',
          email: '',
          phone: '',
          address: '',
          notes: '',
        });
        onClose();
      }, 3000);
    } catch (error) {
      console.error('Error submitting order:', error);
      alert('Failed to submit order. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  return (
    <>
      <div className="modal-overlay" onClick={onClose}></div>
      <div className="checkout-modal">
        {orderSuccess ? (
          <div className="order-success">
            <div className="success-icon">✓</div>
            <h2>Order Placed Successfully!</h2>
            <p>Your order number is: <strong>{orderNumber}</strong></p>
            <p>We'll contact you shortly to confirm your order.</p>
          </div>
        ) : (
          <>
            <div className="modal-header">
              <h2>Complete Your Order</h2>
              <button className="close-modal-btn" onClick={onClose}>×</button>
            </div>

            <div className="modal-content">
              <div className="order-summary">
                <h3>Order Summary</h3>
                <div className="summary-items">
                  {cart.map((item) => (
                    <div key={item.id} className="summary-item">
                      <span>{item.name} x {item.quantity}</span>
                      <span>GHS {(item.price * item.quantity).toFixed(2)}</span>
                    </div>
                  ))}
                </div>
                <div className="summary-total">
                  <span>Total:</span>
                  <span>GHS {totalAmount.toFixed(2)}</span>
                </div>
              </div>

              <form onSubmit={handleSubmit} className="checkout-form">
                <div className="form-group">
                  <label htmlFor="name">Full Name *</label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="email">Email *</label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="phone">Phone Number *</label>
                  <input
                    type="tel"
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleChange}
                    required
                  />
                </div>

                <div className="form-group">
                  <label htmlFor="address">Delivery Address *</label>
                  <textarea
                    id="address"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                    rows="3"
                    required
                  ></textarea>
                </div>

                <div className="form-group">
                  <label htmlFor="notes">Additional Notes (Optional)</label>
                  <textarea
                    id="notes"
                    name="notes"
                    value={formData.notes}
                    onChange={handleChange}
                    rows="2"
                  ></textarea>
                </div>

                <button
                  type="submit"
                  className="submit-order-btn"
                  disabled={isSubmitting}
                >
                  {isSubmitting ? 'Processing...' : 'Place Order'}
                </button>
              </form>
            </div>
          </>
        )}
      </div>
    </>
  );
}

export default CheckoutModal;
