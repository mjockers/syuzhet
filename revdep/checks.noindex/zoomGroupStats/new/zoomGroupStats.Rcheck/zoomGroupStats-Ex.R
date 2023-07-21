pkgname <- "zoomGroupStats"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('zoomGroupStats')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("aggSentiment")
### * aggSentiment

flush(stderr()); flush(stdout())

### Name: aggSentiment
### Title: Helper function to aggregate sentiment variables
### Aliases: aggSentiment

### ** Examples

agg.out = aggSentiment(inputData=sample_transcript_sentiment_aws, 
meetingId="batchMeetingId", speakerId = "userId", sentMethod="aws")

agg.out = aggSentiment(inputData=sample_chat_sentiment_syu, 
meetingId="batchMeetingId", speakerId = "userName", sentMethod="syuzhet")



cleanEx()
nameEx("batchGrabVideoStills")
### * batchGrabVideoStills

flush(stderr()); flush(stdout())

### Name: batchGrabVideoStills
### Title: Batch process video files, breaking them into stills
### Aliases: batchGrabVideoStills

### ** Examples

vidBatchInfo = batchGrabVideoStills(batchInfo=sample_batch_info,
imageDir=tempdir(), overWriteDir=TRUE, sampleWindow=2)
## Not run: 
##D vidBatchInfo = batchGrabVideoStills(batchInfo=zoomOut$batchInfo,
##D imageDir="~/Documents/myMeetings/videoImages", overWriteDir=TRUE,  sampleWindow=600)
## End(Not run)



cleanEx()
nameEx("batchProcessZoomOutput")
### * batchProcessZoomOutput

flush(stderr()); flush(stdout())

### Name: batchProcessZoomOutput
### Title: Batch process files that have been downloaded from Zoom
### Aliases: batchProcessZoomOutput

### ** Examples

batchOut = batchProcessZoomOutput(batchInput=system.file('extdata', 
'myMeetingsBatch.xlsx', package = 'zoomGroupStats'), 
exportZoomRosetta=file.path(tempdir(),"_rosetta.xlsx"))




cleanEx()
nameEx("batchVideoFaceAnalysis")
### * batchVideoFaceAnalysis

flush(stderr()); flush(stdout())

### Name: batchVideoFaceAnalysis
### Title: Batch analyze faces in videos
### Aliases: batchVideoFaceAnalysis

### ** Examples

## Not run: 
##D   vidOut = batchVideoFaceAnalysis(batchInfo=zoomOut$batchInfo, 
##D   imageDir="~/Documents/meetingImages",
##D   sampleWindow = 300)
## End(Not run)



cleanEx()
nameEx("createZoomRosetta")
### * createZoomRosetta

flush(stderr()); flush(stdout())

### Name: createZoomRosetta
### Title: Create a file to aid in adding a unique identifier to link to
###   the zoom user name
### Aliases: createZoomRosetta

### ** Examples

rosetta.out = createZoomRosetta(processZoomOutput(fileRoot=
file.path(system.file('extdata', package = 'zoomGroupStats'),"meeting001")))
## Not run: 
##D rosetta.out = createZoomRosetta(processZoomOutput(fileRoot="~/zoomMeetings/meeting001"))
## End(Not run)



cleanEx()
nameEx("grabVideoStills")
### * grabVideoStills

flush(stderr()); flush(stdout())

### Name: grabVideoStills
### Title: Helper function to split a video into still frames
### Aliases: grabVideoStills

### ** Examples

vidOut = grabVideoStills(inputVideo=system.file('extdata', "meeting001_video.mp4", 
package = 'zoomGroupStats'), imageDir=tempdir(), overWriteDir=TRUE, sampleWindow=2)
## Not run: 
##D grabVideoStills(inputVideo='myMeeting.mp4', 
##D imageDir="~/Documents/myMeetings/videoImages", overWriteDir=TRUE,  sampleWindow=45)
## End(Not run)



cleanEx()
nameEx("importZoomRosetta")
### * importZoomRosetta

flush(stderr()); flush(stdout())

### Name: importZoomRosetta
### Title: Helper function to add unique identifiers to processed Zoom
###   downloads
### Aliases: importZoomRosetta

### ** Examples

batchOutIds = importZoomRosetta(zoomOutput=
batchProcessZoomOutput(batchInput=system.file('extdata', 
'myMeetingsBatch.xlsx', package = 'zoomGroupStats')), 
zoomRosetta=system.file('extdata', 
'myMeetingsBatch_rosetta_edited.xlsx', package = 'zoomGroupStats'), 
meetingId="batchMeetingId")

## Not run: 
##D batchOutIds = importZoomRosetta(zoomOutput=batchOut, zoomRosetta="myEditedRosetta.xlsx", 
##D meetingId="batchMeetingId")
## End(Not run)



cleanEx()
nameEx("makeTimeWindows")
### * makeTimeWindows

flush(stderr()); flush(stdout())

### Name: makeTimeWindows
### Title: Helper function that creates temporal windows in datasets
### Aliases: makeTimeWindows

### ** Examples

win.out = makeTimeWindows(sample_transcript_processed, 
timeVar="utteranceStartSeconds", windowSize=10)



cleanEx()
nameEx("processZoomChat")
### * processZoomChat

flush(stderr()); flush(stdout())

### Name: processZoomChat
### Title: Process a Zoom chat file
### Aliases: processZoomChat

### ** Examples

ch.out = processZoomChat(
fname=system.file('extdata', "meeting001_chat.txt", package = 'zoomGroupStats'), 
sessionStartDateTime = '2020-04-20 13:30:00', 
languageCode = 'en')



cleanEx()
nameEx("processZoomOutput")
### * processZoomOutput

flush(stderr()); flush(stdout())

### Name: processZoomOutput
### Title: Wrapper function to process the raw files from Zoom in a single
###   call
### Aliases: processZoomOutput

### ** Examples

zoomOut = processZoomOutput(fileRoot=file.path(
system.file('extdata', package = 'zoomGroupStats'),"meeting001"
), rosetta=TRUE)
## Not run: 
##D zoomOut = processZoomOutput(fileRoot="~/zoomMeetings/myMeeting", rosetta=TRUE)
## End(Not run)



cleanEx()
nameEx("processZoomParticipantsInfo")
### * processZoomParticipantsInfo

flush(stderr()); flush(stdout())

### Name: processZoomParticipantsInfo
### Title: Process participant information from a Zoom meeting export
### Aliases: processZoomParticipantsInfo

### ** Examples

partInfo = processZoomParticipantsInfo(
system.file('extdata', "meeting001_participants.csv", package = 'zoomGroupStats')
)



cleanEx()
nameEx("processZoomTranscript")
### * processZoomTranscript

flush(stderr()); flush(stdout())

### Name: processZoomTranscript
### Title: Process Zoom transcript file
### Aliases: processZoomTranscript

### ** Examples

tr.out = processZoomTranscript(
fname=system.file('extdata', 'meeting001_transcript.vtt', package = 'zoomGroupStats'), 
recordingStartDateTime = '2020-04-20 13:30:00', languageCode = 'en')



cleanEx()
nameEx("textConversationAnalysis")
### * textConversationAnalysis

flush(stderr()); flush(stdout())

### Name: textConversationAnalysis
### Title: Analyze conversation attributes
### Aliases: textConversationAnalysis

### ** Examples

convo.out = textConversationAnalysis(inputData=sample_transcript_processed, 
inputType='transcript', meetingId='batchMeetingId', 
speakerId='userName', sentMethod="none")

convo.out = textConversationAnalysis(inputData=sample_transcript_sentiment_syu, 
inputType='transcript', meetingId='batchMeetingId', 
speakerId='userName', sentMethod="syuzhet")

convo.out = textConversationAnalysis(inputData=sample_chat_sentiment_aws, 
inputType='chat', meetingId='batchMeetingId', 
speakerId='userName', sentMethod="aws")

## Not run: 
##D convo.out = textConversationAnalysis(inputData=sample_transcript_sentiment_aws, 
##D inputType='transcript', meetingId='batchMeetingId', 
##D speakerId='userName', sentMethod="aws")
##D 
##D convo.out = textConversationAnalysis(inputData=sample_transcript_sentiment_syu, 
##D inputType='transcript', meetingId='batchMeetingId', 
##D speakerId='userName', sentMethod="syuzhet")
##D 
##D convo.out = textConversationAnalysis(inputData=sample_chat_processed, 
##D inputType='chat', meetingId='batchMeetingId', 
##D speakerId='userName', sentMethod="none")
##D 
##D convo.out = textConversationAnalysis(inputData=sample_chat_sentiment_aws, 
##D inputType='chat', meetingId='batchMeetingId', 
##D speakerId='userName', sentMethod="aws")
##D 
##D convo.out = textConversationAnalysis(inputData=sample_chat_sentiment_syu, 
##D inputType='chat',meetingId='batchMeetingId',  
##D speakerId='userName', sentMethod="syuzhet")
## End(Not run)



cleanEx()
nameEx("textSentiment")
### * textSentiment

flush(stderr()); flush(stdout())

### Name: textSentiment
### Title: Conduct a sentiment analysis on text data
### Aliases: textSentiment

### ** Examples

sent.out = textSentiment(inputData=sample_chat_processed,
idVars=c('batchMeetingId', 'messageId'), 
textVar='message', sentMethods='syuzhet',appendOut=TRUE,
languageCodeVar='messageLanguage')

## Not run: 
##D sent.out = textSentiment(inputData=sample_transcript_processed, 
##D idVars=c('batchMeetingId','utteranceId'), 
##D textVar='utteranceMessage', sentMethods=c('aws','syuzhet'), 
##D appendOut=TRUE, languageCodeVar='utteranceLanguage')
## End(Not run)




cleanEx()
nameEx("turnTaking")
### * turnTaking

flush(stderr()); flush(stdout())

### Name: turnTaking
### Title: Simple conversational turn-taking analysis
### Aliases: turnTaking

### ** Examples

turn.out = turnTaking(inputData=sample_transcript_processed, 
inputType='transcript', meetingId='batchMeetingId', 
speakerId='userName')

turn.out = turnTaking(inputData=sample_chat_processed, 
inputType='chat', meetingId='batchMeetingId', 
speakerId='userName')




cleanEx()
nameEx("videoFaceAnalysis")
### * videoFaceAnalysis

flush(stderr()); flush(stdout())

### Name: videoFaceAnalysis
### Title: Analyze the facial features within an exported Zoom video file
### Aliases: videoFaceAnalysis

### ** Examples

## Not run: 
##D vid.out = videoFaceAnalysis(inputVideo="meeting001_video.mp4", 
##D recordingStartDateTime="2020-04-20 13:30:00", 
##D sampleWindow=1, facesCollectionID="group-r",
##D videoImageDirectory="~/Documents/meetingImages", 
##D grabVideoStills=FALSE, overWriteDir=FALSE)
## End(Not run)



cleanEx()
nameEx("windowedTextConversationAnalysis")
### * windowedTextConversationAnalysis

flush(stderr()); flush(stdout())

### Name: windowedTextConversationAnalysis
### Title: Run a windowed analysis on either a Zoom transcript or chat This
###   function conducts a temporal window analysis on the conversation in
###   either a Zoom transcript or chat. It replicates the
###   textConversationAnalysis function across a set of windows at a window
###   size specified by the user.
### Aliases: windowedTextConversationAnalysis

### ** Examples

win.text.out = windowedTextConversationAnalysis(inputData=sample_transcript_sentiment_aws, 
inputType="transcript", meetingId="batchMeetingId", speakerId="userName", sentMethod="aws", 
timeVar="utteranceStartSeconds", windowSize=600)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
