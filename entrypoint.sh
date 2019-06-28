#!/bin/bash
# run as user asterisk
ASTERISK_USER=${ASTERISK_USER:-asterisk}
ASTERISK_DOMAIN=${ASTERISK_DOMAIN:-localhost.localdomin}
ASTERISK_ORG=${ASTERISK_ORG:-AcmeWidgets}

# Horrid insecure defaults CHANGEME
ARI_USER=${ASTERISK_USER:-asterisk}
ARI_PASSWORD=${ARI_PASSWORD:-asterisk}
ARI_APPLICATION=${ARI_APPLICATION:-myApp}

export ARI_USER ARI_PASSWORD ARI_APPLICATION

SUBST=" "
for VAR in $(env);
do
  IFS="=" read -r NAME VALUE <<<$VAR
  EVALUE=$(sed -e 's/\//\\\//g' <<<$VALUE)
  SUBST+=`printf "%ss/___%s___/%s/" " -e " "\\\$$NAME" "$EVALUE"`
done


if [ "$1" = "" ]; then
  COMMAND="/usr/sbin/asterisk -T -W -U ${ASTERISK_USER} -p -vvvdddf"
else
  COMMAND="$@"
fi

# Recursively copy any templated config files (with ENV substitution)
for DIR in /templates/all /templates/${TRUNK_TYPE}
do
  if [ -d ${DIR} ]; then
    cd ${DIR}
    for FILE in `find . -type f -print`
    do
      echo $DIR $FILE
      echo sed $SUBST
      sed $SUBST <${FILE} >/${FILE}
    done
  else
    echo NO Template for ${DIR} - this is probably bad.
    exit 1;
  fi
done

if [ ! -d /etc/asterisk/keys ]; then
  mkdir /etc/asterisk/keys
  ast_tls_cert -C ${ASTERISK_DOMAIN} -O "${ASTERISK_ORG}" -d /etc/asterisk/keys
  chown -R asterisk.asterisk /etc/asterisk/keys
fi

if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
  # recreate user and group for asterisk
  deluser asterisk && \
  adduser --gecos "" --no-create-home --uid ${ASTERISK_UID} --disabled-password ${ASTERISK_USER} || exit
  chown -R ${ASTERISK_UID}:${ASTERISK_UID} /etc/asterisk \
                                           /var/*/asterisk \
                                           /usr/*/asterisk
fi

exec ${COMMAND}
