#!/bin/bash
set -e

# ========== COLORS ==========
CYAN='\033[0;36m'
BLUE='\033[0;34m'
RESET='\033[0m'

# ========== BANNER ==========
figlet -f slant "CyberPunker" | lolcat
echo -e "${BLUE}--- Code by Muhammad MaLik ---${RESET}"
echo -e "${CYAN}Hack the System | Bug Bounty Recon Framework${RESET}"
echo

# ========== INPUT ==========
read -rp "Target Domain: " target
read -rp "Output Directory: " output

mkdir -p "$output"
cd "$output"

# ========== SUBDOMAIN ENUM ==========
echo "[+] Assetfinder"
assetfinder --subs-only "$target" | anew assetfinder.txt

echo "[+] Findomain"
findomain -t "$target" -u findomain.txt

echo "[+] Subfinder"
subfinder -d "$target" -all -silent -o subfinder.txt

echo "[+] crt.sh"
curl -s "https://crt.sh/?q=%25.$target&output=json" \
| jq -r '.[].name_value' \
| sed 's/\*\.//' \
| sort -u > crt.txt

# ========== MERGE ==========
cat *.txt | sort -u | anew uniq.txt
rm assetfinder.txt findomain.txt subfinder.txt crt.txt

# ========== LIVE HOSTS ==========
echo "[+] Probing live hosts"
httpx -l uniq.txt -silent -o alive.txt

# ========== SCREENSHOTS ==========
echo "[+] Taking screenshots"
gowitness scan file -f alive.txt
#eyewitness -f alive.txt -d screenshots --no-prompt

# ========== JS ENUM ==========
echo "[+] Finding JS files"
subjs -i alive.txt | anew js.txt

# ========== URL ENUM ==========
echo "[+] Wayback URLs"
cat alive.txt | waybackurls | anew wayback.txt

echo "[+] Katana"
katana -list alive.txt -silent -o katana.txt

cat wayback.txt katana.txt | sort -u | anew urls.txt
#grep "\.js$" urls.txt | anew js-urls.txt
rm wayback.txt katana.txt

# ========== GF PATTERNS ==========
mkdir gf-patterns
cd gf-patterns

gf xss ../urls.txt | anew xss.txt
gf sqli ../urls.txt | anew sqli.txt
gf lfi ../urls.txt | anew lfi.txt
gf ssrf ../urls.txt | anew ssrf.txt
gf redirect ../urls.txt | anew redirect.txt
gf idor ../urls.txt | anew idor.txt
gf rce ../urls.txt | anew rce.txt
gf ssti ../urls.txt | anew ssti.txt
gf secrets ../urls.txt | anew secrets.txt

cd ..

# ========== QUICK CHECKS ==========
echo "[+] LFI check"
cat gf-patterns/lfi.txt \
| qsreplace "/etc/passwd" \
| xargs -I% -P 20 sh -c 'curl -s "%" | grep -q "root:x" && echo "VULN %"' \
| tee lfi-vuln.txt

echo "[+] Open Redirect check"
cat gf-patterns/redirect.txt \
| qsreplace "https://google.com" \
| xargs -I% -P 20 sh -c 'curl -Is "%" | grep -q "Location: https://google.com" && echo "VULN %"' \
| tee redirect-vuln.txt

# ========== SUBDOMAIN TAKEOVER ==========
echo "[+] Subdomain Takeover"
subzy run --targets uniq.txt --timeout 30 --output subtakeover.txt

# ========== IP ENUM ==========
mkdir IP && cd IP
httpx -l ../uniq.txt -ip -silent -o hosts-ip.txt
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' hosts-ip.txt | sort -u > ips.txt

httpx -l ips.txt -silent -o ip-alive.txt
gowitness scan file -f ip-alive.txt --screenshot-path ip-screens
#eyewitness -f ip-alive.txt -d ip-screens

# ========== NMAP ==========
nmap -sT -Pn -sC -iL ips.txt -oX scan.xml
xsltproc scan.xml -o scan.html

cd ..
<<comment
# ========== 🔥 NUCLEI ==========
echo "[+] Running Nuclei"
nuclei -l alive.txt \
  -severity critical,high,medium \
  -o nuclei.txt
comment
echo
figlet DONE | lolcat
echo "Recon complete 🚀 Results saved in $output"

