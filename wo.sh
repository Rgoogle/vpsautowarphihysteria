#!/bin/bash

# 检查是否是超级用户
if [ $(id -u) -ne 0 ]; then
  # 如果不是超级用户，提示用户输入密码
  echo "Enter your password:"
  read -s password

  # 使用用户输入的密码执行 sudo 命令
  echo $password | sudo -S apt update 2>&1 | tee -a $HOME/wooden.log | grep -q "Sorry, try again."

  # 检查 sudo 命令的退出状态码
  if [ $? -eq 1 ]; then
    echo "Incorrect password." | tee -a $HOME/wooden.log
  fi
else
  # 如果是超级用户，直接执行 apt update 命令
  apt update
  apt install expect -y
fi


#!/usr/bin/expect

set timeout 600

spawn bash -c "wget -N https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh && bash menu.sh"

expect "Language:"
send "1\r"

expect "Add WARP dualstack interface to IPv6 only VPS (bash menu.sh d)"
send "3\r"

expect "Use free account (default)"
send "1\r"

expect "Use initial settings (default)"
send "3\r"

expect "WGCF is ready"
expect "Got the WARP IP successfully."

puts "Installation completed."

# chinese  luanma
echo "set encoding=utf-8" >> ~/.vimrc
echo "export LANG=en_US.utf8" >> ~/.bashrc
source ~/.bashrc

# [Network error]: Failed to get the latest version of hysteria in Github! 


# #!/usr/bin/expect
# set timeout 600
# # spawn bash -c "wget -N https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh && bash menu.sh"
# spawn bash -c "wget -N https://git.io/hysteria.sh && bash hysteria.sh"
# # spawn bash <(curl -fsSL https://git.io/hysteria.sh)

# expect "安装 hysteria"
# send "1\r"

# expect "3、自签证书"
# expect "输入序号:"
# send "3\r"

# expect "请输入自签证书的域名(默认:wechat.com):"
# send "\r"

# # expect "1、正确(默认)"
# expect "输入序号:"
# send "1\r"

# expect "3、wechat-video(默认)"
# send "3\r"

# expect "请输入你想要开启的端口,此端口是server端口,建议10000-65535.(默认随机)"
# send "10000"

# expect "请输入您到此服务器的平均延迟,关系到转发速度(默认200,单位:ms):"
# send "250"

# expect "请输入客户端期望的下行速度:(默认50,单位:mbps):"
# send "100"


# expect "请输入客户端期望的上行速度(默认10,单位:mbps):"
# send "50"


# expect "请输入认证口令(默认随机生成,建议20位以上强密码):"
# send "kldsfjoipdsahfop1265418dfhasjfgdsakL^#!@&*$^@!)$#!@*$^@1f6ds5"

# # expect "1、auth_str(默认)"
# expect "输入序号:"
# send "1"

# expect "请输入客户端名称备注(默认使用域名/IP区分,例如输入test,则名称为Hys-test):"
# send "\r"

# expect "一键链接:"
# send "successfully"

#!/usr/bin/expect
set timeout 600
set max_retries 3
set retry_count 0
set install_success 0

while {$retry_count < $max_retries && !$install_success} {
    spawn bash -c "wget -N https://git.io/hysteria.sh && bash hysteria.sh"
    # spawn bash <(curl -fsSL https://git.io/hysteria.sh)

    expect {
        "安装 hysteria" {
            send "1\r"
            exp_continue
        }
        "3、自签证书" {
            expect "输入序号:"
            send "3\r"
            exp_continue
        }
        "请输入自签证书的域名(默认:wechat.com):" {
            send "\r"
            exp_continue
        }
        "输入序号:" {
            send "1\r"
            exp_continue
        }
        "选择协议类型:" {
            send "3\r"
            exp_continue
        }
        "请输入你想要开启的端口,此端口是server端口,建议10000-65535.(默认随机)" {
            send "10000\r"
            exp_continue
        }
        "请输入您到此服务器的平均延迟,关系到转发速度(默认200,单位:ms):" {
            send "250\r"
            exp_continue
        }
        "请输入客户端期望的下行速度:(默认50,单位:mbps):" {
            send "100\r"
            exp_continue
        }
        "请输入客户端期望的上行速度(默认10,单位:mbps):" {
            send "50\r"
            exp_continue
        }
        "请输入认证口令(默认随机生成,建议20位以上强密码):" {
            send "kldsfjoipdsahfop1265418dfhasjfgdsakL^#!@&*$^@!)$#!@*$^@1f6ds5\r"
            exp_continue
        }
        "输入序号:" {
            send "1\r"
            exp_continue
        }
        "请输入客户端名称备注(默认使用域名/IP区分,例如输入test,则名称为Hys-test):" {
            send "\r"
            exp_continue
        }
        "一键链接:" {
            send "successfully\r"
            set install_success 1
        }
        # Add a branch to handle network errors
        "Failed to get the latest version of hysteria in Github!" {
            set retry_count [expr {$retry_count + 1}]
            if {$retry_count < $max_retries} {
                puts "Error: Failed to get the latest version of hysteria in Github! Retrying..."
            } else {
                # Log the error to a file
                set fp [open "woiden.log" a]
                puts $fp "Installation failed: Failed to get the latest version of hysteria in Github!"
                close $fp
            }
        }
    }
}

if {$install_success} {
    puts "Installation completed successfully!"
}








