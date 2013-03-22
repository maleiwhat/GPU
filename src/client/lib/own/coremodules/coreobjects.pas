unit coreobjects;
{
 Defines a set of objects in common between mainapp (GUI) and core
 (c) 2011 by HB9TVM and the GPU project
}


interface

uses
  lockfiles, loggers, SysUtils,
  coreconfigurations, dbtablemanagers, servermanagers,
  coremodules, servicefactories, servicemanagers, compservicemanagers,
  workflowmanagers, identities, pluginmanagers, methodcontrollers,
  resultcollectors, frontendmanagers;

var
   logger         : TLogger;
   conf           : TCoreConfiguration;
   tableman       : TDbTableManager;
   serverman      : TServerManager;
   coremodule     : TCoreModule;
   servicefactory : TServiceFactory;
   serviceman     : TServiceThreadManager;
   compserviceman : TCompServiceThreadManager;
   workflowman    : TWorkflowManager;

   // lockfiles
   lf_morefrequentupdates : TLockFile;



procedure loadCoreObjects(logFile, componentname : String);
procedure discardCoreObjects;

implementation

procedure loadCoreObjects(logFile, componentname : String);
var
   path : String;
begin
  path := extractFilePath(ParamStr(0));

  logger    := TLogger.Create(path+PathDelim+'logs', logFile+'.log', logFile+'.old', LVL_DEBUG, 1024*1024);
  conf      := TCoreConfiguration.Create(path);
  conf.loadConfiguration();

  logger.setLogLevel(myConfId.loglevel);
  logger.logCR; logger.logCR;
  logger.logCR; logger.logCR;
  logger.logCR; logger.logCR;
  logger.logCR; logger.logCR;
  logger.logCR; logger.logCR;
  logger.logCR; logger.logCR;
  logger.log(LVL_INFO, '********************');
  logger.log(LVL_INFO, '* '+componentname+' launched ...');
  logger.log(LVL_INFO, '********************');


  tableman          := TDbTableManager.Create(path+PathDelim+'gpucore.db');
  tableman.OpenAll;
  serverman         := TServerManager.Create(conf, tableman.getServerTable(), logger);
  workflowman       := TWorkflowManager.Create(tableman, logger);

  coremodule        := TCoreModule.Create(logger, path, 'dll');
  servicefactory    := TServiceFactory.Create(workflowman, serverman, tableman, myConfId.proxy, myconfId.port, logger, conf, coremodule);
  serviceman        := TServiceThreadManager.Create(tmServiceStatus.maxthreads);
  compserviceman    := TCompServiceThreadManager.Create(tmCompStatus.maxthreads);

  lf_morefrequentupdates := TLockFile.Create(path+PathDelim+'locks', 'morefrequentchat.lock');

end;

procedure discardCoreObjects;
begin
  serviceman.free;
  compserviceman.Free;
  servicefactory.free;
  workflowman.free;
  coremodule.free;
  serverman.Free;
  tableman.CloseAll;
  tableman.Free;
  conf.Free;
  logger.Free;

  lf_morefrequentupdates.Free;
end;

end.
