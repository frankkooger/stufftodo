#!/bin/bash
#
# backup script voor firebase met gbak
#
# Shutdown the database
# Doe geen shutdown want gbak doet reguliere dbasebevraginen
#
#gfix -shut full -attach 0 ./administratie.fdb -USER SYSDBA -PASSWORD OpenAdmin.nl

# Doe een backup
#
#gbak -USER SYSDBA -PASSWORD "OpenAdmin.nl" -B -T ./administratie.fdb ./bup.administratie.fdb
gbak -USER SYSDBA -PASSWORD "OpenAdmin.nl" -V -T ./administratie.fdb ./administratie.fbk

# Put online again
#
#gfix -online ./administratie.fdb -USER SYSDBA -PASSWORD OpenAdmin.nl

