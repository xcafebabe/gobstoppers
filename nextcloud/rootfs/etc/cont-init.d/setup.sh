#!/usr/bin/with-contenv sh

#############
# Nextcloud #
#############


CONFIGFILE=/nextcloud/config/config.php
if [ ! -f $CONFIGFILE ]; then
  # Create an initial configuration file.
  instanceid=next$(echo $DOMAIN | sha1sum | fold -w 10 | head -n 1)
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

  echo "Starting automatic configuration..."
  (cd /nextcloud; su-exec nginx:nginx php7 index.php)
  echo "Automatic configuration finished."

  sed -i "s/localhost/$DOMAIN/g" $CONFIGFILE

  # The firstrunwizard gave Josh all sorts of problems, so disabling that.
  # user_external is what allows ownCloud to use IMAP for login. The contacts
  # and calendar apps are the extensions we really care about here.
  su-exec nginx:nginx php7 -f /nextcloud/occ app:disable firstrunwizard
fi
