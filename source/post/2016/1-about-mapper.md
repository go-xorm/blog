```ini
title = 关于XORM中Mapper的使用
date = 2016-01-04 13:08:00
tags = go,golang,xorm,orm,sql,database
```
XORM中的Mapper是一个接口机制，专门用来在程序名称和数据库名称之间进行转换。XORM库中带有三种Mapper的实现，SnakeMapper, SameMapper 以及 GonicMapper。同时为了方便还提供了CacheMapper, PrefixMapper 以及 SuffixMapper，这几种Mapper可以和前面的组合使用。

# SnakeMapper

SnakeMapper是默认的映射机制，他支持数据库表采用匈牙利命名法，而程序中采用驼峰式命名法。下面是一些常见的映射：

表中名称   | 程序名称   
----------|----------
user_info | UserInfo
id        | Id       

# SameMapper

SameMapper就是数据库中的命名法和程序中是相同的。那么鉴于在Go中，基本上要求首字母必须大写。所以一般都是表中和程序中均采用驼峰式命名。下面是一些常见的映射：

表中名称   | 程序名称   
----------|----------
UserInfo  | UserInfo
Id        | Id       

# GonicMapper

GonicMapper是在SnakeMapper的基础上增加了特例，对于常见的缩写不新增下划线处理。这个同时也符合golint的规则。下面是一些常见的映射：

表中名称   | 程序名称   
----------|----------
user_info | UserInfo
id        | ID       
url        | URL     

# CacheMapper

CacheMapper 通过使用一个map来将已经映射过的内容保存起来，下次直接查找即可获得。

# PrefixMapper

PrefixMapper 前缀映射可以组合SnakeMapper, SameMapper或者GonicMapper来在表名或者字段名的映射完成后，再新增一个固定的前缀。比如和SnakeMapper组合：

```Go
engine.SetTableMapper(core.NewPrefixMapper(core.SnakeMapper{}, "tb_"))
engine.SetColumnMapper(core.SnakeMapper{})
```

那么对于结构体`User`，数据库中对应的表名即为`tb_user`，而表中字段名比如`id`对应的程序中结构体字段名仍为`Id`。

# SuffixMapper

SuffixMapper 后缀映射类似与前缀映射，也可以组合SnakeMapper, SameMapper或者GonicMapper来在表名或者字段名的映射完成后，再新增一个固定的前缀。比如和SnakeMapper组合：

```Go
engine.SetTableMapper(core.NewSuffixMapper(core.SnakeMapper{}, "_table"))
engine.SetColumnMapper(core.SnakeMapper{})
```

那么对于结构体`User`，数据库中对应的表名即为`user_table`，而表中字段名比如`id`对应的程序中结构体字段名仍为`Id`。

# 表名和字段名分别映射

在前面的例子中也看到了，这种映射可以对表名和字段名采用相同的映射，也可以表名和字段名采用不同的映射方案。

* 表名和字段名使用相同映射方案
```Go
engine.SetMapper(mapper)
```

* 表名和字段名使用不同的映射方案
```Go
engine.SetTableMapper(mapper1)
engine.SetColumnMapper(mapper2)
```

最后，关于名称映射更多的方法可以参考XORM文档 [使用Table和Tag改变名称映射](http://gobook.io/read/go-xorm/manual-zh-cn/chapter-02/3.tags.html)
