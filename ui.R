library(shiny)
library(shinythemes)

shinyUI(
fluidPage(theme= shinytheme("cosmo"),
navbarPage(  title="Developing Data Products - Social Media Analysis", windowTitle = "Coursera - Dev Data Prod"

           ,tabPanel("1. Case Studies"
                     ,
                     
                     
                     pageWithSidebar(
                       
                       headerPanel(title="1. Case Studies") 
                       ,sidebarPanel(
                         
                         selectInput("casestudy", label=h4("Select Case Study", icon("calendar"))
                                     , choices=c("Internet","Retail - FMCG", "Retail - Technology", "Retail - Beauty"), selected="Technology")
                        
                          ,conditionalPanel(
                           condition="input.casestudy == 'Internet'"
                           ,radioButtons("sel1", label="Select Internet Companies", choices=c("Google","Facebook","LinkedIn"), selected="Facebook")
                         )
                         ,conditionalPanel(
                           condition="input.casestudy == 'Retail - FMCG'"
                           ,radioButtons("sel2", label="Select FMCG Retail Companies (Australia)", choices=c("Woolworths Supermarkets","Coles Supermarkets"))
                         )
                         ,conditionalPanel(
                           condition="input.casestudy == 'Retail - Technology'"
                           ,radioButtons("sel3", label="Select Technology Retail Companies (Australia)", choices=c("JB Hi Fi","EB Games"))
                         )
                         ,conditionalPanel(
                           condition="input.casestudy == 'Retail - Beauty'"
                           ,radioButtons("sel4", label="Select Beauty and Fasion Retail Companies (Australia)", choices=c("David Jones","Myer"))
                         )

                       )#END sidebarPanel
                       
                       ,mainPanel(
                         h2("Coursera Project - Developing Data Products")
                         ,br()
                         ,h3("Author: Anand Gupta - www.github.com/anesthetize")
                         ,br()
                         ,h4("Here, the aim is to view several case studies for social media sentiment analysis performed for a few industries, specifically in the Australian market.  Please note that the Twitter data pulls were performed on 14-Feb-2016 (no, I didn't have a date this Valentine's day! *sad face*).")
                         ,br()
                         ,h4("In this tab we will view the sentiment analysis results, and then deep dive into the data extraction and calculations involved with the sentiment analysis in the forthcoming tabs.
                             Please scroll down to view the raw Twitter data.")
                         
                         ,tabsetPanel(
                           
                           tabPanel("Raw Data from Twitter",
                         tags$hr()
                         ,fluidRow(
                           column(12, align="center",
                                  h3("Raw Data from Twitter")
                                  ,br()
                                  ,p("Here we visualise the raw data retreived from Twitter on 14-Feb-2016 via a wordcloud.  
                                     The wordcloud visualises words appearing in the tweets at least 10 times, with the size representing the volume.")
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Facebook'"
                                                    , img(src = "Facebook/Facebook_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Google'"
                                                    , img(src = "Google/google_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='LinkedIn'"
                                                    , img(src = "LinkedIn/linkedin_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Woolworths Supermarkets'"
                                                    , img(src = "Woolworths/woolworths_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Coles Supermarkets'"
                                                    , img(src = "Coles/coles_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='JB Hi Fi'"
                                                    , img(src = "JBhifi/JBhifi_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='EB Games'"
                                                    , img(src = "EBgames/ebgames_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='David Jones'"
                                                    , img(src = "DavidJones/davidjones_3.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='Myer'"
                                                    , img(src = "Myer/myer_3.png"))
                                  )
                         ),fluidRow(
                           shiny::dataTableOutput("raw_tweets")
                         )
                         
                         
                           )#END tabPanel
                         
                         ,tabPanel("Parsing through data dictionary"
                         ,tags$hr()
                         ,fluidRow(
                           column(12, align="center",
                                  h3("Parsing through data dictionary")
                                  ,br()
                                  ,p("Next, we parse the raw data into a downloaded data dictionary file containing words along with appropriate positive and negative scores.
                                     Again we employ a wordcloud to visualise the score words.")
                                  
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Facebook'"
                                                    , img(src = "Facebook/Facebook_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Google'"
                                                    , img(src = "Google/google_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='LinkedIn'"
                                                    , img(src = "LinkedIn/linkedin_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Woolworths Supermarkets'"
                                                    , img(src = "Woolworths/woolworths_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Coles Supermarkets'"
                                                    , img(src = "Coles/coles_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='JB Hi Fi'"
                                                    , img(src = "JBhifi/JBhifi_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='EB Games'"
                                                    , img(src = "EBgames/ebgames_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='David Jones'"
                                                    , img(src = "DavidJones/davidjones_1.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='Myer'"
                                                    , img(src = "Myer/myer_1.png"))
                           )
                         )
                         )#END tabPanel
                         
                         ,tabPanel("Sentiment Tree Map",
                                   tags$hr()
                         ,fluidRow(
                           column(12, align="center",
                                  h3("Tree Map - visualising sentiment with volume of score words")
                                  ,br()
                                  ,p("While the wordcloud is informative, I find tree-maps to be much more effective.  A tree-map is essentially a 'pie-table', with the area
                                      of each 'block' representing volume of the score word and the colour representing sentiment score.")
                                  
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Facebook'"
                                                    , img(src = "Facebook/Facebook_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='Google'"
                                                    , img(src = "Google/google_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Internet' && input.sel1=='LinkedIn'"
                                                    , img(src = "LinkedIn/linkedin_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Woolworths Supermarkets'"
                                                    , img(src = "Woolworths/woolworths_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - FMCG' && input.sel2=='Coles Supermarkets'"
                                                    , img(src = "Coles/coles_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='JB Hi Fi'"
                                                    , img(src = "JBhifi/JBhifi_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Technology' && input.sel3=='EB Games'"
                                                    , img(src = "EBgames/ebgames_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='David Jones'"
                                                    , img(src = "DavidJones/davidjones_2.png"))
                                  ,conditionalPanel(condition = "input.casestudy == 'Retail - Beauty' && input.sel4=='Myer'"
                                                    , img(src = "Myer/myer_2.png"))
                           )
                         )
                         
                         )#END tabPanel
                         )#END tabsetPanel
                       )#END mainPanel
                     )#END PagewithSidebar
            )#END tabpanel
           ,tabPanel("2. Code - Tweet Extraction",
                     headerPanel(title="2. Code - Tweet Extraction") 
                     ,tags$hr()
                     ,p("Here I have outlined the R code utilised for the tweet extraction (performed independently on 14-Feb-2016)")
                     
                     ,verbatimTextOutput("code1")
                     
                     ,br()
                     
                    # ,source('DevData02.R', local=TRUE)$value
                     )#END tabpanel
           ,tabPanel("3. Code - Sentiment Analysis",
                     headerPanel(title="3. Code - Sentiment Analysis") 
                     ,tags$hr()
                     ,p("Here I have outlined the R code utilised for the sentiment analysis performed on each Tweet extract")
                     
                     ,verbatimTextOutput("code2")
                    # ,source('DevData03.R', local=TRUE)$value
                     )#END tabpanel
    )#END navbarPage
  )#END fluidPage
)#END shinyUI