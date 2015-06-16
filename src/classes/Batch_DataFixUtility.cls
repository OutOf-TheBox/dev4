public class Batch_DataFixUtility
{
public static String body1 = 'Nimble Storage is pleased to announce our release of NimbleOS version 2.0.7.0.0 General Availability (GA) release.  NimbleOS 2.0.7.0 has been made available for all production arrays. <br/> It is imperative ' +
'you carefully read the Nimble OS 1.4 to 2.x Update Guide and Release Notes before proceeding. Please see the <font color="red">IMPORTANT UPDATE NOTES</font> section below before installing this update.<br/> The following host integration ' +
'toolkits are <b>strongly</b> recommended to be installed on all Windows/VMware hosts:<br/><br/>' +
'<ul><li> New: Nimble Windows Toolkit 2.0.7.0 - including Nimble Connection Manager (NCM) for Windows</li>' +
'<li>New: Nimble Connection Manager (NCM) for VMware 2.0.7.0</li></ul><br/><br/>' +
'Note: NCM provides resilient, automated multi-pathing and connection management for VMware and Windows environments even for single array groups.<br/>' +
'Note: When installing or upgrading NWT or NCM for VMware, hosts machines will need to either enter a maintenance mode or be rebooted.<br/><br/>' +
'<font color="red"><b>Release Notes (READ ME FIRST)</font></b><br/>' +
'Release notes contain important update pre-requisite information and should be reviewed before starting any software update process.<br/><br/>' +
'<ul><li>All release notes and software for NimbleOS and Host Integration are available on the InfoSight download page.</li>' +
'<li>The Nimble Storage Software Release Model is also available on the Nimble InfoSight download page under the Support Policies section.</li><br/><br/>' +
'Please click here <a href="https://infosight.nimblestorage.com/infosight/download">Click Here</a> or the Nimble InfoSight download page.<br/>' + 
'While NimbleOS 2.0.7.0 has been made available generally available, the following arrays are blocked from this update due to a suspect configuration issue that will prevent a clean update to NimbleOS 2.0.7.0:<br/>' ;
public static String body2 = 'Nimble Storage has opened a support case to track this issue. Please reply-all to this email or contact Nimble Support directly and refer to the case number shown in the above table to determine appropriate steps for updating the listed arrays to NimbleOS 2.0.7.0<br/><br/><br/>' +
'NimbleOS 2.0.8.0 expected to be available in the next two weeks, but the same restrictions will apply preventing update. <br/>Note: Nimble OS feature release 2.1 is currently in Release Candidate status and is expected to be a General Availability release in the next 2-3 months.<br/><br/><br/>' +
'<font color="red"><b>AutoSupport</b></font><br/>' + 
'Enabling AutoSupport allows Nimble Support to monitor the health of your arrays and proactively inform you of any critical issues that may arise. It also provides you with real-time performance and system sizing information through our InfoSight website.' +
'For more information on InfoSight, please visit our <a href="https://www.nimblestorage.com/infosight">website</a> or login to InfoSight <a href="https://infosight.nimblestorage.com">here</a><br/>' +
'This is how you turn on AutoSupport:<br/>' +
'<ol><li>Open the WebUI and click on Administration tab</li>' + 
'<li>Select AutoSupport/HTTP Proxy</li>' +
'<li>Check box for "Send AutoSupport data to Nimble Storage support" and click "Save"</li>' +
'<li>Click on "Test AutoSupport settings" to verify AutoSupport configuration</li>' +
'<li>Click on "Send AutoSupport" which will create an automated case with Nimble Support to verify end-to-end operation. You will be notified automatically when we receive the AutoSupport</li></ol><br/>' +


'<font color="red"><b>IMPORTANT UPDATE NOTES - DO NOT PROCEED WITHOUT FOLLOWING THESE STEPS</b></font></br>' +

'<ol><li>It\'s important you carefully review the Nimble OS 1.4 to 2.x Update Guide available on Nimble InfoSight before proceeding (<a href="https://infosight.nimblestorage.com/cgi-bin/viewPDFFile?ID=3Darray/2-0-6-0/Nimble_OS_2_0_4_update_quick_start_guide_2.0.x_PN960_0011_001.pdf">click here for document</a>).</li>' +
'<ul><li>Please do not proceed without understanding this thoroughly.</li><li>If you have any questions, please contact Nimble Support by FORWARDING this email along with your questions to <a href="mailto:support@nimblestorage.com">support@nimblestorage.com</a></li></ul>' +
'<li>Please carefully read the Nimble OS 2.0.7.0 and all Host Integration Toolkit release notes before proceeding as there are certain prerequisites that must be adhered to for proper and efficient operation. These documents are located on Nimble InfoSight download section ' +
'<a href="https://in=fosight.nimblestorage.com/infosight/download">located here</a>.</li>' +
'<li>Careful consideration and planning may be required to update your Array and Host servers to 2.0.7.0 software including hot-fixes on Windows hosts using iSCSI direct attached volumes.</li></ol><br/><br/>' +
'<font color="red"><b>Scale-out clustering</b></font><br/>' +
'Nimble Storage makes it easy to grow capacity and performance beyond the physical limitations of a single array with its scale-out cluster architecture. ' +
'Any combination of Nimble Storage CS-Series arrays can be seamlessly configured into a clustered storage system that can be managed as a single entity. ' +
'<ul><li>Scale-out is ideal for flexibly scaling storage to accommodate growing workloads and supporting new ones, without complicating storage management by creating additional silos or breaking the budget with forklift upgrades.</li> ' +
'<li>Nimble Storage\'s scale-out architecture features</li>' +
'<li>Resilient, automated multi-pathing and connection management for VMware and Windows environments even for single Array Groups</li>' + 
'<li>Automated load-balancing that enables linear performance scaling</li>' + 
'<li>Seamless cluster reconfiguration, hardware refreshes and array firmware upgrades</li>'+
'<li>Intuitive, single-pane-of-glass management console</li>' +
'<li>Fine-grain data striping which enables each application to leverage the full set of hardware resources across the cluster</li>' +
'<li>Automated cluster-wide space balancing which eliminates manual data  migrations as you grow/shrink the cluster, or as workloads scale</li>' +
'<li>Dynamically adapts to handle a much higher number of simultaneous replication streams than prior releases.</li>' +
'<li>Enhancements to Array and Group network configuration using the Management WebUI</li><br/>' +
'<font color="red"><b>Verified Update Paths</b></font><br/>'+
'NimbleOS version 2.0.7.0 is available for update using the Nimble GUI on the Administration::Software page for white-listed arrays only.<br/>Supported upgrade paths from the following releases are listed below:<br/>' +
'<table border="1"><tr><td>From Release</td><td>To Release</td></tr>' + 
'<tr><td>1.0.6.*</td><td>Contact Support</td></tr>' + 
'<tr><td>1.0.7.*</td><td>Contact Support</td></tr>' + 
'<tr><td>1.1.*.*</td><td>1.2.2.0</td></tr>' + 
'<tr><td>1.2.*.*</td><td>1.4.6.0</td></tr>' + 
'<tr><td>1.3.*.*</td><td>1.4.6.0</td></tr>' + 
'<tr><td>1.4.*.*</td><td>1.4.7.0</td></tr>' + 
'<tr><td>1.4.7.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>1.4.8.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>1.4.9.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>1.4.10.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>1.4.11.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>2.0.4.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>2.0.5.0</td><td>2.0.7.0</td></tr>' + 
'<tr><td>2.0.6.*</td><td>2.0.7.0</td></tr></table>' + 

'<br/>Regards,<br/>' +
'Nimble Support<br/>' + 
'1-877-3NIMBLE<br/>' +
'<a href="tel:408-432-9600">+1 408-432-9600</a><br/>' +
'<a href="mailto:support@nimblestorage.com">support@nimblestorage.com</a>';
}