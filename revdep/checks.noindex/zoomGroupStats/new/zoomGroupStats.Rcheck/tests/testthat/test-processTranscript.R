test_that("Transcript parsing yields correct records", {
  tr.out = processZoomTranscript(fname=system.file('extdata', "meeting001_transcript.vtt", package = 'zoomGroupStats'), recordingStartDateTime = '2020-04-20 13:30:00',languageCode = 'en')
  
  expect_equal(nrow(tr.out), 300)
  expect_equal(length(unique(tr.out$userName)), 6)
  expect_equal(lubridate::is.POSIXct(tr.out$utteranceStartTime), TRUE)
  expect_equal(lubridate::is.POSIXct(tr.out$utteranceEndTime), TRUE)  
  expect_equal(is.numeric(tr.out$utteranceStartSeconds), TRUE)
  expect_equal(is.numeric(tr.out$utteranceEndSeconds), TRUE)  
})
