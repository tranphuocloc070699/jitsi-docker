// Custom branding for Tuổi Trẻ - Họp trực tuyến
// This script replaces text content on the page

(function() {
    'use strict';

    // Function to replace text content
    function replaceText() {
        // Replace "Jitsi Meet" with "Họp trực tuyến"
        const elements = document.querySelectorAll('*');
        elements.forEach(element => {
            // Only process text nodes
            for (let node of element.childNodes) {
                if (node.nodeType === Node.TEXT_NODE) {
                    if (node.textContent.includes('Jitsi Meet')) {
                        node.textContent = node.textContent.replace(/Jitsi Meet/g, 'Họp trực tuyến');
                    }
                    if (node.textContent.includes('Secure and high quality meeting')) {
                        node.textContent = node.textContent.replace(/Secure and high quality meeting/g, 'Họp trực tuyến của Báo Tuổi Trẻ');
                    }
                    if (node.textContent.includes('Secure, fully featured, and completely free video conferencing')) {
                        node.textContent = node.textContent.replace(/Secure, fully featured, and completely free video conferencing/g, 'Họp trực tuyến của Báo Tuổi Trẻ');
                    }
                }
            }
        });

        // Update page title
        if (document.title.includes('Jitsi Meet')) {
            document.title = document.title.replace(/Jitsi Meet/g, 'Họp trực tuyến');
        }

        // Update meta tags
        const metaTags = document.querySelectorAll('meta[content*="Jitsi Meet"], meta[content*="Jitsi"]');
        metaTags.forEach(meta => {
            if (meta.content) {
                meta.content = meta.content.replace(/Jitsi Meet/g, 'Họp trực tuyến');
            }
        });
    }

    // Run on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', replaceText);
    } else {
        replaceText();
    }

    // Also run after a short delay to catch dynamically loaded content
    setTimeout(replaceText, 500);
    setTimeout(replaceText, 1000);
    setTimeout(replaceText, 2000);

    // Use MutationObserver to catch dynamic content changes
    const observer = new MutationObserver(function(mutations) {
        replaceText();
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    // Override APP_NAME if interfaceConfig is available
    if (window.interfaceConfig) {
        window.interfaceConfig.APP_NAME = 'Họp trực tuyến';
    }

    // Wait for interfaceConfig to be defined and override it
    Object.defineProperty(window, 'interfaceConfig', {
        set: function(value) {
            value.APP_NAME = 'Họp trực tuyến';
            this._interfaceConfig = value;
        },
        get: function() {
            return this._interfaceConfig;
        }
    });

})();
