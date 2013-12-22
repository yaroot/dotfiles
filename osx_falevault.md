
## change passphrase

    # list volumes first
    diskutil cs list

    # look for the uuid of the 'disk1' volume

    # now change it
    # double check new passhphrase
    diskutil cs passwd _uuid_ -oldpassphrase _old_ -newpassphrase _new_

    # close shell and shred your shell history

