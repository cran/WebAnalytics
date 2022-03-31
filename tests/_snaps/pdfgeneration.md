# pdf is generated from sample data

    Code
      system(paste0("cmd /c cd ", wkdir, "& powershell -f makerpt.ps1 minimum"))
    Output
      [1] 0

# pdf is generated using pdfGenerate

    Code
      pdfGenerate(workDir = wkdir, configFile = "minimum.config")
    Warning <simpleWarning>
      Configuration file contains unused variables extractFile
      'C:\Users\greg\AppData\Local\Temp\RtmpeW49YY\minconfigtemp' already exists
    Message <simpleMessage>
      Config Variables Set
      config.author Greg Hunt
      config.current.columnList MSTimestamp             
      ignored: s-ip           
      httpop                  
      url                     
      ignored: cs-uri-query   
      ignored: s-port         
      ignored: cs-username    
      userip                  
      useragent               
      ignored: cs(Referer)    
      httpcode                
      ignored: sc-substatus   
      ignored: sc-win32-status
      elapsedms               
      config.current.dataDir C:\Users\greg\AppData\Local\Temp\RtmpeW49YY/minconfigtemp
      config.current.dirNames .
      config.documentName Subproject/Issue
      config.generateDiagnosticPlots FALSE
      config.generateGraphForTimeOver 10000
      config.generatePercentileRankings FALSE
      config.generateServerSessionStats TRUE
      config.generateTransactionDetails TRUE
      config.projectName Client/Project
      config.readBaseline FALSE
      config.securityClass Commercial-In-Confidence
      config.useragent.discardOther TRUE
      config.useragent.generateFrequencies FALSE
      config.useragent.maximumPercentile 96
      config.useragent.minimumPercentage 2
      column list being read
      msdatepartmstimepartignored: s-iphttpopurlignored: cs-uri-queryignored: s-portignored: cs-usernameuseripuseragentignored: cs(Referer)httpcodeignored: sc-substatusignored: sc-win32-statuselapsedms
    Warning <simpleWarning>
      40 y values <= 0 omitted from logarithmic plot
    Warning <rlang_warning>
      Removed 2 rows containing missing values (geom_bar).
      Removed 2 rows containing missing values (geom_bar).
    Warning <simpleWarning>
      37 y values <= 0 omitted from logarithmic plot
    Warning <rlang_warning>
      Removed 2 rows containing missing values (geom_bar).
      Removed 2 rows containing missing values (geom_bar).
    Output
      [1] "minimum20220330214318.pdf"

