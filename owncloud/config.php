<?php
$CONFIG = array (
  'datadirectory' => '/data/cloud',
  'forcessl' => false,
  'overwritewebroot' => '/cloud',
  'overwrite.cli.url' => '/cloud',
  'user_backends' =>
  array (
    0 =>
    array (
      'class' => 'OC_User_IMAP',
      'arguments' =>
      array (
        0 => '{localhost:993/imap/ssl/novalidate-cert}',
      ),
    ),
  ),
  'memcache.local' => '\\OC\\Memcache\\Memcached',
  'memcached_servers' =>
  array (
    0 =>
    array (
      0 => 'localhost',
      1 => 11211,
    ),
  ),
  'logtimezone' => 'UTC',
  'installed' => true,
  'maintenance' => false,
);

