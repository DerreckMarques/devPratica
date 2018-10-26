define mysql::db($schema, $user=$title, $password){
  Class['mysql::server'] -> Mysql::db[$title]

  exec { "$title-schema":
    unless  =>  "mysql -uroot $schema",
    command =>  "mysqladmin -uroot create $schema",
    path    =>  "/usr/bin/",
  }

  exec { "$title-user":
    unless  =>  "mysql -u$user -p$password $schema",
    command =>  "mysql -uroot -e \" CREATE USER '$user'@'%' IDENTIFIED BY '$password';
                                  GRANT ALL PRIVILEGES ON $schema.* TO '$user'@'%';\"",
    path    =>  "/usr/bin/",
    require =>  Exec["$title-schema"],
  }
}

include mysql::server

mysql::db {"loja":
  schema    =>  "loja_schema",
  password  =>  "lojasecret",
}
