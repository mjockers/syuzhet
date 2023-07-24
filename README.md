# Syuzhet
An R package for the extraction of sentiment and sentiment-based plot arcs from text.

The name "Syuzhet" comes from the Russian Formalists Victor Shklovsky and Vladimir Propp who divided narrative into two components, the "fabula" and the "syuzhet."  Syuzhet refers to the "device" or technique of a narrative whereas fabula is the chronological order of events.  Syuzhet, therefore, is concerned with the manner in which the elements of the story (fabula) are organized (syuzhet).

The Syuzhet package attempts to reveal the latent structure of narrative by means of sentiment analysis.  Instead of detecting shifts in the topic or subject matter of the narrative ([as Ben Schmidt has done](http://sappingattention.blogspot.com/2014/12/fundamental-plot-arcs-seen-through.html)), the Syuzhet package reveals the emotional shifts that serve as proxies for the narrative movement between conflict and conflict resolution.  This was an idea inspired by the late Kurt Vonnegut in an essay titled "Here's a Lesson in Creative Writing" in his collection *A Man Without A Country* ( Random House, 2007).  [A lecture Vonnegut gave on this subject is available via youTube](https://www.youtube.com/watch?v=oP3c1h8v2ZQ)

*Thanks to Lincoln Mullen for early feedback on this package (see http://rpubs.com/lmullen/58030)*.

## Installation

This package is now available on CRAN (http://cran.r-project.org/web/packages/syuzhet/). 

```R
install.packages("syuzhet")
```
You can install the most current development version from gitHub using the ```devtools``` package:

```R
# install.packages("devtools")
devtools::install_github("mjockers/syuzhet")
```
## References
Syuzhet incorporates four sentiment lexicons:

The default "Syuzhet" lexicon was developed in the Nebraska Literary Lab under the direction of Matthew L. Jockers 

The "afinn" lexicon was developed by Finn Arup Nielsen as the AFINN WORD DATABASE
See: See http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010
The AFINN database of words is copyright protected and distributed under
"Open Database License (ODbL) v1.0" http://www.opendatacommons.org/licenses/odbl/1.0/ or a similar copyleft license.

The "bing" lexicon was develoepd by Minqing Hu and Bing Liu as the OPINION LEXICON
See: http://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html

The "nrc" lexicon was developed by Mohammad, Saif M. and Turney, Peter D. as the NRC EMOTION LEXICON.  
See: http://saifmohammad.com/WebPages/lexicons.html
The NRC EMOTION LEXICON is released under the following terms of use:
Terms of use:

1. This lexicon can be used freely for research purposes. 
2. The papers listed below provide details of the creation and use of 
   the lexicon. If you use a lexicon, then please cite the associated 
   papers.
3. If interested in commercial use of the lexicon, send email to the 
   contact. 
4. If you use the lexicon in a product or application, then please 
   credit the authors and NRC appropriately. Also, if you send us an 
   email, we will be thrilled to know about how you have used the 
   lexicon.
5. National Research Council Canada (NRC) disclaims any responsibility 
   for the use of the lexicon and does not provide technical support. 
   However, the contact listed above will be happy to respond to 
   queries and clarifications.
6. Rather than redistributing the data, please direct interested 
   parties to this page:
   http://www.purl.com/net/lexicons 

-- Crowdsourcing a Word-Emotion Association Lexicon, Saif Mohammad and
Peter Turney, To Appear in Computational Intelligence, Wiley Blackwell
Publishing Ltd.
    
-- Tracking Sentiment in Mail: How Genders Differ on Emotional Axes,
Saif Mohammad and Tony Yang, In Proceedings of the ACL 2011 Workshop
on ACL 2011 Workshop on Computational Approaches to Subjectivity and
Sentiment Analysis (WASSA), June 2011, Portland, OR.  Paper (pdf)
    
-- From Once Upon a Time to Happily Ever After: Tracking Emotions in
Novels and Fairy Tales, Saif Mohammad, In Proceedings of the ACL 2011
Workshop on Language Technology for Cultural Heritage, Social
Sciences, and Humanities (LaTeCH), June 2011, Portland, OR.  Paper
 	 
-- Emotions Evoked by Common Words and Phrases: Using Mechanical Turk
to Create an Emotion Lexicon", Saif Mohammad and Peter Turney, In
Proceedings of the NAACL-HLT 2010 Workshop on Computational Approaches
to Analysis and Generation of Emotion in Text, June 2010, LA,
California.

Links to the papers are available here:
http://www.purl.org/net/NRCemotionlexicon

**CONTACT INFORMATION**
Saif Mohammad
Research Officer, National Research Council Canada
email: saif.mohammad@nrc-cnrc.gc.ca
phone: +1-613-993-0620
