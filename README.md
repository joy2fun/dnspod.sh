# dnspod.sh

通过命令行更新DNSPod域名的解析记录，实现动态域名DNS。

 - 兼容Windows的Git bash环境
 - 仅支持API Token调用

The script is inspired by https://github.com/anrip/ArDNSPod

# 使用方法

使用之前先编辑 `dnspod.sh` ，将第2行的 `ID,Token` 替换为自己的。

```sh
$ ./dnspod.sh {domain} {sub_domain} [IP]
```

## 参数说明

 - {domain}是顶级域名，{sub_domain}是二级域名
 - 如果需要更新顶级域名，{sub_domain}填写 `@`
 - [IP]如果为空，默认会使用 https://httpbin.org/get 获取本机公网IP

