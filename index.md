## Welcome to my Twitter Archive Analysis

I have recently started learning R and to get a better grip on it. I decided to use different libraries available to perform different kinds on analysis on my twitter archive.

You learn how to download your twitter archive by using this link.
[Click Here](https://support.twitter.com/articles/20170160)

After download your twitter archive. We'll start with the next steps. In your R file load the libraries and twitter csv file by using the below code.

```r
library(ggplot2)
library(scales)
library(lubridate)

tweets <- read.csv('tweets.csv', stringsAsFactors = FALSE)
```

The timestamp on each tweet is a string at this point, so let’s use a function from the lubridate package to convert the timestamp to a date-time object. The timestamps are recorded in UTC, so to make more interpretable plots, we need to convert to a different time zone. I am combining all my tweets into one timezone for easier representation.

```r
tweets$timestamp <- ymd_hms(tweets$timestamp)
tweets$timestamp <- with_tz(tweets$timestamp, America/San_Francisco)
```


<H2>Tweets by Year, Month, and Day</H2>

First is a basic histogram showing the distribution of my tweets over time.

```r
ggplot(data = tweets, aes(x = timestamp)) +
  geom_histogram(aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")
```
![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Tweets_over_time.png?raw=true)

We can try to find out the tweeting pattern over days by using the wday() function from lubridate and specify the breaks for the histogram.

```r
ggplot(data = tweets, aes(x = wday(timestamp, label = TRUE))) +
  geom_bar(breaks = seq(0.5, 7.5, by =1), aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Day of the Week") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")
```

![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Days.png?raw=true)

We can also try to find out the tweeting pattern over months by using the month() function from lubridate. 

```r
ggplot(data = tweets, aes(x = month(timestamp, label = TRUE))) +
  geom_bar(aes(fill = ..count..)) +
  theme(legend.position = "none") +
  xlab("Month") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "aquamarine2", high = "orange2")
```
![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Months.png?raw=true)

<H2>Hashtags, Retweets and Replies</H2>

I tried to analyse the tweets to look at my hashtags usage. This can be done using the regex and grep with '#' symbols in the text.

```r
ggplot(tweets, aes(factor(grepl("#", tweets$text)))) +
  geom_bar(fill = "orange") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Tweets with Hashtags") +
  scale_x_discrete(labels=c("No hashtags", "Tweets with hashtags"))
```

![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/HashTag.png?raw=true)



