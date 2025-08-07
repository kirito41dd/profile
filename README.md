# profile
Store commonly used configuration files / 存放常用配置文件



### nushell
```nushell
mkdir $nu.user-autoload-dirs.0;  http get https://raw.githubusercontent.com/kirito41dd/profile/refs/heads/master/k.autoload.nu | save -fr ($nu.user-autoload-dirs.0)/k.autoload.nu
```

### vimrc

```bash
curl -LO https://raw.githubusercontent.com/zshorz/profile/master/vimrc
mv vimrc ~/.vimrc
```



