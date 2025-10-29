import { useState } from 'react';
import './ProductCard.css';

function ProductCard({ product, onAddToCart }) {
  const [isAdding, setIsAdding] = useState(false);

  const handleAddToCart = () => {
    setIsAdding(true);
    onAddToCart(product);
    setTimeout(() => setIsAdding(false), 500);
  };

  return (
    <div className="product-card">
      <div className="product-image-wrapper">
        <img src={`/${product.image_url}`} alt={product.name} />
      </div>
      <div className="product-info">
        <h3>{product.name}</h3>
        <p className="product-description">{product.description}</p>
        <p className="product-price">GHS {product.price.toFixed(2)}</p>
        <button
          className={`add-to-cart-btn ${isAdding ? 'adding' : ''}`}
          onClick={handleAddToCart}
        >
          {isAdding ? 'Added!' : 'Add to Cart'}
        </button>
      </div>
    </div>
  );
}

export default ProductCard;
