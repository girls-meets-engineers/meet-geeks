<?php
require "../vendor/autoload.php";

const API_URI = 'http://meet-geeks-api.kaihar4.com';

session_cache_limiter(false);
session_start();

$app = new \Slim\Slim(array(
  "debug" => true,
  'view' => new \Slim\Views\Twig(),
  "templates.path" => "../views"
));

$app->container->singleton('hybridInstance', function() {
  $instance = new Hybrid_Auth('../config/hybridauth.php');
  return $instance;
});

$authenticate = function() use ($app) {
  return function() use ($app) {
    if(!isset($_SESSION['current_user'])) {
      $_SESSION['current_user'] = NULL;
    }
    if(is_null($_SESSION['current_user'])) {
      $app->flash('error', 'Login is required.');
      $app->redirect('/');
    }
  };
};

# e.g.) request_api('GET', '/users')
# e.g.) request_api('POST', '/users', $json)
# e.g.) request_api('PUT', '/users', $json, $header)
# e.g.) request_api('PUT', '/users', NULL, $header)
function request_api($method, $path, $json = NULL, $header = NULL) {
  $uri = API_URI . $path;

  $prefix = "curl -X " . $method . " ";
  if(!is_null($json)) {
    $prefix = $prefix . "-d 'json=" . $json . "' ";
  }
  if(!is_null($header)) {
    $prefix = $prefix . "-H '" . $header . "' ";
  }

  return shell_exec($prefix . $uri);
};

function is_engineer($provider) {
  if($provider === 'github') {
    return true;
  }else {
    return false;
  }
};

# If you need the authentication.
# $app->get("/", $authenticate(), function() use ($app) {
# }
$app->get("/", function() use ($app) {
  if(isset($_SESSION['current_user']) && !is_null($_SESSION['current_user'])) {
    $app->redirect('/chat');
  }else {
    $app->render("index.html.twig");
  }
});

$app->get("/profiles/show/:id", $authenticate(), function($id) use ($app) {
  $user = json_decode(request_api('GET', '/users/' . $id), TRUE);
  $app->render("profile/show.html.twig", array('current_user' => $_SESSION['current_user'], 'user' => $user));
});

$app->get("/profiles/edit", $authenticate(), function() use ($app) {
  $app->render("profile/edit.html.twig", array('current_user' => $_SESSION['current_user']));
});

$app->get("/profiles/:id", $authenticate(), function($id) use ($app) {
  $response = request_api('GET', '/users/' . $id);

  # Return a json
  header("Content-Type: application/json");
  echo $response;
  exit();
});

$app->put("/profiles/:id", $authenticate(), function($id) use ($app) {
  $json = $app->request()->put('json');
  $response = request_api('PUT', '/users/' . $id, $json);

  # Store new user object to Session
  $object = json_decode($response, TRUE);
  if(isset($object['id'])) {
    $_SESSION['current_user'] = $object;
  }

  # Return a json
  header("Content-Type: application/json");
  echo $response;
  exit();
});

$app->post("/request_lists", $authenticate(), function() use ($app) {
  $engineer_id = $app->request()->post('engineer_id');
  $request_list = array('engineer' => $engineer_id, 'girl' => $_SESSION['current_user']['id']);
  $request_list_json = json_encode($request_list);
  $response = request_api('POST', '/message_lists', $request_list_json);
  echo $response;
  exit();
});

$app->get("/search", $authenticate(), function() use ($app) {
  if($_SESSION['current_user']['is_engineer'] == true) {
    $app->flash('error', 'Forbidden.');
    $app->redirect('/chat');
  }
  $engnr_json = request_api('GET', '/engineers');
  $engnrs = json_decode($engnr_json, true);
  $app->render("/search/search-engineer.html.twig", Array('current_user' => $_SESSION['current_user'], 'engnrs' => $engnrs));
});

$app->get("/chat", $authenticate(), function() use ($app) {
  $message_lists_json = request_api('GET', '/users_message_lists/' . $_SESSION['current_user']['id']);

  $message_lists = json_decode($message_lists_json, true);
  $app->render("/chat/chat.html.twig", Array('current_user' => $_SESSION['current_user'], 'message_lists' => $message_lists));
});

$app->get('/auth', function() {
  Hybrid_Endpoint::process();
});

$app->get('/login/:provider', function($provider) use ($app) {
  $adapter = $app->hybridInstance->authenticate($provider);
  $user_profile = $adapter->getUserProfile();

  $user_profile = array('image_url' => $user_profile->photoURL, 'profile_url' => $user_profile->profileURL, 'is_engineer' => var_export(is_engineer($provider), TRUE), 'name' => $user_profile-> displayName);

  $user_profile_json = json_encode($user_profile);
  $result = request_api('POST', '/users', $user_profile_json);

  $user_object = json_decode($result, TRUE);
  $_SESSION['current_user'] = $user_object;

  $app->redirect('/chat');
});

$app->get('/logout', $authenticate(), function() use ($app) {
  $app->hybridInstance->logoutAllProviders();
  $_SESSION['current_user'] = NULL;

  $app->redirect('/');
});

$app->get('/webrtc', function() use ($app) {
  $app->render("/webrtc_sample.html.twig");
});

$app->run();
