# 把现有的证书迁移到match

match 官方文档推荐我们首先把所有的已有证书删除，已经上线的项目不太可能这样做，这个时候就需要手动加密

```

# 手动加密，把证书导出cer和p12，把mp文件
# cer文件用 cert_id_query.rb 查询id 并命名
# mp文件用 bundle_id 命名
# 放在origins文件夹里面，如下

origins
├── certs
│   ├── development
│   │   ├── foobar123.cer
│   │   └── foobar123.p12
│   └── distribution
│       ├── barfoo321.cer
│       └── barfoo321.p12
└── profiles
    ├── development
    │   └── com.foo.bar.mobileprovision
    └── enterprise
        └── com.foo.bar.mobileprovision


# 准备完毕
$ ruby encrypt_all.rb
# 会生成加密后的 certs 和 profiles 文件夹

```

# 参考

* [docs.fastlane.tools](https://docs.fastlane.tools/actions/match/#match)
* [iOS 用fastlane进行团队证书管理](https://www.jianshu.com/p/e9f403fa453d)
* [fastlane match 源码浅析与最佳实践](http://www.saitjr.com/ios/fastlane-match-best-practice.html)
* [Simplify your life with fastlane match](http://macoscope.com/blog/simplify-your-life-with-fastlane-match/)
