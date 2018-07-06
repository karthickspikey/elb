#!/bin/bash
aws elb describe-load-balancers | grep LoadBalancerName | awk '{print $2}' | cut -d ',' -f 1 | cut -d '"' -f 2 > fullelb.txt
grep "private-" fullelb.txt > editelb.txt && grep "LB-HLXDEV1APIGW-" fullelb.txt >> editelb.txt
while read LINE; do aws elb modify-load-balancer-attributes --load-balancer-name "$LINE" --load-balancer-attributes "{\"ConnectionSettings\":{\"IdleTimeout\":180}}"; done < editelb.txt
