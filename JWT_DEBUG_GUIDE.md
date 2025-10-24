# JWT Validation Debug Guide

## ✅ Configuration Verified

Your JWT configuration is correct:
```
JWT_APP_ID: jitsi_app
JWT_APP_SECRET: 39RQlnugivCvauYQ9WXgJTwZqKJQ5O4uPXeuxs9y8RC9lIj7qu3NLqZAE+rMzxXm
JWT_ACCEPTED_ISSUERS: jitsi_app
JWT_ACCEPTED_AUDIENCES: jitsi_app
```

## 🔧 Changes Made

### 1. Fixed Signature Encoding (Lines 189-261 in body.html)
**Problem:** The original code used `String.fromCharCode.apply()` which could corrupt binary data.

**Solution:** Created separate functions for encoding strings vs byte arrays:
- `base64UrlEncodeString()` - For JSON strings (header/payload)
- `base64UrlEncodeBytes()` - For binary signature data

### 2. Added Debug Logging
When you click "Copy Link", check the browser console (F12) for:
```
🔑 JWT Debug Info:
  Header: {"alg":"HS256","typ":"JWT"}
  Payload: { ... }
  Secret length: 64
  Encoded header: eyJhbGc...
  Encoded payload: eyJjb250...
  Signature (first 20 chars): a1b2c3d4e5f6g7h8i9j0...
  Full JWT (first 50 chars): eyJhbGc...
```

## 🧪 Testing Steps

### Step 1: Test JWT Generation Locally
1. Open `/workspace/test-jwt.html` in a browser
2. Click "Generate JWT" button
3. Check the output - it should show:
   - JWT Token
   - Decoded header
   - Decoded payload
   - Signature
   - Configuration details

### Step 2: Verify JWT Structure
A valid JWT should have 3 parts separated by dots:
```
eyJhbGc...  .  eyJjb250...  .  a1b2c3...
  ↑             ↑              ↑
Header        Payload       Signature
```

### Step 3: Check Server Logs
```bash
cd /workspace/jitsi-meet
docker compose logs prosody | grep -i jwt
docker compose logs jicofo | grep -i jwt
```

Look for errors like:
- ❌ "JWT validation failed"
- ❌ "Invalid signature"
- ❌ "Token expired"
- ❌ "Invalid issuer"

### Step 4: Common JWT Validation Issues

#### Issue 1: Clock Skew
**Symptom:** "Token not valid yet" or "Token expired"

**Solution:** Check timestamps in test output:
```
Issued (nbf): 2025-10-21T10:00:00Z
Expires (exp): 2025-10-22T10:00:00Z
Current Time: 2025-10-21T10:00:10Z
```

Our code sets:
- `nbf`: current time - 10 seconds (allows clock skew)
- `exp`: current time + 24 hours

#### Issue 2: Wrong Issuer/Audience
**Symptom:** "Invalid issuer" or "Invalid audience"

**Check payload:**
```json
{
  "aud": "jitsi_app",  // Must match JWT_ACCEPTED_AUDIENCES
  "iss": "jitsi_app",  // Must match JWT_ACCEPTED_ISSUERS
  "sub": "meeting.gamesrcs.com"
}
```

#### Issue 3: Room Name Mismatch
**Symptom:** "Room not allowed"

**Check payload:**
```json
{
  "room": "your-room-name"  // Must match the room in URL
}
```

The room name is extracted from URL pathname.

#### Issue 4: Invalid Signature
**Symptom:** "Signature verification failed"

**Causes:**
1. Secret mismatch (check .env file)
2. Wrong encoding (FIXED in this update)
3. Character encoding issues (FIXED with UTF-8 safe encoding)

## 🔍 Manual JWT Verification

Use this Node.js script to verify the JWT server-side:

```javascript
const jwt = require('jsonwebtoken');

const token = 'YOUR_JWT_TOKEN_HERE';
const secret = '39RQlnugivCvauYQ9WXgJTwZqKJQ5O4uPXeuxs9y8RC9lIj7qu3NLqZAE+rMzxXm';

try {
  const decoded = jwt.verify(token, secret);
  console.log('✅ Valid JWT:', decoded);
} catch (error) {
  console.error('❌ Invalid JWT:', error.message);
}
```

Or use online tools:
- https://jwt.io/ (Paste your token and secret to verify)

## 📋 Checklist

- [ ] JWT_APP_SECRET matches in .env and body.html
- [ ] JWT_APP_ID is "jitsi_app" in both places
- [ ] Domain is "meeting.gamesrcs.com"
- [ ] Token has 3 parts (header.payload.signature)
- [ ] Token can be decoded at jwt.io
- [ ] Timestamps are valid (nbf < now < exp)
- [ ] Room name in token matches URL
- [ ] Prosody/Jicofo containers are running
- [ ] No errors in docker logs

## 🚀 Quick Fix Commands

```bash
# Restart containers
cd /workspace/jitsi-meet
docker compose down
docker compose up -d

# Check container status
docker compose ps

# View logs
docker compose logs prosody | tail -50
docker compose logs jicofo | tail -50

# Test without JWT first
curl -I https://meeting.gamesrcs.com/test-room

# Clear browser cache
# Press Ctrl+Shift+Delete, clear "Cached images and files"
```

## 📞 What to Check Next

1. Open browser console (F12) when copying link
2. Look for the JWT debug output
3. Copy the full JWT token
4. Paste it into https://jwt.io/
5. Enter the secret: `39RQlnugivCvauYQ9WXgJTwZqKJQ5O4uPXeuxs9y8RC9lIj7qu3NLqZAE+rMzxXm`
6. Check if "Signature Verified" appears
7. Share the error message from jwt.io if signature fails

## 🔐 Security Note

The JWT secret is currently hardcoded. For production:
1. Move to environment variables
2. Use a different secret for production
3. Rotate secrets periodically
