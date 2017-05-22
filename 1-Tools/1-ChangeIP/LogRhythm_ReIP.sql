USE LogRhythmEMDB

GO
/* Update the DB Server Specified for the Mediator(s) */
/* This can be set manually from the LogRhythm Console - */
/* Deploymeng Manager -> Data Processors -> (open properties for the data processor(s)) Advanced -> Mediator / General / ServerIP */
Declare @RowNum int, @MediatorID int
Select @MediatorID = MAX(MediatorID) from dbo.Mediator --Start with the highest record ID
Select @RowNum = Count(*) from dbo.Mediator --Get the total number of records
WHILE @RowNum > 0
BEGIN
  UPDATE dbo.Mediator
  SET   DBServer = '$(IP)', ServerIP = '$(IP)'  
  WHERE MediatorID = @MediatorID
  /* added by Cameron */
  /* Also update the ClientAddress within the Mediator config for the AIE */
  /* ...as with the Mediator ServerIP, this */
  /* Can be manually changed from LogRhythm Console -> Data Processors -> properties of each data processor -> Advanced */
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'

  UPDATE dbo.Mediator
  SET DataProviderConfig = REPLACE(DataProviderConfig, @OLDIP, @NEWIP )
  WHERE DataProviderConfig like ('%' + @OLDIP + '%')

  Select top 1 @MediatorID = MediatorID FROM dbo.Mediator 
  WHERE MediatorID < @MediatorID ORDER By MediatorID desc --Get the next row in the loop
  set @RowNum = @RowNum - 1                               --decrease count
END
PRINT N'Committing IP update for Mediator ServerIP & AIE Provider ClientAddress'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

GO
/* Update the HostIdentifier(s) */
BEGIN
  UPDATE dbo.HostIdentifier
  SET Value = '$(IP)'    
  WHERE Value = '$(OLDIP)'
END
PRINT N'Committing IP update for HostIdentifier(s)'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

GO
/* Update the System Monitor to Mediator Record */
/* This will update the ClientIP of the System Monitor Agent that is on the XM / PM box itself */
/* This can be manually updated from the System Monitor Configuration tool where the agent resides */
/* And from the LogRhythm Console -> Deploymeng Manager -> System Monitors -> properties of the agent -> Data Processor Settings */
BEGIN
  UPDATE dbo.SystemMonitorToMediator
  SET ClientAddress = '$(IP)'    
  WHERE ClientAddress = '$(OLDIP)'
END
PRINT N'Committing IP update for System Monitor ClientAddress Record'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

/* Update the System Monitor records for NetflowServerNIC, sFlowServerNIC, and SyslogServerNIC, SNMPLocalIP (if set to an IP rather than 0)  */
/* These settings are available within the LogRhythm Console -> Deployment Manager -> System Monitors -> Properties of the agent */
/* In 'Advanced' for the flow IPs and in the SNMP Trap Receiver tab for SNMP. */
BEGIN
/* cameron to double check whether SQL syntax allows me to set multiple options within a single Update statement */
  UPDATE dbo.SystemMonitor
  SET SyslogServerNIC = '$(IP)'    
  WHERE SyslogServerNIC = '$(OLDIP)'
  
  UPDATE dbo.SystemMonitor
  SET sFlowServerNIC = '$(IP)'    
  WHERE sFlowServerNIC = '$(OLDIP)'
  
  UPDATE dbo.SystemMonitor
  SET NetflowServerNIC = '$(IP)'    
  WHERE NetflowServerNIC = '$(OLDIP)'
  
  UPDATE dbo.SystemMonitor
  SET SNMPLocalIP = '$(IP)'    
  WHERE SNMPLocalIP = '$(OLDIP)'
END
PRINT N'Committing IP update for System Monitor IP records for NetflowServerNIC, sFlowServerNIC, and SyslogServerNIC, SNMPLocalIP (if set to an IP rather than 0)  '
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END


GO
/* Cameron added: dbo.AIEDataProvider*/
/* search & replace the ProviderConfig string, which is XML*/
BEGIN
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'
  UPDATE dbo.AIEDataProvider
  SET ProviderConfig = REPLACE(ProviderConfig, @OLDIP, @NEWIP )
  WHERE ProviderConfig like ('%' + @OLDIP + '%')
END
PRINT N'Committing IP update for AIE Data Provider'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END


Go
/* Cameron added: update Config field in dbo.AIEServer (it's XML) e.g. */
/*<?xml version="1.0"?>  <AIEServerConfig xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">    <ServerAddress>192.168.0.150</ServerAddress>  </AIEServerConfig>*/
/* this instance of the IP can be manually changed from the LogRhythm Console - AI Engine -> Servers -> properties of the AI Engine host.*/
BEGIN
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'
  UPDATE dbo.AIEServer
  SET Config = REPLACE(Config, @OLDIP, @NEWIP )
  WHERE Config like ('%' + @OLDIP + '%')
END
PRINT N'Committing IP update for AIE Server'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

/* Cameron added: dbo.AIEComMgr  e.g. */
/*<?xml version="1.0"?>  <AIEDataProviderReceiverConfig xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">    <ClientAddress />    <ClientMgmtPort>0</ClientMgmtPort>    <ClientDataPort>0</ClientDataPort>    <SkipSendingIPValidation>false</SkipSendingIPValidation>    <ServerAddress />  </AIEDataProviderReceiverConfig>*/
BEGIN
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'
  UPDATE dbo.AIECommgr
  SET Config = REPLACE(Config, @OLDIP, @NEWIP )
  WHERE Config like ('%' + @OLDIP + '%')
END
PRINT N'Committing IP update for AIE Communication Manager'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

/* Cameron added: dbo.ARM e.g. */
/* AlarmURL */
/* http://localhost:80/alarms/ */
BEGIN
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'
  UPDATE dbo.ARM
  SET AlarmURL = REPLACE(AlarmURL, @OLDIP, @NEWIP )
  WHERE AlarmURL like ('%' + @OLDIP + '%')
END
PRINT N'Committing IP update for AlarmURL'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END

/* Cameron added: dbo.ARM e.g. */
/* CaseAPIURL */
/* http://localhost */
BEGIN
  Declare @OLDIP nvarchar(max), @NEWIP nvarchar(max); Set @OLDIP = '$(OLDIP)'; Set @NEWIP = '$(IP)'
  UPDATE dbo.ARM
  SET CaseAPIURL = REPLACE(CaseAPIURL, @OLDIP, @NEWIP )
  WHERE CaseAPIURL like ('%' + @OLDIP + '%')
END
PRINT N'Committing IP update for CaseAPIURL'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 
BEGIN
  PRINT N'An error has occured:' + @@ERROR
  ROLLBACK TRANSACTION   
END
