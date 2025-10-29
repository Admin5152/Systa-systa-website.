import ProductCard from './ProductCard';
import './ProductGrid.css';

function ProductGrid({ products, onAddToCart }) {
  return (
    <section id="products" className="products">
      <h2>Featured Products</h2>
      <div className="product-grid">
        {products.map((product) => (
          <ProductCard
            key={product.id}
            product={product}
            onAddToCart={onAddToCart}
          />
        ))}
      </div>
      <p className="more-text">& More!!!</p>
    </section>
  );
}

export default ProductGrid;
