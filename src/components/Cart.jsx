import './Cart.css';

function Cart({ isOpen, cart, onClose, onUpdateQuantity, onRemove, onCheckout, totalAmount }) {
  if (!isOpen) return null;

  return (
    <>
      <div className="cart-overlay" onClick={onClose}></div>
      <div className={`cart-sidebar ${isOpen ? 'open' : ''}`}>
        <div className="cart-header">
          <h2>Shopping Cart</h2>
          <button className="close-btn" onClick={onClose}>×</button>
        </div>

        <div className="cart-content">
          {cart.length === 0 ? (
            <div className="empty-cart">
              <p>Your cart is empty</p>
            </div>
          ) : (
            <>
              <div className="cart-items">
                {cart.map((item) => (
                  <div key={item.id} className="cart-item">
                    <img src={`/${item.image_url}`} alt={item.name} />
                    <div className="cart-item-info">
                      <h4>{item.name}</h4>
                      <p className="cart-item-price">GHS {item.price.toFixed(2)}</p>
                      <div className="quantity-controls">
                        <button
                          onClick={() => onUpdateQuantity(item.id, item.quantity - 1)}
                        >
                          -
                        </button>
                        <span>{item.quantity}</span>
                        <button
                          onClick={() => onUpdateQuantity(item.id, item.quantity + 1)}
                        >
                          +
                        </button>
                      </div>
                    </div>
                    <div className="cart-item-actions">
                      <p className="cart-item-subtotal">
                        GHS {(item.price * item.quantity).toFixed(2)}
                      </p>
                      <button
                        className="remove-btn"
                        onClick={() => onRemove(item.id)}
                      >
                        Remove
                      </button>
                    </div>
                  </div>
                ))}
              </div>

              <div className="cart-footer">
                <div className="cart-total">
                  <span>Total:</span>
                  <span className="total-amount">GHS {totalAmount.toFixed(2)}</span>
                </div>
                <button className="checkout-btn" onClick={onCheckout}>
                  Proceed to Checkout
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </>
  );
}

export default Cart;
