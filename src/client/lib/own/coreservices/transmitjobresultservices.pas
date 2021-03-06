unit transmitjobresultservices;

interface

uses coreconfigurations, coreservices, synacode, stkconstants,
     jobresulttables, jobqueuetables, servermanagers, loggers, identities, dbtablemanagers, workflowmanagers,
     SysUtils, Classes, DOM;


type TTransmitJobResultServiceThread = class(TTransmitServiceThread)
 public
  constructor Create(var servMan : TServerManager; proxy, port : String; var logger : TLogger;
                     var conf : TCoreConfiguration; var tableman : TDbTableManager; var workflowman : TWorkflowManager);
 protected
  procedure Execute; override;

 private
    jobresultrow_ : TDbJobResultRow;
    jobqueuerow_  : TDbJobQueueRow;
    workflowman_  : TWorkflowManager;

    function  getPHPArguments() : AnsiString;
    procedure insertTransmission();
end;

implementation

constructor TTransmitJobResultServiceThread.Create(var servMan : TServerManager; proxy, port : String; var logger : TLogger;
                   var conf : TCoreConfiguration; var tableman : TDbTableManager; var workflowman : TWorkflowManager);
begin
 inherited Create(servMan, proxy, port, logger, '[TTransmitJobResultServiceThread]> ', conf, tableman);
 workflowman_  := workflowman;
end;

function TTransmitJobResultServiceThread.getPHPArguments() : AnsiString;
var rep : AnsiString;
begin
 rep := '';
 rep := rep+'jobqueueid='+encodeURL(jobresultrow_.jobqueueid)+'&';
 rep := rep+'jobid='+encodeURL(jobresultrow_.jobdefinitionid)+'&';
 rep := rep+'jobresultid='+encodeURL(jobresultrow_.jobresultid)+'&';
 rep := rep+'jobresult='+encodeURL(jobresultrow_.jobresult)+'&';
 rep := rep+'workunitresult='+encodeURL(jobresultrow_.workunitresult)+'&';
 rep := rep+'iserroneous='+encodeURL(BoolToStr(jobresultrow_.iserroneous))+'&';
 rep := rep+'errorid='+encodeURL(IntToStr(jobresultrow_.errorid))+'&';
 rep := rep+'errorarg='+encodeURL(jobresultrow_.errorarg)+'&';
 rep := rep+'errormsg='+encodeURL(jobresultrow_.errormsg)+'&';
 rep := rep+'nodeid='+encodeURL(myGPUId.nodeid)+'&';
 rep := rep+'nodename='+encodeURL(myGPUId.nodename)+'&';
 rep := rep+'walltime='+IntToStr(jobresultrow_.walltime);

 logger_.log(LVL_DEBUG, logHeader_+'Reporting string is:');
 logger_.log(LVL_DEBUG, rep);
 Result := rep;
end;

procedure TTransmitJobResultServiceThread.insertTransmission();
begin
 jobresultrow_.server_id := srv_.id;
 tableman_.getJobResultTable().insertOrUpdate(jobresultrow_);
 jobqueuerow_.serverstatus:='COMPLETED';
 jobqueuerow_.update_dt:=Now;
 tableman_.getJobQueueTable().insertOrUpdate(jobqueuerow_);
 logger_.log(LVL_DEBUG, logHeader_+'Updated or added '+IntToStr(jobresultrow_.id)+' to TBJOBRESULT table.');
end;


procedure TTransmitJobResultServiceThread.Execute;
begin
   if not workflowman_.getClientJobQueueWorkflow().findRowInStatusForResultTransmission(jobqueuerow_) then
         begin
           logger_.log(LVL_DEBUG, logHeader_+'No jobs found in status FOR_RESULT_TRANSMISSION. Exit.');
           done_      := True;
           erroneous_ := false;
           Exit;
         end;

  // retrieve jobresult for this jobqueue
  if not tableman_.getJobResultTable().findRowWithJobQueueId(jobresultrow_, jobqueuerow_.jobqueueid) then
         begin
           logger_.log(LVL_SEVERE, logHeader_+'Internal error: Could not find jobresult with jobqueueid '+jobqueuerow_.jobqueueid+' although jobqueue is in status WORKUNIT_TRANSMITTED!');
           done_      := True;
           erroneous_ := True;
           Exit;
         end;

 workflowman_.getClientJobQueueWorkflow().changeStatusFromForResultTransmissionToTransmittingResult(jobqueuerow_);
 setServer(jobqueuerow_.server_id);
 transmit('/jobqueue/report_jobresult.php?'+getPHPArguments(), false);
 if not erroneous_ then
    begin
        insertTransmission();
        workflowman_.getClientJobQueueWorkflow().changeStatusFromTransmittingResultToCompleted(jobqueuerow_);
        finishTransmit('Jobresult transmitted, this job went through the full workflow and reached the COMPLETED status :-)');
    end
   else
    begin
        workflowman_.getClientJobQueueWorkflow().changeStatusToError(jobqueuerow_, logHeader_+'Could not transmit jobresult!');
        finishTransmit('Could not transmit jobresult :-(');
    end;

end;

end.
