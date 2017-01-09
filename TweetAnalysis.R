library(ggplot2)
library(scales)
library(lubridate)
tweets <- read.csv('tweets.csv', stringsAsFactors = FALSE)

tweets$timestamp <- ymd_hms(tweets$timestamp)
tweets$timestamp <- with_tz(tweets$timestamp, "America/Chicago")

# Code to display tweets throughout the timelime
ggplot(data = tweets, aes(x = timestamp)) +
  geom_histogram(aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")

# Code to display tweets year-wise
ggplot(data = tweets, aes(x = year(timestamp))) +
  geom_histogram(breaks = seq(2007.5, 2015.5, by =1), aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")


# Code to display number of tweets in days of the week
ggplot(data = tweets, aes(x = wday(timestamp, label = TRUE))) +
  geom_bar(breaks = seq(0.5, 7.5, by =1), aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Day of the Week") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")


# Code to display number of tweets in a month
ggplot(data = tweets, aes(x = month(timestamp, label = TRUE))) +
  geom_bar(aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Month") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")


# Code to display tweets according to time
tweets$timeonly <- as.numeric(tweets$timestamp - trunc(tweets$timestamp, "days"))
class(tweets$timeonly) <- "POSIXct"
ggplot(data = tweets, aes(x = timeonly)) +
  geom_histogram(aes(fill = ..count..),bins=30) +
  theme(legend.position = "none") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_x_datetime(breaks = date_breaks("3 hours"),labels = date_format("%H:00")) +
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")


# Code to calculate number of tweets with hashtags
ggplot(tweets, aes(factor(grepl("#", tweets$text)))) +
  geom_bar(fill = "orange") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Tweets with Hashtags") +
  scale_x_discrete(labels=c("No hashtags", "Tweets with hashtags"))


# Code to calculate the number of retweet tweets and no retweet tweets
ggplot(tweets, aes(factor(!is.na(retweeted_status_id)))) +
  geom_bar(fill = "aquamarine2") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Retweeted Tweets") +
  scale_x_discrete(labels=c("Not retweeted", "Retweeted tweets"))


# Code to calculate the replied tweets
ggplot(tweets, aes(factor(!is.na(in_reply_to_status_id)))) +
  geom_bar(fill = "aquamarine4") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Replied Tweets") +
  scale_x_discrete(labels=c("Not in reply", "Replied tweets"))


# Code to calculate number of chars in a tweet
tweets$charsintweet <- sapply(tweets$text, function(x) nchar(x))
ggplot(data = tweets, aes(x = charsintweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 10) +
  theme(legend.position = "none") +
  xlab("Characters per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "orange2")

