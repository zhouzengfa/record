1、运行TortoiseGit开始菜单中的Puttygen程序

2、点击“Generate”按钮，鼠标在上图的空白地方来回移动直到进度条完毕，就会自动生一个随机的key

3、为密钥设置对应的访问密码，在“Key passphrase”和“Confirm passphrase”的后面的输入框中输入密码

4、将多行文本框中以“ssh-rsa”开头的内容全选、复制，并粘贴到github的 Account Settings -> SSH Keys -> Add SSH key -> Key字段中，这就是适用于github的公钥

5、点击“Save private key”按钮,将生成的key保存为适用于TortoiseGit的私钥（扩展名为.ppk）

6、运行TortoiseGit开始菜单中的Pageant程序，程序启动后将自动停靠在任务栏中，双击该图标，弹出key管理列表

7、点击“Add Key”按钮，将第5步保存的ppk私钥添加进来，关闭对话框即可