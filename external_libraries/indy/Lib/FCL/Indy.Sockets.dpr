library Indy.Sockets;

{%DelphiDotNetAssemblyCompiler '$(SystemRoot)\microsoft.net\framework\v1.1.4322\System.dll'}
{%DelphiDotNetAssemblyCompiler 'Mono.Security.dll'}


uses
  Indy.Sockets.IdASN1Util in 'Indy.Sockets.IdASN1Util.pas',
  Indy.Sockets.IdAllFTPListParsers in 'Indy.Sockets.IdAllFTPListParsers.pas',
  Indy.Sockets.IdAntiFreezeBase in 'Indy.Sockets.IdAntiFreezeBase.pas',
  Indy.Sockets.IdAssignedNumbers in 'Indy.Sockets.IdAssignedNumbers.pas',
  Indy.Sockets.IdAttachment in 'Indy.Sockets.IdAttachment.pas',
  Indy.Sockets.IdAttachmentFile in 'Indy.Sockets.IdAttachmentFile.pas',
  Indy.Sockets.IdAttachmentMemory in 'Indy.Sockets.IdAttachmentMemory.pas',
  Indy.Sockets.IdAuthentication in 'Indy.Sockets.IdAuthentication.pas',
  Indy.Sockets.IdAuthenticationDigest in 'Indy.Sockets.IdAuthenticationDigest.pas',
  Indy.Sockets.IdAuthenticationManager in 'Indy.Sockets.IdAuthenticationManager.pas',
  Indy.Sockets.IdBaseComponent in 'Indy.Sockets.IdBaseComponent.pas',
  Indy.Sockets.IdBuffer in 'Indy.Sockets.IdBuffer.pas',
  Indy.Sockets.IdCarrierStream in 'Indy.Sockets.IdCarrierStream.pas',
  Indy.Sockets.IdChargenServer in 'Indy.Sockets.IdChargenServer.pas',
  Indy.Sockets.IdChargenUDPServer in 'Indy.Sockets.IdChargenUDPServer.pas',
  Indy.Sockets.IdCharsets in 'Indy.Sockets.IdCharsets.pas',
  Indy.Sockets.IdCmdTCPClient in 'Indy.Sockets.IdCmdTCPClient.pas',
  Indy.Sockets.IdCmdTCPServer in 'Indy.Sockets.IdCmdTCPServer.pas',
  Indy.Sockets.IdCoder in 'Indy.Sockets.IdCoder.pas',
  Indy.Sockets.IdCoder00E in 'Indy.Sockets.IdCoder00E.pas',
  Indy.Sockets.IdCoder3to4 in 'Indy.Sockets.IdCoder3to4.pas',
  Indy.Sockets.IdCoderBinHex4 in 'Indy.Sockets.IdCoderBinHex4.pas',
  Indy.Sockets.IdCoderHeader in 'Indy.Sockets.IdCoderHeader.pas',
  Indy.Sockets.IdCoderMIME in 'Indy.Sockets.IdCoderMIME.pas',
  Indy.Sockets.IdCoderQuotedPrintable in 'Indy.Sockets.IdCoderQuotedPrintable.pas',
  Indy.Sockets.IdCoderUUE in 'Indy.Sockets.IdCoderUUE.pas',
  Indy.Sockets.IdCoderXXE in 'Indy.Sockets.IdCoderXXE.pas',
  Indy.Sockets.IdCommandHandlers in 'Indy.Sockets.IdCommandHandlers.pas',
  Indy.Sockets.IdComponent in 'Indy.Sockets.IdComponent.pas',
  Indy.Sockets.IdConnectThroughHttpProxy in 'Indy.Sockets.IdConnectThroughHttpProxy.pas',
  Indy.Sockets.IdContainers in 'Indy.Sockets.IdContainers.pas',
  Indy.Sockets.IdContext in 'Indy.Sockets.IdContext.pas',
  Indy.Sockets.IdCookie in 'Indy.Sockets.IdCookie.pas',
  Indy.Sockets.IdCookieManager in 'Indy.Sockets.IdCookieManager.pas',
  Indy.Sockets.IdCustomHTTPServer in 'Indy.Sockets.IdCustomHTTPServer.pas',
  Indy.Sockets.IdCustomTCPServer in 'Indy.Sockets.IdCustomTCPServer.pas',
  Indy.Sockets.IdCustomTransparentProxy in 'Indy.Sockets.IdCustomTransparentProxy.pas',
  Indy.Sockets.IdDICT in 'Indy.Sockets.IdDICT.pas',
  Indy.Sockets.IdDICTCommon in 'Indy.Sockets.IdDICTCommon.pas',
  Indy.Sockets.IdDICTServer in 'Indy.Sockets.IdDICTServer.pas',
  Indy.Sockets.IdDNSCommon in 'Indy.Sockets.IdDNSCommon.pas',
  Indy.Sockets.IdDNSResolver in 'Indy.Sockets.IdDNSResolver.pas',
  Indy.Sockets.IdDNSServer in 'Indy.Sockets.IdDNSServer.pas',
  Indy.Sockets.IdDateTimeStamp in 'Indy.Sockets.IdDateTimeStamp.pas',
  Indy.Sockets.IdDayTime in 'Indy.Sockets.IdDayTime.pas',
  Indy.Sockets.IdDayTimeServer in 'Indy.Sockets.IdDayTimeServer.pas',
  Indy.Sockets.IdDayTimeUDP in 'Indy.Sockets.IdDayTimeUDP.pas',
  Indy.Sockets.IdDayTimeUDPServer in 'Indy.Sockets.IdDayTimeUDPServer.pas',
  Indy.Sockets.IdDiscardServer in 'Indy.Sockets.IdDiscardServer.pas',
  Indy.Sockets.IdDiscardUDPServer in 'Indy.Sockets.IdDiscardUDPServer.pas',
  Indy.Sockets.IdEMailAddress in 'Indy.Sockets.IdEMailAddress.pas',
  Indy.Sockets.IdEcho in 'Indy.Sockets.IdEcho.pas',
  Indy.Sockets.IdEchoServer in 'Indy.Sockets.IdEchoServer.pas',
  Indy.Sockets.IdEchoUDP in 'Indy.Sockets.IdEchoUDP.pas',
  Indy.Sockets.IdEchoUDPServer in 'Indy.Sockets.IdEchoUDPServer.pas',
  Indy.Sockets.IdException in 'Indy.Sockets.IdException.pas',
  Indy.Sockets.IdExceptionCore in 'Indy.Sockets.IdExceptionCore.pas',
  Indy.Sockets.IdExplicitTLSClientServerBase in 'Indy.Sockets.IdExplicitTLSClientServerBase.pas',
  Indy.Sockets.IdFSP in 'Indy.Sockets.IdFSP.pas',
  Indy.Sockets.IdFTP in 'Indy.Sockets.IdFTP.pas',
  Indy.Sockets.IdFTPBaseFileSystem in 'Indy.Sockets.IdFTPBaseFileSystem.pas',
  Indy.Sockets.IdFTPCommon in 'Indy.Sockets.IdFTPCommon.pas',
  Indy.Sockets.IdFTPList in 'Indy.Sockets.IdFTPList.pas',
  Indy.Sockets.IdFTPListOutput in 'Indy.Sockets.IdFTPListOutput.pas',
  Indy.Sockets.IdFTPListParseAS400 in 'Indy.Sockets.IdFTPListParseAS400.pas',
  Indy.Sockets.IdFTPListParseBase in 'Indy.Sockets.IdFTPListParseBase.pas',
  Indy.Sockets.IdFTPListParseBullGCOS7 in 'Indy.Sockets.IdFTPListParseBullGCOS7.pas',
  Indy.Sockets.IdFTPListParseBullGCOS8 in 'Indy.Sockets.IdFTPListParseBullGCOS8.pas',
  Indy.Sockets.IdFTPListParseChameleonNewt in 'Indy.Sockets.IdFTPListParseChameleonNewt.pas',
  Indy.Sockets.IdFTPListParseCiscoIOS in 'Indy.Sockets.IdFTPListParseCiscoIOS.pas',
  Indy.Sockets.IdFTPListParseDistinctTCPIP in 'Indy.Sockets.IdFTPListParseDistinctTCPIP.pas',
  Indy.Sockets.IdFTPListParseEPLF in 'Indy.Sockets.IdFTPListParseEPLF.pas',
  Indy.Sockets.IdFTPListParseHellSoft in 'Indy.Sockets.IdFTPListParseHellSoft.pas',
  Indy.Sockets.IdFTPListParseKA9Q in 'Indy.Sockets.IdFTPListParseKA9Q.pas',
  Indy.Sockets.IdFTPListParseMPEiX in 'Indy.Sockets.IdFTPListParseMPEiX.pas',
  Indy.Sockets.IdFTPListParseMVS in 'Indy.Sockets.IdFTPListParseMVS.pas',
  Indy.Sockets.IdFTPListParseMicrowareOS9 in 'Indy.Sockets.IdFTPListParseMicrowareOS9.pas',
  Indy.Sockets.IdFTPListParseMusic in 'Indy.Sockets.IdFTPListParseMusic.pas',
  Indy.Sockets.IdFTPListParseNCSAForDOS in 'Indy.Sockets.IdFTPListParseNCSAForDOS.pas',
  Indy.Sockets.IdFTPListParseNCSAForMACOS in 'Indy.Sockets.IdFTPListParseNCSAForMACOS.pas',
  Indy.Sockets.IdFTPListParseNovellNetware in 'Indy.Sockets.IdFTPListParseNovellNetware.pas',
  Indy.Sockets.IdFTPListParseNovellNetwarePSU in 'Indy.Sockets.IdFTPListParseNovellNetwarePSU.pas',
  Indy.Sockets.IdFTPListParseOS2 in 'Indy.Sockets.IdFTPListParseOS2.pas',
  Indy.Sockets.IdFTPListParseStercomOS390Exp in 'Indy.Sockets.IdFTPListParseStercomOS390Exp.pas',
  Indy.Sockets.IdFTPListParseStercomUnixEnt in 'Indy.Sockets.IdFTPListParseStercomUnixEnt.pas',
  Indy.Sockets.IdFTPListParseStratusVOS in 'Indy.Sockets.IdFTPListParseStratusVOS.pas',
  Indy.Sockets.IdFTPListParseSuperTCP in 'Indy.Sockets.IdFTPListParseSuperTCP.pas',
  Indy.Sockets.IdFTPListParseTOPS20 in 'Indy.Sockets.IdFTPListParseTOPS20.pas',
  Indy.Sockets.IdFTPListParseTSXPlus in 'Indy.Sockets.IdFTPListParseTSXPlus.pas',
  Indy.Sockets.IdFTPListParseTandemGuardian in 'Indy.Sockets.IdFTPListParseTandemGuardian.pas',
  Indy.Sockets.IdFTPListParseUnix in 'Indy.Sockets.IdFTPListParseUnix.pas',
  Indy.Sockets.IdFTPListParseVM in 'Indy.Sockets.IdFTPListParseVM.pas',
  Indy.Sockets.IdFTPListParseVMS in 'Indy.Sockets.IdFTPListParseVMS.pas',
  Indy.Sockets.IdFTPListParseVSE in 'Indy.Sockets.IdFTPListParseVSE.pas',
  Indy.Sockets.IdFTPListParseVxWorks in 'Indy.Sockets.IdFTPListParseVxWorks.pas',
  Indy.Sockets.IdFTPListParseWfFTP in 'Indy.Sockets.IdFTPListParseWfFTP.pas',
  Indy.Sockets.IdFTPListParseWinQVTNET in 'Indy.Sockets.IdFTPListParseWinQVTNET.pas',
  Indy.Sockets.IdFTPListParseWindowsNT in 'Indy.Sockets.IdFTPListParseWindowsNT.pas',
  Indy.Sockets.IdFTPListParseXecomMicroRTOS in 'Indy.Sockets.IdFTPListParseXecomMicroRTOS.pas',
  Indy.Sockets.IdFTPListTypes in 'Indy.Sockets.IdFTPListTypes.pas',
  Indy.Sockets.IdFTPServer in 'Indy.Sockets.IdFTPServer.pas',
  Indy.Sockets.IdFTPServerContextBase in 'Indy.Sockets.IdFTPServerContextBase.pas',
  Indy.Sockets.IdFinger in 'Indy.Sockets.IdFinger.pas',
  Indy.Sockets.IdFingerServer in 'Indy.Sockets.IdFingerServer.pas',
  Indy.Sockets.IdGlobal in 'Indy.Sockets.IdGlobal.pas',
  Indy.Sockets.IdGlobalCore in 'Indy.Sockets.IdGlobalCore.pas',
  Indy.Sockets.IdGlobalProtocols in 'Indy.Sockets.IdGlobalProtocols.pas',
  Indy.Sockets.IdGopher in 'Indy.Sockets.IdGopher.pas',
  Indy.Sockets.IdGopherConsts in 'Indy.Sockets.IdGopherConsts.pas',
  Indy.Sockets.IdGopherServer in 'Indy.Sockets.IdGopherServer.pas',
  Indy.Sockets.IdHL7 in 'Indy.Sockets.IdHL7.pas',
  Indy.Sockets.IdHTTP in 'Indy.Sockets.IdHTTP.pas',
  Indy.Sockets.IdHTTPHeaderInfo in 'Indy.Sockets.IdHTTPHeaderInfo.pas',
  Indy.Sockets.IdHTTPProxyServer in 'Indy.Sockets.IdHTTPProxyServer.pas',
  Indy.Sockets.IdHTTPServer in 'Indy.Sockets.IdHTTPServer.pas',
  Indy.Sockets.IdHash in 'Indy.Sockets.IdHash.pas',
  Indy.Sockets.IdHashCRC in 'Indy.Sockets.IdHashCRC.pas',
  Indy.Sockets.IdHashElf in 'Indy.Sockets.IdHashElf.pas',
  Indy.Sockets.IdHashMessageDigest in 'Indy.Sockets.IdHashMessageDigest.pas',
  Indy.Sockets.IdHashSHA1 in 'Indy.Sockets.IdHashSHA1.pas',
  Indy.Sockets.IdHeaderList in 'Indy.Sockets.IdHeaderList.pas',
  Indy.Sockets.IdIMAP4 in 'Indy.Sockets.IdIMAP4.pas',
  Indy.Sockets.IdIMAP4Server in 'Indy.Sockets.IdIMAP4Server.pas',
  Indy.Sockets.IdIOHandler in 'Indy.Sockets.IdIOHandler.pas',
  Indy.Sockets.IdIOHandlerSocket in 'Indy.Sockets.IdIOHandlerSocket.pas',
  Indy.Sockets.IdIOHandlerStack in 'Indy.Sockets.IdIOHandlerStack.pas',
  Indy.Sockets.IdIOHandlerStream in 'Indy.Sockets.IdIOHandlerStream.pas',
  Indy.Sockets.IdIOHandlerTls in 'Indy.Sockets.IdIOHandlerTls.pas',
  Indy.Sockets.IdIPAddrMon in 'Indy.Sockets.IdIPAddrMon.pas',
  Indy.Sockets.IdIPAddress in 'Indy.Sockets.IdIPAddress.pas',
  Indy.Sockets.IdIPMCastBase in 'Indy.Sockets.IdIPMCastBase.pas',
  Indy.Sockets.IdIPMCastClient in 'Indy.Sockets.IdIPMCastClient.pas',
  Indy.Sockets.IdIPMCastServer in 'Indy.Sockets.IdIPMCastServer.pas',
  Indy.Sockets.IdIPWatch in 'Indy.Sockets.IdIPWatch.pas',
  Indy.Sockets.IdIRC in 'Indy.Sockets.IdIRC.pas',
  Indy.Sockets.IdIcmpClient in 'Indy.Sockets.IdIcmpClient.pas',
  Indy.Sockets.IdIdent in 'Indy.Sockets.IdIdent.pas',
  Indy.Sockets.IdIdentServer in 'Indy.Sockets.IdIdentServer.pas',
  Indy.Sockets.IdIntercept in 'Indy.Sockets.IdIntercept.pas',
  Indy.Sockets.IdInterceptSimLog in 'Indy.Sockets.IdInterceptSimLog.pas',
  Indy.Sockets.IdInterceptThrottler in 'Indy.Sockets.IdInterceptThrottler.pas',
  Indy.Sockets.IdIrcServer in 'Indy.Sockets.IdIrcServer.pas',
  Indy.Sockets.IdLPR in 'Indy.Sockets.IdLPR.pas',
  Indy.Sockets.IdLogBase in 'Indy.Sockets.IdLogBase.pas',
  Indy.Sockets.IdLogDebug in 'Indy.Sockets.IdLogDebug.pas',
  Indy.Sockets.IdLogEvent in 'Indy.Sockets.IdLogEvent.pas',
  Indy.Sockets.IdLogFile in 'Indy.Sockets.IdLogFile.pas',
  Indy.Sockets.IdLogStream in 'Indy.Sockets.IdLogStream.pas',
  Indy.Sockets.IdMIMETypes in 'Indy.Sockets.IdMIMETypes.pas',
  Indy.Sockets.IdMailBox in 'Indy.Sockets.IdMailBox.pas',
  Indy.Sockets.IdMappedFTP in 'Indy.Sockets.IdMappedFTP.pas',
  Indy.Sockets.IdMappedPOP3 in 'Indy.Sockets.IdMappedPOP3.pas',
  Indy.Sockets.IdMappedPortTCP in 'Indy.Sockets.IdMappedPortTCP.pas',
  Indy.Sockets.IdMappedPortUDP in 'Indy.Sockets.IdMappedPortUDP.pas',
  Indy.Sockets.IdMappedTelnet in 'Indy.Sockets.IdMappedTelnet.pas',
  Indy.Sockets.IdMessage in 'Indy.Sockets.IdMessage.pas',
  Indy.Sockets.IdMessageClient in 'Indy.Sockets.IdMessageClient.pas',
  Indy.Sockets.IdMessageCoder in 'Indy.Sockets.IdMessageCoder.pas',
  Indy.Sockets.IdMessageCoderMIME in 'Indy.Sockets.IdMessageCoderMIME.pas',
  Indy.Sockets.IdMessageCoderQuotedPrintable in 'Indy.Sockets.IdMessageCoderQuotedPrintable.pas',
  Indy.Sockets.IdMessageCoderUUE in 'Indy.Sockets.IdMessageCoderUUE.pas',
  Indy.Sockets.IdMessageCoderXXE in 'Indy.Sockets.IdMessageCoderXXE.pas',
  Indy.Sockets.IdMessageCoderYenc in 'Indy.Sockets.IdMessageCoderYenc.pas',
  Indy.Sockets.IdMessageCollection in 'Indy.Sockets.IdMessageCollection.pas',
  Indy.Sockets.IdMessageParts in 'Indy.Sockets.IdMessageParts.pas',
  Indy.Sockets.IdMultipartFormData in 'Indy.Sockets.IdMultipartFormData.pas',
  Indy.Sockets.IdNNTP in 'Indy.Sockets.IdNNTP.pas',
  Indy.Sockets.IdNNTPServer in 'Indy.Sockets.IdNNTPServer.pas',
  Indy.Sockets.IdNetworkCalculator in 'Indy.Sockets.IdNetworkCalculator.pas',
  Indy.Sockets.IdOSFileName in 'Indy.Sockets.IdOSFileName.pas',
  Indy.Sockets.IdOTPCalculator in 'Indy.Sockets.IdOTPCalculator.pas',
  Indy.Sockets.IdObjs in 'Indy.Sockets.IdObjs.pas',
  Indy.Sockets.IdObjsBase in 'Indy.Sockets.IdObjsBase.pas',
  Indy.Sockets.IdObjsFCL in 'Indy.Sockets.IdObjsFCL.pas',
  Indy.Sockets.IdPOP3 in 'Indy.Sockets.IdPOP3.pas',
  Indy.Sockets.IdPOP3Server in 'Indy.Sockets.IdPOP3Server.pas',
  Indy.Sockets.IdQOTDUDP in 'Indy.Sockets.IdQOTDUDP.pas',
  Indy.Sockets.IdQOTDUDPServer in 'Indy.Sockets.IdQOTDUDPServer.pas',
  Indy.Sockets.IdQotd in 'Indy.Sockets.IdQotd.pas',
  Indy.Sockets.IdQotdServer in 'Indy.Sockets.IdQotdServer.pas',
  Indy.Sockets.IdRSH in 'Indy.Sockets.IdRSH.pas',
  Indy.Sockets.IdRSHServer in 'Indy.Sockets.IdRSHServer.pas',
  Indy.Sockets.IdRawBase in 'Indy.Sockets.IdRawBase.pas',
  Indy.Sockets.IdRawClient in 'Indy.Sockets.IdRawClient.pas',
  Indy.Sockets.IdRawFunctions in 'Indy.Sockets.IdRawFunctions.pas',
  Indy.Sockets.IdRawHeaders in 'Indy.Sockets.IdRawHeaders.pas',
  Indy.Sockets.IdRemoteCMDClient in 'Indy.Sockets.IdRemoteCMDClient.pas',
  Indy.Sockets.IdRemoteCMDServer in 'Indy.Sockets.IdRemoteCMDServer.pas',
  Indy.Sockets.IdReply in 'Indy.Sockets.IdReply.pas',
  Indy.Sockets.IdReplyFTP in 'Indy.Sockets.IdReplyFTP.pas',
  Indy.Sockets.IdReplyIMAP4 in 'Indy.Sockets.IdReplyIMAP4.pas',
  Indy.Sockets.IdReplyPOP3 in 'Indy.Sockets.IdReplyPOP3.pas',
  Indy.Sockets.IdReplyRFC in 'Indy.Sockets.IdReplyRFC.pas',
  Indy.Sockets.IdReplySMTP in 'Indy.Sockets.IdReplySMTP.pas',
  Indy.Sockets.IdResourceStrings in 'Indy.Sockets.IdResourceStrings.pas',
  Indy.Sockets.IdResourceStringsCore in 'Indy.Sockets.IdResourceStringsCore.pas',
  Indy.Sockets.IdResourceStringsProtocols in 'Indy.Sockets.IdResourceStringsProtocols.pas',
  Indy.Sockets.IdRexec in 'Indy.Sockets.IdRexec.pas',
  Indy.Sockets.IdRexecServer in 'Indy.Sockets.IdRexecServer.pas',
  Indy.Sockets.IdSASL in 'Indy.Sockets.IdSASL.pas',
  Indy.Sockets.IdSASLAnonymous in 'Indy.Sockets.IdSASLAnonymous.pas',
  Indy.Sockets.IdSASLCollection in 'Indy.Sockets.IdSASLCollection.pas',
  Indy.Sockets.IdSASLExternal in 'Indy.Sockets.IdSASLExternal.pas',
  Indy.Sockets.IdSASLLogin in 'Indy.Sockets.IdSASLLogin.pas',
  Indy.Sockets.IdSASLOTP in 'Indy.Sockets.IdSASLOTP.pas',
  Indy.Sockets.IdSASLPlain in 'Indy.Sockets.IdSASLPlain.pas',
  Indy.Sockets.IdSASLSKey in 'Indy.Sockets.IdSASLSKey.pas',
  Indy.Sockets.IdSASLUserPass in 'Indy.Sockets.IdSASLUserPass.pas',
  Indy.Sockets.IdSASL_CRAM_MD5 in 'Indy.Sockets.IdSASL_CRAM_MD5.pas',
  Indy.Sockets.IdSMTP in 'Indy.Sockets.IdSMTP.pas',
  Indy.Sockets.IdSMTPBase in 'Indy.Sockets.IdSMTPBase.pas',
  Indy.Sockets.IdSMTPRelay in 'Indy.Sockets.IdSMTPRelay.pas',
  Indy.Sockets.IdSMTPServer in 'Indy.Sockets.IdSMTPServer.pas',
  Indy.Sockets.IdSNPP in 'Indy.Sockets.IdSNPP.pas',
  Indy.Sockets.IdSSL in 'Indy.Sockets.IdSSL.pas',
  Indy.Sockets.IdScheduler in 'Indy.Sockets.IdScheduler.pas',
  Indy.Sockets.IdSchedulerOfThread in 'Indy.Sockets.IdSchedulerOfThread.pas',
  Indy.Sockets.IdSchedulerOfThreadDefault in 'Indy.Sockets.IdSchedulerOfThreadDefault.pas',
  Indy.Sockets.IdSchedulerOfThreadPool in 'Indy.Sockets.IdSchedulerOfThreadPool.pas',
  Indy.Sockets.IdServerIOHandler in 'Indy.Sockets.IdServerIOHandler.pas',
  Indy.Sockets.IdServerIOHandlerSocket in 'Indy.Sockets.IdServerIOHandlerSocket.pas',
  Indy.Sockets.IdServerIOHandlerStack in 'Indy.Sockets.IdServerIOHandlerStack.pas',
  Indy.Sockets.IdServerIOHandlerTls in 'Indy.Sockets.IdServerIOHandlerTls.pas',
  Indy.Sockets.IdServerInterceptLogBase in 'Indy.Sockets.IdServerInterceptLogBase.pas',
  Indy.Sockets.IdServerInterceptLogEvent in 'Indy.Sockets.IdServerInterceptLogEvent.pas',
  Indy.Sockets.IdServerInterceptLogFile in 'Indy.Sockets.IdServerInterceptLogFile.pas',
  Indy.Sockets.IdSimpleServer in 'Indy.Sockets.IdSimpleServer.pas',
  Indy.Sockets.IdSocketHandle in 'Indy.Sockets.IdSocketHandle.pas',
  Indy.Sockets.IdSocketStream in 'Indy.Sockets.IdSocketStream.pas',
  Indy.Sockets.IdSocks in 'Indy.Sockets.IdSocks.pas',
  Indy.Sockets.IdStack in 'Indy.Sockets.IdStack.pas',
  Indy.Sockets.IdStackConsts in 'Indy.Sockets.IdStackConsts.pas',
  Indy.Sockets.IdStackDotNet in 'Indy.Sockets.IdStackDotNet.pas',
  Indy.Sockets.IdStream in 'Indy.Sockets.IdStream.pas',
  Indy.Sockets.IdStreamNET in 'Indy.Sockets.IdStreamNET.pas',
  Indy.Sockets.IdStrings in 'Indy.Sockets.IdStrings.pas',
  Indy.Sockets.IdStruct in 'Indy.Sockets.IdStruct.pas',
  Indy.Sockets.IdSync in 'Indy.Sockets.IdSync.pas',
  Indy.Sockets.IdSys in 'Indy.Sockets.IdSys.pas',
  Indy.Sockets.IdSysBase in 'Indy.Sockets.IdSysBase.pas',
  Indy.Sockets.IdSysLog in 'Indy.Sockets.IdSysLog.pas',
  Indy.Sockets.IdSysLogMessage in 'Indy.Sockets.IdSysLogMessage.pas',
  Indy.Sockets.IdSysLogServer in 'Indy.Sockets.IdSysLogServer.pas',
  Indy.Sockets.IdSysNet in 'Indy.Sockets.IdSysNet.pas',
  Indy.Sockets.IdSystat in 'Indy.Sockets.IdSystat.pas',
  Indy.Sockets.IdSystatServer in 'Indy.Sockets.IdSystatServer.pas',
  Indy.Sockets.IdSystatUDP in 'Indy.Sockets.IdSystatUDP.pas',
  Indy.Sockets.IdSystatUDPServer in 'Indy.Sockets.IdSystatUDPServer.pas',
  Indy.Sockets.IdTCPClient in 'Indy.Sockets.IdTCPClient.pas',
  Indy.Sockets.IdTCPConnection in 'Indy.Sockets.IdTCPConnection.pas',
  Indy.Sockets.IdTCPServer in 'Indy.Sockets.IdTCPServer.pas',
  Indy.Sockets.IdTCPStream in 'Indy.Sockets.IdTCPStream.pas',
  Indy.Sockets.IdTask in 'Indy.Sockets.IdTask.pas',
  Indy.Sockets.IdTelnet in 'Indy.Sockets.IdTelnet.pas',
  Indy.Sockets.IdTelnetServer in 'Indy.Sockets.IdTelnetServer.pas',
  Indy.Sockets.IdText in 'Indy.Sockets.IdText.pas',
  Indy.Sockets.IdThread in 'Indy.Sockets.IdThread.pas',
  Indy.Sockets.IdThreadComponent in 'Indy.Sockets.IdThreadComponent.pas',
  Indy.Sockets.IdThreadSafe in 'Indy.Sockets.IdThreadSafe.pas',
  Indy.Sockets.IdTime in 'Indy.Sockets.IdTime.pas',
  Indy.Sockets.IdTimeServer in 'Indy.Sockets.IdTimeServer.pas',
  Indy.Sockets.IdTimeUDP in 'Indy.Sockets.IdTimeUDP.pas',
  Indy.Sockets.IdTimeUDPServer in 'Indy.Sockets.IdTimeUDPServer.pas',
  Indy.Sockets.IdTlsClientOptions in 'Indy.Sockets.IdTlsClientOptions.pas',
  Indy.Sockets.IdTlsServerOptions in 'Indy.Sockets.IdTlsServerOptions.pas',
  Indy.Sockets.IdTraceRoute in 'Indy.Sockets.IdTraceRoute.pas',
  Indy.Sockets.IdTrivialFTP in 'Indy.Sockets.IdTrivialFTP.pas',
  Indy.Sockets.IdTrivialFTPBase in 'Indy.Sockets.IdTrivialFTPBase.pas',
  Indy.Sockets.IdTrivialFTPServer in 'Indy.Sockets.IdTrivialFTPServer.pas',
  Indy.Sockets.IdUDPBase in 'Indy.Sockets.IdUDPBase.pas',
  Indy.Sockets.IdUDPClient in 'Indy.Sockets.IdUDPClient.pas',
  Indy.Sockets.IdUDPServer in 'Indy.Sockets.IdUDPServer.pas',
  Indy.Sockets.IdURI in 'Indy.Sockets.IdURI.pas',
  Indy.Sockets.IdUnixTime in 'Indy.Sockets.IdUnixTime.pas',
  Indy.Sockets.IdUnixTimeServer in 'Indy.Sockets.IdUnixTimeServer.pas',
  Indy.Sockets.IdUnixTimeUDP in 'Indy.Sockets.IdUnixTimeUDP.pas',
  Indy.Sockets.IdUnixTimeUDPServer in 'Indy.Sockets.IdUnixTimeUDPServer.pas',
  Indy.Sockets.IdUserAccounts in 'Indy.Sockets.IdUserAccounts.pas',
  Indy.Sockets.IdUserPassProvider in 'Indy.Sockets.IdUserPassProvider.pas',
  Indy.Sockets.IdVCard in 'Indy.Sockets.IdVCard.pas',
  Indy.Sockets.IdWhoIsServer in 'Indy.Sockets.IdWhoIsServer.pas',
  Indy.Sockets.IdWhois in 'Indy.Sockets.IdWhois.pas',
  Indy.Sockets.IdYarn in 'Indy.Sockets.IdYarn.pas',
  Indy.Sockets.IdZLibCompressorBase in 'Indy.Sockets.IdZLibCompressorBase.pas',
  Indy.Sockets.IdAssemblyInfo in 'Indy.Sockets.IdAssemblyInfo.pas';

//
// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Revision and Build Numbers
// by using the '*' as shown below:


//
// In order to sign your assembly you must specify a key to use. Refer to the
// Microsoft .NET Framework documentation for more information on assembly signing.
//
// Use the attributes below to control which key is used for signing.
//
// Notes:
//   (*) If no key is specified, the assembly is not signed.
//   (*) KeyName refers to a key that has been installed in the Crypto Service
//       Provider (CSP) on your machine. KeyFile refers to a file which contains
//       a key.
//   (*) If the KeyFile and the KeyName values are both specified, the
//       following processing occurs:
//       (1) If the KeyName can be found in the CSP, that key is used.
//       (2) If the KeyName does not exist and the KeyFile does exist, the key
//           in the KeyFile is installed into the CSP and used.
//   (*) In order to create a KeyFile, you can use the sn.exe (Strong Name) utility.
//       When specifying the KeyFile, the location of the KeyFile should be
//       relative to the project output directory. For example, if your KeyFile is
//       located in the project directory, you would specify the AssemblyKeyFile
//       attribute as [assembly: AssemblyKeyFile('mykey.snk')], provided your output
//       directory is the project directory (the default).
//   (*) Delay Signing is an advanced option - see the Microsoft .NET Framework
//       documentation for more information on this.
//

//
// Use the attributes below to control the COM visibility of your assembly. By
// default the entire assembly is visible to COM. Setting ComVisible to false
// is the recommended default for your assembly. To then expose a class and interface
// to COM set ComVisible to true on each one. It is also recommended to add a
// Guid attribute.
//

//[assembly: Guid(')]
//[assembly: TypeLibVersion(1, 0)]

begin

end.