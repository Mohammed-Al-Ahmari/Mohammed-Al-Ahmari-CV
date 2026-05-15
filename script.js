/* ════════════════════════════════════════════
   script.js  —  Personal CV Website
   Features:
     1. Dark / Light mode toggle (with localStorage)
     2. Sticky nav shrink on scroll
     3. Active nav link highlight (IntersectionObserver)
     4. Mobile hamburger menu
     5. Scroll-reveal animations (IntersectionObserver)
     6. Back-to-top button
     7. Smooth page-load fade-in
   ════════════════════════════════════════════ */

/* ─────────────────────────────────────────────
   1.  DARK / LIGHT MODE
   ───────────────────────────────────────────── */
const themeToggle = document.getElementById('themeToggle');
const themeIcon   = document.getElementById('themeIcon');
const html        = document.documentElement;

// Icons for each theme
const ICONS = {
  dark:  '<i class="fa-solid fa-sun"></i>',   // shown in dark mode  → click = go light
  light: '<i class="fa-solid fa-moon"></i>'   // shown in light mode → click = go dark
};

/**
 * Apply a theme and persist it in localStorage.
 * @param {'dark'|'light'} theme
 */
function applyTheme(theme) {
  html.setAttribute('data-theme', theme);
  themeIcon.innerHTML = ICONS[theme];
  localStorage.setItem('cv-theme', theme);
}

// Initialise: respect saved preference, otherwise keep default (dark)
const savedTheme = localStorage.getItem('cv-theme') || 'dark';
applyTheme(savedTheme);

// Toggle on button click
themeToggle.addEventListener('click', () => {
  const current = html.getAttribute('data-theme');
  applyTheme(current === 'dark' ? 'light' : 'dark');
});

/* ─────────────────────────────────────────────
   2.  STICKY NAV – shrinks after scrolling 20px
   ───────────────────────────────────────────── */
const navbar = document.getElementById('navbar');

window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 20);
}, { passive: true });

/* ─────────────────────────────────────────────
   3.  ACTIVE NAV LINK (IntersectionObserver)
   ───────────────────────────────────────────── */
const navLinks = document.querySelectorAll('.nav__links a');
const sections = document.querySelectorAll('section[id], header[id]');

const linkObserver = new IntersectionObserver(
  entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLinks.forEach(link => {
          link.classList.toggle(
            'active',
            link.getAttribute('href') === `#${entry.target.id}`
          );
        });
      }
    });
  },
  { rootMargin: '-40% 0px -50% 0px' }
);

sections.forEach(sec => linkObserver.observe(sec));

/* ─────────────────────────────────────────────
   4.  HAMBURGER MENU (mobile)
   ───────────────────────────────────────────── */
const hamburger = document.getElementById('hamburger');
const navMenu   = document.querySelector('.nav__links');

hamburger.addEventListener('click', () => {
  const isOpen = navMenu.classList.toggle('open');
  hamburger.setAttribute('aria-expanded', isOpen);

  // Animate bars → X
  const bars = hamburger.querySelectorAll('span');
  if (isOpen) {
    bars[0].style.transform = 'translateY(7px) rotate(45deg)';
    bars[1].style.opacity   = '0';
    bars[2].style.transform = 'translateY(-7px) rotate(-45deg)';
  } else {
    bars[0].style.transform = '';
    bars[1].style.opacity   = '';
    bars[2].style.transform = '';
  }
});

// Close menu when a link is clicked
navLinks.forEach(link => {
  link.addEventListener('click', () => {
    navMenu.classList.remove('open');
    const bars = hamburger.querySelectorAll('span');
    bars[0].style.transform = '';
    bars[1].style.opacity   = '';
    bars[2].style.transform = '';
  });
});

/* ─────────────────────────────────────────────
   5.  SCROLL-REVEAL ANIMATIONS
   ───────────────────────────────────────────── */
const revealElements = document.querySelectorAll('.reveal');

const revealObserver = new IntersectionObserver(
  entries => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        // Stagger siblings inside the same parent for a wave effect
        const siblings = [...entry.target.parentElement.children].filter(
          el => el.classList.contains('reveal')
        );
        const delay = siblings.indexOf(entry.target) * 100;

        setTimeout(() => {
          entry.target.classList.add('visible');
        }, delay);

        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.12 }
);

revealElements.forEach(el => revealObserver.observe(el));

/* ─────────────────────────────────────────────
   6.  BACK-TO-TOP BUTTON
   ───────────────────────────────────────────── */
const backTop = document.getElementById('backTop');

window.addEventListener('scroll', () => {
  backTop.classList.toggle('visible', window.scrollY > 400);
}, { passive: true });

backTop.addEventListener('click', () => {
  window.scrollTo({ top: 0, behavior: 'smooth' });
});

/* ─────────────────────────────────────────────
   7.  PAGE-LOAD FADE-IN
   ───────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.4s ease';
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      document.body.style.opacity = '1';
    });
  });
});

/* ─────────────────────────────────────────────
   8.  YEAR AUTO-UPDATE IN FOOTER (bonus)
   ───────────────────────────────────────────── */
const yearEl = document.querySelector('.footer p');
if (yearEl) {
  yearEl.innerHTML = yearEl.innerHTML.replace(
    /© \d{4}/,
    `© ${new Date().getFullYear()}`
  );
}