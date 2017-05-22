
/*
 * LogRhythm Dark Spare Scripts
 * 13/02/2014
 * 
 * Step 6 - Reset Trustworthy flag source to true
 * This is run against the Dark Spare
 * Required to set this flag on or else errors ensue
 *
 * Version History
 * v1.10 - MF - Added CMDB 20/06/20
 *
 */

USE LogRhythmEMDB;
ALTER DATABASE LogRhythmEMDB SET TRUSTWORTHY ON

USE LogRhythm_Alarms;
ALTER DATABASE Logrhythm_Alarms SET TRUSTWORTHY ON;

USE LogRhythm_Events;
ALTER DATABASE LogRhythm_Events SET TRUSTWORTHY ON;

USE LogRhythm_LogMart;
ALTER DATABASE LogRhythm_LogMart SET TRUSTWORTHY ON;

USE LogRhythm_CMDB;
ALTER DATABASE LogRhythm_CMDB SET TRUSTWORTHY ON;