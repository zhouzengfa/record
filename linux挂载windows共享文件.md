# linux挂载windows共享文件
1. 临时挂载方式
```
mount -o username=zhouzengfa,password=1234567 //172.16.2.109/software /mnt/softwares/
```
2. 开机自动挂载
* 在/etc/fstab中加入
```
//172.16.2.109/software /mnt/softwares cifs username=zhouzengfa,password=1234567 0 0
```
* mount -a 重新加载