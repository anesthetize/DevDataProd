Coursera Project - Developing Data Products
========================================================
author: Anand Gupta
date: 21 March 2016

Introduction
========================================================



This project provides a summary of case studies of Twitter sentiment analysis for a number of industries - Internet and Retail (FMCG, Technology and Beauty).  Please not that the retail case studies are specific to Australia.


The objective is to be able to use the Twitter Code yourself to evaluate and compare sentiment analysis of brands to aid in marketting and / or brand comparison w.r.t. user sentiment.

Further applications:
- evaluating an exact sentiment score based on frequency or sum of scores of positive keywords against all keywords
- evaluating frequency of specific words such as 'like','hate' trending across time


Twitter API - Limitations
========================================================

There are some limitations of the Twitter API that the user needs to be aware of:

- maximum of 2000 tweets can be retreived per keyword search
- the API does not permit you to perform searches historically (more than a month, I believe)
- there are always false-positives in the data that get retreived based on the search.
- for example, a Twitter data pull for keyword 'NAB' (National Australian Bank) is bound to retreive tweets involving roberries, i.e. - 'nab'
- the Twitter API may not work on most secure work networks, may require the user to employ their own cellular network



Case Studies
=======================================================
On the first tab the user will go through the following case studies:

Internet: Facebook, Google and LinkedIn

Retail - (Australia)
- Woolworths - www.woolworths.com.au
- Coles - www.coles.com.au
- JB Hi Fi - www.jbhifi.com.au
- EB Games - www.ebgames.com.au
- David Jones - www.davidjones.com.au
- Myer - www.myer.com.au

Functionality 
=======================================================
On the first tab the user will go through the following sub-tabs:

1. Raw Data from Twitter - this tab enables the user to view the data in a data-table as well as a visualisation of words mentioned in the tweets (having an overall minimum frequency of 10)

2. Parsed Data - this tab enables the user to visualise a word-cloud after the data has been parsed through an external data dictionary containing score words and associated sentiment scores.

3. Tree-Map - this tab enables the user to see a better representation of sentiment through the treemap visualisation.


The user can select the industry and the specific company listed.

R Codes
======================================================

The subsequent tabs contain all the relevant codes employed in the analysis and are fairly reproducible.

Tab 2 - codes for Twitter data retreival.

Kindly ensure you have created a Developer's account on dev.twitter.com and have created a dummy app as you will be required to input your dev account and app's credentials.

Tab 3 - codes for data wrangling for the word clouds and Tree map

Here I have chosen to employ the 'sqldf' package as SQL is fairly widely used by analysts and will make it easier to understand.
