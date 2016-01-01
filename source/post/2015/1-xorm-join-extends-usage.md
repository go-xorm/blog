```ini
title = 在Xorm中使用Join和Extends标记
date = 2015-12-01 16:00:00
tags = go,golang,xorm,orm,sql,database
```

本文主要针对对Xorm已经有了一定了解的读者，如果您是第一次了解Xorm，请先阅读[xorm操作手册](http://xorm.io/docs)。

Xorm的基本操作都是比较简单的，可能大家也都比较熟悉了。今天主要讲解extends标记和join的使用。通过使用join和extends，可以解决许多需要级联进行的操作。

一般我们会针对数据库中的每一个表，建立一个对应的结构体。比如：
```Go
type User struct {
    Id int64
    Name string
}

type Account struct {
    Id int64
    UserId int64 `xorm:"index"`
    Amount int64
}

type Car struct {
    Id int64
    UserId int64 `xorm:"index"`
    Type int
}
```

我们定义了三个结构体，对应数据库的三个表，我们在启动时通过：
```Go
engine.Sync2(new(User), new(Account), new(Car))
```
来进行数据库结构的同步。在这个数据库结构中，我们假设一个用户拥有一个Account，一个用户拥有多个Car。

OK。复杂需求来了。

1）我们需要获得所有的用户的姓名和对应的账户的余额：
```Go
type AccountUser struct {
    Account `xorm:"extends"`
    User `xorm:"extends"`
}

var accounts = make([]*AccountUser, 0)
engine.Table("account").Join("INNER", "user", "account.user_id = user.id").Find(&accounts)
```
OK。这样，我们就取出了user和对应的account，我们通过```account.Account```可以获取到Account的信息，通过```account.User```可以获取到User的信息。

这个是两个表Join，那么如果是三个表也是类似的做法。

2）我只需要用户名，不需要其它的内容：
```Go
type AccountUser struct {
    Account `xorm:"extends"`
    Name string
}
var accounts = make([]*AccountUser, 0)
engine.Table("account").Join("INNER", "user", "account.user_id = user.id").Find(&accounts)
```
其实我们代码也是差不多的，但是这里我们实际上在查询数据库的时候是查询了user表的所有内容的。只是在最后赋值到结构体时，按需赋值。

3）更复杂的，我们还想知道每人有几辆车。
```Go
type AccountUser struct {
    Account `xorm:"extends"`
    Name string
    NumCars int
}
var accounts = make([]*AccountUser, 0)
engine.Sql("select account.*, user.name, (select count(id) from car where car.user_id = user.id) as num_cars from account, user where account.user_id = user.id").Find(&accounts)
```
在这样的复杂需求下，我们使用了Sql函数和extends标记结合来完成这个操作。
