<?php
return
[
  "base_url"   => "http://meet-geeks.kaihar4.com/auth",
  "providers"  => [
    "Github"   => array(
      "enabled" => true,
      "keys"    => array(
        "id"     => "d86d03cfd1809749282b",
        "secret" => "9cc230fc015f51f387045cecbba6090ee1bc7d89"
      ),
      "wrapper" => [ "path" => "hybridauth/GitHub.php", "class" => "Hybrid_Providers_GitHub" ]
    ),
    "Facebook"   => array(
      "enabled" => true,
      "keys"    => array(
        "id"     => "847613171959590",
        "secret" => "84b6b47704d5142c01b828f9a4b5b758"
      ),
    ),
  ],

  "debug_mode" => false,
  "debug_file" => "",
];
