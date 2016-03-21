library(shiny)




#rm('list_primcause')
#rm('list_teams')

facebook <- read.csv('www/Facebook/Tweets_Facebook.csv', stringsAsFactors=FALSE)  
linkedin <- read.csv('www/LinkedIn/Tweets_LinkedIn.csv', stringsAsFactors=FALSE)  
google <- read.csv('www/Google/Tweets_Google.csv', stringsAsFactors=FALSE)  
woolworths <- read.csv('www/Woolworths/Tweets_Woolworths.csv', stringsAsFactors=FALSE)  
coles <- read.csv('www/Coles/Tweets_Coles.csv', stringsAsFactors=FALSE)  
jbhifi <- read.csv('www/JBhifi/Tweets_JBhifi.csv', stringsAsFactors=FALSE)  
ebgames <- read.csv('www/EBgames/Tweets_EBgames.csv', stringsAsFactors=FALSE)  
davidjones <- read.csv('www/DavidJones/Tweets_DavidJones.csv', stringsAsFactors=FALSE)  
myer <- read.csv('www/Myer/Tweets_Myer.csv', stringsAsFactors=FALSE)  

#<- read.csv('data/tweets_.csv', stringsAsFactors=FALSE)  
#<- read.csv('data/tweets_.csv', stringsAsFactors=FALSE)  
#<- read.csv('data/tweets_.csv', stringsAsFactors=FALSE)  



shinyServer(function(input,output){
  
  
output$raw_tweets <- shiny::renderDataTable({
  if(input$casestudy=='Internet' && input$sel1=='Facebook') { facebook }
  else if(input$casestudy=='Internet' && input$sel1=='Google') { google }
  else if(input$casestudy=='Internet' && input$sel1=='LinkedIn') { linkedin }
  else if(input$casestudy=='Retail - FMCG' && input$sel2=='Woolworths Supermarkets') { woolworths }
  else if(input$casestudy=='Retail - FMCG' && input$sel2=='Coles Supermarkets') { coles }
  else if(input$casestudy=='Retail - Technology' && input$sel3=='JB Hi Fi') { jbhifi }
  else if(input$casestudy=='Retail - Technology' && input$sel3=='EB Games') { ebgames }
  else if(input$casestudy=='Retail - Beauty' && input$sel4=='David Jones') { davidjones }
  else if(input$casestudy=='Retail - Beauty' && input$sel4=='Myer') { myer }
  

}, options = list(
  autoWidth = FALSE,
  columnDefs = list(width = '600px', targets = c(list(9))))

)
  

output$code1 <- reactive({"
#################################################
#### STEP 0 -Install and intialise the 'twitteR' API ####
#################################################

install.packages('twitteR')
library('twitteR')


##########################################################################################
#### STEP 1 -Retreive your Twitter Developer credentials - visit www.dev.twitter.com  ####
##########################################################################################

consumer_key <- 'AAAAAAAAAAAAAA'
consumer_secret <- 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
access_token <- 'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'
access_secret <- 'DDDDDDDDDDDDDDDDDDDDDDDDDDDD'


##############################################################
#### STEP 2 -Authenticate connection with the Twitter API ####
##############################################################

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#################################
#### STEP 3 -Retreive Tweets ####
#################################

LinkedIn <- c('#LinkedIn','LinkedIn')
# Assign search keywords for your search

for(i in 1:length(LinkedIn)){
  assign(paste0('Tweets_LinkedIn_',i), searchTwitter(LinkedIn[i], n=2000, retryOnRateLimit = 10))
  
}
# Looping the tweet extraction code to go through all the keywords assigned to character variable 'LinkedIn'


Tweets_LinkedIn_total <- rbind(twListToDF(Tweets_LinkedIn_1)
                               ,twListToDF(Tweets_LinkedIn_2))
# Combining data-pulls into one dataframe

write.csv(Tweets_LinkedIn_total$text,'Tweets_LinkedIn_text_14FEB16.csv')
# Exporting dataframe

#############################################
#### Repeat Steps 1-3 for other searches ####
#############################################

"})


output$code2 <- renderText("
##################################################
#### STEP 0 -Install and intialise relevant packages ####
##################################################
library('sqldf')
library('tm')
library('wordcloud')
library('treemap')
library('stringr')


#############################
#### STEP 1 - Load score dictionary
#############################

dictionary <- read.delim(file='AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
# Can be found at the following URL: http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010

names(dictionary) <- c('word', 'score')

#############################
#### STEP 2 - Edit Source file
#############################
dir_trend <- '***RELEVANT PATH TO FILES CREATED IN TWITTER EXTRACTION STEP***'
trend <- 'LinkedIn'

# Text Mining functions
text<-Corpus(DirSource(paste0(dir_trend,trend)))
text <- tm_map(text, stripWhitespace)
text <- tm_map(text, content_transformer(tolower))
text <- tm_map(text, removeNumbers)
text <- tm_map(text, removePunctuation)
text <- tm_map(text, function(x) removeWords(x,stopwords()))
# Removes stopwords like 'the' 'in' 'and' etc

writeCorpus(text, path=dir_trend, filenames=paste('corpus_',trend,'.csv', sep=''))
# Exporting the cleaned file


Tweetdata<- read.csv(paste0(dir_trend,'corpus_',trend,'.csv'),stringsAsFactors=FALSE)
# Importing the cleaned file

#############################
#### STEP 3 - Changing Sentences into Words
#############################


# Function to change the sentence into words
unlistWords <- function(sentence){
sentence <- gsub('[[:punct:]]', '', sentence)
sentence <- gsub('[[:cntrl:]]', '', sentence)
sentence <- gsub('\\d+', '', sentence)
sentence <- tolower(sentence)
wordList <- str_split(sentence, '\\s+')
words <- unlist(wordList)
return(words)
}


Tweetresult <- as.data.frame(unlistWords(Tweetdata))

names(Tweetresult)<- c('word')

write.csv(Tweetresult,file=paste0(dir_trend,'Overallcloud_',trend,'.csv'))


#############################
#### STEP 4 - Merging Source data with Dictionary
#############################
sqldf1 <- sqldf('SELECT Tweetresult.word, dictionary.score
FROM Tweetresult
left JOIN dictionary
ON Tweetresult.word=dictionary.word')
# Superimposing scores from dictionary to all words in the raw data, where applicable
# Used for RAW Wordcloud

sqldf2<- sqldf('SELECT * from sqldf1 where score IS NOT NULL  order by word')
# Subsetting table for words that have an associated sentiment score
# Used for CLEAN Wordcloud

sqldf3<- sqldf('SELECT word, score, COUNT(*) as freq
from sqldf2 where score IS NOT NULL
group by word order by word')
# Summarising results for each word
# Used for Sentiment Treemap


sqldf3 <- sqldf(paste('select '',trend,'' as trend, word, score, COUNT(*) as freq
from sqldf2 where score IS NOT NULL
group by word order by word', sep=''))


#############################
#### STEP 5 - Generating Plots
#############################

pal <- brewer.pal(6,'Dark2')
# Colour pallete

# 1) Wordcloud - CLEAN DATA
wordcloud(sqldf2[,1],  scale=c(4,.5), color=pal) 
dev.copy(png,paste0(searchtext,'_wc_cln.png'))
dev.off()


# 2) Treemap - CLEAN DATA
treemap(sqldf3, index='word', vSize='freq', vColor='score', type='value', 
title = 'Sentiment Analysis - TreeMap of key words appearing in Tweets',title.legend='Sentiment Score')
dev.copy(png,paste0(searchtext,'_treemap.png'))
dev.off()


# 3) Wordcloud - RAW DATA
wordcloud(sqldf1$word, min.freq = 10, color=pal, scale=c(4,.5))
dev.copy(png,paste0(searchtext,'_wc_raw.png'))
dev.off()
")


# 
# output$scorewords <- shiny::renderDataTable({
#   if(input$casestudy=='Internet' && input$sel1=='Facebook') { facebook }
#   else if(input$casestudy=='Internet' && input$sel1=='Google') { google }
#   else if(input$casestudy=='Internet' && input$sel1=='LinkedIn') { linkedin }
#   else if(input$casestudy=='Retail - FMCG' && input$sel2=='Woolworths Supermarkets') { woolworths }
#   else if(input$casestudy=='Retail - FMCG' && input$sel2=='Coles Supermarkets') { coles }
#   else if(input$casestudy=='Retail - Technology' && input$sel3=='JB Hi Fi') { jbhifi }
#   else if(input$casestudy=='Retail - Technology' && input$sel3=='EB Games') { ebgames }
#   else if(input$casestudy=='Retail - Beauty' && input$sel4=='David Jones') { davidjones }
#   else if(input$casestudy=='Retail - Beauty' && input$sel4=='Myer') { myer }
#   
#   
# }, options = list(
#   autoWidth = FALSE,
#   columnDefs = list(width = '600px', targets = c(list(9))))
# 
# )
#   
  ##########################
  ##### SIDEBAR INPUTS #####
  ##########################
#   output$one <-  reactive({if(input$casestudy=='Internet'){
#       img(src="sel_data.png")
#   }
#   })
  
  
})#END shinyServer