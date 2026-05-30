# The-Reconnaissance-Fabricator
================================================================================
        The Reconnaissance Fabricator - Bug Bounty Recon Framework
                     Code by Muhammad Malik
================================================================================

DESCRIPTION
-----------
Reconnaissance Fabricator is an automated reconnaissance framework designed for bug bounty
hunters and penetration testers. It streamlines the entire recon workflow for
a given target domain — from subdomain enumeration and live host detection to
URL crawling, vulnerability pattern matching, subdomain takeover checks, IP
scanning, and screenshot capturing. Results are neatly organized into categorized
output files for easy review and further exploitation.


--------------------------------------------------------------------------------
WORKFLOW OVERVIEW
-----------------
  1. Subdomain Enumeration     — Discovers subdomains via multiple sources
  2. Live Host Detection        — Filters alive hosts using HTTP probing
  3. Screenshot Capture         — Takes visual screenshots of live hosts
  4. JS File Discovery          — Collects JavaScript files for analysis
  5. URL Enumeration            — Gathers URLs from Wayback Machine & crawling
  6. GF Pattern Matching        — Categorizes URLs by vulnerability type
  7. Quick Vulnerability Checks — Auto-tests for LFI and Open Redirects
  8. Subdomain Takeover Check   — Identifies dangling subdomain records
  9. IP Enumeration & Scanning  — Resolves IPs and performs port scanning
 10. Nmap Scan + HTML Report    — Generates a visual Nmap scan report


--------------------------------------------------------------------------------
SYSTEM REQUIREMENTS
-------------------
  - Operating System : Linux (Debian/Ubuntu or Arch-based recommended)
  - Shell            : Bash (v4.0 or higher)
  - Internet Access  : Required (for crt.sh API and live scanning)
  - Permissions      : Standard user (root not required, but recommended
                       for full Nmap functionality)


--------------------------------------------------------------------------------
REQUIRED TOOLS — MUST BE INSTALLED BEFORE RUNNING
--------------------------------------------------

  UTILITY / DISPLAY
  -----------------
  figlet          — ASCII art banner generator
                    Install: sudo apt install figlet
  lolcat          — Colorizes terminal output
                    Install: sudo apt install lolcat
  jq              — JSON parser (used for crt.sh output)
                    Install: sudo apt install jq
  curl            — HTTP requests
                    Install: sudo apt install curl
  xsltproc        — Converts Nmap XML report to HTML
                    Install: sudo apt install xsltproc
  nmap            — Network/port scanner
                    Install: sudo apt install nmap
  anew            — Appends unique lines to files (by tomnomnom)
                    Install: go install github.com/tomnomnom/anew@latest
  qsreplace       — Replaces query string values (by tomnomnom)
                    Install: go install github.com/tomnomnom/qsreplace@latest

  SUBDOMAIN ENUMERATION
  ---------------------
  assetfinder     — Finds domains and subdomains (by tomnomnom)
                    Install: go install github.com/tomnomnom/assetfinder@latest
  findomain       — Fast subdomain enumeration tool
                    Install: https://github.com/Findomain/Findomain/releases
  subfinder       — Passive subdomain discovery (by ProjectDiscovery)
                    Install: go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

  LIVE HOST DETECTION
  -------------------
  httpx           — Fast HTTP probing tool (by ProjectDiscovery)
                    Install: go install github.com/projectdiscovery/httpx/cmd/httpx@latest

  SCREENSHOT CAPTURE
  ------------------
  gowitness       — Web screenshot utility using Chrome headless
                    Install: go install github.com/sensepost/gowitness@latest
                    Note: Requires Google Chrome or Chromium installed

  JS FILE DISCOVERY
  -----------------
  subjs           — Fetches JavaScript files from hosts (by lc)
                    Install: go install github.com/lc/subjs@latest

  URL ENUMERATION
  ---------------
  waybackurls     — Fetches URLs from Wayback Machine (by tomnomnom)
                    Install: go install github.com/tomnomnom/waybackurls@latest
  katana          — Next-gen web crawling framework (by ProjectDiscovery)
                    Install: go install github.com/projectdiscovery/katana/cmd/katana@latest

  VULNERABILITY PATTERN MATCHING
  -------------------------------
  gf              — Grep patterns for security findings (by tomnomnom)
                    Install: go install github.com/tomnomnom/gf@latest
                    Patterns: https://github.com/1ndianl33t/Gf-Patterns
                    Required patterns: xss, sqli, lfi, ssrf, redirect,
                                       idor, rce, ssti, secrets

  SUBDOMAIN TAKEOVER
  ------------------
  subzy           — Subdomain takeover checker
                    Install: go install github.com/PentestPad/subzy@latest


--------------------------------------------------------------------------------
PRE-RUN CHECKLIST
-----------------
  [ ] Go is installed and $GOPATH/bin is added to $PATH
  [ ] All tools listed above are installed and accessible via terminal
  [ ] gf patterns are placed in ~/.gf/ directory
  [ ] Google Chrome or Chromium is installed (for gowitness)
  [ ] Internet connection is active
  [ ] You have permission to test the target domain (authorized scope only)


--------------------------------------------------------------------------------
HOW TO RUN
----------
  1. Give execute permission:
        chmod +x recon.sh

  2. Run the script:
        ./recon.sh

  3. Enter the target domain when prompted:
        Target Domain: example.com

  4. Enter the output directory name when prompted:
        Output Directory: example-recon


--------------------------------------------------------------------------------
OUTPUT STRUCTURE
----------------
  <output-dir>/
  ├── uniq.txt              — All unique subdomains (merged & deduplicated)
  ├── alive.txt             — Live/reachable hosts
  ├── js.txt                — Discovered JavaScript files
  ├── urls.txt              — All crawled/archived URLs
  ├── lfi-vuln.txt          — Confirmed LFI vulnerable URLs
  ├── redirect-vuln.txt     — Confirmed Open Redirect vulnerable URLs
  ├── subtakeover.txt       — Subdomain takeover candidates
  ├── gf-patterns/
  │   ├── xss.txt           — XSS candidate URLs
  │   ├── sqli.txt          — SQLi candidate URLs
  │   ├── lfi.txt           — LFI candidate URLs
  │   ├── ssrf.txt          — SSRF candidate URLs
  │   ├── redirect.txt      — Open Redirect candidate URLs
  │   ├── idor.txt          — IDOR candidate URLs
  │   ├── rce.txt           — RCE candidate URLs
  │   ├── ssti.txt          — SSTI candidate URLs
  │   └── secrets.txt       — Potential secrets in URLs
  └── IP/
      ├── hosts-ip.txt      — Hosts with resolved IPs
      ├── ips.txt           — Unique IP addresses
      ├── ip-alive.txt      — Live IPs
      ├── ip-screens/       — Screenshots of live IPs
      ├── scan.xml          — Nmap raw XML output
      └── scan.html         — Nmap scan report (HTML, browser-viewable)


--------------------------------------------------------------------------------
LEGAL DISCLAIMER
----------------
  This tool is intended for authorized security testing and bug bounty programs
  ONLY. Unauthorized use against systems you do not have explicit permission to
  test is illegal and unethical. The authors are not responsible for any misuse
  or damage caused by this tool. Always obtain written permission before testing.


================================================================================
                            Happy Hunting! 🚀
================================================================================

