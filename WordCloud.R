library(tm)
library(stringr)
library(wordcloud)

tweets <- read.csv("tweets.csv",stringsAsFactors = FALSE)
nohandles <- str_replace_all(tweets$text, "@\\m+", "")
wordCorpus <- Corpus(VectorSource(nohandles))
wordCorpus <- tm_map(wordCorpus, removePunctuation)
wordCorpus <- tm_map(wordCorpus, content_transformer(tolower))
wordCorpus <- tm_map(wordCorpus, removeWords, stopwords("english"))
wordCorpus <- tm_map(wordCorpus, removeWords, c("amp", "2yo", "3yo", "4yo"))
wordCorpus <- tm_map(wordCorpus, stripWhitespace)

# Code to generate world cloud of the most common words in tweets
pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]
set.seed(123)
wordcloud(words = wordCorpus, scale=c(5,0.1), max.words=100, random.order=FALSE, 
          rot.per=0.35, use.r.layout=FALSE, colors=pal)


friends <- str_extract_all(tweets$text, "@\\m+")
namesCorpus <- Corpus(VectorSource(friends))
set.seed(146)
wordcloud(words = namesCorpus, scale=c(3,0.5), max.words=20, random.order=FALSE, 
          rot.per=0.10, use.r.layout=FALSE, colors=pal)
