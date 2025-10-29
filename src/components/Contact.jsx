import './Contact.css';

function Contact() {
  return (
    <section id="contact" className="contact">
      <h2>Contact Us</h2>
      <div className="contact-info">
        <div className="contact-item">
          <h3>Email</h3>
          <a href="mailto:veagyeimensah@gmail.com">veagyeimensah@gmail.com</a>
        </div>
        <div className="contact-item">
          <h3>Instagram</h3>
          <a href="https://www.instagram.com/systa_systa_?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==" target="_blank" rel="noopener noreferrer">
            @Systa_systa
          </a>
        </div>
        <div className="contact-item">
          <h3>Phone</h3>
          <a href="tel:0597868871">0597868871</a>
        </div>
      </div>
    </section>
  );
}

export default Contact;
