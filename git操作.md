
## 一、基本操作
#### clone分支到指定目录
	git clone -b 分支  git地址 目录
   *例子*
    *git clone -b pet_develop_new git@gitlab.shinezoneserver.com:SolidPoly_Gailias_Client/SolidPoly_Gailias_Client.git test*

#### 添加文件
	git add .

#### 提交文件到本地
	git commit -m "test" -a

#### 提交到过程仓库
	git push

#### 从远程拉代码
	git pull

## 二、tag操作
#### 产生本地tag
	git tag tag-name

#### 删除本地tag
	git tag tag-name -d

#### 删除远程tag
	git push origin :refs/tags/[tagName]

#### 提交所有tag
	git push [remote] --tags

#### 提交指定tag
	git push [remote] [tag]

#### 删除文件
	git rm files

## 三、分支操作
#### 查看远程分支
	git branch -a
带*的为当前分支

#### 查看本地分支
	git branch
#### 创建分支
	git branch test
#### 推送分支到远程 
	git push origin test
#### 切换分支
	git checkout test
#### 删除本地分支
	 git branch -d branch-name
#### 删除远程分支
	git push origin :branch-name

## 四、submodule
#### 使用 git submodule 同步主从项目的依赖关系
	1. 使用git submodule update --init --recursive会自动让从属项目更新到主项目依赖的版本
	2. 使用git submodule update --init --recursive --remote会让从属项目更新到它自己的最新远程 master* 分支.
	
[https://blog.tomyail.com/using-git-submodule-lock-project/](https://blog.tomyail.com/using-git-submodule-lock-project/ "主从项目的依赖关系")