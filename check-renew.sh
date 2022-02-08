#!/bin/bash

certbot certificates 2>/dev/null | grep 'Certificate Name:' | awk {'print $3'} | while read domain; 

do 
    getExpiryDate="$(openssl x509 -enddate -noout -in /etc/letsencrypt/live/${domain}/cert.pem)"
    fullExpiryDate=${getExpiryDate##notAfter=}
    expiryDate={$fullExpiryDate##*}

    if [ $(date -d "${fullExpiryDate}" +%s) -lt $(TZ=${expiryDate} date -d "now + 97 days" +%s) ]
        then
        certbot renew --dry-run 2>/dev/null
    fi

done
