public without sharing class rmaTriggerUtilities
  {public static void setFa(RMAv2__c rmaToProcess)
     {String newFaLogicHistory;

      System.debug('DEBUG: ****************************************');
      System.debug('DEBUG: Timestamp                           = ' + System.now());
      System.debug('DEBUG: User ID                             = ' + UserInfo.getUserId());
      System.debug('DEBUG: User Name                           = ' + UserInfo.getName());
      System.debug('DEBUG: INPUTS:');
      System.debug('DEBUG: rmaType__c                          = ' + rmaToProcess.rmaType__c);
      System.debug('DEBUG: rmaAssetNrdIsInEffect__c            = ' + rmaToProcess.rmaAssetNrdIsInEffect__c);
      System.debug('DEBUG: rmaPartIsAShipOnlyPart__c           = ' + rmaToProcess.rmaPartIsAShipOnlyPart__c);
      System.debug('DEBUG: rmaAssetSla__c                      = ' + rmaToProcess.rmaAssetSla__c);
      System.debug('DEBUG: rmaCaseIsEngOrExecEscalated__c      = ' + rmaToProcess.rmaCaseIsEngOrExecEscalated__c);
      System.debug('DEBUG: rmaComponent__c                     = ' + rmaToProcess.rmaComponent__c);
      System.debug('DEBUG: rmaPartFailedWithinOpsTimePeriod__c = ' + rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c);
      System.debug('DEBUG: rmaFaRequired__c                    = ' + rmaToProcess.rmaFaRequired__c);
      System.debug('DEBUG: rmaOutgoingShipmentStatus__c        = ' + rmaToProcess.rmaOutgoingShipmentStatus__c);
      System.debug('DEBUG: rmaReturnShipmentStatus__c          = ' + rmaToProcess.rmaReturnShipmentStatus__c);
      System.debug('DEBUG: rmaRetShip2Status__c                = ' + rmaToProcess.rmaRetShip2Status__c);
      System.debug('DEBUG: rmaCustomerFaRequired__c            = ' + rmaToProcess.rmaCustomerFaRequired__c);
      System.debug('DEBUG: LOGIC DECISIONS:');

      newFaLogicHistory = rmaToProcess.rmaFaLogicHistory__c +
                          '\n****************************************\n' +
                          'Timestamp                           = ' + System.now() + '\n' +
                          'User ID                             = ' + UserInfo.getUserId() + '\n' +
                          'User Name                           = ' + UserInfo.getName() + '\n' +
                          'INPUTS:\n' +
                          'rmaType__c                          = ' + rmaToProcess.rmaType__c + '\n' +
                          'rmaAssetNrdIsInEffect__c            = ' + rmaToProcess.rmaAssetNrdIsInEffect__c + '\n' +
                          'rmaPartIsAShipOnlyPart__c           = ' + rmaToProcess.rmaPartIsAShipOnlyPart__c + '\n' +
                          'rmaAssetSla__c                      = ' + rmaToProcess.rmaAssetSla__c + '\n' +
                          'rmaCaseIsEngOrExecEscalated__c      = ' + rmaToProcess.rmaCaseIsEngOrExecEscalated__c + '\n' +
                          'rmaComponent__c                     = ' + rmaToProcess.rmaComponent__c + '\n' +
                          'rmaPartFailedWithinOpsTimePeriod__c = ' + rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c + '\n' +
                          'rmaFaRequired__c                    = ' + rmaToProcess.rmaFaRequired__c + '\n' +
                          'rmaOutgoingShipmentStatus__c        = ' + rmaToProcess.rmaOutgoingShipmentStatus__c + '\n' +
                          'rmaReturnShipmentStatus__c          = ' + rmaToProcess.rmaReturnShipmentStatus__c + '\n' +
                          'rmaRetShip2Status__c                = ' + rmaToProcess.rmaRetShip2Status__c + '\n' +
                          'rmaCustomerFaRequired__c            = ' + rmaToProcess.rmaCustomerFaRequired__c + '\n' +
                          'LOGIC DECISIONS:\n';

       // Type = "System/part return"
       if (rmaToProcess.rmaType__c == 'System/part return')
         {System.debug('DEBUG: HERE 0100 - Type = "System/part return"');
          newFaLogicHistory += 'HERE 0100 - Type = "System/part return"\n';

          rmaToProcess.rmaOrderType__c          = 'System/part return';
          rmaToProcess.rmaFaRequired__c         = 'No FA Required';
          rmaToProcess.rmaCustomerFaRequired__c = false;
         }

       // Asset NRD is in Effect
       else if (rmaToProcess.rmaAssetNrdIsInEffect__c == 'Yes')
         {System.debug('DEBUG: HERE 0200 - Asset NRD is in Effect');
          newFaLogicHistory += 'HERE 0200 - Asset NRD is in Effect\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Ship Only w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Ship Only';
            }

          rmaToProcess.rmaFaRequired__c           = 'No FA Required';
          rmaToProcess.rmaReturnShipmentStatus__c = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaRetShip2Status__c       = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaCustomerFaRequired__c   = false;
         }

       // Part is a Ship Only Part
       else if (rmaToProcess.rmaPartIsAShipOnlyPart__c == 'Yes')
         {System.debug('DEBUG: HERE 0300 - Part is a Ship Only Part');
          newFaLogicHistory += 'HERE 0300 - Part is a Ship Only Part\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Ship Only w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Ship Only';
            }

          rmaToProcess.rmaFaRequired__c           = 'No FA Required';
          rmaToProcess.rmaReturnShipmentStatus__c = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaRetShip2Status__c       = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaCustomerFaRequired__c   = false;
         }

       // Case is Engineering or Executive Escalated
       // NOTE: Per Alexander Pham's flowchart, marking
       //       the FA Required field as "Engineering FA" is
       //       no longer required just because the case is
       //       escalated.  Commented this out.
       //else if (rmaToProcess.rmaCaseIsEngOrExecEscalated__c)
       //  {System.debug('DEBUG: HERE 0400 - Case is Engineering or Executive Escalated');
       //   newFaLogicHistory += 'HERE 0400 - Case is Engineering or Executive Escalated\n';
       //
       //   if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
       //     {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
       //     }
       //   else
       //     {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
       //     }
       //
       //   rmaToProcess.rmaFaRequired__c = 'Engineering FA';
       //  }

       // Component = "SSD"
       else if (rmaToProcess.rmaComponent__c == 'SSD')
         {System.debug('DEBUG: HERE 0500 - Component = "SSD"');
          newFaLogicHistory += 'HERE 0500 - Component = "SSD"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }

          rmaToProcess.rmaFaRequired__c = 'Engineering FA';
         }

       // Part Failed within Ops Time Period
       //   and
       // FA Required is not "Engineering FA"
       else if (rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c == 'Yes' &&
                rmaToProcess.rmaFaRequired__c != 'Engineering FA')
         {System.debug('DEBUG: HERE 0600 - Part Failed within Ops Time Period and FA Required is not "Engineering FA"');
          newFaLogicHistory += 'HERE 0600 - Part Failed within Ops Time Period and FA Required is not "Engineering FA"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }

          rmaToProcess.rmaFaRequired__c = 'Operations FA';
         }

       // FA Required = "Engineering FA" or "Operations FA"
       else if (rmaToProcess.rmaFaRequired__c == 'Engineering FA' ||
                rmaToProcess.rmaFaRequired__c == 'Operations FA')
         {System.debug('DEBUG: HERE 0700 - FA Required = "Engineering FA" or "Operations FA"');
          newFaLogicHistory += 'HERE 0700 - FA Required = "Engineering FA" or "Operations FA"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }
         }

       // Asset SLA contains "Onsite"
       else if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
         {System.debug('DEBUG: HERE 0800 - Asset SLA contains "Onsite"');
          newFaLogicHistory += 'HERE 0800 - Asset SLA contains "Onsite"\n';

          rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Def Rtrn w/ Tech';
         }

       // Asset SLA does not contain "Onsite"
       // This section is the last block of logic, and will
       // catch all RMAs that didn't match earlier logic.
       else
         {System.debug('DEBUG: HERE 0900 - Asset SLA does not contain "Onsite"');
          newFaLogicHistory += 'HERE 0900 - Asset SLA does not contain "Onsite"\n';

          rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Defective Return';
         }

      System.debug('DEBUG: OUTPUTS:');
      System.debug('DEBUG: rmaOrderType__c              = ' + rmaToProcess.rmaOrderType__c);
      System.debug('DEBUG: rmaFaRequired__c             = ' + rmaToProcess.rmaFaRequired__c);
      System.debug('DEBUG: rmaOutgoingShipmentStatus__c = ' + rmaToProcess.rmaOutgoingShipmentStatus__c);
      System.debug('DEBUG: rmaReturnShipmentStatus__c   = ' + rmaToProcess.rmaReturnShipmentStatus__c);
      System.debug('DEBUG: rmaRetShip2Status__c         = ' + rmaToProcess.rmaRetShip2Status__c);
      System.debug('DEBUG: rmaCustomerFaRequired__c     = ' + rmaToProcess.rmaCustomerFaRequired__c);

      newFaLogicHistory += 'OUTPUTS:\n' +
                           'rmaOrderType__c              = ' + rmaToProcess.rmaOrderType__c + '\n' +
                           'rmaFaRequired__c             = ' + rmaToProcess.rmaFaRequired__c + '\n' +
                           'rmaOutgoingShipmentStatus__c = ' + rmaToProcess.rmaOutgoingShipmentStatus__c + '\n' +
                           'rmaReturnShipmentStatus__c   = ' + rmaToProcess.rmaReturnShipmentStatus__c + '\n' +
                           'rmaRetShip2Status__c         = ' + rmaToProcess.rmaRetShip2Status__c + '\n' +
                           'rmaCustomerFaRequired__c     = ' + rmaToProcess.rmaCustomerFaRequired__c;

      rmaToProcess.rmaFaLogicHistory__c = newFaLogicHistory.right(131072);

     }
  }