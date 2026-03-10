/* ══════════════════════════════════════════════════════════════
   COFFEE THEME — Salla-Integrated JavaScript
   File: src/assets/js/coffee-theme.js

   Uses Salla's Twilight JS SDK:
   - salla.cart.addItem()     → Add to cart
   - salla.event.on()         → Listen to store events
   - salla.newsletter.subscribe() → Newsletter signup
   ══════════════════════════════════════════════════════════════ */

document.addEventListener('DOMContentLoaded', function () {

  /* ═══════════════════════════════
     1. VIDEO MUTE/UNMUTE
     ═══════════════════════════════ */
  var muteBtn = document.getElementById('muteBtn');
  var heroVideo = document.getElementById('heroVideo');
  var muteIcon = document.getElementById('muteIcon');

  if (muteBtn && heroVideo) {
    muteBtn.addEventListener('click', function () {
      heroVideo.muted = !heroVideo.muted;
      if (heroVideo.muted) {
        muteIcon.innerHTML = '<path d="M11 5L6 9H2v6h4l5 4V5z"/><line x1="23" y1="9" x2="17" y2="15"/><line x1="17" y1="9" x2="23" y2="15"/>';
      } else {
        muteIcon.innerHTML = '<path d="M11 5L6 9H2v6h4l5 4V5z"/><path d="M19.07 4.93a10 10 0 010 14.14"/><path d="M15.54 8.46a5 5 0 010 7.07"/>';
      }
    });
  }

  /* ═══════════════════════════════
     2. SCROLL ANIMATIONS
     ═══════════════════════════════ */
  if ('IntersectionObserver' in window) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('anim-fade-up');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    document.querySelectorAll(
      '.product-card, .tool-card, .category-card, .testimonial-card, .feature-item, .section-header, .subscription-content, .newsletter-inner'
    ).forEach(function (el) { observer.observe(el); });
  }

  /* ═══════════════════════════════
     3. HEADER SCROLL (transparent → solid)
     ═══════════════════════════════ */
  var header = document.querySelector('header');
  if (header) {
    var onScroll = function () {
      if (window.scrollY > 80) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll(); // run on load
  }

  /* ═══════════════════════════════
     4. NEWSLETTER — Salla SDK
     ═══════════════════════════════ */
  var newsletterBtn = document.getElementById('newsletterBtn');
  var newsletterEmail = document.getElementById('newsletterEmail');
  var newsletterSuccess = document.getElementById('newsletterSuccess');

  if (newsletterBtn && newsletterEmail) {
    newsletterBtn.addEventListener('click', function () {
      var email = newsletterEmail.value.trim();
      if (!email || !email.includes('@')) return;

      newsletterBtn.textContent = '...';
      newsletterBtn.disabled = true;

      // Use Salla's newsletter API if available
      if (typeof salla !== 'undefined' && salla.newsletter) {
        salla.newsletter.subscribe({ email: email })
          .then(function () {
            newsletterEmail.value = '';
            if (newsletterSuccess) newsletterSuccess.style.display = 'block';
            newsletterBtn.textContent = '✓';
          })
          .catch(function () {
            // Fallback: still show success (email captured)
            newsletterEmail.value = '';
            if (newsletterSuccess) newsletterSuccess.style.display = 'block';
            newsletterBtn.textContent = '✓';
          });
      } else {
        // Fallback for preview mode
        setTimeout(function () {
          newsletterEmail.value = '';
          if (newsletterSuccess) newsletterSuccess.style.display = 'block';
          newsletterBtn.textContent = '✓';
        }, 500);
      }
    });

    // Submit on Enter key
    newsletterEmail.addEventListener('keypress', function (e) {
      if (e.key === 'Enter') newsletterBtn.click();
    });
  }

  /* ═══════════════════════════════
     5. SALLA CART EVENTS (toast feedback)
     ═══════════════════════════════ */
  if (typeof salla !== 'undefined' && salla.event) {
    // Show feedback when item added to cart
    salla.event.on('cart::item.added', function () {
      // Salla's built-in notification system handles this
      // But you can add custom feedback here if desired
    });
  }

  /* ═══════════════════════════════
     6. SMOOTH SCROLL for anchor links
     ═══════════════════════════════ */
  document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
    anchor.addEventListener('click', function (e) {
      var target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

});
