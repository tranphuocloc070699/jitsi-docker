local log = module._log;
local is_admin = require "core.usermanager".is_admin;

local function is_healthcheck_room(room_jid)
    return room_jid:find("health%.") ~= nil;
end

module:hook("muc-occupant-pre-join", function (event)
    local room, stanza = event.room, event.stanza;
    local session = event.origin;
    
    if is_healthcheck_room(room.jid) then
        return;
    end
    
    local user_jid = stanza.attr.from;
    if is_admin(user_jid, module.host) then
        return;
    end
    
    if not session.auth_token then
        return;
    end
    
    local user = session.jitsi_meet_context_user;
    if not user then
        return;
    end
    
    local affiliation = "member";
    if user.moderator == true or user.moderator == "true" then
        affiliation = "owner";
    elseif user.affiliation == "owner" then
        affiliation = "owner";
    end
    
    local bare_jid = stanza.attr.from:match("^[^/]+");
    room:set_affiliation(true, bare_jid, affiliation);
    
    log("info", "Set affiliation '%s' for %s (moderator=%s)", affiliation, bare_jid, tostring(user.moderator));
end, 10);
