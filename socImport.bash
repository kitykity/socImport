#!/bin/bash
# socImport.bash by Susan Pitman
# Pulls files from a directory in DropBox
# called Apps/Day One/Incoming into
# Day One journal posts.
# 1/18/15 Script created
# 1/19/15 Added Facebook photo post import

thisUser="suzy" # Change to the user on your computer that has DropBox mounted.
socDir="/Users/${thisUser}/Dropbox/Apps/Day One/Incoming"
thisDir="/Users/suzy/socImport" # Directory where this script is running from

if ls "${socDir}"/*.txt > /dev/null 2>&1 ; then
  ls "${socDir}"/*.txt > ${thisDir}/txtlist.socImport
  ls "${socDir}"/completed >/dev/null 2>&1 || mkdir "${socDir}"/completed 2> /dev/null
  while read thisFile ; do
    #printf "\n${thisFile}\n"
    dayLine=`head -1 "${thisFile}"`
    thisMon=`echo ${dayLine} | cut -d" " -f1`
    thisMonth=`date -v "${thisMon}" +%m`
    thisDay=`echo ${dayLine} | cut -d" " -f2 | cut -d"," -f1`
    thisYear=`echo ${dayLine} | cut -d" " -f3`
    thisTime=`echo ${dayLine} | cut -d" " -f5`
    postDate="${thisMonth}/${thisDay}/${thisYear} ${thisTime}"
    case `basename "${thisFile}" | cut -d"-" -f1` in 
      "facebook")
        #echo "This is a Facebook post."
        postText=`tail -n +2 "${thisFile}"`
        #printf "${postText}\n\n"
        printf "Facebook Post \n${postText} \n \nImported from Facebook.\n" | /usr/local/bin/dayone -d="${postDate}" new > /dev/null && mv "${thisFile}" "${socDir}"/completed
        ;;
      "facebookphoto")
        echo "This is a Facebook photo post."
        postText=`tail -n +3 "${thisFile}"`
        postLink=`tail -n +2 "${thisFile}" | head -1`
        #photoLink=`curl -s ${postLink}`
        photoLink=`curl -s ${postLink} | grep "^<a href" | sed 's/\"/~/g' | cut -d"~" -f2 | cut -d"?" -f1`
echo "PHOTOLINK: ${photoLink}"
        curl -s ${photoLink} -o ${thisDir}/photo.jpg
        printf "Facebook Post \n<img src=${photoLink} width=640> \n${postText} \n \nImported from Facebook.\n" | /usr/local/bin/dayone -d="${postDate}" -p="${thisDir}/photo.jpg" new > /dev/null && mv "${thisFile}" "${socDir}"/completed && rm "${thisDir}/photo.jpg"
        ;;
      "inst")
        #echo "This is an Instagram post."
        postText=`tail -n +3 "${thisFile}"`
        postLink=`tail -n +2 "${thisFile}" | head -1`
        photoLink=`curl -s ${postLink} | grep "^<a href" | sed 's/\"/~/g' | cut -d"~" -f2`
        curl -s ${photoLink} -o ${thisDir}/photo.jpg
        #printf "${postText}\n\n"
        printf "Instagram Post \n${postText} \n \nImported from Instagram.\n" | /usr/local/bin/dayone -d="${postDate}" -p="${thisDir}/photo.jpg" new > /dev/null && mv "${thisFile}" "${socDir}"/completed && rm "${thisDir}/photo.jpg"
        ;;
      "twit")
        #echo "This is a twitter post."
        postLink=`tail -n +2 "${thisFile}" | head -1`
        postText=`tail -n +3 "${thisFile}"`
        #printf "${postText}\n\n"
        printf "Twitter Post \n${postText} \n \n<br><a href=${postLink}>View Post</a><br>Imported from Twitter.\n" | /usr/local/bin/dayone -d="${postDate}" new > /dev/null && mv "${thisFile}" "${socDir}"/completed
        ;;
    esac
    #printf "About to do another...\n"
    sleep 5
  done < ${thisDir}/txtlist.socImport
fi
