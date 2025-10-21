admins = {
    
    "jigasi@auth.meeting.gamesrcs.com",
    

    
    "jibri@auth.meeting.gamesrcs.com",
    

    "focus@auth.meeting.gamesrcs.com",
    "jvb@auth.meeting.gamesrcs.com"
}

unlimited_jids = {
    "focus@auth.meeting.gamesrcs.com",
    "jvb@auth.meeting.gamesrcs.com"
}

plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom", "/prosody-plugins-contrib" }

muc_mapper_domain_base = "meeting.gamesrcs.com";
muc_mapper_domain_prefix = "muc";

recorder_prefixes = { "recorder@hidden.meet.jitsi" };

http_default_host = "meeting.gamesrcs.com"


asap_accepted_issuers = { "jitsi_app" }



asap_accepted_audiences = { "jitsi_app" }


consider_bosh_secure = true;
consider_websocket_secure = true;


smacks_max_unacked_stanzas = 5;
smacks_hibernation_time = 60;
smacks_max_old_sessions = 1;




VirtualHost "meeting.gamesrcs.com"

  
  authentication = "token"
    app_id = "jitsi_app"
    
    app_secret = "39RQlnugivCvauYQ9WXgJTwZqKJQ5O4uPXeuxs9y8RC9lIj7qu3NLqZAE+rMzxXm"
    
    allow_empty_token = false
    
    enable_domain_verification = false
  

    ssl = {
        key = "/config/certs/meeting.gamesrcs.com.key";
        certificate = "/config/certs/meeting.gamesrcs.com.crt";
    }
    modules_enabled = {
        "bosh";
        
        "websocket";
        "smacks"; -- XEP-0198: Stream Management
        
        "speakerstats";
        "conference_duration";
        "room_metadata";
        
        "end_conference";
        
        
        
        "muc_breakout_rooms";
        
        
        "av_moderation";
        
        
        
        
        

    }

    main_muc = "muc.meeting.gamesrcs.com"
    room_metadata_component = "metadata.meeting.gamesrcs.com"
    

    

    
    breakout_rooms_muc = "breakout.meeting.gamesrcs.com"
    

    speakerstats_component = "speakerstats.meeting.gamesrcs.com"
    conference_duration_component = "conferenceduration.meeting.gamesrcs.com"

    
    end_conference_component = "endconference.meeting.gamesrcs.com"
    

    
    av_moderation_component = "avmoderation.meeting.gamesrcs.com"
    

    c2s_require_encryption = true

    

    
VirtualHost "guest.meeting.gamesrcs.com"
    authentication = "jitsi-anonymous"
    modules_enabled = {
        
        "smacks"; -- XEP-0198: Stream Management
        
    }

    c2s_require_encryption = true
    



VirtualHost "auth.meeting.gamesrcs.com"
    ssl = {
        key = "/config/certs/auth.meeting.gamesrcs.com.key";
        certificate = "/config/certs/auth.meeting.gamesrcs.com.crt";
    }
    modules_enabled = {
        "limits_exception";
        "smacks";
    }
    authentication = "internal_hashed"
    smacks_hibernation_time = 15;



Component "internal-muc.meeting.gamesrcs.com" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_hide_all";
        "muc_filter_access";
        }
    restrict_room_creation = true
    muc_filter_whitelist="auth.meeting.gamesrcs.com"
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_room_cache_size = 1000
    muc_tombstones = false
    muc_room_allow_persistent = false

Component "muc.meeting.gamesrcs.com" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "token_affiliation";
        "token_verification";
        
        "polls";
        "muc_domain_mapper";
        
        "muc_password_whitelist";
    }

    -- The size of the cache that saves state for IP addresses
    rate_limit_cache_size = 10000;

    muc_room_cache_size = 10000
    muc_room_locking = false
    muc_room_default_public_jids = true
    
    muc_password_whitelist = {
        "focus@auth.meeting.gamesrcs.com";
    }
    muc_tombstones = false
    muc_room_allow_persistent = false

Component "focus.meeting.gamesrcs.com" "client_proxy"
    target_address = "focus@auth.meeting.gamesrcs.com"

Component "speakerstats.meeting.gamesrcs.com" "speakerstats_component"
    muc_component = "muc.meeting.gamesrcs.com"

Component "conferenceduration.meeting.gamesrcs.com" "conference_duration_component"
    muc_component = "muc.meeting.gamesrcs.com"


Component "endconference.meeting.gamesrcs.com" "end_conference"
    muc_component = "muc.meeting.gamesrcs.com"



Component "avmoderation.meeting.gamesrcs.com" "av_moderation_component"
    muc_component = "muc.meeting.gamesrcs.com"





Component "breakout.meeting.gamesrcs.com" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_cache_size = 10000
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_tombstones = false
    muc_room_allow_persistent = false
    modules_enabled = {
        "muc_meeting_id";
        "polls";
        }


Component "metadata.meeting.gamesrcs.com" "room_metadata_component"
    muc_component = "muc.meeting.gamesrcs.com"
    breakout_rooms_component = "breakout.meeting.gamesrcs.com"



