Roboo - HTTP Robot Mitigator
Copyright (C) 2011 Yuri Gushin, Alex Behar


Overview
========
Roboo uses advanced non-interactive HTTP challenge/response mechanisms to detect and subsequently mitigate HTTP robots.

It integrates with Nginx web server and reverse proxy as an embedded perl module, quickly and easily!


Functionality
=============
Roboo will respond to each request from an unverified source, before the request reaches the protected server/proxy,
triggering the source to re-issue the original request along with a special HTTP Cookie, that would have only been
set by a real browser with full HTTP, HTML, Javascript and Flash player stacks.

It uses a positive security model where all allowed robotic activity must be whitelisted, any other clients are 
verified using the challenge/response mechanisms prior to proxying them to the protected endpoint(s).

Such deep level of verification weeds out the larger percentage of HTTP robots which do not use real browsers
or implement full browser stacks, resulting in the mitigation of various web threats:
    - HTTP Denial of Service tools - e.g. Low Orbit Ion Cannon 
    - Vulnerability Scanning - e.g. Acunetix Web Vulnerability Scanner, Metasploit Pro, Nessus
    - Web exploits
    - Spiders, Crawlers and other robotic evil

Integrating as an Nginx module - Roboo can be used along with the caching, balancing and other features Nginx offers.

For more information, refer to the "Building Floodgates: Cutting-Edge Denial of Service Mitigation" presentation from
Black Hat Europe 2011.


Configuration
=============
The following parameters may be configured to control the module:

    Roboo_challenge_modes   -   "SWF,gzip":
        - "JS" or "SWF" for pure Javascript-based challenge or flash + javascript challenge.  If Roboo is used behind a
        site with flash content - it is advised on using this verification type for maximum security.
        - ",gzip" to enable gzip compression of the chosen challenge type
    
    Roboo_cookie_name       -   "Anti-Robot"
        - The name of the HTTP cookie to contain the challenge/response key

    Roboo_validity_window   -   600
        - Validity window in seconds for the challenge/response key - when expired, client will be re-challenged
        - When set to zero - the validity per authenticated host will persist until Roboo is restarted
    
    Roboo_whitelist         -   "UA('Googlebot'),IP(127.0.0.0/8),URI('^/ajax/')"
        - UA('pcre_string') and URI('pcre_string') syntax whitelists a user-agent or URI string using PCRE
        - IP(0.0.0.0/0) syntax whitelists a CIDR network

    Roboo_charset           -   "UTF-8"
        - The character set to use during the challenge - so POST challenges that resubmit data use the correct encoding

    (Advanced)  Roboo_challenge_hash_input  -   $remote_addr (client IP address)
        - Sets the input to the challenge hash function producing the key - the default should be fine for most
        environments, if deeper verification resolution is desired more variables can be added.  For example, changing 
        it to "$remote_addr$http_user_agent" ensures a different challenge key is generated for every IP address +
        User-Agent, meaning different clients behind a NAT will be challenged and verified with different keys.

    (Advanced)  Roboo_secret    - "<RANDOM STRING>"
        - The secret is used for the challenge key computation and is by default regenerated on every Roboo (Nginx)
        invocation.
        - It is possible to specify the secret as part of the configuration - use only when required, as setting this
        value statically reduces the strength of the challenge key.
        - Use case - when multiple Roboo servers are being used behind a load-balancer without persistence set up -
        since each server produces a unique challenge key - the host will need to reauthenticate every time it reaches a
        different server.
        Setting this value identically across an array of such Roboo servers will result in the generation of identical
        keys and eliminate the key mismatch problems.
        In order for multiple Roboo servers to produce the same challenge key, the following conditions must be met
        across all servers:
            - Roboo secret value - use the same long random string as input
                * Change & synchronize the secret periodically (e.g. with cronjob)
            - System time & validity window - ensure time is synchronized and the same Roboo_validity_window is configured
            - Perl environment - ensure the same RANDBITS value was compiled into perl
                * Verify by running: perl -MConfig -e 'print "$Config{randbits}\n";'


Installation
============
Roboo was tested with the stable branch of Nginx - version 1.0.0, compiled with perl, proxy and rewrite modules.

It requires the following Perl modules to be installed:
    Crypt::Random
    Math::Pari
    Net::IP::Match::Regexp

To install, copy Roboo.pm and configure Nginx as per the provided example configuration file and instructions above.


Contact
=======
The authors can be contacted at:
    Yuri Gushin - yuri@ecl-labs.org
    Alex Behar  - alex@ecl-labs.org

