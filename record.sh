
#! /bin/bash
# ./record.sh <CHANNELNUMBERXX> <HH:MM:SS or --notime>  <FILE.MP4>
# You need to have *ffmpeg* installed AND *jq* json parser for this script to function
# If you have issues it will probably be because the base rtmp url port number is wrong for you. Thus find out the correct 
# port by generating an rtmp link and modifying line 20 of this script.
# Correct usage is ./record.sh 01 1:30:00 ouput.mp4 OR ./record.sh 01 --notime ouput.mp4 which requires you to 
# stop the recording manually. 
# Chan number must be 2 or 3 digits. 
# I recommend calling this script with linux command *at* https://linux.die.net/man/1/at

#edit for your account.
user=dumbfred
pass=hasabadpassword

#change site variable to reflect the service you use. 
#Mystreams/usport=viewms Live247=view247, Starstreams=viewss, MMA-TV/Myshout=viewmma, Streamtvnow=viewstvn
site=view247
urlkey=$(curl "http://auth.smoothstreams.tv/hash_api.php?site=$site&username=$user&password=$pass" | jq -r .hash)
url=rtmp://dna.smoothstreams.tv:3615/view247?wmsAuthSign=$urlkey/ch$1q1.stream

if [[ $2 == "--notime" ]]; then
  ffmpeg -i $url -vcodec copy -acodec copy $3
else
  ffmpeg -i $url -vcodec copy -acodec copy -t $2 $3 
fi
