#!/bin/sh
token='ID,Token'
domain=${1:-'css.js.cn'}
sub_domain=${2:-'c'}
new_ip=${3:-$(curl -s 'http://ip.taobao.com/service/getIpInfo2.php?ip=myip' | sed 's/.*"ip":"\([0-9.]*\)".*/\1/')}

api_call() {
	local param="login_token=${token}&format=json&domain=${domain}&${2}"
	curl -s -k -XPOST -o- -A'shdns/0.1(php@html.js.cn)' -d $param https://dnsapi.cn/${1}
}

api_error() {
	local key='"code":"1",'
	[ "${1#*$key}" = "$1" ] && {
		echo "error: $2"
		echo $1
		exit 1
	}
}

(echo "$new_ip" | grep -Eq "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$") || {
	echo "Invalid IP: ${new_ip}"
	exit 1
}
record=$(api_call "Record.List" "sub_domain=${sub_domain}")
api_error "$record" "Unable to find the record."
old_ip=$(echo "$record" | sed 's/.*"value":"\([0-9.]*\)".*/\1/')
[ "$old_ip" = "$new_ip" ] && {
	echo "Record(${new_ip}) not changed. Skipped."
	exit 0
}
echo "Changing A record(${sub_domain}.${domain}) from ${old_ip} to ${new_ip} ..."
record_id=$(echo "$record" | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
result=$(api_call "Record.Ddns" "record_id=${record_id}&sub_domain=${sub_domain}&record_type=A&value=${new_ip}&record_line=%E9%BB%98%E8%AE%A4")
api_error "$result" "Failed to update recode."
