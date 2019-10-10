
## 一、基本操作
#### 1. clone分支到指定目录
	git clone -b 分支  git地址 目录
   *例子*
    *git clone -b pet_develop_new git@gitlab.shinezoneserver.com:SolidPoly_Gailias_Client/SolidPoly_Gailias_Client.git test*


#### 2. 添加文件
	git add .

#### 3. 提交文件到本地
	git commit -m "test" -a

#### 4. 提交到过程仓库
	git push

#### 5. 从远程拉代码
	git pull
#### 6. 查看当前详细分支信息（可看到当前分支与对应的远程追踪分支）:
	git branch -vv
#### 7. 查看当前远程仓库信息
	git remote -vv
#### 8. 补充提交
	git commit -m "新的注释" --amend

## 二、tag操作
#### 1. 产生本地tag
	git tag tag-name

#### 2. 删除本地tag
	git tag tag-name -d

#### 3. 删除远程tag
	git push origin :refs/tags/[tagName]

#### 4. 提交所有tag
	git push [remote] --tags

#### 5. 提交指定tag
	git push [remote] [tag]

#### 6. 删除文件
	git rm files

## 三、分支操作
#### 1. 查看远程分支
	git branch -a
带*的为当前分支

#### 2. 查看本地分支
	git branch
#### 3. 创建分支
	git branch test [commitid or master]
#### 4. 推送分支到远程 
	git push origin test
#### 5. 切换分支
	git checkout test
#### 6. 删除本地分支
	 git branch -d branch-name
#### 7. 删除远程分支
	git push origin :branch-name
#### 8. 合并游离分支
```shell
git reflog #查看提交日志，找到自己在游离分支上提交的临时id
git merge id(eef5) #合并游离分支代码到当前分支上来
```
## 四、submodule
#### 1. 递归clone子模块
	 git clone -b develop --recursive git@gitlab.shinezoneserver.com:SolidPoly_Gailias_Server/SolidPoly_Gailias_Server.git submode-test
#### 2. 使用 git submodule 同步主从项目的依赖关系
	1. 使用git submodule update --init --recursive会自动让从属项目更新到主项目依赖的版本
	2. 使用git submodule update --init --recursive --remote会让从属项目更新到它自己的最新远程 master* 分支.
	
## 五、回滚
#### 1. 回滚提交到指定版本
1) reset方式
* **回滚到指定版本**
```shell
git reset --hard HEAD^        回退到上个版本
git reset --hard commit_id    退到/进到 指定commit_id
```
* **推送到远程**
```shell
git push origin HEAD --force
```
reset 为 重置到这次提交，将内容重置到指定的版本。git reset 命令后面是需要加2种参数的：–-hard 和 –-soft。这条命令默认情况下是 -–soft。执行上述命令时，这该条commit号之 后（时间作为参考点）的所有commit的修改都会退回到git缓冲区中。使用git status 命令可以在缓冲区中看到这些修改。而如果加上-–hard参数，则缓冲区中不会存储这些修改，git会直接丢弃这部分内容。可以使用 git push origin HEAD --force 强制将分区内容推送到远程服务器。

* **可以吃的后悔药->版本穿梭**
当你回滚之后，又后悔了，想恢复到新的版本怎么办？
用git reflog打印你记录你的每一次操作记录
```shell
$ git reflog
75cf6ff HEAD@{0}: reset: moving to 75cf6ff
5b21786 HEAD@{1}: commit: 333
75cf6ff HEAD@{2}: commit: 222
3825737 HEAD@{3}: commit: 111
1adca26 HEAD@{4}: reset: moving to 1adca2
9e04d68 HEAD@{5}: commit: 3333
6ecbe04 HEAD@{6}: commit: test 222
2df075d HEAD@{7}: commit: test reset multi version111
```
找到你操作的id如：5b21786，就可以回退到这个版本<br\>
```shell
$ git reset --hard 5b21786
```

2）revert方式
* **回滚到指定版本**
```shell
  git revert commitId
```
若有冲突，先解决冲突，然后执行 
```shell
git revert --continue
```
输入提交信息后，退出保存，即可 
* **推送到远程**
```shell
git push origin master
```

二者区别：

* revert是放弃指定提交的修改，但是会生成一次新的提交，需要填写提交注释，以前的历史记录都在；
* reset是指将HEAD指针指到指定提交，历史记录中不会出现放弃的提交记录。

#### 2. 回滚文件到历史版本
*  **查看指定文件的历史版本**
```shell
	git log <filename>
```
* **回滚到指定commitID， 并提交**
```shell
	git checkout <commitID> <filename>
	git commit -m "xxxx"
	git push
```

#### 3. 删除某次提交 
* **查看提交版本**
```shell
git log --oneline -n5
```
* **指定commit id的前一次提交**
```shell
git rebase -i "commit id"
```
按提示进行操作，如：移动光标到指定commit条目，按d删除此次提交等。
* **推送到远程**
```shell
git push origin master -f
```


参考：
[https://git-scm.com/book/zh/v2](https://git-scm.com/book/zh/v2 "git官方文档")
[https://blog.tomyail.com/using-git-submodule-lock-project/](https://blog.tomyail.com/using-git-submodule-lock-project/ "主从项目的依赖关系")