(() => {
  const patterns = {
    android: /-Android-arm64-v8a-release\.apk$/i,
    ios: /-iOS-release\.ipa$/i,
    windows: /-windows-x86_64-release\.zip$/i,
    macos: /-macOS-universal-release\.zip$/i,
    linux: /-linux-x86_64-release\.tar\.gz$/i,
  };
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 8000);

  fetch('https://api.github.com/repos/MoeKeyDev/MoeKey/releases/latest', {
    signal: controller.signal,
    headers: { Accept: 'application/vnd.github+json' },
  })
    .then(response => {
      if (!response.ok) throw new Error('Release unavailable');
      return response.json();
    })
    .then(release => {
      if (!Array.isArray(release.assets) || !release.tag_name) return;
      document.querySelectorAll('[data-platform]').forEach(link => {
        const pattern = patterns[link.dataset.platform];
        const asset = release.assets.find(item => pattern?.test(item.name));
        // Only use download URLs belonging to this repository.
        if (asset?.browser_download_url?.startsWith('https://github.com/MoeKeyDev/MoeKey/releases/download/')) {
          link.href = asset.browser_download_url;
        }
      });
      const label = document.querySelector('[data-release-version]');
      if (label) label.textContent = release.tag_name.replace(/^v?/, 'v');
    })
    // Static links remain usable when offline, rate limited, or missing an asset.
    .catch(() => {})
    .finally(() => clearTimeout(timeout));
})();
