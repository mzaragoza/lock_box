          ________ _________  ________
         |\   ____\\___   ___\\  _____\
         \ \  \___\|___ \  \_\ \  \__/
          \ \  \       \ \  \ \ \   __\
           \ \  \____   \ \  \ \ \  \_|
            \ \_______\  \ \__\ \ \__\
          ___\|_______|___\|__|__\|__|_  ___       ________
         |\___   ___\\   __  \|\   __  \|\  \     |\   ____\
         \|___ \  \_\ \  \|\  \ \  \|\  \ \  \    \ \  \___|_
              \ \  \ \ \  \\\  \ \  \\\  \ \  \    \ \_____  \
               \ \  \ \ \  \\\  \ \  \\\  \ \  \____\|____|\  \
                \ \__\ \ \_______\ \_______\ \_______\____\_\  \
                 \|__|  \|_______|\|_______|\|_______|\_________\
                                                     \|_________|


### CTF Websites
* https://ringzer0team.com
  * Completed Challenges
    * [001](https://ringzer0team.com/challenges/1) | Bypass me if you can | Objective is to bypass the login form. Hint: SQL Injection ;-)
    * [013](https://ringzer0team.com/challenges/13) | Hash me please - Objective is to hash a string using sha512 algorithm
      * Example: ```rake run:ctf:challenge\['013', 'acidburn', 's@mepl123'\]```
    * [014](https://ringzer0team.com/challenges/14) | Hash me reloaded - Objective is to hash a string using sha512 algorithm, however first you must convert the string from binary to ascii text output before converting using sha512
      * Example: ```rake run:ctf:challenge\['014', 'acidburn', 's@mepl123'\]```
    * [032](https://ringzer0team.com/challenges/32) | Can you help me find the answer to this equation - Objective is to get the answer to an arithmetic question from a string PS: tricky part is the hex and binary to integer
      * Example: ```rake run:ctf:challenge\['032', 'acidburn', 's@mepl123'\]```
    * [172](https://ringzer0team.com/challenges/172) | Ask your grandpa! - Objective is to decode the pounch card
    * [218](https://ringzer0team.com/challenges/218) | Bash Jail 1
      * Connect to the remote server via ssh ```ssh level1@challenges.ringzer0team.com -p 10219```
        * password is ```level1```
      * Initialize a new shell ```/bin/bash```
      * redirect stdout to stderr ```awk '{system("wc "$1)}' /home/level1/flag.txt```
        * [What is awk?](https://linuxconfig.org/learning-linux-commands-awk)
