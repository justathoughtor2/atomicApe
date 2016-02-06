#!/bin/sh
V="5.0.6"
prefix=/usr
infodir=${prefix}/share/info
docdir=${prefix}/share/doc
manifest=/etc/preremove/zsh-manifest.lst

[ -f $manifest ] || (echo "Unable to find manifest file" && exit 0)

echo "*** Removing unmodified profiles."
echo "*** These will be updated by the postinstall script."
echo "*** Please wait."

while read f; do
  fSrc1=/etc/defaults/${f}
  fSrc2=${docdir}/zsh-$V/StartupFiles/${f}
  fDest=/${f}
  /bin/cmp -s ${fDest} "${fSrc1}" && \
    (echo /$f hasn\'t been modified, it will be updated ; \
     /bin/rm -f "/${f}")
  /bin/cmp -s ${fDest} "${fSrc2}" && \
    (echo /$f hasn\'t been modified, it will be updated ; \
     /bin/rm -f "/${f}")
done < ${manifest}
