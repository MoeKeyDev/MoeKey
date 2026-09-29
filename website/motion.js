(() => {
  const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
  const finePointer = matchMedia('(hover: hover) and (pointer: fine)');
  const header = document.querySelector('.navigation-shell');
  const topLink = document.querySelector('.back-top');
  const hero = document.querySelector('.intro');
  const art = document.querySelector('.hero-art');
  const running = new Set();

  // Content stays visible if JavaScript, observers or animation are unavailable.
  const enter = (element, delay = 0) => {
    if (reducedMotion.matches || !element.animate) return;
    const animation = element.animate([
      { opacity: 0.35, transform: 'translateY(26px)' },
      { opacity: 1, transform: 'translateY(0)' },
    ], { duration: 650, delay, easing: 'cubic-bezier(.2,.7,.2,1)', fill: 'backwards' });
    running.add(animation);
    animation.onfinish = animation.oncancel = () => running.delete(animation);
  };
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const siblings = [...entry.target.parentElement.children];
        const stagger = entry.target.matches('.highlights article, .feature-list > div')
          ? Math.min(siblings.indexOf(entry.target), 2) * 85 : 0;
        enter(entry.target, stagger);
        observer.unobserve(entry.target);
      });
    }, { threshold: 0.12 });
    document.querySelectorAll('.intro-copy, .highlights article, .preview-heading, .preview, .section-label, .feature-list > div, .download .section-body')
      .forEach(element => observer.observe(element));
  }

  let scrollFrame = 0;
  const updateScroll = () => {
    header.classList.toggle('is-scrolled', scrollY > 16);
    topLink.classList.toggle('is-visible', scrollY > 500);
    scrollFrame = 0;
  };
  addEventListener('scroll', () => {
    if (!scrollFrame) scrollFrame = requestAnimationFrame(updateScroll);
  }, { passive: true });
  updateScroll();

  const resetTilt = () => {
    art.style.removeProperty('--tilt-x');
    art.style.removeProperty('--tilt-y');
  };
  hero.addEventListener('pointermove', event => {
    if (reducedMotion.matches || !finePointer.matches) return;
    const bounds = hero.getBoundingClientRect();
    const x = (event.clientX - bounds.left) / bounds.width - 0.5;
    const y = (event.clientY - bounds.top) / bounds.height - 0.5;
    art.style.setProperty('--tilt-x', `${-y * 9}deg`);
    art.style.setProperty('--tilt-y', `${x * 12}deg`);
  }, { passive: true });
  hero.addEventListener('pointerleave', resetTilt);
  finePointer.addEventListener('change', resetTilt);
  reducedMotion.addEventListener('change', () => {
    resetTilt();
    if (reducedMotion.matches) running.forEach(animation => animation.cancel());
  });
})();
