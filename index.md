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

One of the columns in the CSV file from Twitter codes whether the tweet is a retweet or not, so it is not tough to see how many tweets are retweeted vs. original content.

```r
ggplot(tweets, aes(factor(!is.na(retweeted_status_id)))) +
  geom_bar(fill = "aquamarine2") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Retweeted Tweets") +
  scale_x_discrete(labels=c("Not retweeted", "Retweeted tweets"))
```
![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Retweet.png?raw=true)

There is another column in the CSV file that codes whether the tweet is in reply to another tweet.

```r
ggplot(tweets, aes(factor(!is.na(in_reply_to_status_id)))) +
  geom_bar(fill = "aquamarine4") + 
  theme(legend.position="none", axis.title.x = element_blank()) +
  ylab("Number of tweets") + 
  ggtitle("Replied Tweets") +
  scale_x_discrete(labels=c("Not in reply", "Replied tweets"))
```
![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Reply.png?raw=true)

<H2>Number of characters in a tweet</H2>

Lastly, let’s look at the distribution of the number of characters in my tweets. I can use one of the functions from the apply family of functions to count up the characters.

 ```r
 tweets$charsintweet <- sapply(tweets$text, function(x) nchar(x))
 ggplot(data = tweets, aes(x = charsintweet)) +
        geom_histogram(aes(fill = ..count..), binwidth = 8) +
        theme(legend.position = "none") +
        xlab("Characters per Tweet") + ylab("Number of tweets") + 
        scale_fill_gradient(low = "midnightblue", high = "aquamarine4")
 ```
 
 ![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/Chars.png?raw=true)
 

<H2>Word Cloud</H2>

We'll try to find the most occurences in the tweets

 
```r
nohandles <- str_replace_all(tweets$text, "@\\m+", "")
wordCorpus <- Corpus(VectorSource(nohandles))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("amp", "2yo", "3yo", "4yo"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)
pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]
set.seed(123)
wordcloud(words = wordCorpus, scale=c(5,0.1), max.words=100, random.order=FALSE, 
          rot.per=0.35, use.r.layout=FALSE, colors=pal)
```
 
 
![alt text](https://github.com/maitray16/Twitter-Analysis-using-R/blob/master/Images/WordCloud.png?raw=true)
