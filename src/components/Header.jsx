import './Header.css';

function Header({ cartItemCount, onCartClick }) {
  return (
    <header className="header">
      <div className="logo">SYSTA | ƧYSTA - Fashion Redefined</div>
      <nav>
        <ul>
          <li><a href="#home">Home</a></li>
          <li><a href="#products">Products</a></li>
          <li><a href="#contact">Contact</a></li>
          <li>
            <button className="cart-button" onClick={onCartClick}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M9 2L6 6H3v14h18V6h-3l-3-4H9z"/>
                <path d="M9 8v4M15 8v4"/>
              </svg>
              {cartItemCount > 0 && (
                <span className="cart-badge">{cartItemCount}</span>
              )}
            </button>
          </li>
        </ul>
      </nav>
    </header>
  );
}

export default Header;
