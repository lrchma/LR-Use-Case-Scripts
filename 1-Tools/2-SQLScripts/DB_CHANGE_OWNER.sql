
/*
 * LogRhythm Dark Spare Scripts
 * 03/04/2012
 * 
 * Step 7 - Set DB owner of restored DBs back to SA
 * This is run against the Dark Spare to reset the DB owner to SA
 *
 * Version History
 * v1.10 - MF - Added CMDB 20/06/20
 *
 *
 */

USE LogrhythmEMDB;
EXEC SP_CHANGEDBOWNER sa

USE LogRhythm_Alarms;
EXEC SP_CHANGEDBOWNER sa

USE LogRhythm_Events;
EXEC SP_CHANGEDBOWNER sa

USE LogRhythm_LogMart;
EXEC SP_CHANGEDBOWNER sa

USE LogRhythm_CMDB;
EXEC SP_CHANGEDBOWNER sa
