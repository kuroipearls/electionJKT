library(devtools)
require("Rfacebook")
fb_oauth <- fbOAuth(app_id="1085738828191965",app_secret="3e8944ae5574a8272539609865ec89f6",extended_permissions=TRUE)

save(fb_oauth, file="fb_oauth")
load("fb_oauth")

#GET MY LIKES - UNCOMMENT TO ACTIVATE
me <- getUsers("me",token=fb_oauth)
my_likes <- getLikes(user="me",token=fb_oauth)
View(my_likes)

my_news <- getNewsfeed(token=fb_oauth, n=100)
View(my_news)