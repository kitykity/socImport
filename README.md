# socImport
Send Twitter/Instagram/Facebook posts to Day One Journal

Create a DropBox account (if you don't have one) and create a folder called Apps/Day One/Incoming .

Use these free IFTTT recipes to send your social media posts to a folder in DropBox...
Facebook Photo Posts - https://ifttt.com/recipes/244050-day-one-import-facebook-photo-posts
Facebook Text Posts - https://ifttt.com/recipes/242576-day-one-facebook-to-text-in-dropbox
Twitter Posts - https://ifttt.com/recipes/242574-day-one-tweets-to-text-in-dropbox
Instagram Posts - https://ifttt.com/recipes/242577-day-one-instagram-to-text-in-dropbox

Then, save the socImport.bash script to a folder on your Mac; I suggest in a folder called /Users/yourname/socImport .
Make sure it's executable by you.

Now set up a cron job on your Mac, by using the command "crontab -e". 
(If you have never used cron before, Google some instructions.)
I have the cron job run even-numbered hours, during the hours I'm usually awake. You may want to have it run more or less than that. Here's my example:
00 8,10,12,14,16,18,20,22 * * * /Users/suzy/socImport/socImport.bash

Whenever your Mac is on, and it hits one of those times, the script will run, taking the text files dropped into your Incoming folder by the If This Then That recipes and importing them into Day One.

Enjoy! :)
