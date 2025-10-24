# Jitsi Meet - "Mời thêm người tham dự" Popup Documentation

## Overview
This document explains the structure and customization of the Jitsi Meet "Invite More Participants" (Mời thêm người tham dự) popup.

## File Location & Structure

### 1. **Main Translation File**
**Path:** `/workspace/jitsi-meet-cfg/web/main-vi.json`

This file contains Vietnamese translations for the entire Jitsi Meet interface. The "Mời thêm người tham dự" text is located in the `addPeople` section:

```json
{
  "addPeople": {
    "title": "Mời người tham dự cuộc họp này",
    "inviteMorePrompt": "Mời thêm người tham dự",
    "inviteMoreHeader": "Bạn là người duy nhất trong cuộc họp",
    "add": "Mời",
    "addContacts": "Mời các liên hệ của bạn",
    "copyLink": "Sao chép liên kết cuộc họp",
    "shareLink": "Chia sẻ đường dẫn để mời người khác tham dự cuộc họp"
  }
}
```

**Key Translation Keys:**
- `addPeople.inviteMorePrompt`: "Mời thêm người tham dự" - The main invite prompt text
- `addPeople.title`: "Mời người tham dự cuộc họp này" - Dialog title
- `addPeople.inviteMoreHeader`: "Bạn là người duy nhất trong cuộc họp" - Header when alone
- `addPeople.copyLink`: "Sao chép liên kết cuộc họp" - Copy link button
- `addPeople.shareLink`: "Chia sẻ đường dẫn để mời người khác tham dự cuộc họp" - Share link text

---

## Configuration Files Structure

### 2. **Config.js** - Main Jitsi Configuration
**Path:** `/workspace/jitsi-meet-cfg/web/config.js`

**Purpose:** Controls Jitsi Meet's core functionality and features.

**Key Settings:**
```javascript
config.defaultLanguage = 'vi';  // Force Vietnamese language
config.lang = 'vi';
config.requireDisplayName = false;
config.enableCalendarIntegration = false;

// JWT Authentication
config.enableUserRolesBasedOnToken = true;

// Moderator settings
config.conference = {
    firstUserIsModerator: true,
    enforceJwtModeratorRole: true
};
```

### 3. **Interface_config.js** - UI Configuration
**Path:** `/workspace/jitsi-meet-cfg/web/interface_config.js`

**Purpose:** Controls UI elements, buttons, and visual settings.

**Key Settings:**
```javascript
var interfaceConfig = {
    APP_NAME: 'Jitsi Meet',

    // Hide invite header when alone
    HIDE_INVITE_MORE_HEADER: false,  // Set to true to hide "Mời thêm người tham dự"

    // Language detection
    LANG_DETECTION: true,

    // Mobile app promotion
    MOBILE_APP_PROMO: true,

    // Welcome page
    DISPLAY_WELCOME_FOOTER: true,
    DISPLAY_WELCOME_PAGE_CONTENT: false
};
```

### 4. **Body.html** - Custom Scripts & Branding
**Path:** `/workspace/jitsi-meet-cfg/web/body.html`

**Purpose:** Contains custom JavaScript for:
- JWT authentication checks
- Text replacement for branding
- Custom translation overrides
- Dynamic UI modifications

**Key Features:**
```javascript
// Authentication redirect logic
if (isRoomPage && !hasJWT) {
    window.location.href = '/login?room=' + roomName;
}

// Custom translation override function
function overrideTranslations() {
    if (window.APP && window.APP.translation) {
        window.APP.translation.addLanguage('vi', {
            'dialog.kickTitle': 'Bạn được mời ra khỏi cuộc họp',
            // Add more custom translations here
        });
    }
}
```

---

## How to Modify the UI

### Option 1: Change Translation Text
Edit `/workspace/jitsi-meet-cfg/web/main-vi.json`:

```json
{
  "addPeople": {
    "inviteMorePrompt": "Your Custom Text Here",
    "title": "Custom Dialog Title"
  }
}
```

### Option 2: Hide the Invite Header
Edit `/workspace/jitsi-meet-cfg/web/interface_config.js`:

```javascript
var interfaceConfig = {
    HIDE_INVITE_MORE_HEADER: true  // Change to true to hide
};
```

### Option 3: Override Translations Dynamically
Edit `/workspace/jitsi-meet-cfg/web/body.html` and add to the `overrideTranslations()` function:

```javascript
function overrideTranslations() {
    if (window.APP && window.APP.translation) {
        window.APP.translation.addLanguage('vi', {
            'addPeople.inviteMorePrompt': 'Custom Invite Text',
            'addPeople.title': 'Custom Title'
        });
    } else {
        setTimeout(overrideTranslations, 500);
    }
}
```

---

## How to Add Custom Buttons with API Calls

### Method 1: Using body.html Custom Script

Add this code to `/workspace/jitsi-meet-cfg/web/body.html`:

```javascript
<script>
(function() {
    'use strict';

    // Wait for Jitsi API to be ready
    function addCustomButton() {
        if (window.APP && window.APP.UI) {
            try {
                // Create custom button
                const customButton = document.createElement('button');
                customButton.id = 'custom-invite-button';
                customButton.className = 'toolbox-button';
                customButton.textContent = 'Custom Action';
                customButton.style.cssText = `
                    padding: 10px 20px;
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    margin: 10px;
                `;

                // Add click handler with API call
                customButton.addEventListener('click', async function() {
                    console.log('Custom button clicked');

                    // Example: Call your custom API
                    try {
                        const response = await fetch('https://your-api.com/endpoint', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer YOUR_TOKEN'
                            },
                            body: JSON.stringify({
                                action: 'invite',
                                roomName: window.APP.conference.roomName,
                                participants: window.APP.conference.participants
                            })
                        });

                        const data = await response.json();
                        console.log('API Response:', data);

                        // Show notification to user
                        if (window.APP.UI.messageHandler) {
                            window.APP.UI.messageHandler.notify(
                                'Success',
                                'Invitation sent successfully!'
                            );
                        }
                    } catch (error) {
                        console.error('API Error:', error);
                        alert('Failed to send invitation: ' + error.message);
                    }
                });

                // Find toolbar and append button
                const toolbar = document.querySelector('.toolbox-content') ||
                               document.querySelector('.toolbar') ||
                               document.getElementById('new-toolbox');

                if (toolbar) {
                    toolbar.appendChild(customButton);
                    console.log('Custom button added successfully');
                } else {
                    setTimeout(addCustomButton, 500);
                }

            } catch (error) {
                console.error('Error adding custom button:', error);
            }
        } else {
            setTimeout(addCustomButton, 500);
        }
    }

    // Initialize when page loads
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', addCustomButton);
    } else {
        addCustomButton();
    }

    // Also try after window load
    window.addEventListener('load', function() {
        setTimeout(addCustomButton, 1000);
    });

})();
</script>
```

### Method 2: Modify Invite Dialog Behavior

Add a custom handler to intercept the invite dialog:

```javascript
<script>
(function() {
    'use strict';

    // Override invite functionality
    function customizeInviteDialog() {
        if (window.APP && window.APP.conference) {
            // Save original invite function
            const originalInvite = window.APP.conference.invite;

            // Override with custom behavior
            window.APP.conference.invite = function(invitees) {
                console.log('Custom invite triggered for:', invitees);

                // Call your custom API
                fetch('https://your-api.com/send-invites', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        roomName: window.APP.conference.roomName,
                        invitees: invitees,
                        inviter: window.APP.conference.localParticipant.name,
                        timestamp: new Date().toISOString()
                    })
                })
                .then(response => response.json())
                .then(data => {
                    console.log('Invite API response:', data);

                    // Call original function if needed
                    if (originalInvite) {
                        originalInvite.call(this, invitees);
                    }
                })
                .catch(error => {
                    console.error('Failed to send custom invite:', error);
                });
            };

            console.log('Invite dialog customized');
        } else {
            setTimeout(customizeInviteDialog, 500);
        }
    }

    customizeInviteDialog();
})();
</script>
```

### Method 3: Add Button to Invite Dialog Using MutationObserver

```javascript
<script>
(function() {
    'use strict';

    // Monitor for invite dialog appearance
    function monitorInviteDialog() {
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                mutation.addedNodes.forEach(function(node) {
                    // Check if this is the invite dialog
                    if (node.nodeType === 1 &&
                        (node.classList.contains('invite-dialog') ||
                         node.querySelector('[aria-label*="Mời"]') ||
                         node.querySelector('[aria-label*="invite"]'))) {

                        addCustomButtonToDialog(node);
                    }
                });
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    function addCustomButtonToDialog(dialog) {
        // Check if button already exists
        if (dialog.querySelector('#custom-api-button')) {
            return;
        }

        // Create custom button
        const customButton = document.createElement('button');
        customButton.id = 'custom-api-button';
        customButton.textContent = 'Send via API';
        customButton.className = 'custom-invite-button';
        customButton.style.cssText = `
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            font-weight: 500;
        `;

        // Add hover effect
        customButton.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#1976D2';
        });
        customButton.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '#2196F3';
        });

        // Add click handler
        customButton.addEventListener('click', async function(e) {
            e.preventDefault();

            // Get invite data from dialog
            const emailInput = dialog.querySelector('input[type="email"]') ||
                              dialog.querySelector('input[type="text"]');
            const inviteEmail = emailInput ? emailInput.value : '';

            console.log('Sending invite via API to:', inviteEmail);

            // Call your API
            try {
                const response = await fetch('https://your-api.com/invite', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer YOUR_API_TOKEN'
                    },
                    body: JSON.stringify({
                        email: inviteEmail,
                        roomName: window.location.pathname.replace('/', ''),
                        roomUrl: window.location.href,
                        inviterName: 'Current User',
                        timestamp: new Date().toISOString()
                    })
                });

                if (response.ok) {
                    const result = await response.json();
                    alert('Invitation sent successfully via API!');
                    console.log('API Result:', result);
                } else {
                    alert('Failed to send invitation via API');
                }
            } catch (error) {
                console.error('API Error:', error);
                alert('Error: ' + error.message);
            }
        });

        // Find a good place to insert the button
        const dialogContent = dialog.querySelector('.invite-dialog-content') ||
                             dialog.querySelector('.dialog-content') ||
                             dialog.querySelector('form') ||
                             dialog;

        if (dialogContent) {
            dialogContent.appendChild(customButton);
            console.log('Custom API button added to invite dialog');
        }
    }

    // Start monitoring
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', monitorInviteDialog);
    } else {
        monitorInviteDialog();
    }
})();
</script>
```

---

## Complete Example: Full Custom Invite Integration

Here's a complete example that combines everything:

```javascript
<script>
(function() {
    'use strict';

    const API_BASE_URL = 'https://your-api.com/api';
    const API_TOKEN = 'your-api-token-here';

    // Configuration
    const config = {
        enableCustomButton: true,
        enableAPILogging: true,
        autoSendInvites: false
    };

    // API Service
    const InviteAPI = {
        async sendInvite(inviteData) {
            try {
                const response = await fetch(`${API_BASE_URL}/invites`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${API_TOKEN}`
                    },
                    body: JSON.stringify(inviteData)
                });

                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }

                return await response.json();
            } catch (error) {
                console.error('InviteAPI Error:', error);
                throw error;
            }
        },

        async getInviteHistory(roomName) {
            try {
                const response = await fetch(`${API_BASE_URL}/invites/${roomName}`, {
                    headers: {
                        'Authorization': `Bearer ${API_TOKEN}`
                    }
                });
                return await response.json();
            } catch (error) {
                console.error('Failed to get invite history:', error);
                return [];
            }
        }
    };

    // UI Manager
    const UIManager = {
        showNotification(message, type = 'info') {
            if (window.APP && window.APP.UI && window.APP.UI.messageHandler) {
                window.APP.UI.messageHandler.notify(
                    type === 'error' ? 'Error' : 'Success',
                    message
                );
            } else {
                alert(message);
            }
        },

        createCustomButton() {
            const button = document.createElement('button');
            button.id = 'custom-invite-api-button';
            button.innerHTML = `
                <svg width="20" height="20" viewBox="0 0 24 24" fill="white">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                <span>Custom Invite</span>
            `;
            button.style.cssText = `
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 16px;
                background-color: #FF6B6B;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s;
            `;

            button.addEventListener('mouseenter', function() {
                this.style.backgroundColor = '#FF5252';
                this.style.transform = 'scale(1.05)';
            });

            button.addEventListener('mouseleave', function() {
                this.style.backgroundColor = '#FF6B6B';
                this.style.transform = 'scale(1)';
            });

            button.addEventListener('click', this.handleCustomInvite.bind(this));

            return button;
        },

        async handleCustomInvite() {
            const email = prompt('Enter email address to invite:');
            if (!email) return;

            const roomName = window.location.pathname.replace('/', '') || 'default-room';

            try {
                this.showNotification('Sending invitation...', 'info');

                const result = await InviteAPI.sendInvite({
                    email: email,
                    roomName: roomName,
                    roomUrl: window.location.href,
                    inviterName: window.APP?.conference?.getLocalDisplayName() || 'Guest',
                    timestamp: new Date().toISOString()
                });

                this.showNotification(`Invitation sent to ${email}!`, 'success');

                if (config.enableAPILogging) {
                    console.log('Invite sent successfully:', result);
                }
            } catch (error) {
                this.showNotification('Failed to send invitation', 'error');
                console.error('Invite error:', error);
            }
        }
    };

    // Initialize
    function initialize() {
        if (!window.APP || !document.querySelector('.toolbox-content')) {
            setTimeout(initialize, 500);
            return;
        }

        if (config.enableCustomButton) {
            const toolbar = document.querySelector('.toolbox-content');
            if (toolbar && !document.querySelector('#custom-invite-api-button')) {
                const button = UIManager.createCustomButton();
                toolbar.appendChild(button);
                console.log('✓ Custom invite button initialized');
            }
        }
    }

    // Start
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

    window.addEventListener('load', function() {
        setTimeout(initialize, 1000);
    });

})();
</script>
```

---

## File Structure Summary

```
/workspace/jitsi-meet-cfg/web/
├── main-vi.json              # Vietnamese translations (including "Mời thêm người tham dự")
├── config.js                 # Core Jitsi configuration
├── interface_config.js       # UI settings and button visibility
├── body.html                 # Custom scripts, authentication, branding
├── custom-branding.js        # Text replacement for branding
└── lang-vi-custom.js         # Custom Vietnamese translation overrides
```

---

## Deployment Steps

1. **Modify translations:** Edit `/workspace/jitsi-meet-cfg/web/main-vi.json`
2. **Add custom buttons:** Edit `/workspace/jitsi-meet-cfg/web/body.html`
3. **Update UI settings:** Edit `/workspace/jitsi-meet-cfg/web/interface_config.js`
4. **Restart Docker containers:**
   ```bash
   cd /workspace/jitsi-meet
   docker-compose down
   docker-compose up -d
   ```

---

## API Integration Best Practices

1. **Authentication:** Always use Bearer tokens or API keys
2. **Error Handling:** Implement try-catch blocks and user notifications
3. **Rate Limiting:** Consider rate limits when making API calls
4. **Logging:** Log API calls for debugging (only in development)
5. **Security:** Never expose API keys in client-side code (use environment variables)
6. **CORS:** Ensure your API server allows requests from your Jitsi domain

---

## Important Notes

⚠️ **This is a Docker deployment configuration repository**, not the Jitsi Meet source code.

- The actual React components are not in this repository
- UI customization is done through JavaScript injection in `body.html`
- Translation changes require container restart
- For deep customization, you need to modify the Jitsi Meet source code from [github.com/jitsi/jitsi-meet](https://github.com/jitsi/jitsi-meet)

---

## Support & References

- **Jitsi Meet Documentation:** https://jitsi.github.io/handbook/
- **Jitsi Meet API:** https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-iframe
- **Translation Files:** Located in `/workspace/jitsi-meet-cfg/web/main-vi.json`
- **Configuration Reference:** https://github.com/jitsi/docker-jitsi-meet

---

*Last Updated: 2025-10-21*
