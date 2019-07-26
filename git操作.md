
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

