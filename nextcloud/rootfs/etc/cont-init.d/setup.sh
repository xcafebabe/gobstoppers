#!/usr/bin/with-contenv sh

#############
# Nextcloud #
#############

CONFIGFILE=/nextcloud/config/config.php
if [ ! -f $CONFIGFILE ]; then

  # Apply uid/gid mods
  OLDUID=`id -u nginx`
  OLDGID=`id -g nginx`
  NEWUID=${NGINX_UID:-${OLDUID}}
  NEWGID=${NGINX_GID:-${OLDGID}}
  echo "${NEWUID} uid selected for user nginx"
  echo "${NEWGID} gid selected for group nginx"

  usermod -u ${NEWUID} nginx
  groupmod -g ${NEWGID} nginx
  echo "Applied uid/gid mods"
  find /var /data /apps2 /nextcloud -user ${OLDUID} -exec chown -h ${NEWUID} {} \;
  echo "Applied chown"
  find /var /data /apps2 /nextcloud -group ${OLDGID} -exec chgrp -h ${NEWGID} {} \;
  echo "Applied chgrp"
  usermod -g ${NEWGID} nginx
  echo "Done uid/gid mods"

  # Create an initial configuration file.
  instanceid=next$(echo date | sha1sum | fold -w 10 | head -n 1)
  cat > $CONFIGFILE <<EOF;
<?php
\$CONFIG = array (
  'datadirectory' => '/data',

  "apps_paths" => array (
      0 => array (
              "path"     => "/nextcloud/apps",
              "url"      => "/apps",
              "writable" => false,
      ),
      1 => array (
              "path"     => "/apps2",
              "url"      => "/apps2",
              "writable" => true,
      ),
  ),

  'memcache.local' => '\OC\Memcache\APCu',
  'logtimezone' => '${TZ}',
  'logdateformat' => 'd-m-Y H:i:s',
  'instanceid' => '$instanceid',
);
?>
EOF
  chown nginx:nginx $CONFIGFILE
  echo "Created config file..."
fi


AUTOCONFIG=/nextcloud/config/autoconfig.php
if [ ! -f $AUTOCONFIG ]; then
  cat > $AUTOCONFIG <<EOF;
<?php
\$AUTOCONFIG = array (
  # storage/database
  'directory'     => '/data',
  'dbtype'        => '${DB_TYPE:-sqlite3}',
  'dbname'        => '${DB_NAME:-nextcloud}',
  'dbuser'        => '${DB_USER:-nextcloud}',
  'dbpass'        => '${DB_PASSWORD:-password}',
  'dbhost'        => '${DB_HOST:-nextcloud-db}',
  'dbtableprefix' => 'oc_',
  # create an administrator account with a random password so that
  # the user does not have to enter anything on first load of ownCloud
  'adminlogin'    => '${ADMIN_USER:-admin}',
  'adminpass'     => '${ADMIN_PASSWORD:-password}'
  );
?>
EOF
  chown nginx:nginx $AUTOCONFIG
  echo "Starting automatic configuration..."
  (cd /nextcloud; s6-setuidgid nginx php7 index.php)
  echo "Automatic configuration finished."

  s6-setuidgid nginx php7 -f /nextcloud/occ app:disable firstrunwizard

  if [ ! -z "$TRUSTED_DOMAINS" ]; then
    index=1
    for domain in $TRUSTED_DOMAINS
    do
      s6-setuidgid nginx php7 -f /nextcloud/occ config:system:set trusted_domains $index --value=$domain
      let index=$index+1
    done
  fi
fi
