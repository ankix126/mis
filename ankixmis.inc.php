<?php
if (!defined('IN_DISCUZ')) {
    exit('Access Denied');
}
require_once dirname(__FILE__)."/class/env.class.php";
$plugin_path = ankixmis_env::get_plugin_path();
$setting = C::m('#ankixmis#ankixmis_setting')->get();
$embedded = isset($_GET['embedded']) ? 1 : 0;

try {
    //1. 登录检查
    if(!$_G['uid']){
        $login = ankixmis_env::get_siteurl()."/member.php?mod=logging&action=login";
        $login.= "&referto=".urlencode(ankixmis_env::get_request_url());
        header("Location: $login");
        exit();
    }

    //2. 权限检查
    $auth = C::t('#ankixmis#ankixmis_auth')->getByUid($_G['uid']);
    if ($auth<=0) {
        throw new Exception('很抱歉,您没有权限访问此页面,请联系管理员开通权限!');
    }

    //3. 导航菜单
    $nav = C::m('#ankixmis#ankixmis_nav_setting')->getEnabledNavMenu();

    //4. 加载模板
    $filename = basename(__FILE__);
    list($controller) = explode('.',$filename);
    include template("ankixmis:".strtolower($controller));
    ankixmis_env::getlog()->trace("pv[".$_G['username']."|uid:".$_G['uid']."]");
    C::t('#ankixmis#ankixmis_log')->write("visit ankixmis:$controller");
} catch (Exception $e) {
    $msg = $e->getMessage();
    include template("ankixmis:error");
}
