#!/bin/bash

echo "Ai fost furculitat ! "

verify_host() {
    local name="$1"
    local ip="$2"
    local dns_server="$3"

    if [ -n "$name" ]; then
        local real_ip
        real_ip=$(nslookup "$name" "$dns_server" 2>/dev/null | awk '/^Address: / { print $2 }' | tail -n1)

        if [ -n "$real_ip" ] && [ "$real_ip" != "$ip" ]; then
            echo "Bogus IP for $name in /etc/hosts (detectat prin DNS $dns_server)!"
        fi
    fi
}

cat /etc/hosts | while read -r ip name; do
    [[ -z "$ip" || "$ip" =~ ^# || "$ip" =~ : ]] && continue
    [[ "$name" == "localhost" || "$ip" == "127.0.0.1" ]] && continue

    verify_host "$name" "$ip" "8.8.8.8"
done
