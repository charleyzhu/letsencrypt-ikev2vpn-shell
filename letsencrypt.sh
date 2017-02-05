#! /bin/bash

#！！本脚本只支持CentOS6和7！！

function __debug() {
  echo "[`date`][DEBUG] $1 "
}

# __debug "## 升级操作系统最新版本..."
# yum update

# __debug "## 安装acme.sh..."
# cd ~
# wget https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh
# source acme.sh --install --debug
# source ~/.bashrc

__debug "## 初始化脚本变量"
#设置域名 adusir.net
domain_base="domain.com"
#证书路径
domain_param=" -d $domain_base \
     -d www.$domain_base \"
cert_dir="/etc/my_ssl_cert_rep"
key_file=$cert_dir/key.pem
ca_file=$cert_dir/ca.pem    
cert_file=$cert_dir/cert.pem
fullchain_file=$cert_dir/fullchain.pem

aliyum_api_key="LTAIFKSyg4z9Rbro invalid key you know that"
aliyum_api_sec="I8ZD9aEM9GAn5Z5dBFLuykJq2X6Ng4 invalid secrit you know that"

__debug "## 使用acme.sh给域名颁布数字证书(使用dns的方式)...."
export Ali_Key=${aliyum_api_key}
export Ali_Secret=${aliyum_api_sec}
acme.sh --debug --issue $domain_param --dns dns_ali

__debug "## 给应用服务器安装数字证书..."
if [ ! -d $cert_dir ]; then
  mkdir $cert_dir
fi

acme.sh --debug --installcert -d $domain_base  \
        --keypath  $key_file \
        --capath   $ca_file \
        --certpath  $cert_file \
        --fullchainpath $fullchain_file \
        --reloadcmd  "echo test"  
__debug "## 应用服务器数字证书安装完毕！"
