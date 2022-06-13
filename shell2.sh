##Basic shell commands
#!/bin/bash
n=rzc
echo $n
##to capture values passed to the script
echo $1
echo $2
echo $3
##prompt and capture value into variable(s)
read -p 'enter your name" ' FIRSTNAME LASTNAME
echo your name is $NAME

if [ 10 -lt 13 ] 
then    echo 10 is less than 13
fi



