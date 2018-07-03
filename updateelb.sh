#!/bin/bash
aws elb describe-load-balancers | grep LoadBalancerName | awk '{print $2}' | cut -d ',' -f 1 | cut -d '"' -f 2 > elb.txt
while read LINE; do aws elb modify-load-balancer-attributes --load-balancer-name "$LINE" --load-balancer-attributes "{\"ConnectionSettings\":{\"IdleTimeout\":180}}"; done < elb.txt
